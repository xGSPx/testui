-- VOIDHUB v3.5 • MOBILE + SMALL UI EDITION (2025)
local VOIDHUB = {}

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- AUTO DETECT MOBILE
local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- DYNAMIC SIZING (small on mobile, normal on PC)
local Scale = IsMobile and 0.75 or 1
local Width = IsMobile and 420 or 560
local Height = IsMobile and 520 or 560

-- CONFIG
local CONFIG_FOLDER = "VOIDHUB_MOBILE"
if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
local ConfigData = {}
local ConfigName = "default"

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VOIDHUB_MOBILE"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- MAIN FRAME (smaller + rounded)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, Width * Scale, 0, Height * Scale)
MainFrame.Position = UDim2.new(0.5, -(Width*Scale)/2, 0.5, -(Height*Scale)/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 18)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(100, 100, 255)
Stroke.Thickness = 2.5

-- TOPBAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Text = "VOIDHUB MOBILE"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = IsMobile and 18 or 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- DELETE & MINIMIZE (bigger touch area on mobile)
local Delete = Instance.new("TextButton")
Delete.Size = UDim2.new(0, 50, 0, 50)
Delete.Position = UDim2.new(1, -58, 0, 0)
Delete.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
Delete.Text = "X"
Delete.TextColor3 = Color3.new(1, 1, 1)
Delete.Font = Enum.Font.GothamBold
Delete.TextSize = 22
Delete.Parent = TopBar
Instance.new("UICorner", Delete).CornerRadius = UDim.new(0, 16)
Delete.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 50, 0, 50)
Minimize.Position = UDim2.new(1, -110, 0, 0)
Minimize.BackgroundColor3 = Color3.fromRGB(90, 90, 255)
Minimize.Text = "−"
Minimize.TextColor3 = Color3.new(1, 1, 1)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 28
Minimize.Parent = TopBar
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 16)

-- HIDE CIRCLE (mobile friendly)
local Circle = Instance.new("Frame")
Circle.Size = UDim2.new(0, 80, 0, 80)
Circle.Position = UDim2.new(0, 30, 0.5, -40)
Circle.BackgroundColor3 = Color3.fromRGB(90, 90, 255)
Circle.Visible = false
Circle.Parent = ScreenGui
Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
local Plus = Instance.new("TextLabel", Circle)
Plus.Size = UDim2.new(1, 0, 1, 0)
Plus.BackgroundTransparency = 1
Plus.Text = "+"
Plus.TextColor3 = Color3.new(1, 1, 1)
Plus.Font = Enum.Font.GothamBold
Plus.TextSize = 48

-- DRAG FUNCTION (works on touch too)
local function Drag(frame)
    local dragging, start, orig
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = input.Position
            orig = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - start
            frame.Position = UDim2.new(orig.X.Scale, orig.X.Offset + delta.X, orig.Y.Scale, orig.Y.Offset + delta.Y)
        end
    end)
end
Drag(TopBar)
Drag(Circle)

-- MINIMIZE LOGIC
local hidden = false
Minimize.MouseButton1Click:Connect(function()
    hidden = not hidden
    if hidden then
        TS:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.4)
        MainFrame.Visible = false
        Circle.Visible = true
    else
        MainFrame.Visible = true
        Circle.Visible = false
        TS:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, Width * Scale, 0, Height * Scale)}):Play()
    end
end)
Circle.MouseButton1Click:Connect(function() Minimize.MouseButton1Click:Fire() end)

