-- ModernUi.lua
local ModernUi = {}
ModernUi.__index = ModernUi
local Players = game:GetService("Players")

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

-- Constructor
function ModernUi.new(title)
	local self = setmetatable({}, ModernUi)
	local player = Players.LocalPlayer

	-- GUI
	local gui = Instance.new("ScreenGui")
	gui.Name = title or "UltraModernUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = player:WaitForChild("PlayerGui")
	self.gui = gui

	-- Window
	local window = Instance.new("Frame")
	window.Size = UDim2.new(0,520,0,320)
	window.Position = UDim2.new(0.5,-260,0.5,-160)
	window.BackgroundColor3 = Color3.fromRGB(18,18,22)
	window.BorderSizePixel = 0
	window.ClipsDescendants = true
	window.Parent = gui
	roundify(window,16)
	shadow(window)
	self.window = window

	-- Header
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1,0,0,42)
	header.BackgroundColor3 = Color3.fromRGB(24,24,30)
	header.BorderSizePixel = 0
	header.Parent = window
	roundify(header,16)
	self.header = header

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = title or "⚙ Krenka UI — 2025"
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 16
	titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Position = UDim2.new(0,18,0,0)
	titleLabel.Size = UDim2.new(0.6,0,1,0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Parent = header

	-- Sidebar + Content
	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0,100,1,-42)
	sidebar.Position = UDim2.new(0,0,0,42)
	sidebar.BackgroundColor3 = Color3.fromRGB(22,22,28)
	sidebar.BorderSizePixel = 0
	sidebar.Parent = window
	roundify(sidebar,14)
	self.sidebar = sidebar

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1,-100,1,-42)
	content.Position = UDim2.new(0,100,0,42)
	content.BackgroundColor3 = Color3.fromRGB(26,26,32)
	content.BorderSizePixel = 0
	content.Parent = window
	roundify(content,14)
	self.content = content

	return self
end

-- Section creation with chained API
function ModernUi:Section(name)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.45,0,0,140)
	frame.Position = UDim2.new(0,10,0,10) -- you can calculate dynamically
	frame.BackgroundColor3 = Color3.fromRGB(34,34,42)
	frame.BorderSizePixel = 0
	frame.Parent = self.content
	roundify(frame,12)
	shadow(frame)

	local title = Instance.new("TextLabel")
	title.Text = name
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextColor3 = Color3.fromRGB(245,245,245)
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0,12,0,8)
	title.Size = UDim2.new(1,-24,0,20)
	title.Parent = frame

	local section = {}
	section.Frame = frame

	-- Chained functions
	function section:Button(opts)
		local b = Instance.new("TextButton")
		b.Text = opts.Title or "Button"
		b.Font = Enum.Font.GothamSemibold
		b.TextSize = 14
		b.TextColor3 = Color3.fromRGB(255,255,255)
		b.BackgroundColor3 = Color3.fromRGB(70,130,255)
		b.Size = UDim2.new(1,-20,0,34)
		b.Position = UDim2.new(0,10,#frame:GetChildren()*40)
		b.BorderSizePixel = 0
		b.AutoButtonColor = true
		b.Parent = frame
		roundify(b,8)
		if opts.Callback then
			b.MouseButton1Click:Connect(opts.Callback)
		end
		return self
	end

	function section:Toggle(opts)
		local frameToggle = Instance.new("Frame")
		frameToggle.Size = UDim2.new(1,-20,0,34)
		frameToggle.Position = UDim2.new(0,10,#frame:GetChildren()*40)
		frameToggle.BackgroundColor3 = Color3.fromRGB(44,44,52)
		frameToggle.BorderSizePixel = 0
		frameToggle.Parent = frame
		roundify(frameToggle,8)

		local label = Instance.new("TextLabel")
		label.Text = opts.Title or "Toggle"
		label.Font = Enum.Font.Gotham
		label.TextSize = 14
		label.TextColor3 = Color3.fromRGB(220,220,220)
		label.BackgroundTransparency = 1
		label.Size = UDim2.new(0.7,0,1,0)
		label.Position = UDim2.new(0,10,0,0)
		label.Parent = frameToggle

		local switch = Instance.new("Frame")
		switch.Size = UDim2.new(0,22,0,22)
		switch.Position = UDim2.new(1,-32,0,6)
		switch.BackgroundColor3 = Color3.fromRGB(90,90,100)
		switch.BorderSizePixel = 0
		switch.Parent = frameToggle
		roundify(switch,11)

		if opts.Callback then
			switch.MouseButton1Click:Connect(opts.Callback)
		end
		return self
	end

	-- You can add Slider, Dropdown etc in same style

	return section
end

return ModernUi
