-- ModernUI Library (Executor-ready)
local ModernUI = {}
ModernUI.__index = ModernUI

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local GuiService = Player:WaitForChild("PlayerGui")

-- Helper function to make instances
local function new(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

-- Window Constructor
function ModernUI:CreateWindow(title)
    local selfTable = {}
    
    -- ScreenGui
    local ScreenGui = new("ScreenGui", {Parent = GuiService, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    
    -- Main Frame
    local MainFrame = new("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        Size = UDim2.new(0,400,0,300),
        Position = UDim2.new(0.3,0,0.3,0)
    })
    new("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0,10)})
    
    -- Top Bar
    local TopBar = new("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        Size = UDim2.new(1,0,0,30),
        Position = UDim2.new(0,0,0,0)
    })
    new("UICorner", {Parent = TopBar, CornerRadius = UDim.new(0,10)})
    
    local TitleLabel = new("TextLabel", {
        Parent = TopBar,
        Text = title or "Executor UI",
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7,0,1,0),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local CloseButton = new("TextButton", {
        Parent = TopBar,
        Text = "X",
        TextColor3 = Color3.fromRGB(255,75,75),
        BackgroundTransparency = 1,
        Size = UDim2.new(0,30,1,0),
        Position = UDim2.new(0.93,0,0,0),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tabs Container
    local TabContainer = new("ScrollingFrame", {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,0,0,30),
        Size = UDim2.new(0.25,0,1,-30),
        CanvasSize = UDim2.new(0,0,0,0),
        ScrollBarThickness = 6
    })
    new("UICorner", {Parent = TabContainer, CornerRadius = UDim.new(0,8)})
    
    -- Content Container
    local ContentFrame = new("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(50,50,50),
        Position = UDim2.new(0.25,5,0,30),
        Size = UDim2.new(0.75,-5,1,-30)
    })
    new("UICorner", {Parent = ContentFrame, CornerRadius = UDim.new(0,8)})
    
    -- Tab Function
    function selfTable:CreateTab(name)
        local TabButton = new("TextButton", {
            Parent = TabContainer,
            Text = name,
            BackgroundColor3 = Color3.fromRGB(60,60,60),
            Size = UDim2.new(1,0,0,30),
            Font = Enum.Font.SourceSansBold,
            TextSize = 16,
            TextColor3 = Color3.fromRGB(255,255,255)
        })
        new("UICorner", {Parent = TabButton, CornerRadius = UDim.new(0,6)})
        
        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1,0,1,0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentFrame
        
        TabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(ContentFrame:GetChildren()) do
                if v:IsA("Frame") then v.Visible = false end
            end
            TabContent.Visible = true
        end)
        
        function TabContent:CreateButton(text, callback)
            local Btn = new("TextButton", {
                Parent = TabContent,
                Text = text,
                Size = UDim2.new(0,150,0,30),
                Position = UDim2.new(0,10,#TabContent:GetChildren()*35),
                BackgroundColor3 = Color3.fromRGB(70,70,70),
                TextColor3 = Color3.fromRGB(255,255,255),
                Font = Enum.Font.SourceSans,
                TextSize = 16
            })
            new("UICorner", {Parent = Btn, CornerRadius = UDim.new(0,6)})
            Btn.MouseButton1Click:Connect(callback)
        end
        
        return TabContent
    end
    
    return selfTable
end

return ModernUI
