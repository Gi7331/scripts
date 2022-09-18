--keybind to open is comma
--made by Gi#7331

local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local Emotes = {}
local function AddEmote(name, id, price)
	Emotes[#Emotes+1] = {
		["name"] = name,
		["id"] = id,
		["icon"] = "rbxthumb://type=Asset&id=".. id .."&w=150&h=150",
		["price"] = price,
		["sort"] = {
			["recentfirst"] = #Emotes+1
		}
	}
end
local CurrentSort = "recentfirst"

local Cursor = ""
while true do
	local Response = game:HttpGetAsync("https://catalog.roblox.com/v1/search/items/details?Category=12&Subcategory=39&SortType=3&SortAggregation=&limit=30&cursor=".. Cursor .."&IncludeNotForSale=true")
	local Body = HttpService:JSONDecode(Response)
	for i,v in pairs(Body.data) do
		AddEmote(v.name or "", v.id or 0, v.price or 0)
	end
	if Body.nextPageCursor ~= nil then
		Cursor = Body.nextPageCursor
	else
		break
	end
end

--unreleased emotes
AddEmote("Arm Wave", 5915773155, 0)
AddEmote("Head Banging", 5915779725, 0)
AddEmote("Face Calisthenics", 9830731012, 0)


--sorting options setup
table.sort(Emotes, function(a, b)
	return a.sort.recentfirst > b.sort.recentfirst
end)
for i,v in pairs(Emotes) do
	v.sort.recentlast = i
end

table.sort(Emotes, function(a, b)
	return a.name:lower() < b.name:lower()
end)
for i,v in pairs(Emotes) do
	v.sort.alphabeticfirst = i
end

table.sort(Emotes, function(a, b)
	return a.name:lower() > b.name:lower()
end)
for i,v in pairs(Emotes) do
	v.sort.alphabeticlast = i
end

table.sort(Emotes, function(a, b)
	return a.price < b.price
end)
for i,v in pairs(Emotes) do
	v.sort.lowestprice = i
end

table.sort(Emotes, function(a, b)
	return a.price > b.price
end)
for i,v in pairs(Emotes) do
	v.sort.highestprice = i
end

local FavoriteOff = "rbxassetid://10651060677"
local FavoriteOn = "rbxassetid://10651061109"
local FavoritedEmotes = {}
local FavoritedEmotesSorted = {}
if isfile("FavoritedEmotes.txt") then
	if not pcall(function()
		FavoritedEmotes = HttpService:JSONDecode(readfile("FavoritedEmotes.txt"))
	end) then
		FavoritedEmotes = {}
	end
else
	writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes))
end
for i,Emote in pairs(Emotes) do
	if table.find(FavoritedEmotes, Emote.name) then
		FavoritedEmotesSorted[#FavoritedEmotesSorted+1] = Emote
	end
end
local function SortFavoriteEmotes()
	table.sort(FavoritedEmotesSorted, function(a, b)
		if CurrentSort == "recentfirst" then
			return a.sort.recentfirst < b.sort.recentfirst
		elseif CurrentSort == "recentlast" then
			return a.sort.recentfirst > b.sort.recentfirst
		elseif CurrentSort == "alphabeticfirst" then
			return a.name:lower() < b.name:lower()
		elseif CurrentSort == "alphabeticlast" then
			return a.name:lower() > b.name:lower()
		elseif CurrentSort == "lowestprice" then
			return a.price < b.price
		elseif CurrentSort == "highestprice" then
			return a.price > b.price
		end
	end)
end
SortFavoriteEmotes()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Emotes"
ScreenGui.DisplayOrder = 2
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false

local BackFrame = Instance.new("Frame")
BackFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
BackFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BackFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
BackFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
BackFrame.BackgroundTransparency = 1
BackFrame.BorderSizePixel = 0
BackFrame.Parent = ScreenGui

local EmoteName = Instance.new("TextLabel")
EmoteName.Name = "EmoteName"
EmoteName.TextScaled = true
EmoteName.AnchorPoint = Vector2.new(0.5, 0.5)
EmoteName.Position = UDim2.new(-0.1, 0, 0.5, 0)
EmoteName.Size = UDim2.new(0.2, 0, 0.2, 0)
EmoteName.SizeConstraint = Enum.SizeConstraint.RelativeYY
EmoteName.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
EmoteName.TextColor3 = Color3.new(1, 1, 1)
EmoteName.BorderSizePixel = 0
EmoteName.Parent = BackFrame

local Corner = Instance.new("UICorner")
Corner.Parent = EmoteName

local Frame = Instance.new("ScrollingFrame")
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Frame.ScrollingDirection = Enum.ScrollingDirection.Y
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.BackgroundTransparency = 1
Frame.ScrollBarThickness = 5
Frame.BorderSizePixel = 0
Frame.MouseLeave:Connect(function()
	EmoteName.Text = "Select an Emote"
end)
Frame.Parent = BackFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0.105, 0, 0, 0)
Grid.CellPadding = UDim2.new(0.006, 0, 0.006, 0)
Grid.SortOrder = Enum.SortOrder.LayoutOrder
Grid.Parent = Frame

