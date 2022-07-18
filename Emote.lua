--keybind to open is comma
--made by Gi#7331

local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local emotes = {}
local function addemote(name, id, price)
	emotes[#emotes+1] = {
		["name"] = name,
		["id"] = id,
		["icon"] = "rbxthumb://type=Asset&id=".. id .."&w=150&h=150",
		["price"] = price,
		["sort"] = {
			["recentasc"] = #emotes+1
		}
	}
end
local currentsort = "recentasc"

local cursor = ""
while true do
	local response = game:HttpGetAsync("https://catalog.roblox.com/v1/search/items/details?Category=12&Subcategory=39&SortType=3&SortAggregation=&limit=30&cursor=".. cursor .."&IncludeNotForSale=true")
	local body = HttpService:JSONDecode(response)
	for i,v in pairs(body.data) do
		addemote(v.name or "", v.id or 0, v.price or 0)
	end
	if body.nextPageCursor ~= nil then
		cursor = body.nextPageCursor
	else
		break
	end
end

--unreleased emotes
addemote("Arm Wave", 5915773155, 0)
addemote("Head Banging", 5915779725, 0)
addemote("Face Calisthenics", 9830731012, 0)

--sorting options setup
table.sort(emotes, function(a, b)
	return a.sort.recentasc > b.sort.recentasc
end)
for i,v in pairs(emotes) do
	v.sort.recentdesc = i
end

table.sort(emotes, function(a, b)
	return a.name:lower() < b.name:lower()
end)
for i,v in pairs(emotes) do
	v.sort.alphabeticasc = i
end

table.sort(emotes, function(a, b)
	return a.name:lower() > b.name:lower()
end)
for i,v in pairs(emotes) do
	v.sort.alphabeticdesc = i
end

table.sort(emotes, function(a, b)
	return a.price < b.price
end)
for i,v in pairs(emotes) do
	v.sort.priceasc = i
end

table.sort(emotes, function(a, b)
	return a.price > b.price
end)
for i,v in pairs(emotes) do
	v.sort.pricedesc = i
end

local screengui = Instance.new("ScreenGui")
screengui.Name = "Emotes"
screengui.DisplayOrder = 2
screengui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screengui.Enabled = false

local backframe = Instance.new("Frame")
backframe.Size = UDim2.new(0.9, 0, 0.5, 0)
backframe.AnchorPoint = Vector2.new(0.5, 0.5)
backframe.Position = UDim2.new(0.5, 0, 0.5, 0)
backframe.SizeConstraint = Enum.SizeConstraint.RelativeYY
backframe.BackgroundTransparency = 1
backframe.BorderSizePixel = 0
backframe.Parent = screengui

local emotename = Instance.new("TextLabel")
emotename.Name = "EmoteName"
emotename.TextScaled = true
emotename.AnchorPoint = Vector2.new(0.5, 0.5)
emotename.Position = UDim2.new(-0.1, 0, 0.5, 0)
emotename.Size = UDim2.new(0.2, 0, 0.2, 0)
emotename.SizeConstraint = Enum.SizeConstraint.RelativeYY
emotename.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
emotename.TextColor3 = Color3.new(1, 1, 1)
emotename.BorderSizePixel = 0
emotename.Parent = backframe

local corner = Instance.new("UICorner")
corner.Parent = emotename

local frame = Instance.new("ScrollingFrame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.CanvasSize = UDim2.new(0, 0, 0, 0)
frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
frame.ScrollingDirection = Enum.ScrollingDirection.Y
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundTransparency = 1
frame.ScrollBarThickness = 5
frame.BorderSizePixel = 0
frame.MouseLeave:Connect(function()
	emotename.Text = "Select an Emote"
end)
frame.Parent = backframe

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0.105, 0, 0, 0)
grid.CellPadding = UDim2.new(0.006, 0, 0.006, 0)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = frame

local sortframe = Instance.new("Frame")
sortframe.Visible = false
sortframe.BorderSizePixel = 0
sortframe.Position = UDim2.new(1, 5, -0.125, 0)
sortframe.Size = UDim2.new(0.2, 0, 0, 0)
sortframe.AutomaticSize = Enum.AutomaticSize.Y
sortframe.BackgroundTransparency = 1
corner:Clone().Parent = sortframe
sortframe.Parent = backframe

local sortlist = Instance.new("UIListLayout")
sortlist.Padding = UDim.new(0.02, 0)
sortlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
sortlist.VerticalAlignment = Enum.VerticalAlignment.Top
sortlist.SortOrder = Enum.SortOrder.LayoutOrder
sortlist.Parent = sortframe

