--[[
    AetherUI: A lightweight and modern Roblox UI library.
    
    To use:
    local AetherUI = loadstring(game:HttpGet("URL_TO_THIS_FILE"))()
]]

local AetherUI = {}
AetherUI.__index = AetherUI

--// Roblox Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

--// Main Window Constructor
function AetherUI:CreateWindow(properties)
    local window = {}
    setmetatable(window, AetherUI)

    --// Default Properties
    properties = properties or {}
    local Title = properties.Title or "Aether Window"
    local Size = properties.Size or UDim2.new(0, 500, 0, 400)
    local Position = properties.Position or UDim2.new(0.5, -Size.X.Offset / 2, 0.5, -Size.Y.Offset / 2)

    --// Create GUI Instances
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AetherUI_Root"
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Size
    MainFrame.Position = Position
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 37, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 27, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 5, 0, 0)
    TitleLabel.Text = Title
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = TopBar
    
    --// Store instances
    window.Instances = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TopBar = TopBar,
        TitleLabel = TitleLabel
    }
    
    --// Make window draggable
    local dragging = false
    local dragInput, lastPosition
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            lastPosition = input.Position
            
            local dragConnection
            dragConnection = UserInputService.InputChanged:Connect(function(newInput)
                if newInput == dragInput then
                    local delta = newInput.Position - lastPosition
                    MainFrame.Position = MainFrame.Position + UDim2.new(0, delta.X, 0, delta.Y)
                    lastPosition = newInput.Position
                else
                    dragConnection:Disconnect()
                end
            end)
            
            local stopConnection
            stopConnection = UserInputService.InputEnded:Connect(function(endInput)
                if endInput == dragInput then
                    dragging = false
                    dragConnection:Disconnect()
                    stopConnection:Disconnect()
                end
            end)
        end
    end)
    
    --// Add this window to the player's GUI
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    return window
end

--// Method to add a button to a window
function AetherUI:AddButton(properties)
    local window = self -- The window object this is called on
    assert(window.Instances and window.Instances.MainFrame, "This function must be called on a window created by AetherUI:CreateWindow()")
    
    --// Default Properties
    properties = properties or {}
    local Text = properties.Text or "Button"
    local Callback = properties.Callback or function() print("Button clicked!") end
    
    --// Create Button Instance
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "AetherButton"
    TextButton.Size = UDim2.new(0, 120, 0, 35)
    -- This is a very basic positioning system. You'd want to improve this.
    TextButton.Position = UDim2.new(0.5, -60, 0.5, -17.5) 
    TextButton.Text = Text
    TextButton.Font = Enum.Font.Gotham
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- A nice modern blue
    TextButton.BorderSizePixel = 0
    TextButton.Parent = window.Instances.MainFrame

    --// Add a UICorner for rounded edges
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = TextButton

    --// Connect the callback
    TextButton.MouseButton1Click:Connect(Callback)

    return TextButton -- Return the instance so it can be customized further
end


return AetherUI