local SortFrame = Instance.new("Frame")
SortFrame.Visible = false
SortFrame.BorderSizePixel = 0
SortFrame.Position = UDim2.new(1, 5, -0.125, 0)
SortFrame.Size = UDim2.new(0.2, 0, 0, 0)
SortFrame.AutomaticSize = Enum.AutomaticSize.Y
SortFrame.BackgroundTransparency = 1
Corner:Clone().Parent = SortFrame
SortFrame.Parent = BackFrame

local SortList = Instance.new("UIListLayout")
SortList.Padding = UDim.new(0.02, 0)
SortList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SortList.VerticalAlignment = Enum.VerticalAlignment.Top
SortList.SortOrder = Enum.SortOrder.LayoutOrder
SortList.Parent = SortFrame

local function createsort(order, text, sort)
	local CreatedSort = Instance.new("TextButton")
	CreatedSort.SizeConstraint = Enum.SizeConstraint.RelativeXX
	CreatedSort.Size = UDim2.new(1, 0, 0.2, 0)
	CreatedSort.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	CreatedSort.LayoutOrder = order
	CreatedSort.TextColor3 = Color3.new(1, 1, 1)
	CreatedSort.Text = text
	CreatedSort.TextScaled = true
	CreatedSort.BorderSizePixel = 0
	Corner:Clone().Parent = CreatedSort
	CreatedSort.Parent = SortFrame
	CreatedSort.MouseButton1Click:Connect(function()
		SortFrame.Visible = false
		CurrentSort = sort
		for i,Emote in pairs(Emotes) do
			if Frame:FindFirstChild(Emote.name) then
				local EmoteButton = Frame[Emote.name]
				if not table.find(FavoritedEmotes, Emote.name) then
					EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + #FavoritedEmotesSorted
				end
				EmoteButton.number.Text = Emote.sort[CurrentSort]
			end
		end
		SortFavoriteEmotes()
		for i,Emote in pairs(FavoritedEmotesSorted) do
			if Frame:FindFirstChild(Emote.name) then
				local EmoteButton = Frame[Emote.name]
				EmoteButton.LayoutOrder = i
			end
		end
	end)
	return CreatedSort
end

createsort(1, "Recently Updated First", "recentfirst")
createsort(2, "Recently Updated Last", "recentlast")
createsort(3, "Alphabetically First", "alphabeticfirst")
createsort(4, "Alphabetically Last", "alphabeticlast")
createsort(5, "Highest Price", "highestprice")
createsort(6, "Lowest Price", "lowestprice")

local SortButton = Instance.new("TextButton")
SortButton.BorderSizePixel = 0
SortButton.AnchorPoint = Vector2.new(0.5, 0.5)
SortButton.Position = UDim2.new(0.925, -5, -0.075, 0)
SortButton.Size = UDim2.new(0.15, 0, 0.1, 0)
SortButton.TextScaled = true
SortButton.TextColor3 = Color3.new(1, 1, 1)
SortButton.BackgroundColor3 = Color3.new(0, 0, 0)
SortButton.BackgroundTransparency = 0.3
SortButton.Text = "Sort"
SortButton.MouseButton1Click:Connect(function()
	SortFrame.Visible = not SortFrame.Visible
end)
Corner:Clone().Parent = SortButton
SortButton.Parent = BackFrame

local CloseButton = Instance.new("TextButton")
CloseButton.BorderSizePixel = 0
CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
CloseButton.Position = UDim2.new(0.075, 0, -0.075, 0)
CloseButton.Size = UDim2.new(0.15, 0, 0.1, 0)
CloseButton.TextScaled = true
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.new(0, 0, 0)
CloseButton.BackgroundTransparency = 0.3
CloseButton.Text = "Close"
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)
Corner:Clone().Parent = CloseButton
CloseButton.Parent = BackFrame

