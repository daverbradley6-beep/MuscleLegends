-- Muscle Legends | evidence-led client utility v0.1
-- Place 3623096087. Uses client-visible GUI and world objects only.
-- Does not spoof remotes, bypass protections, or automate server-authoritative rewards.
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UIS = game:GetService('UserInputService')
local player = Players.LocalPlayer
assert(game.PlaceId == 3623096087, 'This script is for Muscle Legends (3623096087)')
local pg = player:WaitForChild('PlayerGui')
if _G.MuscleLegendsUtilityCleanup then pcall(_G.MuscleLegendsUtilityCleanup) end
local connections, live = {}, true
local function connect(signal, fn) local c=signal:Connect(fn); table.insert(connections,c); return c end
local old=pg:FindFirstChild('MLUtilityV01'); if old then old:Destroy() end
local gui=Instance.new('ScreenGui'); gui.Name='MLUtilityV01'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.Parent=pg
local function mk(class,props,parent)
 local o=Instance.new(class)
 for k,v in pairs(props or {}) do o[k]=v end
 o.Parent=parent; return o
end
local dark=Color3.fromRGB(20,22,28); local panel=Color3.fromRGB(31,34,42)
local accent=Color3.fromRGB(120,205,255); local white=Color3.fromRGB(245,246,250)
local main=mk('Frame',{Size=UDim2.fromOffset(420,485),Position=UDim2.new(.5,-210,.5,-242),BackgroundColor3=dark,BorderSizePixel=0},gui)
mk('UICorner',{CornerRadius=UDim.new(0,12)},main)
mk('UIStroke',{Color=accent,Thickness=1.5},main)
local title=mk('TextLabel',{Size=UDim2.new(1,-95,0,42),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text='MUSCLE LEGENDS | UTILITY',TextColor3=white,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,TextSize=16},main)
local close=mk('TextButton',{Size=UDim2.fromOffset(32,28),Position=UDim2.new(1,-38,0,7),Text='×',TextColor3=white,BackgroundColor3=panel,Font=Enum.Font.GothamBold,TextSize=22},main)
local minimize=mk('TextButton',{Size=UDim2.fromOffset(32,28),Position=UDim2.new(1,-74,0,7),Text='−',TextColor3=white,BackgroundColor3=panel,Font=Enum.Font.GothamBold,TextSize=20},main)
local status=mk('TextLabel',{Size=UDim2.new(1,-24,0,42),Position=UDim2.new(0,12,1,-46),Text='Ready. Actions use existing game controls.',TextColor3=accent,BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=12,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left},main)
local scroll=mk('ScrollingFrame',{Size=UDim2.new(1,-24,1,-103),Position=UDim2.fromOffset(12,48),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=5,CanvasSize=UDim2.fromOffset(0,0)},main)
local layout=mk('UIListLayout',{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},scroll)
connect(layout:GetPropertyChangedSignal('AbsoluteContentSize'),function() scroll.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+8) end)
local function msg(t) status.Text=t end
local function button(text,fn)
 local b=mk('TextButton',{Size=UDim2.new(1,-6,0,33),BackgroundColor3=panel,TextColor3=white,Text=text,Font=Enum.Font.GothamMedium,TextSize=13,AutoButtonColor=true},scroll)
 mk('UICorner',{CornerRadius=UDim.new(0,6)},b); mk('UIStroke',{Color=accent,Thickness=.7},b)
 connect(b.MouseButton1Click,function() local ok,err=pcall(fn); if not ok then msg('Error: '..tostring(err)) end end)
 return b
end
local function header(text)
 mk('TextLabel',{Size=UDim2.new(1,-6,0,25),BackgroundTransparency=1,Text=text,TextColor3=accent,Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left},scroll)
end
local function path(root, parts)
 local obj=root
 for _,part in ipairs(parts) do obj=obj and obj:FindFirstChild(part) end
 return obj
end
local function activate(parts,label)
 local target=path(pg,parts)
 if not target or not target:IsA('GuiButton') then msg(label..': game control unavailable (open normal HUD first)'); return end
 if not target.Visible then msg(label..': control currently hidden'); return end
 local ok,err=pcall(function() target:Activate() end)
 msg(ok and (label..': activated game control; check in-game response') or (label..': activation failed: '..tostring(err)))
end
local hud={'gameGui','hudNewMenu'}
local function menu(label, tail)
 local p={unpack(hud)}; for _,v in ipairs(tail) do table.insert(p,v) end
 button('Open '..label,function() activate(p,label) end)
end
header('GAME MENUS')
menu('Rebirth',{'MiddleLeft','BTNList','Rebirth'})
menu('Items / Inventory',{'MiddleLeft','BTNList','Items'})
menu('Trade',{'MiddleLeft','BTNList','Trade'})
menu('Stats',{'MiddleLeft','BTNList','Stats'})
menu('Moves',{'Right','TopBtns','Moves'})
menu('Quests',{'Right','TopBtns','Quests'})
menu('Free Gifts',{'Right','BottomBTNs','Claim'})
menu('Halloween',{'Right','TopBtns','HalloweenButton','Container'})
menu('Fortune Wheel',{'Top','WheelBtn'})
header('INVENTORY CATEGORIES')
for _,name in ipairs({'Pets','Eggs','Auras','Boosts'}) do
 button('Select '..name,function() activate({'gameGui','itemsNewMenu','LeftSlots',name..'Button'},name) end)
