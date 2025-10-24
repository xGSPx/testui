--[[
    AetherUI v1.0
    A modern and lightweight Roblox UI library.
    
    Features:
    - Draggable Windows
    - Buttons
    - Labels
    - Toggles (Checkboxes)
    - Text Inputs
    - Alerts
    
    To use:
    local AetherUI = loadstring(game:HttpGet("URL_TO_THIS_FILE"))()
]]

local AetherUI = {}
AetherUI.__index = AetherUI

--// Roblox Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--// Internal Theme / Configuration
local THEME = {
    Background = Color3.fromRGB(35, 37, 40),
    Primary = Color3.fromRGB(88, 101, 242), -- Discord-like Blue/Purple
    Secondary = Color3.fromRGB(70, 72, 78),
    Header = Color3.fromRGB(25, 27, 30),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(87, 242, 135),
    Warning = Color3.fromRGB(254, 231, 92),
    Error = Color3.fromRGB(237, 66, 69),
    Font = Enum.Font.Gotham,
    FontSemibold = Enum.Font.GothamSemibold,
    Padding = 15,
}

---------------------------------------------------------------------------------
--// HELPER FUNCTIONS
---------------------------------------------------------------------------------

-- Helper to create a base component frame for layout management
local function createComponentFrame(window, height)
    local frame = Instance.new("Frame")
    frame.Name = "ComponentFrame"
    frame.Size = UDim2.new(1, -THEME.Padding * 2, 0, height)
    frame.Position = UDim2.new(0, THEME.Padding, 0, window._layout.currentY)
    frame.BackgroundTransparency = 1
    frame.Parent = window.Instances.ContentFrame
    
    -- Update layout position for the next component
    window._layout.currentY = window._layout.currentY + height + window._layout.spacing
    
    -- Auto-update canvas size for scrolling
    window.Instances.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, window._layout.currentY)

    return frame
end


---------------------------------------------------------------------------------
--// MAIN CONSTRUCTOR
---------------------------------------------------------------------------------

function AetherUI:CreateWindow(properties)
    local window = {}
    setmetatable(window, AetherUI)

    --// Properties
    properties = properties or {}
    local Title = properties.Title or "Aether Window"
    local Size = properties.Size or UDim2.new(0, 500, 0, 400)
    local Position = properties.Position or UDim2.new(0.5, -Size.X.Offset / 2, 0.5, -Size.Y.Offset / 2)

    --// Internal layout manager
    window._layout = {
        currentY = THEME.Padding,
        spacing = 10 -- Space between components
    }

    --// Create GUI Instances
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AetherUI_Root"
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Size
    MainFrame.Position = Position
    MainFrame.BackgroundColor3 = THEME.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainFrame
    MainFrame.Parent = ScreenGui

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = THEME.Header
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Text = Title
    TitleLabel.Font = THEME.FontSemibold
    TitleLabel.TextColor3 = THEME.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = TopBar

    --// Content Area (for scrolling)
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ContentFrame"
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -TopBar.Size.Y.Offset)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, TopBar.Size.Y.Offset)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarImageColor3 = THEME.Primary
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.Parent = MainFrame

    window.Instances = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentFrame = ScrollingFrame,
        TopBar = TopBar,
        TitleLabel = TitleLabel
    }
    
    --// Draggable functionality
    local dragging, dragInput, lastPosition
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragInput = input; lastPosition = input.Position
            local conn = UserInputService.InputChanged:Connect(function(newInput)
                if newInput == dragInput then
                    local delta = newInput.Position - lastPosition
                    MainFrame.Position += UDim2.new(0, delta.X, 0, delta.Y)
                    lastPosition = newInput.Position
                end
            end)
            local conn2 = UserInputService.InputEnded:Connect(function(endInput)
                if endInput == dragInput then dragging = false; conn:Disconnect(); conn2:Disconnect() end
            end)
        end
    end)
    
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    return window
end


---------------------------------------------------------------------------------
--// COMPONENT METHODS
---------------------------------------------------------------------------------

function AetherUI:AddLabel(properties)
    local window = self
    properties = properties or {}
    local Text = properties.Text or "Label"
    local TextSize = properties.TextSize or 16

    local componentFrame = createComponentFrame(window, TextSize + 4)
    
    local label = Instance.new("TextLabel")
    label.Name = "AetherLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = THEME.Font
    label.TextColor3 = THEME.TextSecondary
    label.Text = Text
    label.TextSize = TextSize
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = componentFrame
    
    return label
end

