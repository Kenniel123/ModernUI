-- ModernUI 2025 (Tabs, Sections, Left/Right Columns, Auto Resize)
local ModernUI = {}
ModernUI.__index = ModernUI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local GuiService = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- Helpers
local function new(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k] = v end
    return inst
end

local function createUICorner(inst, radius)
    local corner = Instance.new("UICorner", inst)
    corner.CornerRadius = UDim.new(0, radius or 6)
    return corner
end

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Section class
local Section = {}
Section.__index = Section

function Section:UpdateLayout()
    -- Auto-arrange left/right columns
    local leftY, rightY = 10, 10
    for _, child in pairs(self.Container:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextBox") or child:IsA("TextButton") then
            local col = child:GetAttribute("Column") or "Left"
            if col == "Left" then
                child.Position = UDim2.new(0,10,0,leftY)
                leftY = leftY + child.Size.Y.Offset + 10
            else
                child.Position = UDim2.new(0.5,5,0,rightY)
                rightY = rightY + child.Size.Y.Offset + 10
            end
        end
    end
    -- Resize container height
    self.Container.Size = UDim2.new(1, -20, 0, math.max(leftY,rightY))
end

function Section:Button(opts)
    local btn = new("TextButton", {
        Parent = self.Container,
        Text = opts.Title or "Button",
        Size = UDim2.new(0.48,0,0,30),
        BackgroundColor3 = Color3.fromRGB(70,130,255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(18,18,20),
    })
    btn:SetAttribute("Column", opts.Column or "Left")
    createUICorner(btn,6)
    if opts.Callback then btn.MouseButton1Click:Connect(opts.Callback) end
    self:UpdateLayout()
    return btn
end

function Section:Toggle(opts)
    local frame = new("Frame", {
        Parent = self.Container,
        Size = UDim2.new(0.48,0,0,30),
        BackgroundColor3 = Color3.fromRGB(40,40,44),
    })
    frame:SetAttribute("Column", opts.Column or "Left")
    createUICorner(frame,6)

    local label = new("TextLabel", {
        Parent = frame,
        Text = opts.Title or "Toggle",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(200,200,200),
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7,0,1,0),
        Position = UDim2.new(0,10,0,0)
    })

    local box = new("Frame", {
        Parent = frame,
        Size = UDim2.new(0,20,0,20),
        Position = UDim2.new(1,-30,0,5),
        BackgroundColor3 = Color3.fromRGB(80,80,80)
    })
    createUICorner(box,4)

    local state = false
    frame.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Color3.fromRGB(80,170,255) or Color3.fromRGB(80,80,80)
        if opts.Callback then opts.Callback(state) end
    end)

    self:UpdateLayout()
    return frame
end

function Section:Slider(opts)
    local frame = new("Frame", {
        Parent = self.Container,
        Size = UDim2.new(0.48,0,0,30),
        BackgroundColor3 = Color3.fromRGB(40,40,44),
    })
    frame:SetAttribute("Column", opts.Column or "Left")
    createUICorner(frame,6)

    new("TextLabel", {
        Parent = frame,
        Text = opts.Title or "Slider",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(200,200,200),
        BackgroundTransparency = 1,
        Size = UDim2.new(0.3,0,1,0),
        Position = UDim2.new(0,10,0,0)
    })

    local bar = new("Frame", {
        Parent = frame,
        Size = UDim2.new(0.65,0,0.4,0),
        Position = UDim2.new(0.32,0,0.3,0),
        BackgroundColor3 = Color3.fromRGB(80,170,255)
    })
    createUICorner(bar,4)

    if opts.Callback then
        -- Optional: implement dragging value later
        bar.MouseButton1Click:Connect(function() opts.Callback(0) end)
    end

    self:UpdateLayout()
    return frame
end

function Section:Textbox(opts)
    local box = new("TextBox", {
        Parent = self.Container,
        PlaceholderText = opts.Placeholder or "",
        Size = UDim2.new(0.48,0,0,30),
        BackgroundColor3 = Color3.fromRGB(40,40,44),
        TextColor3 = Color3.fromRGB(220,220,220),
        Font = Enum.Font.Code,
        TextSize = 14,
    })
    box:SetAttribute("Column", opts.Column or "Left")
    createUICorner(box,6)
    self:UpdateLayout()
    return box
