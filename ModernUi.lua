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

-- Draggable
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Toggle button
local function createToggle(parent, text, default, callback)
    local frame = new("Frame", {Parent=parent, Size=UDim2.new(1,0,0,35), BackgroundTransparency=1})
    local label = new("TextLabel", {
        Parent=frame,
        Text=text,
        TextColor3=Color3.fromRGB(245,245,245),
        BackgroundTransparency=1,
        Size=UDim2.new(0.7,0,1,0),
        Position=UDim2.new(0,10,0,0),
        Font=Enum.Font.Gotham,
        TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left
    })
    local btn = new("TextButton", {
        Parent=frame,
        Size=UDim2.new(0,30,0,20),
        Position=UDim2.new(0.75,0,0.15,0),
        BackgroundColor3 = default and Color3.fromRGB(124,58,174) or Color3.fromRGB(80,80,80),
        Text = "",
        AutoButtonColor = false
    })
    new("UICorner",{Parent=btn, CornerRadius=UDim.new(0,6)})
    new("UIStroke",{Parent=btn, Color=Color3.fromRGB(170,85,255), Transparency=0.6, Thickness=1})
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        Tween(btn, {BackgroundColor3 = state and Color3.fromRGB(124,58,174) or Color3.fromRGB(80,80,80)},0.2)
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
            BackgroundColor3 = Color3.fromRGB(40,40,44),
            TextColor3 = Color3.fromRGB(245,245,245),
            Size = UDim2.new(0,200,0,40),
            Position = UDim2.new(0,20,#TabContent:GetChildren()*50),
            Font = Enum.Font.Gotham,
            TextSize = 16,
            AutoButtonColor = false
        })
        new("UICorner",{Parent=Btn, CornerRadius=UDim.new(0,10)})
        new("UIStroke",{Parent=Btn, Color=Color3.fromRGB(124,58,174), Transparency=0.5, Thickness=1})
        Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Color3.fromRGB(60,60,65)},0.2) end)
        Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Color3.fromRGB(40,40,44)},0.2) end)
        Btn.MouseButton1Click:Connect(callback)
    end

    function TabObj:CreateToggle(text, default, callback)
        return createToggle(TabContent, text, default, callback)
    end

    return setmetatable(TabObj, TabObj)
end

-- Main window
function ModernUI:CreateWindow(title)
    local selfTable = {}
    local gui = new("ScreenGui",{Parent=GuiService,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})

    local root = new("Frame",{
        Parent=gui,
        Size=UDim2.fromOffset(300,350),
        Position=UDim2.new(0.5,-150,0.5,-175),
        BackgroundColor3=Color3.fromRGB(18,18,20)
    })
    new("UICorner",{Parent=root, CornerRadius=UDim.new(0,14)})
    new("UIStroke",{Parent=root, Color=Color3.fromRGB(124,58,174), Thickness=1, Transparency=0.7})
    makeDraggable(root)

    -- Header
    local header = new("Frame", {Parent=root, Size=UDim2.new(1,0,0,50), BackgroundTransparency=1})
    local titleLabel = new("TextLabel", {
        Parent=header,
        Text=title or "Modern UI",
        Size=UDim2.new(1,-50,1,0),
        Position=UDim2.new(0,10,0,0),
        TextColor3=Color3.fromRGB(245,245,245),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=18,
        TextXAlignment=Enum.TextXAlignment.Left
    })
    local btnClose = new("TextButton", {
        Parent=header,
        Text="✕",
        Size=UDim2.new(0,36,0,36),
        Position=UDim2.new(1,-46,0.5,-18),
        BackgroundColor3=Color3.fromRGB(30,30,34),
        TextColor3=Color3.fromRGB(220,220,220),
        Font=Enum.Font.Gotham,
        TextSize=18
    })
    new("UICorner",{Parent=btnClose, CornerRadius=UDim.new(0,10)})
    btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- Tab container
    local tabContainer = new("ScrollingFrame", {
        Parent=root,
        Position=UDim2.new(0,0,0,50),
        Size=UDim2.new(0.25,0,1,-50),
        BackgroundTransparency=1,
        ScrollBarThickness=6
    })
    new("UICorner",{Parent=tabContainer, CornerRadius=UDim.new(0,10)})

    local contentFrame = new("Frame", {
        Parent=root,
        BackgroundColor3=Color3.fromRGB(28,28,30),
        Position=UDim2.new(0.25,5,0,50),
        Size=UDim2.new(0.75,-5,1,-50)
    })
    new("UICorner",{Parent=contentFrame, CornerRadius=UDim.new(0,10)})

    function selfTable:CreateTab(name)
        local tabButton = new("TextButton", {
            Parent=tabContainer,
            Text=name,
            Size=UDim2.new(1,0,0,40),
            BackgroundColor3=Color3.fromRGB(40,40,44),
            Font=Enum.Font.GothamBold,
            TextSize=16,
            TextColor3=Color3.fromRGB(245,245,245)
        })
        new("UICorner",{Parent=tabButton, CornerRadius=UDim.new(0,10)})
        local tabContent = new("Frame", {Parent=contentFrame, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false})
        tabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(contentFrame:GetChildren()) do if v:IsA("Frame") then v.Visible=false end end
            tabContent.Visible=true
        end)
        return CreateTabObject(tabContent)
    end

    return selfTable
end

return ModernUI
