--[[
    Muscle Legends Assistant - standalone read-only client UI
    Version: 0.2.0
    Target: Potassium-compatible Lua environment using standard Roblox client APIs.
    No remote calls, gameplay automation, movement modification, purchases, or anti-cheat bypass.
    Data is observational/sample data from the supplied Muscle Legends 3.7.3 inspection.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    warn("[MuscleLegends] LocalPlayer unavailable. Run this from a client context.")
    return
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then
    warn("[MuscleLegends] PlayerGui unavailable.")
    return
end

-- Remove an older copy if this file is executed again.
local old = PlayerGui:FindFirstChild("MuscleLegendsAssistant")
if old then old:Destroy() end

local DATA = {
    equipment = {
        {name="Bench Press", stat="Strength", requirement=10, strength=11, durability=1, agility=0, repTime=1},
        {name="Squat Rack", stat="Strength", requirement=1000, strength=12, durability=2, agility=0, repTime=1},
        {name="Pullups", stat="Strength", requirement=1000, strength=12, durability=0, agility=1, repTime=1},
        {name="Deadlift", stat="Strength", requirement=8000, strength=21, durability=0, agility=0, repTime=1.5},
        {name="Boulder Throw", stat="Strength", requirement=25000, strength=26, durability=13, agility=0, repTime=1},
        {name="Treadmill", stat="Agility", requirement=100, strength=0, durability=0, agility=3, repTime=nil},
        {name="Punching Rock", stat="Durability", requirement=10, strength=0, durability=2, agility=0, repTime=nil},
    },
    pets = {
        {name="Leaf Chameleon", strength=415, durability=470, agility=360, damage=4125},
        {name="Moonlight Fox", strength=640, durability=725, agility=555, damage=6375},
        {name="Prismcore Hound", strength=800, durability=600, agility=625, damage=8500},
        {name="Inferno Drake", strength=10000, durability=10000, agility=10000, damage=nil},
    },
    gyms = {
        {name="Eternal Gym", requirement=15},
        {name="Industrial Gym", requirement=150},
    }
}

local C = {
    bg = Color3.fromRGB(22,23,27),
    panel = Color3.fromRGB(34,36,42),
    panel2 = Color3.fromRGB(44,47,55),
    text = Color3.fromRGB(242,245,250),
    muted = Color3.fromRGB(165,174,188),
    blue = Color3.fromRGB(105,190,255),
    green = Color3.fromRGB(115,210,150),
    red = Color3.fromRGB(245,125,125)
}

local function make(class, props, parent)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end
local function corner(o, radius)
    make("UICorner", {CornerRadius=UDim.new(0,radius or 8)}, o)
end
local function outline(o, color)
    make("UIStroke", {Color=color or C.blue, Thickness=1}, o)
end
local function text(parent, value, size, color, bold)
    return make("TextLabel", {
        BackgroundTransparency=1, Text=tostring(value), TextColor3=color or C.text,
        Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize=size or 12, TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Center
    }, parent)
end
local function button(parent, value)
    local b=make("TextButton", {
        Text=value, BackgroundColor3=C.panel2, TextColor3=C.text,
        Font=Enum.Font.GothamMedium, TextSize=12, AutoButtonColor=true
    }, parent)
    corner(b,7); outline(b)
    return b
end
local function input(parent, placeholder, initial)
    local box=make("TextBox", {
        Text=tostring(initial or ""), PlaceholderText=placeholder,
        ClearTextOnFocus=false, BackgroundColor3=C.panel2,
        TextColor3=C.text, PlaceholderColor3=C.muted,
        Font=Enum.Font.Gotham, TextSize=12
    }, parent)
    corner(box,7); outline(box)
    return box
end

local gui=make("ScreenGui", {
    Name="MuscleLegendsAssistant", ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=50
}, PlayerGui)

local main=make("Frame", {
    Name="Main", Size=UDim2.fromOffset(720,500),
    Position=UDim2.new(0.5,-360,0.5,-250),
    BackgroundColor3=C.bg, BorderSizePixel=0, Active=true
}, gui)
corner(main,13); outline(main)

local top=make("Frame", {
    Size=UDim2.new(1,0,0,46), BackgroundColor3=C.panel,
    BorderSizePixel=0, Active=true
}, main)
corner(top,13)
local title=text(top,"MUSCLE LEGENDS  /  ASSISTANT",15,C.text,true)
title.Position=UDim2.fromOffset(15,0); title.Size=UDim2.new(1,-105,1,0)
local minimise=button(top,"—")
minimise.Size=UDim2.fromOffset(34,30); minimise.Position=UDim2.new(1,-43,0,8)

local sidebar=make("Frame", {
    Position=UDim2.fromOffset(10,56), Size=UDim2.new(0,142,1,-66),
    BackgroundColor3=C.panel, BorderSizePixel=0
},main)
corner(sidebar,9)
local sideLayout=make("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},sidebar)
make("UIPadding",{PaddingTop=UDim.new(0,9),PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7)},sidebar)

local body=make("ScrollingFrame", {
    Position=UDim2.fromOffset(162,56), Size=UDim2.new(1,-172,1,-66),
    BackgroundColor3=C.panel, BorderSizePixel=0, ScrollBarThickness=5,
    ScrollBarImageColor3=C.blue, AutomaticCanvasSize=Enum.AutomaticSize.Y,
    CanvasSize=UDim2.new()
},main)
corner(body,9)
make("UIPadding",{PaddingTop=UDim.new(0,12),PaddingBottom=UDim.new(0,12),PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12)},body)
local bodyLayout=make("UIListLayout",{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},body)

local restore=button(gui,"L")
restore.Size=UDim2.fromOffset(42,42); restore.Position=UDim2.new(0,16,0.5,-21)
restore.TextSize=19; restore.Font=Enum.Font.GothamBold
restore.Visible=false
minimise.MouseButton1Click:Connect(function() main.Visible=false; restore.Visible=true end)
restore.MouseButton1Click:Connect(function() restore.Visible=false; main.Visible=true end)

-- Drag window using standard input events.
local dragging, dragInput, dragStart, startPos=false,nil,nil,nil
top.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=i.Position; startPos=main.Position
        i.Changed:Connect(function()
            if i.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
top.InputChanged:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i==dragInput then
        local d=i.Position-dragStart
        main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)

local function clearBody()
    for _,v in ipairs(body:GetChildren()) do
        if v~=bodyLayout and v.ClassName~="UIPadding" then v:Destroy() end
    end
    body.CanvasPosition=Vector2.new(0,0)
end
local function heading(value)
    local h=text(body,value,18,C.text,true); h.Size=UDim2.new(1,0,0,29); return h
end
local function note(value, color)
    local n=text(body,value,11,color or C.muted,false); n.Size=UDim2.new(1,0,0,38); return n
end
local function card(name, value)
    local f=make("Frame",{Size=UDim2.new(1,0,0,65),BackgroundColor3=C.panel2,BorderSizePixel=0},body)
    corner(f,8)
    local a=text(f,name,12,C.text,true); a.Position=UDim2.fromOffset(10,5); a.Size=UDim2.new(1,-20,0,20)
    local b=text(f,value,11,C.muted,false); b.Position=UDim2.fromOffset(10,26); b.Size=UDim2.new(1,-20,0,34)
end
local function readStat(name)
    local stats=LocalPlayer:FindFirstChild("leaderstats")
    if stats then
        local v=stats:FindFirstChild(name)
        if v and (v:IsA("NumberValue") or v:IsA("IntValue") or v:IsA("StringValue")) then return tostring(v.Value) end
    end
    local a=LocalPlayer:GetAttribute(name)
    if a~=nil then return tostring(a) end
    return "Not exposed to client"
end

local function dashboard()
    clearBody(); heading("Dashboard")
    note("Read-only client display. Values appear only when the game exposes them through leaderstats or player attributes.")
    for _,stat in ipairs({"Strength","Durability","Agility","Rebirths","Ascension","Gems","Coins"}) do
        card(stat,readStat(stat))
    end
    card("Inspection baseline","Muscle Legends 3.7.3 · Inspector 2.16.0 · 172/172 parts scanned")
    card("Scan coverage","82,617 objects · 39,350 unique objects · 3,934 observed configuration values")
end

local function training()
    clearBody(); heading("Training calculator")
    note("Uses observed sample values, not verified server formulas. Confirm requirements and boosts in-game.")
    local selected=1
    local pick=button(body,"Equipment: "..DATA.equipment[selected])
    pick.Size=UDim2.new(1,0,0,34)
    pick.MouseButton1Click:Connect(function()
        selected=selected%#DATA.equipment+1
        pick.Text="Equipment: "..DATA.equipment[selected].name
    end)
    local function row(labelText, default)
        local r=make("Frame",{Size=UDim2.new(1,0,0,34),BackgroundTransparency=1},body)
        local l=text(r,labelText,11,C.muted,false); l.Size=UDim2.new(0.48,0,1,0)
        local box=input(r,labelText,default); box.Position=UDim2.new(0.5,0,0,1); box.Size=UDim2.new(0.5,0,1,-2)
        return box
    end
    local current=row("Current stat",1000)
    local target=row("Target stat",100000)
    local mult=row("Assumed multiplier",1)
    local result=note("Choose equipment and calculate.")
    local calc=button(body,"CALCULATE")
    calc.Size=UDim2.new(1,0,0,34)
    calc.MouseButton1Click:Connect(function()
        local e=DATA.equipment[selected]
        local now=tonumber(current.Text); local goal=tonumber(target.Text); local m=tonumber(mult.Text)
        if not now or not goal or not m or m<0 then result.Text="Enter valid non-negative numbers."; result.TextColor3=C.red; return end
        local gain=(e[e.stat=="Strength" and "strength" or e.stat=="Durability" and "durability" or "agility"] or 0)*m
        if now<e.requirement then result.Text="Requirement not met. Need "..tostring(e.requirement-now).." more "..e.stat.."."; result.TextColor3=C.amber; return end
        if gain<=0 then result.Text="No observed gain for this stat/equipment combination."; result.TextColor3=C.red; return end
        local reps=math.ceil(math.max(0,goal-now)/gain)
        if e.repTime then result.Text=string.format("%d reps · %.1f seconds · %.2f gain per rep",reps,reps*e.repTime,gain)
        else result.Text=string.format("%d reps · rep time not recorded · %.2f gain per rep",reps,gain) end
        result.TextColor3=C.green
    end)
    for _,e in ipairs(DATA.equipment) do
        card(e.name,string.format("%s requirement %d · STR +%d · DUR +%d · AGI +%d · rep time %s",e.stat,e.requirement,e.strength,e.durability,e.agility,e.repTime and tostring(e.repTime).."s" or "unknown"))
    end
end

local function pets()
    clearBody(); heading("Pet reference")
    note("Examples only. This is not a complete pet catalogue or an optimiser for your live inventory.")
    for _,p in ipairs(DATA.pets) do
        card(p.name,string.format("Strength %d · Durability %d · Agility %d · Damage %s",p.strength,p.durability,p.agility,p.damage and tostring(p.damage) or "not recorded"))
    end
    card("Optimiser status","Owned inventory, slot capacity and verified stacking rules are not established by the scan.")
end

local function progression()
    clearBody(); heading("Progression reference")
    note("Observed configuration values; not a guarantee of current server-side unlock rules.")
    for _,g in ipairs(DATA.gyms) do card(g.name,"Observed requirement: "..g.requirement.." rebirths") end
    card("Rebirth / ascension","The inspection identifies related objects, but does not establish remote arguments or server validation.")
end

local descriptions = {
    Quests="Quest catalogues were detected. Full objectives, live progress and reward dependencies are not yet verified.",
    Economy="Shop and character objects were detected. Prices and purchase rules are not assumed.",
    Rewards="Reward systems were detected. No drop rates or probabilities are invented.",
    Combat="Boss and brawl objects were detected. Live health and damage data are not established here.",
    Travel="Travel-related objects were detected. This panel does not invoke teleport or travel remotes.",
    Risk="Read-only UI and local calculations only. No remote abuse, anti-cheat bypass or movement manipulation.",
    Settings="Use the minimise button to collapse the window and the L button to restore it."
}
local function infoPage(name)
    clearBody(); heading(name); note(descriptions[name] or "Read-only information panel.")
    card("Status","This section is a reference panel. It does not claim unsupported actions are functional.")
end

local pages={Dashboard=dashboard,Training=training,Pets=pets,Progression=progression}
for name in pairs(descriptions) do pages[name]=function() infoPage(name) end end
local navNames={"Dashboard","Training","Pets","Progression","Quests","Economy","Rewards","Combat","Travel","Risk","Settings"}
for i,name in ipairs(navNames) do
    local b=button(sidebar,name); b.Size=UDim2.new(1,0,0,29); b.LayoutOrder=i
    b.MouseButton1Click:Connect(function() pages[name]() end)
end

dashboard()
print("[MuscleLegends] Assistant loaded. Read-only UI active.")
