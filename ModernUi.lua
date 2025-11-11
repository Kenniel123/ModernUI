-- ModernUi.lua
-- ✨ Ultra Modern 2025 UI Library
local ModernUi = {}
ModernUi.__index = ModernUi

local Players = game:GetService("Players")

-- Utils
local function roundify(inst, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = inst
end

local function shadow(parent)
	local s = Instance.new("ImageLabel")
	s.Name = "Shadow"
	s.Image = "rbxassetid://1316045217"
	s.ImageColor3 = Color3.fromRGB(0,0,0)
	s.ImageTransparency = 0.8
	s.ScaleType = Enum.ScaleType.Slice
	s.SliceCenter = Rect.new(10,10,118,118)
	s.AnchorPoint = Vector2.new(0.5,0.5)
	s.Position = UDim2.new(0.5, 0, 0.5, 0)
	s.Size = UDim2.new(1, 24, 1, 24)
	s.ZIndex = parent.ZIndex - 1
	s.BackgroundTransparency = 1
	s.Parent = parent
end

-- Main constructor
function ModernUi.new(name)
	local self = setmetatable({}, ModernUi)
	local player = Players.LocalPlayer
	local gui = Instance.new("ScreenGui")
	gui.Name = name or "UltraModernUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = player:WaitForChild("PlayerGui")
	self.gui = gui

	-- Window
	local window = Instance.new("Frame")
	window.Size = UDim2.new(0, 520, 0, 320)
	window.Position = UDim2.new(0.5, -260, 0.5, -160)
	window.BackgroundColor3 = Color3.fromRGB(18,18,22)
	window.BorderSizePixel = 0
	window.ClipsDescendants = true
	window.Parent = gui
	roundify(window, 16)
	shadow(window)
	self.window = window

	-- Header
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1,0,0,42)
	header.BackgroundColor3 = Color3.fromRGB(24,24,30)
	header.BorderSizePixel = 0
	header.Parent = window
	roundify(header, 16)
	self.header = header

	local title = Instance.new("TextLabel")
	title.Text = name or "⚙ Krenka UI — 2025"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Position = UDim2.new(0, 18, 0, 0)
	title.Size = UDim2.new(0.6, 0, 1, 0)
	title.BackgroundTransparency = 1
	title.Parent = header
	self.title = title

	-- Top Buttons
	local function topBtn(txt, pos)
		local b = Instance.new("TextButton")
		b.Text = txt
		b.Font = Enum.Font.GothamBold
		b.TextSize = 18
		b.TextColor3 = Color3.fromRGB(230,230,230)
		b.BackgroundColor3 = Color3.fromRGB(30,30,36)
		b.Size = UDim2.new(0,32,0,26)
		b.Position = pos
		b.AnchorPoint = Vector2.new(1,0)
		b.AutoButtonColor = true
		b.BorderSizePixel = 0
		b.Parent = header
		roundify(b,8)
		return b
	end

	self.btnClose = topBtn("✕", UDim2.new(1,-35,0.5,-13))
	self.btnMin   = topBtn("–", UDim2.new(1,-70,0.5,-15))

	-- Sidebar
	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0,100,1,-42)
	sidebar.Position = UDim2.new(0,0,0,42)
	sidebar.BackgroundColor3 = Color3.fromRGB(22,22,28)
	sidebar.BorderSizePixel = 0
	sidebar.Parent = window
	roundify(sidebar,14)
	self.sidebar = sidebar

	-- Content
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1,-100,1,-42)
	content.Position = UDim2.new(0,100,0,42)
	content.BackgroundColor3 = Color3.fromRGB(26,26,32)
	content.BorderSizePixel = 0
	content.Parent = window
	roundify(content,14)
	self.content = content

	-- Gradient
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(80,140,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(160,100,255))
	}
	gradient.Rotation = 90
	gradient.Transparency = NumberSequence.new(0.9)
	gradient.Parent = content

	-- Button connections
	self.btnClose.MouseButton1Click:Connect(function()
		window.Visible = false
	end)
	local minimized = false
	self.btnMin.MouseButton1Click:Connect(function()
		if minimized then
			window.Size = UDim2.new(0,520,0,320)
		else
			window.Size = UDim2.new(0,520,0,42)
		end
		minimized = not minimized
	end)

	return self
end

-- Sidebar tabs
function ModernUi:AddTab(name, y)
	local t = Instance.new("TextButton")
	t.Text = name
	t.Font = Enum.Font.Gotham
	t.TextSize = 14
	t.TextColor3 = Color3.fromRGB(210,210,210)
	t.BackgroundColor3 = Color3.fromRGB(32,32,38)
	t.AutoButtonColor = true
	t.Size = UDim2.new(1,-20,0,34)
	t.Position = UDim2.new(0,10,0,y)
	t.BorderSizePixel = 0
	t.Parent = self.sidebar
	roundify(t,10)
	return t