local SearchBar = Instance.new("TextBox")
SearchBar.BorderSizePixel = 0
SearchBar.AnchorPoint = Vector2.new(0.5, 0.5)
SearchBar.Position = UDim2.new(0.5, 0, -0.075, 0)
SearchBar.Size = UDim2.new(0.55, 0, 0.1, 0)
SearchBar.TextScaled = true
SearchBar.PlaceholderText = "Search"
SearchBar.TextColor3 = Color3.new(1, 1, 1)
SearchBar.BackgroundColor3 = Color3.new(0, 0, 0)
SearchBar.BackgroundTransparency = 0.3
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
	local text = SearchBar.Text:lower()
	local buttons = Frame:GetChildren()
	if text ~= text:sub(1,50) then
		SearchBar.Text = SearchBar.Text:sub(1,50)
		text = SearchBar.Text:lower()
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
Corner:Clone().Parent = SearchBar
SearchBar.Parent = BackFrame

local function openemotes(name, state, object)
	if state == Enum.UserInputState.Begin then
		ScreenGui.Enabled = not ScreenGui.Enabled
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
ScreenGui:GetPropertyChangedSignal("Enabled"):Connect(function()
	if ScreenGui.Enabled == true then
		EmoteName.Text = "Select an Emote"
		SearchBar.Text = ""
		SortFrame.Visible = false
		GuiService:SetEmotesMenuOpen(false)
		inputconnect = UserInputService.InputBegan:Connect(function(input, processed)
			if not processed then
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					ScreenGui.Enabled = false
				end
			end
		end)
	else
		inputconnect:Disconnect()
	end
end)

GuiService.EmotesMenuOpenChanged:Connect(function(isopen)
	if isopen then
		ScreenGui.Enabled = false
	end
end)

GuiService.MenuOpened:Connect(function()
	ScreenGui.Enabled = false
end)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

--thanks inf yield
local SynV3 = syn and DrawingImmediate
if (not is_sirhurt_closure) and (not SynV3) and (syn and syn.protect_gui) then
	syn.protect_gui(ScreenGui)
	ScreenGui.Parent = CoreGui
elseif get_hidden_gui or gethui then
	local hiddenUI = get_hidden_gui or gethui
	ScreenGui.Parent = hiddenUI()
else
	ScreenGui.Parent = CoreGui
end

local LocalPlayer = Players.LocalPlayer

