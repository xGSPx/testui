--[[
    Astral UI Library V3
    - Mobile Support (Auto Scale & Touch)
    - Draggable Mobile Toggle Button
    - Smooth Tweening
]]

local Astral = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- // UTILITY: Protect GUI \\ --
local function ProtectGui(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = CoreGui
    end
end

-- // UTILITY: Mobile/Touch Dragging \\ --
local function MakeDraggable(ClickObject, MoveObject)
    local Dragging = false
    local DragInput, DragStart, StartPos

    ClickObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MoveObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    ClickObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            local TargetPos = UDim2.new(
                StartPos.X.Scale, 
                StartPos.X.Offset + Delta.X, 
                StartPos.Y.Scale, 
                StartPos.Y.Offset + Delta.Y
            )
            TweenService:Create(MoveObject, TweenInfo.new(0.1), {Position = TargetPos}):Play()
        end
    end)
end

function Astral.MakeWindow(Configuration)
    local Settings = {
        Name = Configuration.Name or "Astral UI",
        KeySystem = Configuration.KeySystem or false,
        KeySettings = Configuration.KeySettings or {},
        ToggleKey = Configuration.ToggleKey or Enum.KeyCode.RightControl
    }

    local AstralScreen = Instance.new("ScreenGui")
    AstralScreen.Name = "AstralLib_Mobile"
    AstralScreen.ResetOnSpawn = false
    AstralScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ProtectGui(AstralScreen)

    -- // CHECK FOR MOBILE / SCREEN SIZE \\ --
    local ViewportSize = Workspace.CurrentCamera.ViewportSize
    local IsMobile = ViewportSize.X < 600 -- Rough detection for phones

    -- // KEY SYSTEM \\ --
    if Settings.KeySystem then
        local Validated = false
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Parent = AstralScreen
        KeyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
        
        -- Mobile Sizing for Key System
        if IsMobile then
            KeyFrame.Size = UDim2.new(0.8, 0, 0, 160)
        else
            KeyFrame.Size = UDim2.new(0, 350, 0, 150)
        end
        KeyFrame.Position = UDim2.new(0.5, -KeyFrame.Size.X.Offset/2, 0.5, -75)
        if IsMobile then KeyFrame.Position = UDim2.new(0.1, 0, 0.4, 0) end

        Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
        
        local KeyBox = Instance.new("TextBox")
        KeyBox.Parent = KeyFrame
        KeyBox.Size = UDim2.new(0.9, 0, 0, 40)
        KeyBox.Position = UDim2.new(0.05, 0, 0.3, 0)
        KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
        KeyBox.PlaceholderText = "Enter Key"
        KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,6)

        local SubmitBtn = Instance.new("TextButton")
        SubmitBtn.Parent = KeyFrame
        SubmitBtn.Size = UDim2.new(0.5, 0, 0, 35)
        SubmitBtn.Position = UDim2.new(0.25, 0, 0.65, 0)
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
        SubmitBtn.Text = "Submit"
        SubmitBtn.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0,6)

        SubmitBtn.MouseButton1Click:Connect(function()
            local Correct = Settings.KeySettings.Key
            if Settings.KeySettings.Mode == "API" then
                pcall(function() Correct = game:HttpGet(Settings.KeySettings.Url):gsub("%s+", "") end)
            end
            if KeyBox.Text == Correct then
                Validated = true
                TweenService:Create(KeyFrame, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
                KeyFrame:Destroy()
            else
                KeyBox.Text = "Incorrect"
                wait(1)
                KeyBox.Text = ""
            end
        end)
        repeat wait() until Validated
    end

    -- // MAIN FRAME \\ --
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Content = Instance.new("Frame")
    local TabContainer = Instance.new("ScrollingFrame") -- Scrollable tabs for mobile
    
    MainFrame.Parent = AstralScreen
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    -- DYNAMIC SIZING LOGIC
    if IsMobile then
        MainFrame.Size = UDim2.new(0.85, 0, 0.5, 0) -- 85% width on mobile
        MainFrame.Position = UDim2.new(0.075, 0, 0.25, 0)
    else
        MainFrame.Size = UDim2.new(0, 550, 0, 350)
        MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    end

    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    MakeDraggable(TopBar, MainFrame)

    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = Settings.Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.MouseButton1Click:Connect(function() AstralScreen:Destroy() end)

    -- // MOBILE TOGGLE BUTTON (Visual Icon) \\ --
    local MobileToggle = Instance.new("ImageButton")
    MobileToggle.Name = "MobileToggle"
    MobileToggle.Parent = AstralScreen
    MobileToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MobileToggle.Position = UDim2.new(0.1, 0, 0.15, 0) -- Top left area
    MobileToggle.Size = UDim2.new(0, 45, 0, 45)
    MobileToggle.Image = "rbxassetid://10618644218" -- Gear Icon
    MobileToggle.Visible = true 
    Instance.new("UICorner", MobileToggle).CornerRadius = UDim.new(0, 10)
    MakeDraggable(MobileToggle, MobileToggle) -- Mobile users can drag the button around

    local UI_Open = true
    local function ToggleUI()
        UI_Open = not UI_Open
        MainFrame.Visible = UI_Open
    end
    
    MobileToggle.MouseButton1Click:Connect(ToggleUI)
    
    -- Keyboard support still exists
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Settings.ToggleKey then ToggleUI() end
    end)

    -- // CONTENT AREA \\ --
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.Size = UDim2.new(0, 120, 0.9, -60) -- Sidebar style
    TabContainer.ScrollBarThickness = 0
    Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 6)
    
    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.Padding = UDim.new(0, 5)

    Content.Parent = MainFrame
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 140, 0, 50)
    Content.Size = UDim2.new(1, -150, 0.9, -60)

    -- // TAB LOGIC \\ --
    local Lib = {}

    function Lib:MakeTab(Config)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Text = Config.Name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 14

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Content
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        
        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 5)
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0, PageList.AbsoluteContentSize.Y + 20)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150,150,150)}):Play() 
                end 
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)

        local Elements = {}

        function Elements:AddButton(Config)
            local BtnFrame = Instance.new("Frame")
            BtnFrame.Parent = Page
            BtnFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            BtnFrame.Size = UDim2.new(1, -5, 0, 40) -- Larger for touch
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)

            local Btn = Instance.new("TextButton")
            Btn.Parent = BtnFrame
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = Config.Name
            Btn.TextColor3 = Color3.fromRGB(255,255,255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14

            Btn.MouseButton1Click:Connect(function()
                if Config.Callback then Config.Callback() end
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(60,60,60)}):Play()
                wait(0.1)
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(45,45,45)}):Play()
            end)
        end

        function Elements:AddToggle(Config)
            local Toggled = Config.Default or false
            local Frame = Instance.new("Frame")
            Frame.Parent = Page
            Frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
            Frame.Size = UDim2.new(1, -5, 0, 40)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

            local Text = Instance.new("TextLabel")
            Text.Parent = Frame
            Text.BackgroundTransparency = 1
            Text.Position = UDim2.new(0.05, 0, 0, 0)
            Text.Size = UDim2.new(0.7, 0, 1, 0)
            Text.Text = Config.Name
            Text.TextColor3 = Color3.fromRGB(255,255,255)
            Text.Font = Enum.Font.Gotham
            Text.TextSize = 14
            Text.TextXAlignment = Enum.TextXAlignment.Left

            local Indicator = Instance.new("Frame")
            Indicator.Parent = Frame
            Indicator.Position = UDim2.new(0.85, 0, 0.25, 0)
            Indicator.Size = UDim2.new(0, 20, 0, 20)
            Indicator.BackgroundColor3 = Toggled and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60)
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)

            local Btn = Instance.new("TextButton")
            Btn.Parent = Frame; Btn.Size = UDim2.new(1,0,1,0); Btn.BackgroundTransparency = 1; Btn.Text = ""
            
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Indicator.BackgroundColor3 = Toggled and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60)
                if Config.Callback then Config.Callback(Toggled) end
            end)
        end

        return Elements
    end

    return Lib
end

return Astral