end

-- Section
function ModernUi:CreateSection(name, i)
	local sec = Instance.new("Frame")
	sec.Size = UDim2.new(0.45,0,0,140)
	sec.Position = UDim2.new(0, (i%2)*200 + 10, 0, math.floor(i/2)*150 + 10)
	sec.BackgroundColor3 = Color3.fromRGB(34,34,42)
	sec.BorderSizePixel = 0
	sec.Parent = self.content
	roundify(sec,12)
	shadow(sec)

	local title = Instance.new("TextLabel")
	title.Text = name
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextColor3 = Color3.fromRGB(245,245,245)
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0,12,0,8)
	title.Size = UDim2.new(1,-24,0,20)
	title.Parent = sec
	return sec
end

-- UI Elements
function ModernUi:Dropdown(parent, text, y)
	local d = Instance.new("Frame")
	d.Size = UDim2.new(1,-20,0,34)
	d.Position = UDim2.new(0,10,0,y)
	d.BackgroundColor3 = Color3.fromRGB(44,44,52)
	d.BorderSizePixel = 0
	d.Parent = parent
	roundify(d,8)

	local label = Instance.new("TextLabel")
	label.Text = text.." ▼"
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(220,220,220)
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1,-10,1,0)
	label.Position = UDim2.new(0,10,0,0)
	label.Parent = d
	return d
end

function ModernUi:Toggle(parent, text, y)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,-20,0,34)
	frame.Position = UDim2.new(0,10,0,y)
	frame.BackgroundColor3 = Color3.fromRGB(44,44,52)
	frame.BorderSizePixel = 0
	frame.Parent = parent
	roundify(frame,8)

	local label = Instance.new("TextLabel")
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(220,220,220)
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(0.7,0,1,0)
	label.Position = UDim2.new(0,10,0,0)
	label.Parent = frame

	local switch = Instance.new("Frame")
	switch.Size = UDim2.new(0,22,0,22)
	switch.Position = UDim2.new(1,-32,0,6)
	switch.BackgroundColor3 = Color3.fromRGB(90,90,100)
	switch.BorderSizePixel = 0
	switch.Parent = frame
	roundify(switch,11)
	return frame
end

function ModernUi:Slider(parent, text, y)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,-20,0,44)
	frame.Position = UDim2.new(0,10,0,y)
	frame.BackgroundColor3 = Color3.fromRGB(44,44,52)
	frame.BorderSizePixel = 0
	frame.Parent = parent
	roundify(frame,8)

	local label = Instance.new("TextLabel")
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(220,220,220)
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0,10,0,4)
	label.Size = UDim2.new(0.4,0,0,18)
	label.Parent = frame

	local track = Instance.new("Frame")
	track.Size = UDim2.new(0.8,0,0,8)
	track.Position = UDim2.new(0.18,0,0.6,0)
	track.BackgroundColor3 = Color3.fromRGB(70,70,80)
	track.BorderSizePixel = 0
	track.Parent = frame
	roundify(track,6)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0.4,0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(70,130,255)
	fill.BorderSizePixel = 0
	fill.Parent = track
	roundify(fill,6)
	return frame
end

function ModernUi:Input(parent, placeholder, y)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,-20,0,34)
	frame.Position = UDim2.new(0,10,0,y)
	frame.BackgroundColor3 = Color3.fromRGB(44,44,52)
	frame.BorderSizePixel = 0
	frame.Parent = parent
	roundify(frame,8)

	local tb = Instance.new("TextBox")
	tb.PlaceholderText = placeholder
	tb.Size = UDim2.new(1,-14,1,-6)
	tb.Position = UDim2.new(0,7,0,3)
	tb.BackgroundTransparency = 1
	tb.TextColor3 = Color3.fromRGB(230,230,230)
	tb.Font = Enum.Font.Code
	tb.TextSize = 14
	tb.ClearTextOnFocus = false
	tb.Parent = frame
	return tb
end

function ModernUi:Button(parent, text, y)
	local b = Instance.new("TextButton")
	b.Text = text
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 14
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.BackgroundColor3 = Color3.fromRGB(70,130,255)
	b.Size = UDim2.new(1,-20,0,34)
	b.Position = UDim2.new(0,10,0,y)
	b.BorderSizePixel = 0
	b.AutoButtonColor = true
	b.Parent = parent
	roundify(b,8)
	return b
end

return ModernUi