local function PlayEmote(name, id)
	ScreenGui.Enabled = false
	SearchBar.Text = ""
	if name == "random" then
		local randomemote = Emotes[math.random(1, #Emotes)]
		name = randomemote.name
		id = randomemote.id
	end
	if LocalPlayer.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
		local succ, err = pcall(function()
			LocalPlayer.Character.Humanoid:PlayEmote(name)
		end)
		if not succ then
			pcall(function()
				LocalPlayer.Character.Humanoid.HumanoidDescription:AddEmote(name, id)
				LocalPlayer.Character.Humanoid:PlayEmote(name)
			end)
		end
	else
		StarterGui:SetCore("SendNotification", {
			Title = "r6? lol",
			Text = "you gotta be r15 dude"
		})
	end
end

local function CharacterAdded(Character)
	for i,v in pairs(Frame:GetChildren()) do
		if not v:IsA("UIGridLayout") then
			v:Destroy()
		end
	end
	local Humanoid = Character:WaitForChild("Humanoid")
	local Description = Humanoid:WaitForChild("HumanoidDescription")
	local random = Instance.new("TextButton")
	local Ratio = Instance.new("UIAspectRatioConstraint")
	Ratio.AspectType = Enum.AspectType.ScaleWithParentSize
	Ratio.Parent = random
	random.LayoutOrder = 0
	random.TextColor3 = Color3.new(1, 1, 1)
	random.BorderSizePixel = 0
	random.BackgroundTransparency = 0.5
	random.BackgroundColor3 = Color3.new(0, 0, 0)
	random.TextScaled = true
	random.Text = "Random"
	random:SetAttribute("name", "")
	Corner:Clone().Parent = random
	random.MouseButton1Click:Connect(function()
		PlayEmote("random")
	end)
	random.MouseEnter:Connect(function()
		EmoteName.Text = "Random"
	end)
	random.Parent = Frame
	for i,Emote in pairs(Emotes) do
		Description:AddEmote(Emote.name, Emote.id)
		local EmoteButton = Instance.new("ImageButton")
		if not table.find(FavoritedEmotes, Emote.name) then
			EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + #FavoritedEmotesSorted
		end
		EmoteButton.Name = Emote.name
		EmoteButton:SetAttribute("name", Emote.name)
		Corner:Clone().Parent = EmoteButton
		EmoteButton.Image = Emote.icon
		EmoteButton.BackgroundTransparency = 0.5
		EmoteButton.BackgroundColor3 = Color3.new(0, 0, 0)
		EmoteButton.BorderSizePixel = 0
		Ratio:Clone().Parent = EmoteButton
		local EmoteNumber = Instance.new("TextLabel")
		EmoteNumber.Name = "number"
		EmoteNumber.TextScaled = true
		EmoteNumber.BackgroundTransparency = 1
		EmoteNumber.TextColor3 = Color3.new(1, 1, 1)
		EmoteNumber.BorderSizePixel = 0
		EmoteNumber.AnchorPoint = Vector2.new(0.5, 0.5)
		EmoteNumber.Size = UDim2.new(0.2, 0, 0.2, 0)
		EmoteNumber.Position = UDim2.new(0.1, 0, 0.9, 0)
		EmoteNumber.Text = Emote.sort[CurrentSort]
		EmoteNumber.TextXAlignment = Enum.TextXAlignment.Center
		EmoteNumber.TextYAlignment = Enum.TextYAlignment.Center
		EmoteNumber.Parent = EmoteButton
		EmoteButton.Parent = Frame
		EmoteButton.MouseButton1Click:Connect(function()
			PlayEmote(Emote.name, Emote.id)
		end)
		EmoteButton.MouseEnter:Connect(function()
			EmoteName.Text = Emote.name
		end)
		local Favorite = Instance.new("ImageButton")
		Favorite.Name = "favorite"
		if table.find(FavoritedEmotes, Emote.name) then
			Favorite.Image = FavoriteOn
		else
			Favorite.Image = FavoriteOff
		end
		Favorite.AnchorPoint = Vector2.new(0.5, 0.5)
		Favorite.Size = UDim2.new(0.2, 0, 0.2, 0)
		Favorite.Position = UDim2.new(0.9, 0, 0.9, 0)
		Favorite.BorderSizePixel = 0
		Favorite.BackgroundTransparency = 1
		Favorite.Parent = EmoteButton
		Favorite.MouseButton1Click:Connect(function()
			local index = table.find(FavoritedEmotes, Emote.name)
			if index then
				table.remove(FavoritedEmotes, index)
				table.remove(FavoritedEmotesSorted, table.find(FavoritedEmotesSorted, Emote))
				Favorite.Image = FavoriteOff
				writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes))
				for i,Emote in pairs(Emotes) do
					if Frame:FindFirstChild(Emote.name) then
						local EmoteButton = Frame[Emote.name]
						if not table.find(FavoritedEmotes, Emote.name) then
							EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + #FavoritedEmotesSorted
						end
						EmoteButton.number.Text = Emote.sort[CurrentSort]
					end
				end
				SortFavoriteEmotes()
				for i,Emote in pairs(FavoritedEmotesSorted) do
					if Frame:FindFirstChild(Emote.name) then
						local EmoteButton = Frame[Emote.name]
						EmoteButton.LayoutOrder = i
					end
				end
			else
				table.insert(FavoritedEmotes, Emote.name)
				FavoritedEmotesSorted[#FavoritedEmotesSorted+1] = Emote
				Favorite.Image = FavoriteOn
				writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes))
				for i,Emote in pairs(Emotes) do
					if Frame:FindFirstChild(Emote.name) then
						local EmoteButton = Frame[Emote.name]
						if not table.find(FavoritedEmotes, Emote.name) then
							EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + #FavoritedEmotesSorted
						end
						EmoteButton.number.Text = Emote.sort[CurrentSort]
					end
				end
				SortFavoriteEmotes()
				for i,Emote in pairs(FavoritedEmotesSorted) do
					if Frame:FindFirstChild(Emote.name) then
						local EmoteButton = Frame[Emote.name]
						EmoteButton.LayoutOrder = i
					end
				end
			end
		end)
	end
	SortFavoriteEmotes()
	for i,Emote in pairs(FavoritedEmotesSorted) do
		if Frame:FindFirstChild(Emote.name) then
			local EmoteButton = Frame[Emote.name]
			EmoteButton.LayoutOrder = i
		end
	end
	for i=1,9 do
		local EmoteButton = Instance.new("Frame")
		EmoteButton.LayoutOrder = 2147483647
		EmoteButton.Name = "filler"
		EmoteButton.BackgroundTransparency = 1
		EmoteButton.BorderSizePixel = 0
		Ratio:Clone().Parent = EmoteButton
		EmoteButton.Visible = true
		EmoteButton.Parent = Frame
		EmoteButton.MouseEnter:Connect(function()
			EmoteName.Text = "Select an Emote"
		end)
	end
end

if LocalPlayer.Character ~= nil then
	CharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(CharacterAdded)
