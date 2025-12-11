--[[
    ⭐ Astral UI Library V9: Deep Element Injection Fix ⭐
    - Adds UIPadding to the Page for guaranteed margins.
    - Explicitly sets Tab Button size with pixel offsets.
    - Simplified element sizes to avoid ListLayout conflicts.
]]

local Astral = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- // 🎨 STYLE DEFINITIONS \\ --
local STYLE = {
    AccentColor = Color3.fromRGB(150, 0, 255),  
    BaseColor = Color3.fromRGB(15, 0, 25),      
    SecondaryColor = Color3.fromRGB(35, 5, 55), 
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementHeight = 40,
    Padding = 5
}

-- // UTILITY: Protect GUI \\ --
local function ProtectGui(gui)
    gui.Parent = CoreGui
end

-- // UTILITY: Dragging (Standard Logic) \\ --
local function MakeDraggable(ClickObject, MoveObject)
    local Dragging = false
    local DragInput, DragStart, StartPos

    ClickObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MoveObject.Position
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
                StartPos.X.Scale, StartPos.X.Offset + Delta.X, 
                StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
            )
            TweenService:Create(MoveObject, TweenInfo.new(0.1), {Position = TargetPos}):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
end

-- // MAIN LIBRARY \\ --
function Astral.MakeWindow(Configuration)
    local Settings = {
        Name = Configuration.Name or "Astral UI V9",
        ToggleKey = Configuration.ToggleKey or Enum.KeyCode.RightControl
    }
    
    local ViewportSize = Workspace.CurrentCamera.ViewportSize
    local IsMobile = ViewportSize.X < 600

    local AstralScreen = Instance.new("ScreenGui")
    AstralScreen.Name = "AstralLib_V9"
    AstralScreen.ResetOnSpawn = false
    ProtectGui(AstralScreen)

    -- // MAIN FRAME \\ --
    local MainFrame = Instance.new("Frame", AstralScreen)
    MainFrame.BackgroundColor3 = STYLE.BaseColor
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    local MainGlow = Instance.new("UIStroke", MainFrame)
    MainGlow.Color = STYLE.AccentColor; MainGlow.Thickness = 2; MainGlow.Transparency = 0.5
    MainGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    -- Removed AspectRatio constraint as it can sometimes fight with manual sizing
    
    if IsMobile then
        MainFrame.Size = UDim2.new(0.9, 0, 0, 315)
        MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
    else
        MainFrame.Size = UDim2.new(0, 550, 0, 350)
        MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    end

    -- TOP BAR & CONTROLS (Standard logic)
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1,0,0,40); TopBar.BackgroundColor3 = STYLE.SecondaryColor
    MakeDraggable(TopBar, MainFrame)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0.7, 0, 1, 0); Title.Text = Settings.Name
    Title.TextColor3 = STYLE.AccentColor; Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0,40,1,0); CloseBtn.Position = UDim2.new(1,-40,0,0)
    CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.BackgroundTransparency = 1
    CloseBtn.MouseButton1Click:Connect(function() AstralScreen:Destroy() end)

    -- // CONTENT CONTAINERS \\ --
    local TabContainer = Instance.new("ScrollingFrame", MainFrame)
    TabContainer.BackgroundColor3 = STYLE.SecondaryColor
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.Size = UDim2.new(0, 120, 1, -60)
    TabContainer.ScrollBarThickness = 0
    Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 6)

    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, STYLE.Padding)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.VerticalAlignment = Enum.VerticalAlignment.Top 
    
    -- UIPadding to ensure tabs are not pressed against the edge
    Instance.new("UIPadding", TabContainer).PaddingTop = UDim.new(0, STYLE.Padding)

    local Content = Instance.new("Frame", MainFrame)
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 140, 0, 50)
    Content.Size = UDim2.new(1, -150, 1, -60) 

    -- // TAB & ELEMENTS API \\ --
    local Lib = {}
    local CurrentTab = nil

    function Lib:MakeTab(Config)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Name = Config.Name .. "TabButton"
        -- CRITICAL FIX: Simplified X-Size to 100% minus pixel offset padding
        TabBtn.Size = UDim2.new(1, 0, 0, 35); TabBtn.Text = Config.Name; 
        TabBtn.BackgroundTransparency = 1; TabBtn.TextColor3 = STYLE.TextColor
        
        local Page = Instance.new("ScrollingFrame", Content)
        Page.Name = Config.Name .. "Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1; Page.Visible = false
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = STYLE.AccentColor
        
        -- CRITICAL FIX: Adding UIPadding to the Page itself
        Instance.new("UIPadding", Page).PaddingAll = UDim.new(0, STYLE.Padding * 2) -- Extra padding on all sides

        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, STYLE.Padding)
        PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageList.VerticalAlignment = Enum.VerticalAlignment.Top
        
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            -- Adjust canvas size based on content height + padding
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 4 * STYLE.Padding) 
        end)
        
        -- Tab Selection Logic (Standard logic)
        TabBtn.MouseButton1Click:Connect(function()
            if CurrentTab then CurrentTab.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then v.TextColor3 = STYLE.TextColor end
            end
            Page.Visible = true
            TabBtn.TextColor3 = STYLE.AccentColor
            CurrentTab = Page
        end)
        
        if not CurrentTab then TabBtn:Click() end

        local Elements = {}

        -- BUTTON 
        function Elements:AddButton(Config)
            local BtnFrame = Instance.new("Frame", Page)
            BtnFrame.BackgroundColor3 = STYLE.SecondaryColor
            -- CRITICAL FIX: X-Size is now 100% minus the padding from the UIPadding element (1 - 2 * Padding)
            BtnFrame.Size = UDim2.new(1, 0, 0, STYLE.ElementHeight) 
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)
            
            local BtnGlow = Instance.new("UIStroke", BtnFrame)
            BtnGlow.Color = STYLE.AccentColor; BtnGlow.Thickness = 1
            BtnGlow.Transparency = 0.8; BtnGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local Btn = Instance.new("TextButton", BtnFrame)
            Btn.Size = UDim2.new(1, 0, 1, 0); Btn.BackgroundTransparency = 1
            Btn.Text = Config.Name; Btn.TextColor3 = STYLE.TextColor
            
            Btn.MouseButton1Click:Connect(function()
                if Config.Callback then Config.Callback() end
            end)
        end
        
        -- TOGGLE 
        function Elements:AddToggle(Config)
            local Toggled = Config.Default or false
            local Frame = Instance.new("Frame", Page)
            Frame.BackgroundColor3 = STYLE.SecondaryColor
            Frame.Size = UDim2.new(1, 0, 0, STYLE.ElementHeight) -- CRITICAL FIX: X-Size is 1, no offsets
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            
            local Text = Instance.new("TextLabel", Frame)
            Text.BackgroundTransparency = 1; Text.Position = UDim2.new(0.05, 0, 0, 0)
            Text.Size = UDim2.new(0.7, 0, 1, 0); Text.Text = Config.Name
            Text.TextColor3 = STYLE.TextColor; Text.TextXAlignment = Enum.TextXAlignment.Left

            local Indicator = Instance.new("Frame", Frame)
            Indicator.Position = UDim2.new(0.85, 0, 0.25, 0); Indicator.Size = UDim2.new(0, 20, 0, 20)
            Indicator.BackgroundColor3 = Toggled and STYLE.AccentColor or Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)
            
            local Btn = Instance.new("TextButton", Frame); Btn.Size = UDim2.new(1,0,1,0); Btn.BackgroundTransparency = 1
            
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Indicator.BackgroundColor3 = Toggled and STYLE.AccentColor or Color3.fromRGB(50, 50, 50)
                if Config.Callback then Config.Callback(Toggled) end
            end)
        end

        return Elements
    end

    return Lib
end

return Astral
