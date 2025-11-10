local ModernUI = {}
ModernUI.__index = ModernUI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local GuiService = player:WaitForChild("PlayerGui")

-- Helpers
local function new(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k] = v end
    return inst
end

local function Tween(inst, props, duration)
    TweenService:Create(inst, TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
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
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Section creator (inside tab content)
local function createSection(parent, titleText, y)
    local sec = new("Frame", {
        Parent = parent,
        Size = UDim2.new(0.45,0,0.45,0),
        Position = UDim2.new(0, (y%2)*170 + 10, 0, math.floor(y/2)*130 + 10),
        BackgroundColor3 = Color3.fromRGB(32,32,36)
    })
    new("UICorner",{Parent=sec, CornerRadius=UDim.new(0,10)})

    local title = new("TextLabel", {
        Parent = sec,
        Text = titleText,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(245,245,245),
        BackgroundTransparency = 1,
        Position = UDim2.new(0,10,0,5),
        Size = UDim2.new(1,-20,0,20)
    })

    return sec
end

-- Toggle for sections
local function createToggle(parent, text, default, callback)
    local frame = new("Frame", {Parent=parent, Size=UDim2.new(1,-20,0,30), Position=UDim2.new(0,10,0,30*#parent:GetChildren()), BackgroundColor3 = Color3.fromRGB(40,40,44)})
    new("UICorner",{Parent=frame, CornerRadius=UDim.new(0,6)})

    local label = new("TextLabel", {
        Parent = frame,
        Text = text,
        TextColor3 = Color3.fromRGB(200,200,200),
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7,0,1,0),
        Position = UDim2.new(0,10,0,0),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local box = new("Frame", {
        Parent = frame,
        Size = UDim2.new(0,20,0,20),
        Position = UDim2.new(1,-30,0,5),
        BackgroundColor3 = default and Color3.fromRGB(124,58,174) or Color3.fromRGB(80,80,80)
    })
    new("UICorner",{Parent=box, CornerRadius=UDim.new(0,4)})

    local state = default
    frame.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Color3.fromRGB(124,58,174) or Color3.fromRGB(80,80,80)
        if callback then callback(state) end
    end)
    return frame
end

-- Tab Object
local function CreateTabObject(tabContent)
    local TabObj = {}
    TabObj.__index = TabObj

    function TabObj:CreateSection(titleText, y)
        return createSection(tabContent, titleText, y)
    end

    function TabObj:CreateToggle(section, text, default, callback)
        return createToggle(section, text, default, callback)
    end

    return setmetatable(TabObj, TabObj)
end

-- Main Window
function ModernUI:CreateWindow(title)
    local selfTable = {}
    local gui = new("ScreenGui",{Parent=GuiService, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})

    local window = new("Frame", {
        Parent = gui,
        Size = UDim2.new(0,450,0,300),
        Position = UDim2.new(0.5,-225,0.5,-150),
        BackgroundColor3 = Color3.fromRGB(24,24,28)
    })
    new("UICorner",{Parent=window, CornerRadius=UDim.new(0,14)})
    makeDraggable(window)

    -- Header
    local header = new("Frame",{Parent=window, Size=UDim2.new(1,0,0,40), BackgroundTransparency=1})
    new("TextLabel",{
        Parent = header,
        Text = title or "Modern UI",
        Size = UDim2.new(1,-80,1,0),
        Position = UDim2.new(0,10,0,0),
        TextColor3 = Color3.fromRGB(245,245,245),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 16
    })
    local btnClose = new("TextButton", {
        Parent = header,
        Text="✕",
        Size=UDim2.new(0,30,0,30),
        Position=UDim2.new(1,-35,0.5,-15),
        BackgroundColor3=Color3.fromRGB(30,30,34),
        TextColor3=Color3.fromRGB(220,220,220)
    })
    new("UICorner",{Parent=btnClose, CornerRadius=UDim.new(0,6)})
    btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- Tabs (left)
    local tabs = new("Frame", {
        Parent = window,
        Size = UDim2.new(0,100,1,-40),
        Position = UDim2.new(0,0,0,40),
        BackgroundTransparency = 1
    })

    -- Content (right)
    local content = new("Frame", {
        Parent = window,
        Size = UDim2.new(1,-100,1,-40),
        Position = UDim2.new(0,100,0,40),
        BackgroundTransparency = 1
    })

    function selfTable:CreateTab(name)
        local tabButton = new("TextButton", {
            Parent = tabs,
            Text = name,
            Size = UDim2.new(1,0,0,35),
            BackgroundColor3 = Color3.fromRGB(34,34,38),
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(200,200,200)
        })
        new("UICorner",{Parent=tabButton, CornerRadius=UDim.new(0,8)})

        local tabContent = new("Frame", {Parent = content, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false})
        tabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(content:GetChildren()) do if v:IsA("Frame") then v.Visible=false end end
            tabContent.Visible=true
        end)

        return CreateTabObject(tabContent)
    end

    return selfTable
end

return ModernUI
