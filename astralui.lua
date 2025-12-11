--[[
    Astral UI Library V5 (Purple Neon Style & Button Fix)
    - Purple/Black Aesthetic
    - Neon UIStroke Glow
    - Mobile Support & Functionality Retained
]]

local Astral = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
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
    
    local AccentColor = Color3.fromRGB(150, 0, 255) -- Bright Purple
    local BaseColor = Color3.fromRGB(15, 15, 15) -- Deep Black/Purple Base
    local SecondaryColor = Color3.fromRGB(30, 0, 50) -- Dark Purple for Frames

    local ViewportSize = Workspace.CurrentCamera.ViewportSize
    local IsMobile = ViewportSize.X < 600

    local AstralScreen = Instance.new("ScreenGui")
    AstralScreen.Name = "AstralLib_V5"
    AstralScreen.ResetOnSpawn = false
    ProtectGui(AstralScreen)

    -- // KEY SYSTEM (Simple Stub) \\ --
    if Settings.KeySystem then
        local Validated = false
        local KeyFrame = Instance.new("Frame", AstralScreen); KeyFrame.Size = UDim2.new(0.5,0,0.5,0); KeyFrame.Position = UDim2.new(0.25,0,0.25,0)
        Validated = true
        wait(1)
        KeyFrame:Destroy()
        if not Validated then repeat wait() until Validated end
    end

    -- // MAIN FRAME & TOGGLE \\ --
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = AstralScreen
    MainFrame.BackgroundColor3 = BaseColor
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- NEON GLOW EFFECT (UIStroke)
    local MainGlow = Instance.new("UIStroke", MainFrame)
    MainGlow.Color = AccentColor
    MainGlow.Thickness = 2
    MainGlow.Transparency = 0.5
    MainGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    if IsMobile then
        MainFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
        MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
    else
        MainFrame.Size = UDim2.new(0, 550, 0, 350)
        MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    end

    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1,0,0,40); TopBar.BackgroundColor3 = SecondaryColor
    MakeDraggable(TopBar, MainFrame)
    
    -- Title
    local Title = Instance.new("TextLabel", TopBar)
    Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0.7, 0, 1, 0); Title.Text = Settings.Name
    Title.TextColor3 = AccentColor; Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0,40,1,0); CloseBtn.Position = UDim2.new(1,-40,0,0)
    CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.BackgroundTransparency = 1
    CloseBtn.MouseButton1Click:Connect(function() AstralScreen:Destroy() end)

    local MobileToggle = Instance.new("ImageButton", AstralScreen)
    MobileToggle.Size = UDim2.new(0,45,0,45); MobileToggle.BackgroundColor3 = SecondaryColor
    MobileToggle.Position = UDim2.new(0.1, 0, 0.15, 0)
    MobileToggle.Visible = IsMobile
    Instance.new("UICorner", MobileToggle).CornerRadius = UDim.new(0, 10)
    MakeDraggable(MobileToggle, MobileToggle)

    local UI_Open = true
    local function ToggleUI()
        UI_Open = not UI_Open
        MainFrame.Visible = UI_Open
        if IsMobile then MobileToggle.Visible = not UI_Open end
    end
    
    local MinimizeBtn = Instance.new("TextButton", TopBar)
    MinimizeBtn.Size = UDim2.new(0,40,1,0); MinimizeBtn.Position = UDim2.new(1,-80,0,0)
    MinimizeBtn.Text = "-"; MinimizeBtn.TextColor3 = AccentColor; MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.MouseButton1Click:Connect(ToggleUI)
    MobileToggle.MouseButton1Click:Connect(ToggleUI)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Settings.ToggleKey then ToggleUI() end
    end)

    -- // CONTENT CONTAINERS \\ --
    local TabContainer = Instance.new("ScrollingFrame", MainFrame)
    TabContainer.BackgroundColor3 = SecondaryColor
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.Size = UDim2.new(0, 120, 1, -60)
    TabContainer.ScrollBarThickness = 0
    Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 6)

    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 5)

    local Content = Instance.new("Frame", MainFrame)
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 140, 0, 50)
    Content.Size = UDim2.new(1, -150, 1, -60) -- Crucial size setting for buttons to fit

    -- // TAB & ELEMENTS API \\ --
    local Lib = {}

    function Lib:MakeTab(Config)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 35); TabBtn.Text = Config.Name; 
        TabBtn.BackgroundTransparency = 1; TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200) -- Fix 1: Ensure text is visible
        
        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 5)
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0, PageList.AbsoluteContentSize.Y + 20)
        end)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do v.Visible = false end
            Page.Visible = true
            -- Update tab button color on selection
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(200, 200, 200) end
            end
            TabBtn.TextColor3 = AccentColor
        end)

        local Elements = {}

        function Elements:AddButton(Config)
            local BtnFrame = Instance.new("Frame", Page)
            BtnFrame.BackgroundColor3 = SecondaryColor
            BtnFrame.Size = UDim2.new(1, -5, 0, 40) -- Sufficient height
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)
            
            -- Neon Border for Button
            local BtnGlow = Instance.new("UIStroke", BtnFrame)
            BtnGlow.Color = AccentColor
            BtnGlow.Thickness = 1
            BtnGlow.Transparency = 0.8
            BtnGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local Btn = Instance.new("TextButton", BtnFrame)
            Btn.Size = UDim2.new(1, 0, 1, 0); Btn.BackgroundTransparency = 1
            Btn.Text = Config.Name; Btn.TextColor3 = Color3.fromRGB(255,255,255)
            
            Btn.MouseButton1Click:Connect(function()
                if Config.Callback then Config.Callback() end
            end)
        end
        
        function Elements:AddToggle(Config)
            local Toggled = Config.Default or false
            local Frame = Instance.new("Frame", Page)
            Frame.BackgroundColor3 = SecondaryColor
            Frame.Size = UDim2.new(1, -5, 0, 40)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            
            local Text = Instance.new("TextLabel", Frame)
            Text.BackgroundTransparency = 1; Text.Position = UDim2.new(0.05, 0, 0, 0)
            Text.Size = UDim2.new(0.7, 0, 1, 0); Text.Text = Config.Name
            Text.TextColor3 = Color3.fromRGB(255,255,255); Text.TextXAlignment = Enum.TextXAlignment.Left

            local Indicator = Instance.new("Frame", Frame)
            Indicator.Position = UDim2.new(0.85, 0, 0.25, 0); Indicator.Size = UDim2.new(0, 20, 0, 20)
            Indicator.BackgroundColor3 = Toggled and AccentColor or Color3.fromRGB(50, 50, 50)
            
            local Btn = Instance.new("TextButton", Frame); Btn.Size = UDim2.new(1,0,1,0); Btn.BackgroundTransparency = 1
            
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Indicator.BackgroundColor3 = Toggled and AccentColor or Color3.fromRGB(50, 50, 50)
                if Config.Callback then Config.Callback(Toggled) end
            end)
        end

        return Elements
    end

    return Lib
end

return Astral