local function createsort(order, text, sort)
	local createdsort = Instance.new("TextButton")
	createdsort.SizeConstraint = Enum.SizeConstraint.RelativeXX
	createdsort.Size = UDim2.new(1, 0, 0.2, 0)
	createdsort.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	createdsort.LayoutOrder = order
	createdsort.TextColor3 = Color3.new(1, 1, 1)
	createdsort.Text = text
	createdsort.TextScaled = true
	createdsort.BorderSizePixel = 0
	corner:Clone().Parent = createdsort
	createdsort.Parent = sortframe
	createdsort.MouseButton1Click:Connect(function()
		sortframe.Visible = false
		currentsort = sort
		for i,v in pairs(emotes) do
			if frame:FindFirstChild(v.name) then
				local emotebutton = frame[v.name]
				emotebutton.LayoutOrder = v.sort[currentsort]
				emotebutton.number.Text = v.sort[currentsort]
			end
		end
	end)
	return createdsort
end

createsort(1, "Recently Updated Asc.", "recentasc")
createsort(2, "Recently Updated Desc.", "recentdesc")
createsort(3, "Alphabetically Asc.", "alphabeticasc")
createsort(4, "Alphabetically Desc.", "alphabeticdesc")
createsort(5, "Price Asc.", "priceasc")
createsort(6, "Price Desc.", "pricedesc")

local sortbutton = Instance.new("TextButton")
sortbutton.BorderSizePixel = 0
sortbutton.AnchorPoint = Vector2.new(0.5, 0.5)
sortbutton.Position = UDim2.new(0.925, -5, -0.075, 0)
sortbutton.Size = UDim2.new(0.15, 0, 0.1, 0)
sortbutton.TextScaled = true
sortbutton.TextColor3 = Color3.new(1, 1, 1)
sortbutton.BackgroundColor3 = Color3.new(0, 0, 0)
sortbutton.BackgroundTransparency = 0.3
sortbutton.Text = "Sort"
sortbutton.MouseButton1Click:Connect(function()
	sortframe.Visible = not sortframe.Visible
end)
corner:Clone().Parent = sortbutton
sortbutton.Parent = backframe

local closebutton = Instance.new("TextButton")
closebutton.BorderSizePixel = 0
closebutton.AnchorPoint = Vector2.new(0.5, 0.5)
closebutton.Position = UDim2.new(0.075, 0, -0.075, 0)
closebutton.Size = UDim2.new(0.15, 0, 0.1, 0)
closebutton.TextScaled = true
closebutton.TextColor3 = Color3.new(1, 1, 1)
closebutton.BackgroundColor3 = Color3.new(0, 0, 0)
closebutton.BackgroundTransparency = 0.3
closebutton.Text = "Close"
closebutton.MouseButton1Click:Connect(function()
	screengui.Enabled = false
end)
corner:Clone().Parent = closebutton
closebutton.Parent = backframe

local searchbar = Instance.new("TextBox")
searchbar.BorderSizePixel = 0
searchbar.AnchorPoint = Vector2.new(0.5, 0.5)
searchbar.Position = UDim2.new(0.5, 0, -0.075, 0)
searchbar.Size = UDim2.new(0.55, 0, 0.1, 0)
searchbar.TextScaled = true
searchbar.PlaceholderText = "Search"
searchbar.TextColor3 = Color3.new(1, 1, 1)
searchbar.BackgroundColor3 = Color3.new(0, 0, 0)
searchbar.BackgroundTransparency = 0.3
searchbar:GetPropertyChangedSignal("Text"):Connect(function()
	local text = searchbar.Text:lower()
	local buttons = frame:GetChildren()
	if text ~= text:sub(1,50) then
		searchbar.Text = searchbar.Text:sub(1,50)
		text = searchbar.Text:lower()
	end
	if text ~= ""  then
		for i,button in pairs(buttons) do
			if button:IsA("GuiButton") then
				local name = button:GetAttribute("name"):lower()
				if name:match(text) then
					button.Visible = true
				else
					button.Visible = false
				end
			end
		end
	else
		for i,button in pairs(buttons) do
			if button:IsA("GuiButton") then
				button.Visible = true
			end
		end
	end
end)
corner:Clone().Parent = searchbar
searchbar.Parent = backframe

local function openemotes(name, state, object)
	if state == Enum.UserInputState.Begin then
		screengui.Enabled = not screengui.Enabled
	end
end

ContextActionService:BindCoreActionAtPriority(
	"Emote Menu",
	openemotes,
	true,
	2001,
	Enum.KeyCode.Comma
)

local inputconnect
screengui:GetPropertyChangedSignal("Enabled"):Connect(function()
	if screengui.Enabled == true then
		emotename.Text = "Select an Emote"
		searchbar.Text = ""
		sortframe.Visible = false
		GuiService:SetEmotesMenuOpen(false)
		inputconnect = UserInputService.InputBegan:Connect(function(input, processed)
			if not processed then
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					screengui.Enabled = false
				end
			end
		end)
	else
		inputconnect:Disconnect()
	end
end)