-- TABS & CONTENT
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 140, 1, -50)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 4
TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabContainer.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout", TabContainer)
TabLayout.Padding = UDim.new(0, 8)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -140, 1, -50)
Content.Position = UDim2.new(0, 140, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- CONFIG SAVE/LOAD
local function SaveConfig()
    writefile(CONFIG_FOLDER.."/"..ConfigName..".json", HttpService:JSONEncode(ConfigData))
end

local function LoadConfig(name)
    if isfile(CONFIG_FOLDER.."/"..name..".json") then
        ConfigData = HttpService:JSONDecode(readfile(CONFIG_FOLDER.."/"..name..".json"))
        ConfigName = name
        return true
    end
    return false
end

if isfile(CONFIG_FOLDER.."/default.json") then LoadConfig("default") end

-- NEW TAB FUNCTION (same components, smaller size)
function VOIDHUB:NewTab(name, icon)
    icon = icon or "◆"
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -16, 0, 48)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    TabBtn.Text = "  "..icon.."  "..name
    TabBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = IsMobile and 16 or 18
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Parent = TabContainer
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 12)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -20, 1, -20)
    Page.Position = UDim2.new(0, 10, 0, 10)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 5
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Visible = false
    Page.Parent = Content
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 10)

    local function Select()
        for _, v in TabContainer:GetChildren() do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                v.TextColor3 = Color3.fromRGB(220, 220, 220)
            end
        end
        for _, v in Content:GetChildren() do if v:IsA("ScrollingFrame") then v.Visible = false end end
        TabBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        TabBtn.TextColor3 = Color3.new(1, 1, 1)
        Page.Visible = true
    end
    TabBtn.MouseButton1Click:Connect(Select)

    local Tab = {}

    function Tab:Button(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 46)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = IsMobile and 16 or 18
        btn.Parent = Page
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        btn.MouseButton1Click:Connect(callback or function() end)
    end

    function Tab:Toggle(text, default, callback)
        local key = text
        local val = ConfigData[key] ~= nil and ConfigData[key] or default

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 46)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        frame.Parent = Page
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

        local label = Instance.new("TextLabel", frame)
        label.Text = text
        label.Size = UDim2.new(1, -80, 1, 0)
        label.Position = UDim2.new(0, 14, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.TextSize = IsMobile and 16 or 18

        local switch = Instance.new("TextButton", frame)
        switch.Size = UDim2.new(0, 64, 0, 34)
        switch.Position = UDim2.new(1, -78, 0.5, -17)
        switch.BackgroundColor3 = val and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(70, 70, 70)
        switch.Text = ""
        Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

        local ball = Instance.new("Frame", switch)
        ball.Size = UDim2.new(0, 28, 0, 28)
        ball.Position = val and UDim2.new(1, -32, 0.5, -14) or UDim2.new(0, 4, 0.5, -14)
        ball.BackgroundColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)

        switch.MouseButton1Click:Connect(function()
            val = not val
            ConfigData[key] = val
            SaveConfig()
            TS:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = val and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(70, 70, 70)}):Play()
            TS:Create(ball, TweenInfo.new(0.2), {Position = val and UDim2.new(1, -32, 0.5, -14) or UDim2.new(0, 4, 0.5, -14)}):Play()
            if callback then callback(val) end
        end)
    end

    function Tab:Slider(text, min, max, default, callback)
        local key = text
        local val = ConfigData[key] or default

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 70)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        frame.Parent = Page
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

        local label = Instance.new("TextLabel", frame)
        label.Text = text.." : "..val
        label.Size = UDim2.new(1, 0, 0, 30)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.Gotham
        label.TextSize = IsMobile and 16 or 18

        local bar = Instance.new("Frame", frame)
        bar.Size = UDim2.new(1, -30, 0, 18)
        bar.Position = UDim2.new(0, 15, 0, 45)
        bar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 9)

        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 9)

        local knob = Instance.new("Frame", fill)
        knob.Size = UDim2.new(0, 32, 0, 32)
        knob.Position = UDim2.new(1, -16, -0.4, 0)
        knob.BackgroundColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local dragging = false
        bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
        bar.InputEnded:Connect(function() dragging = false end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local percent = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * percent)
                ConfigData[key] = val
                SaveConfig()
                label.Text = text.." : "..val
                fill.Size = UDim2.new(percent, 0, 1, 0)
                if callback then callback(val) end
            end
        end)
    end

    -- Add your other components (Dropdown, Keybind, Textbox) the same way — just smaller

    function Tab:ConfigSection()
        Tab:Button("Save Config", SaveConfig)
        Tab:Button("Load Default", function() LoadConfig("default") end)
        Tab:Button("List Configs", function()
            for _, f in listfiles(CONFIG_FOLDER) do print(f) end
        end)
    end

    return Tab
end

-- TEST TABS
local Combat = VOIDHUB:NewTab("Combat", "⚔️")
Combat:Toggle("Kill Aura", false, function(v) print("KA:", v) end)
Combat:Slider("Range", 5, 50, 20, function(v) print("Range:", v) end)
Combat:Button("Fling All", function() loadstring(game:HttpGet("https://pastebin.com/raw/gKZmSBEw"))() end)

local Move = VOIDHUB:NewTab("Movement", "🚀")
Move:Slider("Speed", 16, 300, 100, function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end)

local Config = VOIDHUB:NewTab("Config", "⚙️")
Config:ConfigSection()

-- NOTIF
game.StarterGui:SetCore("SendNotification", {
    Title = "VOIDHUB MOBILE v3.5";
    Text = IsMobile and "Perfect on phone!" or "Compact mode active";
    Duration = 5;
})

return VOIDHUB