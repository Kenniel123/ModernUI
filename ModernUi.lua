local ModernUI = {}
ModernUI.__index = ModernUI

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local GuiService = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

-- Helpers
local function new(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k] = v end
    return inst
end

local function Tween(inst, props, duration, style, direction)
    TweenService:Create(inst, TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props):Play()
end

-- Glass frame
local function createGlassFrame(parent, size, pos)
    local frame = new("Frame", {
        Parent = parent,
        Size = size,
        Position = pos,
        BackgroundColor3 = Color3.fromRGB(11,18,32),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0
    })
    new("UICorner", {Parent=frame, CornerRadius=UDim.new(0,14)})
    local grad = new("UIGradient", {Parent=frame})
    grad.Color = ColorSequence.new(Color3.fromRGB(15,23,36), Color3.fromRGB(2,18,27))
    grad.Rotation = 90
    return frame
end

-- Toggle button
local function createToggle(parent, text, callback, default)
    local frame = new("Frame", {Parent=parent, Size=UDim2.new(1,0,0,35), BackgroundTransparency=1})
    local label = new("TextLabel", {
        Parent = frame,
        Text = text,
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7,0,1,0),
        Position = UDim2.new(0,10,0,0),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local btn = new("TextButton", {
        Parent = frame,
        Size = UDim2.new(0,30,0,20),
        Position = UDim2.new(0.75,0,0.15,0),
        BackgroundColor3 = default and Color3.fromRGB(124,58,174) or Color3.fromRGB(80,80,80),
        Text = "",
        AutoButtonColor = false
    })
    new("UICorner",{Parent=btn, CornerRadius=UDim.new(0,6)})
    new("UIStroke",{Parent=btn, Color=Color3.fromRGB(170,85,255), Thickness=1, Transparency=0.5})

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        Tween(btn, {BackgroundColor3 = state and Color3.fromRGB(124,58,174) or Color3.fromRGB(80,80,80)}, 0.2)
        callback(state)
    end)
    return frame
end

-- Tab object
local function CreateTabObject(TabContent)
    local TabObj = {}
    TabObj.__index = TabObj

    function TabObj:CreateButton(text, callback)
        local Btn = new("TextButton", {
            Parent = TabContent,
            Text = text,
            BackgroundColor3 = Color3.fromRGB(50,50,50),
            TextColor3 = Color3.fromRGB(255,255,255),
            Size = UDim2.new(0,200,0,40),
            Position = UDim2.new(0,20,#TabContent:GetChildren()*50),
            Font = Enum.Font.Gotham,
            TextSize = 16,
            AutoButtonColor = false
        })
        new("UICorner",{Parent=Btn, CornerRadius=UDim.new(0,10)})
        new("UIGradient",{Parent=Btn, Color=ColorSequence.new(Color3.fromRGB(60,60,60), Color3.fromRGB(40,40,40)), Rotation=45})

        Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Color3.fromRGB(75,75,75)},0.2) end)
        Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Color3.fromRGB(50,50,50)},0.2) end)
        Btn.MouseButton1Click:Connect(callback)
    end

    function TabObj:CreateToggle(text, default, callback)
        return createToggle(TabContent, text, callback, default)
    end

    return setmetatable(TabObj, TabObj)
end

-- Create main window
function ModernUI:CreateWindow(title)
    local selfTable = {}
    local ScreenGui = new("ScreenGui",{Parent=GuiService,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})

    local MainFrame = new("Frame",{
        Parent=ScreenGui,
        BackgroundColor3=Color3.fromRGB(28,28,28),
        Size=UDim2.fromOffset(300,350),
        Position=UDim2.new(0.5,-150,0.5,-175)
    })
    new("UICorner",{Parent=MainFrame,CornerRadius=UDim.new(0,14)})

    local TopBar = new("Frame",{
        Parent=MainFrame,
        BackgroundColor3=Color3.fromRGB(35,35,35),
        Size=UDim2.new(1,0,0,40)
    })
    new("UICorner",{Parent=TopBar,CornerRadius=UDim.new(0,14)})

    local TitleLabel = new("TextLabel",{
        Parent=TopBar,
        Text=title or "Modern UI",
        TextColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=1,
        Size=UDim2.new(0.7,0,1,0),
        Font=Enum.Font.GothamBold,
        TextSize=18,
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local CloseButton = new("TextButton",{
        Parent=TopBar,
        Text="X",
        TextColor3=Color3.fromRGB(255,75,75),
        BackgroundTransparency=1,
        Size=UDim2.new(0,35,1,0),
        Position=UDim2.new(0.93,0,0,0),
        Font=Enum.Font.GothamBold,
        TextSize=18
    })
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local MinimizeButton = new("TextButton",{
        Parent=TopBar,
        Text="-",
        TextColor3=Color3.fromRGB(255,200,0),
        BackgroundTransparency=1,
        Size=UDim2.new(0,35,1,0),
        Position=UDim2.new(0.88,0,0,0),
        Font=Enum.Font.GothamBold,
        TextSize=18
    })
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        Tween(MainFrame, {Size = minimized and UDim2.fromOffset(300,40) or UDim2.fromOffset(300,350)}, 0.25)
    end)

    local TabContainer = new("ScrollingFrame",{
        Parent=MainFrame,
        BackgroundTransparency=1,
        Position=UDim2.new(0,0,0,40),
        Size=UDim2.new(0.25,0,1,-40),
        ScrollBarThickness=6
    })
    new("UICorner",{Parent=TabContainer,CornerRadius=UDim.new(0,10)})

    local ContentFrame = new("Frame",{
        Parent=MainFrame,
        BackgroundColor3=Color3.fromRGB(38,38,38),
        Position=UDim2.new(0.25,5,0,40),
        Size=UDim2.new(0.75,-5,1,-40)
    })
    new("UICorner",{Parent=ContentFrame,CornerRadius=UDim.new(0,10)})

    function selfTable:CreateTab(name)
        local TabButton = new("TextButton",{
            Parent=TabContainer,
            Text=name,
            BackgroundColor3=Color3.fromRGB(50,50,50),
            Size=UDim2.new(1,0,0,40),
            Font=Enum.Font.GothamBold,
            TextSize=16,
            TextColor3=Color3.fromRGB(255,255,255)
        })
        new("UICorner",{Parent=TabButton,CornerRadius=UDim.new(0,10)})

        local TabContent = new("Frame",{
            Parent=ContentFrame,
            Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,
            Visible=false
        })

        TabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(ContentFrame:GetChildren()) do
                if v:IsA("Frame") then v.Visible=false end
            end
            TabContent.Visible=true
        end)

        return CreateTabObject(TabContent)
    end

    return selfTable
end

return ModernUI