GuiService.EmotesMenuOpenChanged:Connect(function(isopen)
	if isopen then
		screengui.Enabled = false
	end
end)

GuiService.MenuOpened:Connect(function()
	screengui.Enabled = false
end)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

--thanks inf yield
if (not is_sirhurt_closure) and (syn and syn.protect_gui) then
	syn.protect_gui(screengui)
	screengui.Parent = CoreGui
elseif get_hidden_gui or gethui then
	local hiddenUI = get_hidden_gui or gethui
	screengui.Parent = hiddenUI()
else
	screengui.Parent = CoreGui
end

local localplayer = Players.LocalPlayer

local function playemote(name, id, icon)
	screengui.Enabled = false
	searchbar.Text = ""
	if name == "random" then
		local randomemote = emotes[math.random(1, #emotes)]
		name = randomemote.name
		id = randomemote.id
		icon = randomemote.icon
	end
	if localplayer.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
		local succ, err = pcall(function()
			localplayer.Character.Humanoid:PlayEmote(name)
		end)
		if not succ then
			localplayer.Character.Humanoid.HumanoidDescription:AddEmote(name, id)
			localplayer.Character.Humanoid:PlayEmote(name)
		end
	else
		StarterGui:SetCore("SendNotification", {
			Title = "r6? lol",
			Text = "you gotta be r15 dude",
			Icon = icon
		})
	end
end

local awesome = false
local function charadded(character)
	for i,v in pairs(frame:GetChildren()) do
		if not v:IsA("UIGridLayout") then
			v:Destroy()
		end
	end
	local humanoid = character:WaitForChild("Humanoid")
	local description = humanoid:WaitForChild("HumanoidDescription")
	local random = Instance.new("TextButton")
	local ratio = Instance.new("UIAspectRatioConstraint")
	ratio.AspectType = Enum.AspectType.ScaleWithParentSize
	ratio.Parent = random
	random.LayoutOrder = 0
	random.TextColor3 = Color3.new(1, 1, 1)
	random.BorderSizePixel = 0
	random.BackgroundTransparency = 0.5
	random.BackgroundColor3 = Color3.new(0, 0, 0)
	random.TextScaled = true
	random.Text = "Random"
	random:SetAttribute("name", "")
	corner:Clone().Parent = random
	random.MouseButton1Click:Connect(function()
		playemote("random")
	end)
	random.MouseEnter:Connect(function()
		emotename.Text = "Random"
	end)
	random.Parent = frame
	for i,v in pairs(emotes) do
		description:AddEmote(v.name, v.id)
		local emotebutton = Instance.new("ImageButton")
		emotebutton.LayoutOrder = v.sort[currentsort]
		emotebutton.Name = v.name
		emotebutton:SetAttribute("name", v.name)
		corner:Clone().Parent = emotebutton
		emotebutton.Image = v.icon
		emotebutton.BackgroundTransparency = 0.5
		emotebutton.BackgroundColor3 = Color3.new(0, 0, 0)
		emotebutton.BorderSizePixel = 0
		ratio:Clone().Parent = emotebutton
		local emotenumber = Instance.new("TextLabel")
		emotenumber.Name = "number"
		emotenumber.TextScaled = true
		emotenumber.BackgroundTransparency = 1
		emotenumber.TextColor3 = Color3.new(1, 1, 1)
		emotenumber.BorderSizePixel = 0
		emotenumber.AnchorPoint = Vector2.new(0.5, 0.5)
		emotenumber.Size = UDim2.new(0.2, 0, 0.2, 0)
		emotenumber.Position = UDim2.new(0.9, 0, 0.9, 0)
		emotenumber.Text = v.sort[currentsort]
		emotenumber.Parent = emotebutton
		emotebutton.Parent = frame
		emotebutton.MouseButton1Click:Connect(function()
			playemote(v.name, v.id, v.icon)
		end)
		emotebutton.MouseEnter:Connect(function()
			emotename.Text = v.name
		end)
	end
	for i=1,9 do
		local emotebutton = Instance.new("Frame")
		emotebutton.LayoutOrder = #emotes+1
		emotebutton.Name = "filler"
		emotebutton.BackgroundTransparency = 1
		emotebutton.BorderSizePixel = 0
		ratio:Clone().Parent = emotebutton
		emotebutton.Visible = true
		emotebutton.Parent = frame
		emotebutton.MouseEnter:Connect(function()
			emotename.Text = "Select an Emote"
		end)
	end
	if awesome == true then
		description:SetEquippedEmotes({
			"Air Dance",
			"Quiet Waves",
			"Victory - 24kGoldn",
			"Samba",
			"Chicken Dance",
			"Hype Dance",
			"Floss Dance",
			"BURBERRY LOLA ATTITUDE - NIMBUS"
		})
	end
end

if localplayer.Character ~= nil then
	charadded(localplayer.Character)
end
localplayer.CharacterAdded:Connect(charadded)