end
button('Next inventory page',function() activate({'gameGui','itemsNewMenu','MainBase','Content','PageBG','NextButton','Button'},'Next page') end)
button('Previous inventory page',function() activate({'gameGui','itemsNewMenu','MainBase','Content','PageBG','PreviousButton','Button'},'Previous page') end)
header('QUEST CATEGORIES')
for _,name in ipairs({'Daily','Weekly','Story','Enchant'}) do
 button('Select '..name..' quests',function()
  local source={'Daily','Weekly','Story','Enchant'}
  for _,from in ipairs(source) do
   local p={'questsGui','questsNewMenu','Quests'..from,'LeftSlots',name..'Button'}
   local b=path(pg,p)
   if b and b:IsA('GuiButton') and b.Visible then activate(p,name..' quests'); return end
  end
  msg('Quest category unavailable; open Quests first')
 end)
end
header('LIVE INFORMATION')
local statsLabel=mk('TextLabel',{Size=UDim2.new(1,-6,0,68),BackgroundColor3=panel,TextColor3=white,Text='Loading stats...',Font=Enum.Font.Code,TextSize=12,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left},scroll)
mk('UICorner',{CornerRadius=UDim.new(0,6)},statsLabel)
local function updateStats()
 local ls=player:FindFirstChild('leaderstats'); local entries={}
 if ls then for _,v in ipairs(ls:GetChildren()) do if v:IsA('ValueBase') then table.insert(entries,v.Name..': '..tostring(v.Value)) end end end
 statsLabel.Text=#entries>0 and table.concat(entries,'   |   ') or 'No replicated leaderstats currently available'
end
updateStats(); local elapsed=0
connect(RunService.Heartbeat,function(dt) elapsed=elapsed+dt; if elapsed>=1 then elapsed=0; updateStats() end end)
button('Refresh stats now',updateStats)
header('WORLD INTERACTIONS')
local function listPrompts()
 local found={}
 for _,d in ipairs(workspace:GetDescendants()) do
  if d:IsA('ProximityPrompt') then table.insert(found,d) end
 end
 table.sort(found,function(a,b) return a:GetFullName()<b:GetFullName() end)
 return found
end
button('List nearby interaction prompts',function()
 local prompts=listPrompts(); local root=player.Character and player.Character:FindFirstChild('HumanoidRootPart')
 local nearby={}
 for _,p in ipairs(prompts) do
  local part=p.Parent; local pos=part and (part:IsA('BasePart') and part.Position or part:IsA('Attachment') and part.WorldPosition)
  if root and pos and (root.Position-pos).Magnitude<=75 then table.insert(nearby,p.ActionText~='' and p.ActionText or p.Name) end
 end
 msg(#nearby>0 and ('Nearby: '..table.concat(nearby,', ')) or 'No nearby prompt within 75 studs')
end)
button('Show pet crafting / enchanting prompt locations',function()
 local found={}
 for _,p in ipairs(listPrompts()) do
  if p.Name=='petCraftPrompt' or p.Name=='petEnchantPrompt' then table.insert(found,p:GetFullName()) end
 end
 msg(#found>0 and table.concat(found,' | ') or 'No matching pet prompts currently replicated')
end)
header('LOCAL SETTINGS')
local fpsLabel=button('Show current FPS',function() msg('FPS sampling begins below') end)
local frames=0; local timeAcc=0
connect(RunService.RenderStepped,function(dt)
 frames=frames+1; timeAcc=timeAcc+dt
 if timeAcc>=1 then fpsLabel.Text='Current FPS: '..math.floor(frames/timeAcc+.5);frames=0;timeAcc=0 end
end)
local collapsed=false
connect(minimize.MouseButton1Click,function()
 collapsed=not collapsed; scroll.Visible=not collapsed;status.Visible=not collapsed
 main.Size=collapsed and UDim2.fromOffset(420,42) or UDim2.fromOffset(420,485)
end)
local floating=mk('TextButton',{Size=UDim2.fromOffset(44,44),Position=UDim2.new(0,16,.5,-22),BackgroundColor3=dark,Text='L',TextColor3=accent,TextSize=21,Font=Enum.Font.GothamBold,Visible=false},gui)
mk('UICorner',{CornerRadius=UDim.new(1,0)},floating);mk('UIStroke',{Color=accent,Thickness=2},floating)
local function toggle() main.Visible=not main.Visible;floating.Visible=not main.Visible end
connect(close.MouseButton1Click,toggle);connect(floating.MouseButton1Click,toggle)
local dragging,dragStart,startPos=false,nil,nil
connect(title.InputBegan,function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true;dragStart=input.Position;startPos=main.Position end
end)
connect(UIS.InputChanged,function(input)
 if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
  local d=input.Position-dragStart;main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
 end
end)
connect(UIS.InputEnded,function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
_G.MuscleLegendsUtilityCleanup=function()
 if not live then return end;live=false
 for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
 pcall(function() gui:Destroy() end)
 _G.MuscleLegendsUtilityCleanup=nil
end
msg('Loaded: '..tostring(#scroll:GetChildren()-1)..' UI elements. No gameplay actions have been verified live.')