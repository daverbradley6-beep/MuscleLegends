-- Muscle Legends Assistant - authorised Roblox Studio companion
-- Install as a LocalScript in StarterPlayer > StarterPlayerScripts.
-- This client does not invoke remotes, modify game movement, or automate public-game actions.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local TrainingData = require(script.Parent.modules.TrainingData)
local Calculators = require(script.Parent.modules.Calculators)

local THEME = {
    background = Color3.fromRGB(22, 23, 26),
    panel = Color3.fromRGB(34, 36, 40),
    panel2 = Color3.fromRGB(44, 47, 52),
    text = Color3.fromRGB(245, 246, 248),
    muted = Color3.fromRGB(165, 170, 180),
    blue = Color3.fromRGB(110, 190, 255),
    border = Color3.fromRGB(75, 80, 88),
    green = Color3.fromRGB(115, 205, 145),
    amber = Color3.fromRGB(245, 190, 95),
}

local gui = Instance.new("ScreenGui")
gui.Name = "MuscleLegendsAssistant"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 20
gui.Parent = playerGui

local function round(instance, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = instance
end

local function stroke(instance, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.blue
    s.Thickness = thickness or 1
    s.Parent = instance
end

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function label(parent, text, size, color, font)
    return make("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or THEME.text,
        Font = font or Enum.Font.Gotham,
        TextSize = size or 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 24),
    }, parent)
end

local function button(parent, text, width)
    local b = make("TextButton", {
        Text = text,
        Size = UDim2.new(0, width or 120, 0, 34),
        BackgroundColor3 = THEME.panel2,
        TextColor3 = THEME.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        AutoButtonColor = true,
    }, parent)
    round(b, 8)
    stroke(b, THEME.blue, 1)
    return b
end

local window = make("Frame", {
    Name = "MainWindow",
    Size = UDim2.fromOffset(760, 520),
    Position = UDim2.new(0.5, -380, 0.5, -260),
    BackgroundColor3 = THEME.background,
    BorderSizePixel = 0,
    Active = true,
}, gui)
round(window, 14)
stroke(window, THEME.border, 1)

local top = make("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0,
    Active = true,
}, window)
round(top, 14)
local title = label(top, "MUSCLE LEGENDS  /  ASSISTANT", 15, THEME.text, Enum.Font.GothamBold)
title.Position = UDim2.fromOffset(16, 0)
title.Size = UDim2.new(1, -120, 1, 0)
local minimise = button(top, "—", 34)
minimise.Position = UDim2.new(1, -46, 0, 7)

local sidebar = make("Frame", {
    Position = UDim2.fromOffset(12, 60),
    Size = UDim2.new(0, 150, 1, -72),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0,
}, window)
round(sidebar, 10)
local navLayout = Instance.new("UIListLayout")
navLayout.Padding = UDim.new(0, 5)
navLayout.SortOrder = Enum.SortOrder.LayoutOrder
navLayout.Parent = sidebar
local navPad = Instance.new("UIPadding")
navPad.PaddingTop = UDim.new(0, 10)
navPad.PaddingLeft = UDim.new(0, 8)
navPad.PaddingRight = UDim.new(0, 8)
navPad.Parent = sidebar