function AetherUI:AddButton(properties)
    local window = self
    properties = properties or {}
    local Text = properties.Text or "Button"
    local Callback = properties.Callback or function() print("Button clicked!") end

    local componentFrame = createComponentFrame(window, 35)

    local button = Instance.new("TextButton")
    button.Name = "AetherButton"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = THEME.Primary
    button.Text = Text
    button.TextColor3 = THEME.Text
    button.Font = THEME.FontSemibold
    button.TextSize = 16
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = button
    button.Parent = componentFrame
    
    button.MouseButton1Click:Connect(Callback)
    
    return button
end

function AetherUI:AddToggle(properties)
    local window = self
    properties = properties or {}
    local Text = properties.Text or "Toggle"
    local DefaultValue = properties.Default or false
    local Callback = properties.Callback or function(value) print("Toggle set to:", value) end
    
    local componentFrame = createComponentFrame(window, 24)
    local state = DefaultValue

    local label = Instance.new("TextLabel")
    label.Name = "ToggleLabel"
    label.Size = UDim2.new(1, -40, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = THEME.Font
    label.TextColor3 = THEME.Text
    label.Text = Text
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = componentFrame

    local switch = Instance.new("TextButton")
    switch.Name = "Switch"
    switch.Size = UDim2.new(0, 44, 0, 24)
    switch.Position = UDim2.new(1, -44, 0.5, -12)
    switch.BackgroundColor3 = THEME.Secondary
    switch.Text = ""
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 12); corner.Parent = switch
    switch.Parent = componentFrame
    
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = THEME.Text
    knob.BorderSizePixel = 0
    local kcorner = Instance.new("UICorner"); kcorner.CornerRadius = UDim.new(0, 10); kcorner.Parent = knob
    knob.Parent = switch

    local function updateVisuals(isInstant)
        local tweenInfo = TweenInfo.new(isInstant and 0 or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local goalColor = state and THEME.Success or THEME.Secondary
        local goalPos = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        
        TweenService:Create(switch, tweenInfo, { BackgroundColor3 = goalColor }):Play()
        TweenService:Create(knob, tweenInfo, { Position = goalPos }):Play()
    end
    
    switch.MouseButton1Click:Connect(function()
        state = not state
        updateVisuals()
        pcall(Callback, state)
    end)
    
    updateVisuals(true) -- Set initial state
    
    return switch
end

function AetherUI:AddTextInput(properties)
    local window = self
    properties = properties or {}
    local PlaceholderText = properties.Placeholder or "Enter text..."
    local ClearOnFocus = properties.ClearOnFocus or false
    local Callback = properties.Callback or function(text) print("Text submitted:", text) end

    local componentFrame = createComponentFrame(window, 35)
    
    local textbox = Instance.new("TextBox")
    textbox.Name = "AetherTextBox"
    textbox.Size = UDim2.new(1, 0, 1, 0)
    textbox.BackgroundColor3 = THEME.Secondary
    textbox.Font = THEME.Font
    textbox.TextColor3 = THEME.Text
    textbox.PlaceholderText = PlaceholderText
    textbox.PlaceholderColor3 = THEME.TextSecondary
    textbox.TextSize = 14
    textbox.ClearTextOnFocus = ClearOnFocus
    local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0,10); pad.PaddingRight = UDim.new(0,10); pad.Parent = textbox
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = textbox
    textbox.Parent = componentFrame

    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            pcall(Callback, textbox.Text)
        end
    end)

    return textbox
end

function AetherUI:AddAlert(properties)
    local window = self
    properties = properties or {}
    local Text = properties.Text or "This is an alert."
    local Type = string.lower(properties.Type or "info") -- info, success, warning, error

    local bgColor = THEME.Primary
    if Type == "success" then bgColor = THEME.Success
    elseif Type == "warning" then bgColor = THEME.Warning
    elseif Type == "error" then bgColor = THEME.Error end

    local componentFrame = createComponentFrame(window, 50)
    
    local alertFrame = Instance.new("Frame")
    alertFrame.Name = "AetherAlert"
    alertFrame.Size = UDim2.new(1, 0, 1, 0)
    alertFrame.BackgroundColor3 = Color3.fromRGB(bgColor.r*255, bgColor.g*255, bgColor.b*255)
    alertFrame.BackgroundTransparency = 0.8
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = alertFrame
    alertFrame.Parent = componentFrame

    local accent = Instance.new("Frame")
    accent.BackgroundColor3 = bgColor
    accent.BorderSizePixel = 0
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.Parent = alertFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = THEME.Font
    label.TextColor3 = THEME.Text
    label.Text = Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = alertFrame

    return alertFrame
end

return AetherUI
