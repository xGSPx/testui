-- // NEON VIBE UI LIBRARY \\ --
-- // Mobile & PC Supported \\ --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}

-- // UTILITIES \\ --

local function MakeDraggable(topbarObject, object)
    local dragging, dragInput, dragStart, startPos
    
    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- // MAIN FUNCTIONS \\ --

function Library:CreateWindow(Settings)
    local Name = Settings.Name or "UI Library"
    
    -- 1. Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeonVibeUI"
    ScreenGui.ResetOnSpawn = false
    
    -- Safe Parent
    if gethui then ScreenGui.Parent = gethui()
    elseif CoreGui:FindFirstChild("RobloxGui") then ScreenGui.Parent = CoreGui
    else ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. Open/Minimize Button (The Bubble)
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Name = "OpenButton"
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Position = UDim2.new(0, 20, 0.4, 0)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    OpenBtn.BorderColor3 = Color3.fromRGB(170, 0, 255) -- Neon Purple
    OpenBtn.BorderSizePixel = 2
    OpenBtn.Text = "UI"
    OpenBtn.TextColor3 = Color3.fromRGB(170, 0, 255)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 14
    OpenBtn.Parent = ScreenGui
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
    MakeDraggable(OpenBtn, OpenBtn)

    -- 3. Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- Stroke (Neon Outline)
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = MainFrame
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(170, 0, 255)
    
    MakeDraggable(MainFrame, MainFrame)

    -- Toggle Logic
    local Visible = true
    OpenBtn.MouseButton1Click:Connect(function()
        Visible = not Visible
        MainFrame.Visible = Visible
    end)

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Name
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    -- Close / Destroy Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Header
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Sidebar (Tab Buttons)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 120, 1, -50)
    Sidebar.Position = UDim2.new(0, 10, 0, 45)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = MainFrame
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.Parent = Sidebar

    -- Container (Pages)
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -145, 1, -50)
    PageContainer.Position = UDim2.new(0, 135, 0, 45)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    local WindowFunctions = {}
    local FirstTab = true

    function WindowFunctions:CreateTab(TabName)
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        -- Tab Page
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        Page.Parent = PageContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page
        
        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 5)
        PagePadding.PaddingLeft = UDim.new(0, 5)
        PagePadding.Parent = Page

        -- Activate Logic
        TabBtn.MouseButton1Click:Connect(function()
            -- Deactivate all
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 30), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
            end
            for _, v in pairs(PageContainer:GetChildren()) do
                v.Visible = false
            end
            
            -- Activate this
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(170, 0, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            Page.Visible = true
        end)

        -- Auto Select First
        if FirstTab then
            FirstTab = false
            TabBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Page.Visible = true
        end

        local TabFunctions = {}

        -- 1. SEPARATOR / LABEL
        function TabFunctions:CreateSection(Text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -10, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Color3.fromRGB(170, 0, 255)
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Page
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y)
        end

        -- 2. BUTTON
        function TabFunctions:CreateButton(Cfg)
            local BtnFrame = Instance.new("TextButton")
            BtnFrame.Size = UDim2.new(1, -10, 0, 35)
            BtnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            BtnFrame.Text = "  " .. Cfg.Name
            BtnFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnFrame.Font = Enum.Font.Gotham
            BtnFrame.TextSize = 13
            BtnFrame.TextXAlignment = Enum.TextXAlignment.Left
            BtnFrame.AutoButtonColor = false
            BtnFrame.Parent = Page
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)

            local Icon = Instance.new("ImageLabel")
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Position = UDim2.new(1, -30, 0.5, -10)
            Icon.BackgroundTransparency = 1
            Icon.Image = "rbxassetid://3926305904" -- Mouse Click Icon
            Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
            Icon.Parent = BtnFrame

            BtnFrame.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
                task.wait(0.1)
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
                pcall(Cfg.Callback)
            end)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y)
        end

        -- 3. TOGGLE
        function TabFunctions:CreateToggle(Cfg)
            local ToggFrame = Instance.new("TextButton")
            ToggFrame.Size = UDim2.new(1, -10, 0, 35)
            ToggFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ToggFrame.Text = "  " .. Cfg.Name
            ToggFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggFrame.Font = Enum.Font.Gotham
            ToggFrame.TextSize = 13
            ToggFrame.TextXAlignment = Enum.TextXAlignment.Left
            ToggFrame.AutoButtonColor = false
            ToggFrame.Parent = Page
            Instance.new("UICorner", ToggFrame).CornerRadius = UDim.new(0, 6)

            local CheckBox = Instance.new("Frame")
            CheckBox.Size = UDim2.new(0, 20, 0, 20)
            CheckBox.Position = UDim2.new(1, -30, 0.5, -10)
            CheckBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            CheckBox.Parent = ToggFrame
            Instance.new("UICorner", CheckBox).CornerRadius = UDim.new(0, 4)
            local Stroke = Instance.new("UIStroke", CheckBox)
            Stroke.Color = Color3.fromRGB(60, 60, 60)
            Stroke.Thickness = 1

            local Toggled = Cfg.Default or false
            
            local function UpdateState()
                if Toggled then
                    TweenService:Create(CheckBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(170, 0, 255)}):Play()
                else
                    TweenService:Create(CheckBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
                end
                pcall(Cfg.Callback, Toggled)
            end
            
            if Toggled then UpdateState() end

            ToggFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                UpdateState()
            end)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y)
        end

        -- 4. INPUT
        function TabFunctions:CreateInput(Cfg)
            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, -10, 0, 40)
            InputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            InputFrame.Parent = Page
            Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Cfg.Name
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = InputFrame

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(0.5, -10, 0.7, 0)
            TextBox.Position = UDim2.new(0.5, 0, 0.15, 0)
            TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            TextBox.TextColor3 = Color3.fromRGB(200, 200, 200)
            TextBox.PlaceholderText = Cfg.Placeholder or "Type here..."
            TextBox.Text = ""
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 12
            TextBox.Parent = InputFrame
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

            TextBox.FocusLost:Connect(function(enterPressed)
                pcall(Cfg.Callback, TextBox.Text)
            end)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y)
        end

        -- 5. SLIDER
        function TabFunctions:CreateSlider(Cfg)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -10, 0, 50)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            SliderFrame.Parent = Page
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = Cfg.Name
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Position = UDim2.new(1, -60, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(Cfg.Min)
            ValueLabel.TextColor3 = Color3.fromRGB(170, 0, 255)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 13
            ValueLabel.Parent = SliderFrame

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 6)
            SliderBar.Position = UDim2.new(0, 10, 0, 35)
            SliderBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            SliderBar.Parent = SliderFrame
            Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
            Fill.Parent = SliderBar
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = ""
            Button.Parent = SliderBar

            local Min = Cfg.Min or 0
            local Max = Cfg.Max or 100
            local Default = Cfg.Default or Min

            -- Set Default
            local Percent = (Default - Min) / (Max - Min)
            Fill.Size = UDim2.new(Percent, 0, 1, 0)
            ValueLabel.Text = tostring(Default)

            local dragging = false

            local function Move(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                TweenService:Create(Fill, TweenInfo.new(0.1), {Size = pos}):Play()
                
                local val = math.floor(((pos.X.Scale * (Max - Min)) + Min) * 10) / 10
                ValueLabel.Text = tostring(val)
                pcall(Cfg.Callback, val)
            end

            Button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    Move(input)
                end
            end)

            Button.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    Move(input)
                end
            end)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y)
        end

        -- 6. DROPDOWN
        function TabFunctions:CreateDropdown(Cfg)
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, -10, 0, 35) -- Collapsed size
            DropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = Page
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -30, 0, 35)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Cfg.Name
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = DropFrame

            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 30, 0, 35)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "V"
            Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
            Arrow.Font = Enum.Font.GothamBold
            Arrow.Parent = DropFrame

            local OpenBtn = Instance.new("TextButton")
            OpenBtn.Size = UDim2.new(1, 0, 0, 35)
            OpenBtn.BackgroundTransparency = 1
            OpenBtn.Text = ""
            OpenBtn.Parent = DropFrame

            local List = Instance.new("Frame")
            List.Size = UDim2.new(1, 0, 0, 0)
            List.Position = UDim2.new(0, 0, 0, 35)
            List.BackgroundTransparency = 1
            List.Parent = DropFrame
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = List
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            for _, option in pairs(Cfg.Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                OptBtn.Text = option
                OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.Parent = List
                
                OptBtn.MouseButton1Click:Connect(function()
                    Label.Text = Cfg.Name .. ": " .. option
                    pcall(Cfg.Callback, option)
                    -- Close
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), 