local content = make("ScrollingFrame", {
    Position = UDim2.fromOffset(174, 60),
    Size = UDim2.new(1, -186, 1, -72),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = THEME.blue,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, window)
round(content, 10)
local contentPad = Instance.new("UIPadding")
contentPad.PaddingTop = UDim.new(0, 14)
contentPad.PaddingBottom = UDim.new(0, 14)
contentPad.PaddingLeft = UDim.new(0, 14)
contentPad.PaddingRight = UDim.new(0, 14)
contentPad.Parent = content
local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = content

local restore = button(gui, "L", 42)
restore.Size = UDim2.fromOffset(42, 42)
restore.Position = UDim2.new(0, 18, 0.5, -21)
restore.BackgroundColor3 = Color3.fromRGB(105, 108, 115)
restore.TextSize = 20
restore.Font = Enum.Font.GothamBold
restore.Visible = false
stroke(restore, Color3.new(0, 0, 0), 2)

local dragging, dragStart, startPosition = false, nil, nil
local function clampPosition(position)
    local camera = workspace.CurrentCamera
    if not camera then return position end
    local viewport = camera.ViewportSize
    local abs = window.AbsoluteSize
    local x = math.clamp(position.X.Offset, 0, math.max(0, viewport.X - abs.X))
    local y = math.clamp(position.Y.Offset, 0, math.max(0, viewport.Y - abs.Y))
    return UDim2.fromOffset(x, y)
end

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = window.AbsolutePosition
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        window.Position = clampPosition(UDim2.fromOffset(startPosition.X + delta.X, startPosition.Y + delta.Y))
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

minimise.MouseButton1Click:Connect(function()
    window.Visible = false
    restore.Visible = true
end)
restore.MouseButton1Click:Connect(function()
    restore.Visible = false
    window.Visible = true
end)

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if child ~= contentPad and child ~= contentLayout then child:Destroy() end
    end
    content.CanvasPosition = Vector2.zero
end

local function heading(text)
    local h = label(content, text, 18, THEME.text, Enum.Font.GothamBold)
    h.Size = UDim2.new(1, 0, 0, 30)
    return h
end

local function note(text, color)
    local n = label(content, text, 12, color or THEME.muted)
    n.Size = UDim2.new(1, 0, 0, 42)
    return n
end

local function card(titleText, bodyText)
    local f = make("Frame", { Size = UDim2.new(1, 0, 0, 76), BackgroundColor3 = THEME.panel2, BorderSizePixel = 0 }, content)
    round(f, 9)
    local t = label(f, titleText, 13, THEME.text, Enum.Font.GothamBold)
    t.Position = UDim2.fromOffset(12, 7)
    t.Size = UDim2.new(1, -24, 0, 22)
    local b = label(f, bodyText, 11, THEME.muted)
    b.Position = UDim2.fromOffset(12, 31)
    b.Size = UDim2.new(1, -24, 0, 38)
    return f
end

local function statValue(name)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local value = leaderstats:FindFirstChild(name)
        if value and (value:IsA("IntValue") or value:IsA("NumberValue") or value:IsA("StringValue")) then return tostring(value.Value) end
    end
    local attribute = player:GetAttribute(name)
    if attribute ~= nil then return tostring(attribute) end
    return "Not exposed"
end

local function addInputRow(prompt, default)
    local row = make("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1 }, content)
    local l = label(row, prompt, 12, THEME.muted)
    l.Size = UDim2.new(0.48, 0, 1, 0)
    local box = make("TextBox", {
        Position = UDim2.new(0.5, 0, 0, 2), Size = UDim2.new(0.5, -2, 1, -4),
        BackgroundColor3 = THEME.panel2, TextColor3 = THEME.text, PlaceholderColor3 = THEME.muted,
        Text = tostring(default or ""), ClearTextOnFocus = false, Font = Enum.Font.Gotham, TextSize = 12,
    }, row)
    round(box, 7)
    stroke(box, THEME.blue, 1)
    return box
end

local function showDashboard()
    clearContent(); heading("Dashboard")
    note("Live values are read only from this authorised Studio experience's leaderstats or player attributes.")
    for _, name in ipairs({"Strength", "Durability", "Agility", "Rebirths", "Ascension", "Gems", "Coins"}) do
        card(name, statValue(name))
    end
    card("Inspection baseline", "Muscle Legends 3.7.3 · Inspector 2.16.0 · 172/172 scan parts verified")
    card("Data coverage", "82,617 scanned objects · 39,350 unique objects · 3,934 observed configuration values")
end

local function showTraining()
    clearContent(); heading("Training optimiser")
    note("Calculations use observed sample values. Equipment availability and server-side multipliers must be verified in your own experience.")
    local names = {}
    for _, item in ipairs(TrainingData.Equipment) do table.insert(names, item.name) end
    local selectedIndex = 1
    local selectButton = button(content, "Equipment: " .. names[selectedIndex], 260)
    selectButton.Size = UDim2.new(1, 0, 0, 36)
    selectButton.MouseButton1Click:Connect(function()
        selectedIndex = selectedIndex % #names + 1
        selectButton.Text = "Equipment: " .. names[selectedIndex]
    end)
    local current = addInputRow("Current attribute value", 1000)
    local target = addInputRow("Target attribute value", 100000)
    local multiplier = addInputRow("Assumed multiplier", 1)
    local output = note("Select equipment and calculate a target.")
    local calculate = button(content, "CALCULATE", 150)
    calculate.MouseButton1Click:Connect(function()
        local equipment = TrainingData.Equipment[selectedIndex]
        local result, err = Calculators.Training(equipment, current.Text, target.Text, multiplier.Text)
        if not result then output.Text = err or "Calculation unavailable"; return end
        if not result.available then
            output.Text = string.format("Requirement not met: need %s more %s.", tostring(result.remaining), equipment.attribute)
        elseif result.seconds then
            output.Text = string.format("%d reps · %.2f seconds (%.2f minutes) · %.2f gain per rep", result.reps, result.seconds, result.minutes, result.gainPerRep)
        else
            output.Text = string.format("%d reps · %.2f gain per rep · rep time not recorded", result.reps, result.gainPerRep)
        end
    end)
    for _, item in ipairs(TrainingData.Equipment) do
        local details = string.format("%s requirement: %s · Strength +%s · Durability +%s · Agility +%s · rep time: %s", item.attribute, tostring(item.requirement or "not recorded"), tostring(item.strengthGain or "—"), tostring(item.durabilityGain or "—"), tostring(item.agilityGain or "—"), tostring(item.repTime or "not recorded"))
        card(item.name, details)
    end
end

local function showPets()
    clearContent(); heading("Pet reference")
    note("These are observed examples from the supplied specification, not a complete inventory or verified live pet catalogue.")
    for _, pet in ipairs(TrainingData.PetExamples) do
        card(pet.name, string.format("Strength %s · Durability %s · Agility %s · Damage %s", tostring(pet.strength), tostring(pet.durability), tostring(pet.agility), tostring(pet.damage or "not recorded")))
    end
    card("Optimisation status", "A complete best-pet selector requires the live owned-pet inventory, slot count and verified stacking rules. Those are not established by the scan alone.")
end

local function showProgression()
    clearContent(); heading("Progression")
    note("Observed unlock requirements; these should be treated as configuration evidence rather than a guarantee of current server rules.")
    for _, gym in ipairs(TrainingData.GymUnlocks) do card(gym.name, string.format("Requires %d %s", gym.requirement, gym.requirementType)) end
    card("Rebirth and ascension", "The scan identifies progression controllers and remotes, but does not reveal safe invocation contracts or complete server validation.")
end

local sectionDescriptions = {
    Quests = "Quest objects were detected, but a complete objective-to-reward dependency graph needs the relevant catalog records and live progress values.",
    Economy = "Shop and character configuration objects were detected. Live prices, purchase eligibility and transaction behaviour are not assumed.",
    Rewards = "Reward, chest and daily-gift systems were detected. Probabilities are intentionally omitted unless explicit probability data is verified.",
    Combat = "Boss and brawl entities were detected. Health, damage and reward displays require live values from the authorised experience.",
    Travel = "Travel objects and an area-travel remote were detected. This assistant does not invoke travel remotes or teleport players.",
    Movement = "Read-only movement status only. Speed modification, fly and noclip are not implemented.",
    Automation = "No gameplay automation is enabled. Use Roblox Studio server/client code and documented APIs in an experience you own.",
    Risk = "LOW: read-only displays and local calculations. BLOCKED: executor injection, remote abuse, movement cheats, anti-cheat bypass and ban evasion.",
    Settings = "Window can be minimised and restored. Theme and scale customisation are not yet exposed in this starter build.",
}

local pages = {
    Dashboard = showDashboard,
    Training = showTraining,
    Pets = showPets,
    Progression = showProgression,
}
for name, description in pairs(sectionDescriptions) do
    pages[name] = function()
        clearContent(); heading(name); note(description)
        card("Availability", "Read-only information panel. No unsupported action buttons are presented as functional.")
    end
end

local pageNames = {"Dashboard", "Training", "Pets", "Progression", "Quests", "Economy", "Rewards", "Combat", "Travel", "Movement", "Automation", "Risk", "Settings"}
for index, name in ipairs(pageNames) do
    local nav = button(sidebar, name, 132)
    nav.Size = UDim2.new(1, 0, 0, 30)
    nav.LayoutOrder = index
    nav.MouseButton1Click:Connect(function()
        local page = pages[name]
        if page then page() end
    end)
end

showDashboard()

script.Destroying:Connect(function()
    if gui then gui:Destroy() end
end)
