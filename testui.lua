-- // NEON VIBE UI LIBRARY (DIRECT VERSION) \\ --

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

function Library:CreateWindow(Settings)
    local Name = Settings.Name or "UI Library"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeonUI_" .. math.random(1,1000)
    ScreenGui.ResetOnSpawn = false
    
    -- Safe Parent Logic (Mobile Fix)
    if gethui then ScreenGui.Parent = gethui()
    elseif CoreGui:FindFirstChild("RobloxGui") then ScreenGui.Parent = CoreGui
    else ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Open Button (Bubble)
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Name = "OpenButton"
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Position = UDim2.new(0, 20, 0.4, 0)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    OpenBtn.BorderColor3 = Color3.fromRGB(170, 0, 255)
    OpenBtn.BorderSizePixel = 2
    OpenBtn.Text = "UI"
    OpenBtn.TextColor3 = Color3.fromRGB(170, 0, 255)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.Parent = ScreenGui
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- Outline
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = MainFrame
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(170, 0, 255)

    -- Dragging Logic
    local function MakeDraggable(gui)
        local dragging, dragStart, startPos
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        gui.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    MakeDraggable(OpenBtn)
    MakeDraggable(MainFrame)

    OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Text = Name
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextSize = 16
    Title.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Header
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Sidebar (Tabs)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 120, 1, -50)
    Sidebar.Position = UDim2.new(0, 10, 0, 45)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = MainFrame
    local SideLayout = Instance.new("UIListLayout", Sidebar); SideLayout.Padding = UDim.new(0, 5)

    -- Page Container
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -145, 1, -50)
    PageContainer.Position = UDim2.new(0, 135, 0, 45)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    local WindowFuncs = {}
    local FirstTab = true

    function WindowFuncs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.Parent = PageContainer
        local PLayout = Instance.new("UIListLayout", Page); PLayout.Padding = UDim.new(0, 5)
        PLayout.SortOrder = Enum.SortOrder.LayoutOrder

        if FirstTab then
            FirstTab = false
            TabBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Page.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
            end
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(170, 0, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            Page.Visible = true
        end)

        local TabFuncs = {}

        function TabFuncs:CreateSection(text)
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, -10, 0, 25)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = Color3.fromRGB(170, 0, 255)
            Lbl.Font = Enum.Font.GothamBold
            Lbl.TextSize = 14
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Page
            Page.CanvasSize = UDim2.new(0,0,0,PLayout.AbsoluteContentSize.Y)
        end

        function TabFuncs:CreateButton(cfg)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            Btn.Text = "  " .. cfg.Name
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
                pcall(cfg.Callback)
            end)
            Page.CanvasSize = UDim2.new(0,0,0,PLayout.AbsoluteContentSize.Y)
        end

        function TabFuncs:CreateToggle(cfg)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            Btn.Text = "  " .. cfg.Name
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            
            local Check = Instance.new("Frame")
            Check.Size = UDim2.new(0, 20, 0, 20)
            Check.Position = UDim2.new(1, -30, 0.5, -10)
            Check.BackgroundColor3 = cfg.Default and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(20, 20, 20)
            Check.Parent = Btn
            Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 4)
            
            local Toggled = cfg.Default or false
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                TweenService:Create(Check, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(20, 20, 20)}):Play()
                pcall(cfg.Callback, Toggled)
            end)
            Page.CanvasSize = UDim2.new(0,0,0,PLayout.AbsoluteContentSize.Y)
        end

        function TabFuncs:CreateInput(cfg)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -5, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            Frame.Parent = Page
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0.4, 0, 1, 0)
            Lbl.Position = UDim2.new(0, 10, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = cfg.Name
            Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 13
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Frame
            
            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(0.5, -10, 0.7, 0)
            Box.Position = UDim2.new(0.5, 0, 0.15, 0)
            Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Box.TextColor3 = Color3.fromRGB(200, 200, 200)
            Box.Text = ""
            Box.PlaceholderText = cfg.Placeholder or "..."
            Box.Font = Enum.Font.Gotham
            Box.TextSize = 12
            Box.Parent = Frame
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
            
            Box.FocusLost:Connect(function() pcall(cfg.Callback, Box.Text) end)
            Page.CanvasSize = UDim2.new(0,0,0,PLayout.AbsoluteContentSize.Y)
        end

        return TabFuncs
    end
    return WindowFuncs
end

-- // EXAMPLE USAGE (Delete this part to use in your own scripts) \\ --

local Window = Library:CreateWindow({Name = "Neon Exploit"})

local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("Character")
MainTab:CreateToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(val) print("God Mode:", val) end
})
MainTab:CreateButton({
    Name = "Reset",
    Callback = function() game.Players.LocalPlayer.Character.Humanoid.Health = 0 end
})

local FarmTab = Window:CreateTab("Auto Farm")
FarmTab:CreateSection("Settings")
FarmTab:CreateInput({
    Name = "Target",
    Placeholder = "Player Name",
    Callback = function(text) print("Target:", text) end
})