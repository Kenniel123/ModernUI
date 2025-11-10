local ModernUI = {}
ModernUI.__index = ModernUI

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local GuiService = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

local function new(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k] = v end
    return inst
end

local function Tween(inst, prop, goal, time)
    TweenService:Create(inst, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[prop]=goal}):Play()
end

local function CreateTabObject(TabContent)
    local TabObj = {}
    TabObj.__index = TabObj

    function TabObj:CreateButton(text, callback)
        local Btn = new("TextButton", {
            Parent = TabContent,
            Text = text,
            BackgroundColor3 = Color3.fromRGB(45,45,45),
            TextColor3 = Color3.fromRGB(255,255,255),
            Size = UDim2.new(0,180,0,35),
            Position = UDim2.new(0,15,#TabContent:GetChildren()*45),
            Font = Enum.Font.Gotham,
            TextSize = 16,
            AutoButtonColor = false
        })
        new("UICorner",{Parent = Btn, CornerRadius=UDim.new(0,8)})

        Btn.MouseEnter:Connect(function() Tween(Btn,"BackgroundColor3",Color3.fromRGB(65,65,65)) end)
        Btn.MouseLeave:Connect(function() Tween(Btn,"BackgroundColor3",Color3.fromRGB(45,45,45)) end)
        Btn.MouseButton1Click:Connect(callback)
    end

    return setmetatable(TabObj, TabObj)
end

function ModernUI:CreateWindow(title)
    local selfTable = {}
    local ScreenGui = new("ScreenGui", {Parent = GuiService, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    local MainFrame = new("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(25,25,25),
        Size = UDim2.new(0,480,0,320),
        Position = UDim2.new(0.3,0,0.3,0)
    })
    new("UICorner",{Parent = MainFrame, CornerRadius = UDim.new(0,12)})

    local TopBar = new("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        Size = UDim2.new(1,0,0,40)
    })
    new("UICorner",{Parent = TopBar, CornerRadius = UDim.new(0,12)})

    local TitleLabel = new("TextLabel", {
        Parent = TopBar,
        Text = title or "Executor UI",
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7,0,1,0),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local CloseButton = new("TextButton", {
        Parent = TopBar,
        Text = "X",
        TextColor3 = Color3.fromRGB(255,75,75),
        BackgroundTransparency = 1,
        Size = UDim2.new(0,35,1,0),
        Position = UDim2.new(0.93,0,0,0),
        Font = Enum.Font.GothamBold,
        TextSize = 18
    })
    CloseButton.MouseEnter:Connect(function() Tween(CloseButton,"TextColor3",Color3.fromRGB(255,0,0)) end)
    CloseButton.MouseLeave:Connect(function() Tween(CloseButton,"TextColor3",Color3.fromRGB(255,75,75)) end)
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local MinimizeButton = new("TextButton", {
        Parent = TopBar,
        Text = "-",
        TextColor3 = Color3.fromRGB(255,200,0),
        BackgroundTransparency = 1,
        Size = UDim2.new(0,35,1,0),
        Position = UDim2.new(0.88,0,0,0),
        Font = Enum.Font.GothamBold,
        TextSize = 18
    })
    MinimizeButton.MouseEnter:Connect(function() Tween(MinimizeButton,"TextColor3",Color3.fromRGB(255,255,0)) end)
    MinimizeButton.MouseLeave:Connect(function() Tween(MinimizeButton,"TextColor3",Color3.fromRGB(255,200,0)) end)
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        ScreenGui.Enabled = not minimized
    end)

    local TabContainer = new("ScrollingFrame", {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,0,0,40),
        Size = UDim2.new(0.25,0,1,-40),
        ScrollBarThickness = 6
    })
    new("UICorner",{Parent = TabContainer, CornerRadius = UDim.new(0,8)})

    local ContentFrame = new("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        Position = UDim2.new(0.25,5,0,40),
        Size = UDim2.new(0.75,-5,1,-40)
    })
    new("UICorner",{Parent = ContentFrame, CornerRadius = UDim.new(0,8)})

    function selfTable:CreateTab(name)
        local TabButton = new("TextButton", {
            Parent = TabContainer,
            Text = name,
            BackgroundColor3 = Color3.fromRGB(45,45,45),
            Size = UDim2.new(1,0,0,35),
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextColor3 = Color3.fromRGB(255,255,255)
        })
        new("UICorner",{Parent = TabButton, CornerRadius = UDim.new(0,8)})

        local TabContent = new("Frame", {
            Parent = ContentFrame,
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Visible = false
        })

        TabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(ContentFrame:GetChildren()) do
                if v:IsA("Frame") then v.Visible = false end
            end
            TabContent.Visible = true
        end)

        return CreateTabObject(TabContent)
    end

    return selfTable
end

return ModernUI
