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
            BackgroundColor3 = Color3.fromRGB(50,50,50),
            TextColor3 = Color3.fromRGB(255,255,255),
            Size = UDim2.new(0,200,0,40),
            Position = UDim2.new(0,20,#TabContent:GetChildren()*50),
            Font = Enum.Font.Gotham,
            TextSize = 16,
            AutoButtonColor = false
        })
        local corner = new("UICorner", {Parent=Btn, CornerRadius=UDim.new(0,10)})

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new(Color3.fromRGB(60,60,60), Color3.fromRGB(40,40,40))
        gradient.Rotation = 45
        gradient.Parent = Btn

        Btn.MouseEnter:Connect(function()
            Tween(Btn,"BackgroundColor3",Color3.fromRGB(75,75,75))
        end)
        Btn.MouseLeave:Connect(function()
            Tween(Btn,"BackgroundColor3",Color3.fromRGB(50,50,50))
        end)
        Btn.MouseButton1Click:Connect(callback)
    end

    return setmetatable(TabObj, TabObj)
end

function ModernUI:CreateWindow(title)
    local selfTable = {}
    local ScreenGui = new("ScreenGui",{Parent=GuiService,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    
    local MainFrame = new("Frame",{
        Parent=ScreenGui,
        BackgroundColor3=Color3.fromRGB(28,28,28),
        Size=UDim2.new(0,500,0,350),
        Position=UDim2.new(0.25,0,0.25,0)
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
        Text=title or "Executor UI",
        TextColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=1,
        Size=UDim2.new(0.7,0,1,0),
        Font=Enum.Font.GothamBold,
        TextSize=20,
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
    CloseButton.MouseEnter:Connect(function() Tween(CloseButton,"TextColor3",Color3.fromRGB(255,0,0)) end)
    CloseButton.MouseLeave:Connect(function() Tween(CloseButton,"TextColor3",Color3.fromRGB(255,75,75)) end)
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
    MinimizeButton.MouseEnter:Connect(function() Tween(MinimizeButton,"TextColor3",Color3.fromRGB(255,255,0)) end)
    MinimizeButton.MouseLeave:Connect(function() Tween(MinimizeButton,"TextColor3",Color3.fromRGB(255,200,0)) end)
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        MainFrame.Size = minimized and UDim2.new(0,500,0,40) or UDim2.new(0,500,0,350)
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
