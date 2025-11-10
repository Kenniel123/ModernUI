-- ModernUI (Mockup -> Functional)
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

local function createUICorner(inst, radius)
    local corner = Instance.new("UICorner", inst)
    corner.CornerRadius = UDim.new(0, radius or 6)
    return corner
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

-- Control creators
local function createDropdown(parent, text, y)
    local drop = new("Frame",{Parent=parent, Size=UDim2.new(1,-20,0,30), Position=UDim2.new(0,10,0,y), BackgroundColor3=Color3.fromRGB(40,40,44)})
    createUICorner(drop,6)
    new("TextLabel",{Parent=drop, Text=text.." ▼", Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(200,200,200), BackgroundTransparency=1, Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,5,0,0)})
    return drop
end

local function createToggle(parent, text, y)
    local frame = new("Frame",{Parent=parent, Size=UDim2.new(1,-20,0,30), Position=UDim2.new(0,10,0,y), BackgroundColor3=Color3.fromRGB(40,40,44)})
    createUICorner(frame,6)
    new("TextLabel",{Parent=frame, Text=text, Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(200,200,200), BackgroundTransparency=1, Size=UDim2.new(0.7,0,1,0), Position=UDim2.new(0,10,0,0)})
    local box = new("Frame",{Parent=frame, Size=UDim2.new(0,20,0,20), Position=UDim2.new(1,-30,0,5), BackgroundColor3=Color3.fromRGB(80,80,80)})
    createUICorner(box,4)
    local state = false
    frame.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Color3.fromRGB(80,170,255) or Color3.fromRGB(80,80,80)
    end)
    return frame
end

local function createSlider(parent, text, y)
    local frame = new("Frame",{Parent=parent, Size=UDim2.new(1,-20,0,30), Position=UDim2.new(0,10,0,y), BackgroundColor3=Color3.fromRGB(40,40,44)})
    createUICorner(frame,6)
    new("TextLabel",{Parent=frame, Text=text, Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(200,200,200), BackgroundTransparency=1, Size=UDim2.new(0.3,0,1,0), Position=UDim2.new(0,10,0,0)})
    local bar = new("Frame",{Parent=frame, Size=UDim2.new(0.65,0,0.4,0), Position=UDim2.new(0.32,0,0.3,0), BackgroundColor3=Color3.fromRGB(80,170,255)})
    createUICorner(bar,4)
    return frame
end

local function createTextbox(parent, text, y)
    local box = new("TextBox",{Parent=parent, PlaceholderText=text, Size=UDim2.new(1,-20,0,30), Position=UDim2.new(0,10,0,y), BackgroundColor3=Color3.fromRGB(40,40,44), TextColor3=Color3.fromRGB(220,220,220), Font=Enum.Font.Code, TextSize=14, Text=""})
    createUICorner(box,6)
    return box
end

local function createButton(parent, text, y)
    local btn = new("TextButton",{Parent=parent, Text=text, Size=UDim2.new(1,-20,0,30), Position=UDim2.new(0,10,0,y), Font=Enum.Font.GothamBold, TextSize=14, TextColor3=Color3.fromRGB(18,18,20), BackgroundColor3=Color3.fromRGB(80,170,255)})
    createUICorner(btn,6)
    return btn
end

-- Section
local function createSection(parent, titleText, y)
    local sec = new("Frame",{Parent=parent, Size=UDim2.new(0.45,0,0.45,0), Position=UDim2.new(0, (y%2)*170 + 10, 0, math.floor(y/2)*130 + 10), BackgroundColor3=Color3.fromRGB(32,32,36)})
    createUICorner(sec,10)
    new("TextLabel",{Parent=sec, Text=titleText, Font=Enum.Font.GothamBold, TextSize=14, TextColor3=Color3.fromRGB(245,245,245), BackgroundTransparency=1, Position=UDim2.new(0,10,0,5), Size=UDim2.new(1,-20,0,20)})
    return sec
end

-- Window
function ModernUI:CreateWindow(title)
    local selfTable = {}
    local gui = new("ScreenGui",{Parent=GuiService, ResetOnSpawn=false, Name="ModernUI"})
    
    local window = new("Frame",{Parent=gui, Size=UDim2.new(0,450,0,300), Position=UDim2.new(0.5,-225,0.5,-150), BackgroundColor3=Color3.fromRGB(24,24,28)})
    createUICorner(window,14)
    makeDraggable(window)
    
    -- Header
    local header = new("Frame",{Parent=window, Size=UDim2.new(1,0,0,40), BackgroundTransparency=1})
    new("TextLabel",{Parent=header, Text=title or "Modern UI", Font=Enum.Font.GothamBold, TextSize=16, TextColor3=Color3.fromRGB(245,245,245), BackgroundTransparency=1, Size=UDim2.new(1,-80,1,0), Position=UDim2.new(0,10,0,0)})
    
    local btnClose = new("TextButton",{Parent=header, Text="✕", Font=Enum.Font.GothamBold, TextSize=18, TextColor3=Color3.fromRGB(220,220,220), BackgroundColor3=Color3.fromRGB(30,30,34), Size=UDim2.new(0,30,0,30), Position=UDim2.new(1,-35,0.5,-15)})
    createUICorner(btnClose,6)
    btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)
    
    local btnMin = new("TextButton",{Parent=header, Text="–", Font=Enum.Font.GothamBold, TextSize=18, TextColor3=Color3.fromRGB(220,220,220), BackgroundColor3=Color3.fromRGB(30,30,34), Size=UDim2.new(0,30,0,30), Position=UDim2.new(1,-70,0.5,-15)})
    createUICorner(btnMin,6)
    local minimized = false
    btnMin.MouseButton1Click:Connect(function()
        if minimized then window.Size = UDim2.new(0,450,0,300) else window.Size = UDim2.new(0,450,0,40) end
        minimized = not minimized
    end)
    
    -- Tabs
    local tabs = new("Frame",{Parent=window, Size=UDim2.new(0,100,1,-40), Position=UDim2.new(0,0,0,40), BackgroundTransparency=1})
    local content = new("Frame",{Parent=window, Size=UDim2.new(1,-100,1,-40), Position=UDim2.new(0,100,0,40), BackgroundTransparency=1})
    
    function selfTable:CreateTab(name)
        local tabBtn = new("TextButton",{Parent=tabs, Text=name, Size=UDim2.new(1,0,0,35), BackgroundColor3=Color3.fromRGB(34,34,38), Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(200,200,200)})
        createUICorner(tabBtn,8)
        local tabContent = new("Frame",{Parent=content, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false})
        tabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(content:GetChildren()) do if v:IsA("Frame") then v.Visible=false end end
            tabContent.Visible = true
        end)
        local tabObj = {CreateSection=function(self, title,y) return createSection(tabContent,title,y) end, CreateDropdown=function(self, parent, text,y) return createDropdown(parent,text,y) end, CreateToggle=function(self, parent, text,y) return createToggle(parent,text,y) end, CreateSlider=function(self, parent,text,y) return createSlider(parent,text,y) end, CreateTextbox=function(self, parent,text,y) return createTextbox(parent,text,y) end, CreateButton=function(self,parent,text,y) return createButton(parent,text,y) end}
        return setmetatable(tabObj,{__index=tabObj})
    end
    
    return selfTable
end

return ModernUI