end

-- Tab class
local Tab = {}
Tab.__index = Tab

function Tab:Section(title)
    local frame = new("Frame", {
        Parent = self.Content,
        Size = UDim2.new(1,0,0,50),
        BackgroundColor3 = Color3.fromRGB(34,34,38),
        BorderSizePixel = 0,
    })
    createUICorner(frame,8)

    local label = new("TextLabel", {
        Parent = frame,
        Text = title or "Section",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(245,245,245),
        BackgroundTransparency = 1,
        Position = UDim2.new(0,10,0,5),
        Size = UDim2.new(1,-20,0,20)
    })

    local container = new("Frame", {
        Parent = frame,
        Size = UDim2.new(1,-20,0,0),
        Position = UDim2.new(0,10,0,30),
        BackgroundColor3 = Color3.fromRGB(44,44,52)
    })
    createUICorner(container,6)

    local section = setmetatable({Container=container, Frame=frame}, Section)
    table.insert(self.Sections, section)
    return section
end

-- ModernUI main
function ModernUI:CreateWindow(title)
    local selfTable = {}
    local gui = new("ScreenGui",{Parent=GuiService, ResetOnSpawn=false, Name="ModernUI"})
    
    local window = new("Frame",{Parent=gui, Size=UDim2.new(0,520,0,320), Position=UDim2.new(0.5,-260,0.5,-160), BackgroundColor3=Color3.fromRGB(18,18,22)})
    createUICorner(window,16)
    makeDraggable(window)

    -- Header
    local header = new("Frame",{Parent=window, Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(24,24,30)})
    local titleLbl = new("TextLabel",{Parent=header, Text=title or "Modern UI", Font=Enum.Font.GothamBold, TextSize=16, TextColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=1, Position=UDim2.new(0,18,0,0), Size=UDim2.new(0.6,0,1,0)})

    local btnClose = new("TextButton",{Parent=header, Text="✕", Font=Enum.Font.GothamBold, TextSize=18, TextColor3=Color3.fromRGB(230,230,230), BackgroundColor3=Color3.fromRGB(30,30,36), Size=UDim2.new(0,32,0,26), Position=UDim2.new(1,-35,0.5,-13)})
    createUICorner(btnClose,8)
    btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)

    local btnMin = new("TextButton",{Parent=header, Text="–", Font=Enum.Font.GothamBold, TextSize=18, TextColor3=Color3.fromRGB(230,230,230), BackgroundColor3=Color3.fromRGB(30,30,36), Size=UDim2.new(0,32,0,26), Position=UDim2.new(1,-70,0.5,-15)})
    createUICorner(btnMin,8)
    local minimized = false
    btnMin.MouseButton1Click:Connect(function()
        if minimized then window.Size=UDim2.new(0,520,0,320) else window.Size=UDim2.new(0,520,0,42) end
        minimized = not minimized
    end)

    -- Tabs container
    local tabs = new("Frame",{Parent=window, Size=UDim2.new(0,100,1,-42), Position=UDim2.new(0,0,0,42), BackgroundColor3=Color3.fromRGB(22,22,28)})
    local content = new("Frame",{Parent=window, Size=UDim2.new(1,-100,1,-42), Position=UDim2.new(0,100,0,42), BackgroundTransparency=1})

    function selfTable:CreateTab(name)
        local tabBtn = new("TextButton",{Parent=tabs, Text=name, Size=UDim2.new(1,0,0,34), Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(210,210,210), BackgroundColor3=Color3.fromRGB(32,32,38)})
        createUICorner(tabBtn,10)

        local tabContent = new("Frame",{Parent=content, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false})

        tabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(content:GetChildren()) do if v:IsA("Frame") then v.Visible=false end end
            tabContent.Visible = true
        end)

        local tabObj = setmetatable({Content=tabContent, Sections={}}, Tab)
        return tabObj
    end

    return selfTable
end

return ModernUI
