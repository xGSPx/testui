-- NexusUI Library - Fresh 2025 Rayfield Alternative
-- Left sidebar tabs, dual scrollable areas, modern design
-- Unique name, same easy Rayfield-style API

local NexusUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Windows = {}

function NexusUI:CreateWindow(config)
    config = config or {}
    local Name = config.Name or "NexusUI"
    local Keybind = config.Keybind or Enum.KeyCode.RightControl
    local Theme = config.Theme or "Dark"
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false
    
    -- Loading Screen
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "Loading"
    LoadingFrame.Parent = ScreenGui
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingFrame.Size = UDim2.new(0, 400, 0, 200)
    LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.Parent = LoadingFrame
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Position = UDim2.new(0.5, 0, 0.3, 0)
    LoadingTitle.Size = UDim2.new(1, 0, 0.2, 0)
    LoadingTitle.AnchorPoint = Vector2.new(0.5, 0)
    LoadingTitle.Font = Enum.Font.GothamBold
    LoadingTitle.Text = Name
    LoadingTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
    LoadingTitle.TextSize = 28
    
    local LoadingSubtitle = Instance.new("TextLabel")
    LoadingSubtitle.Parent = LoadingFrame
    LoadingSubtitle.BackgroundTransparency = 1
    LoadingSubtitle.Position = UDim2.new(0.5, 0, 0.55, 0)
    LoadingSubtitle.Size = UDim2.new(1, 0, 0.15, 0)
    LoadingSubtitle.AnchorPoint = Vector2.new(0.5, 0)
    LoadingSubtitle.Font = Enum.Font.Gotham
    LoadingSubtitle.Text = "Loading interface..."
    LoadingSubtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    LoadingSubtitle.TextSize = 16
    
    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0, 50, 0, 50)
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    
    -- Corner rounding
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(1, 0, 0, 50)
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = Topbar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Topbar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Name
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Topbar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    CloseBtn.TextSize = 20
    
    -- Sidebar (Left Tabs)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.Size = UDim2.new(0, 180, 1, -50)
    
    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 12)
    SideCorner.Parent = Sidebar
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Parent = Sidebar
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.Position = UDim2.new(0, 10, 0, 10)
    TabScroll.Size = UDim2.new(1, -20, 1, -20)
    TabScroll.ScrollBarThickness = 3
    TabScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 120, 180)
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabScroll
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 185, 0, 50)
    ContentArea.Size = UDim2.new(1, -185, 1, -50)
    
    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Parent = ContentArea
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.BorderSizePixel = 0
    ContentScroll.Size = UDim2.new(1, -20, 1, 0)
    ContentScroll.Position = UDim2.new(0, 10, 0, 0)
    ContentScroll.ScrollBarThickness = 5
    ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 120, 180)
    ContentScroll.CanvasSize = UDim2.new(1, 0, 0, 0)
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = ContentScroll
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 12)
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Window Object
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TabScroll = TabScroll,
        ContentScroll = ContentScroll,
        ContentLayout = ContentLayout
    }
    
    local function updateCanvasSizes()
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
        ContentScroll.CanvasSize = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSizes)
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSizes)
    
    -- Tab Creation
    function Window:CreateTab(options)
        options = options or {}
        local TabName = options.Name or "Tab"
        local Icon = options.Icon or ""
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = TabName
        TabBtn.Parent = TabScroll
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, 0, 0, 45)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.Text = Icon .. "  " .. TabName
        TabBtn.TextColor3 = Color3.fromRGB(190, 200, 220)
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.LayoutOrder = #Window.Tabs + 1
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 8)
        TabBtnCorner.Parent = TabBtn
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = TabName .. "_Content"
        TabContent.Parent = ContentScroll
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(0.95, 0, 0, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 0
        TabContent.Visible = false
        TabContent.LayoutOrder = #Window.Tabs + 1
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Parent = TabContent
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 10)
        
        local Tab = {Button = TabBtn, Content = TabContent, Components = {}}
        
        -- Tab switching
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                TweenService:Create(t.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 60),
                    TextColor3 = Color3.fromRGB(190, 200, 220)
                }):Play()
                t.Content.Visible = false
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 170, 255),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end)
        
        table.insert(Window.Tabs, Tab)
        updateCanvasSizes()
        
        if #Window.Tabs == 1 then
            TabBtn.MouseButton1Click:Fire()
        end
        
        return Tab
    end
    
    -- Component Methods
    local function createSection(parent, name)
        local Section = Instance.new("Frame")
        Section.Name = name
        Section.Parent = parent
        Section.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        Section.BorderSizePixel = 0
        Section.Size = UDim2.new(1, 0, 0, 50)
        
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 8)
        SectionCorner.Parent = Section
        
        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Parent = Section
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Size = UDim2.new(1, 0, 1, 0)
        SectionLabel.Font = Enum.Font.GothamBold
        SectionLabel.Text = name
        SectionLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
        SectionLabel.TextSize = 15
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local SectionContent = Instance.new("Frame")
        SectionContent.Name = "Content"
        SectionContent.Parent = Section
        SectionContent.BackgroundTransparency = 1
        SectionContent.Position = UDim2.new(0, 0, 1, 5)
        SectionContent.Size = UDim2.new(1, 0, 0, 0)
        
        local SectionContentLayout = Instance.new("UIListLayout")
        SectionContentLayout.Parent = SectionContent
        SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SectionContentLayout.Padding = UDim.new(0, 8)
        
        return SectionContent
    end
    
    function Window:CreateButton(options)
        local tab = Window.CurrentTab
        if not tab then return end
        
        options = options or {}
        local Name = options.Name or "Button"
        local Callback = options.Callback or function() end
        
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Parent = tab.Content
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
        ButtonFrame.BorderSizePixel = 0
        ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = ButtonFrame
        
        local ButtonLabel = Instance.new("TextButton")
        ButtonLabel.Parent = ButtonFrame
        ButtonLabel.BackgroundTransparency = 1
        ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
        ButtonLabel.Font = Enum.Font.GothamSemibold
        ButtonLabel.Text = Name
        ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ButtonLabel.TextSize = 15
        
        ButtonLabel.MouseButton1Click:Connect(Callback)
        
        -- Hover effects
        ButtonLabel.MouseEnter:Connect(function()
            TweenService:Create(ButtonFrame, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            }):Play()
        end)
        
        ButtonLabel.MouseLeave:Connect(function()
            TweenService:Create(ButtonFrame, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(55, 55, 75)
            }):Play()
        end)
        
        table.insert(tab.Components, ButtonFrame)
    end
    
    function Window:CreateToggle(options)
        local tab = Window.CurrentTab
        if not tab then return end
        
        options = options or {}
        local Name = options.Name or "Toggle"
        local Default = options.Default or false
        local Callback = options.Callback or function() end
        
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Parent = tab.Content
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = ToggleFrame
        
        local Label = Instance.new("TextLabel")
        Label.Parent = ToggleFrame
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.Size = UDim2.new(1, -70, 1, 0)
        Label.Font = Enum.Font.Gotham
        Label.Text = Name
        Label.TextColor3 = Color3.fromRGB(230, 230, 230)
        Label.TextSize = 15
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        local ToggleSwitch = Instance.new("TextButton")
        ToggleSwitch.Parent = ToggleFrame
        ToggleSwitch.BackgroundColor3 = Default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 90)
        ToggleSwitch.BorderSizePixel = 0
        ToggleSwitch.Position = UDim2.new(1, -45, 0.25, 0)
        ToggleSwitch.Size = UDim2.new(0, 30, 0, 20)
        ToggleSwitch.Font = Enum.Font.GothamBold
        ToggleSwitch.Text = ""
        
        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(0, 10)
        SwitchCorner.Parent = ToggleSwitch
        
        local SwitchIndicator = Instance.new("Frame")
        SwitchIndicator.Parent = ToggleSwitch
        SwitchIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SwitchIndicator.BorderSizePixel = 0
        SwitchIndicator.Position = Default and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
        SwitchIndicator.Size = UDim2.new(0.48, 0, 1, 0)
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 10)
        IndicatorCorner.Parent = SwitchIndicator
        
        local value = Default
        ToggleSwitch.MouseButton1Click:Connect(function()
            value = not value
            TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {
                BackgroundColor3 = value and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 90)
            }):Play()
            TweenService:Create(SwitchIndicator, TweenInfo.new(0.2), {
                Position = value and UDim2.new(1, -12, 0, 0) or UDim2.new(0, 0, 0, 0),
                Size = value and UDim2.new(0.48, 0, 1, 0) or UDim2.new(0.48, 0, 1, 0)
            }):Play()
            Callback(value)
        end)
        
        table.insert(tab.Components, ToggleFrame)
    end
    
    -- Window Controls
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)
    
    -- Dragging
    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Keybind Toggle
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Keybind then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    -- Loading animation then show window
    wait(1.5)
    LoadingFrame:Destroy()
    MainFrame.Visible = true
    
    table.insert(Windows, Window)
    return Window
end

-- Export
_G.NexusUI = NexusUI
getgenv().NexusUI = NexusUI

return NexusUI