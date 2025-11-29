-- Rayfield-Like Minimal UI Library (Purple / Black Theme)
-- Lightweight, Mobile-Friendly
-- Single-file Module

local UI = {}
UI.__index = UI

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Theme
local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Card = Color3.fromRGB(18, 18, 20),
    Panel = Color3.fromRGB(35, 0, 60),
    Accent = Color3.fromRGB(150, 70, 255),
    Text = Color3.fromRGB(230, 230, 255),
    SubText = Color3.fromRGB(180,180,200)
}

-- Utility: Tween
local function tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- Helper to create instances
local function new(class, props)
    local inst = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k ~= "Parent" then
                pcall(function() inst[k] = v end)
            end
        end
        if props.Parent then inst.Parent = props.Parent end
    end
    return inst
end

-- Root construction
function UI:CreateWindow(config)
    config = config or {}
    local window = { Tabs = {} }
    setmetatable(window, UI)

    local gui = new("ScreenGui", {Name = config.Name or "RayUI", ResetOnSpawn = false, Parent = LocalPlayer:WaitForChild("PlayerGui")})

    local main = new("Frame", {Parent = gui, Size = UDim2.new(0, 420, 0, 340), Position = UDim2.new(0.5, -210, 0.45, -170), BackgroundColor3 = Theme.Panel, BorderSizePixel = 0})
    new("UICorner", {Parent = main, CornerRadius = UDim.new(0,8)})

    local title = new("TextLabel", {Parent = main, Size = UDim2.new(1,0,0,34), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Theme.Card, Text = config.Name or "UI Window", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 18})
    new("UICorner", {Parent = title, CornerRadius = UDim.new(0,8)})

    -- content area
    local sidebar = new("Frame", {Parent = main, Size = UDim2.new(0,120,1,-44), Position = UDim2.new(0,8,0,44), BackgroundTransparency = 1})
    local content = new("Frame", {Parent = main, Size = UDim2.new(1,-140,1,-54), Position = UDim2.new(0,132,0,44), BackgroundTransparency = 1})

    local sidebarLayout = new("UIListLayout", {Parent = sidebar, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,6)})
    sidebarLayout.Padding = UDim.new(0,6)

    main.Draggable = false -- we handle drag by title

    -- drag logic
    do
        local dragging = false
        local dragStart
        local startPos
        title.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = i.Position
                startPos = main.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        title.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement then
                if dragging and dragStart and startPos then
                    local delta = i.Position - dragStart
                    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end
        end)
    end

    -- expose
    window.GUI = gui
    window.Main = main
    window.Sidebar = sidebar
    window.Content = content

    return window
end

-- Tabs
function UI:CreateTab(name)
    local tab = { Sections = {} }
    setmetatable(tab, UI)

    -- button
    local btn = new("TextButton", {Parent = self.Sidebar, Size = UDim2.new(1,0,0,30), Text = name, BackgroundColor3 = Theme.Card, TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 14, BorderSizePixel = 0})
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})

    -- frame
    local frame = new("ScrollingFrame", {Parent = self.Content, Size = UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,1,0), BackgroundTransparency = 1, ScrollBarThickness = 6})
    local list = new("UIListLayout", {Parent = frame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,8)})
    frame.Visible = false

    btn.MouseButton1Click:Connect(function()
        for _,t in ipairs(self.Tabs) do t.Frame.Visible = false; t.Button.TextColor3 = Theme.SubText end
        frame.Visible = true
        btn.TextColor3 = Theme.Text
    end)

    table.insert(self.Tabs, {Name = name, Button = btn, Frame = frame})
    if #self.Tabs == 1 then btn:MouseButton1Click() end

    -- return tab object that uses the frame as self.Frame
    return setmetatable({Frame = frame, ParentWindow = self}, {__index = UI})
end

-- Section (simple label + container)
function UI:CreateSection(title)
    local holder = new("Frame", {Parent = self.Frame, Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1})
    local lbl = new("TextLabel", {Parent = holder, Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, Text = "  "..title, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 15})
    local container = new("Frame", {Parent = holder, Size = UDim2.new(1,0,0,0), BackgroundColor3 = Theme.Card, BorderSizePixel = 0})
    new("UICorner", {Parent = container, CornerRadius = UDim.new(0,6)})
    local layout = new("UIListLayout", {Parent = container, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,6)})

    -- size binding: simple approach
    holder:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        holder.Size = UDim2.new(1, 0, 0, lbl.AbsoluteSize.Y + container.AbsoluteSize.Y)
    end)

    holder.Parent = self.Frame

    return setmetatable({Frame = container, Holder = holder}, {__index = UI})
end

-- Separator
function UI:CreateSeparator()
    local sep = new("Frame", {Parent = self.Frame, Size = UDim2.new(1, -12, 0, 10), BackgroundTransparency = 1})
    local line = new("Frame", {Parent = sep, Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,6,0,5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0})
    return sep
end

-- Button
function UI:CreateButton(cfg)
    cfg = cfg or {}
    local btn = new("TextButton", {Parent = self.Frame, Size = UDim2.new(1, -12, 0, 34), BackgroundColor3 = Theme.Card, Text = cfg.Name or "Button", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, BorderSizePixel = 0})
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
    btn.MouseButton1Click:Connect(function()
        pcall(cfg.Callback)
    end)
    return btn
end

-- Toggle
function UI:CreateToggle(cfg)
    cfg = cfg or {}
    local frame = new("Frame", {Parent = self.Frame, Size = UDim2.new(1, -12, 0, 34), BackgroundTransparency = 1})
    local label = new("TextLabel", {Parent = frame, Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, Text = cfg.Name or "Toggle", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14})
    local box = new("Frame", {Parent = frame, Size = UDim2.new(0, 44, 0, 24), Position = UDim2.new(1, -48, 0.5, -12), BackgroundColor3 = Theme.Background, BorderSizePixel = 0})
    new("UICorner", {Parent = box, CornerRadius = UDim.new(0,6)})
    local dot = new("Frame", {Parent = box, Size = UDim2.new(0,20,0,20), Position = UDim2.new(0,2,0,2), BackgroundColor3 = Theme.SubText})
    new("UICorner", {Parent = dot, CornerRadius = UDim.new(0,6)})

    local state = cfg.Default or false
    if state then dot.Position = UDim2.new(0,22,0,2); dot.BackgroundColor3 = Theme.Accent else dot.Position = UDim2.new(0,2,0,2); dot.BackgroundColor3 = Theme.SubText end

    box.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            if state then tween(dot, {Position = UDim2.new(0,22,0,2)}); dot.BackgroundColor3 = Theme.Accent else tween(dot, {Position = UDim2.new(0,2,0,2)}); dot.BackgroundColor3 = Theme.SubText end
            pcall(cfg.Callback, state)
        end
    end)

    return {
        Get = function() return state end,
        Set = function(v) state = v; if state then dot.Position = UDim2.new(0,22,0,2); dot.BackgroundColor3 = Theme.Accent else dot.Position = UDim2.new(0,2,0,2); dot.BackgroundColor3 = Theme.SubText end; pcall(cfg.Callback, state) end
    }
end

-- Slider
function UI:CreateSlider(cfg)
    cfg = cfg or {}
    local min = cfg.Min or 0
    local max = cfg.Max or 100
    local default = cfg.Default or min
    local holder = new("Frame", {Parent = self.Frame, Size = UDim2.new(1,-12,0,48), BackgroundTransparency = 1})
    local label = new("TextLabel", {Parent = holder, Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, Text = (cfg.Name or "Slider") .. ": " .. tostring(default), TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14})
    local bar = new("Frame", {Parent = holder, Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,0,28), BackgroundColor3 = Theme.Background, BorderSizePixel = 0})
    new("UICorner", {Parent = bar, CornerRadius = UDim.new(0,6)})
    local fill = new("Frame", {Parent = bar, Size = UDim2.new((default - min)/(max-min),0,1,0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0})
    new("UICorner", {Parent = fill, CornerRadius = UDim.new(0,6)})

    local dragging = false
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(rel,0,1,0)
            local val = math.floor(min + (max-min) * rel)
            label.Text = (cfg.Name or "Slider") .. ": " .. val
            pcall(cfg.Callback, val)
        end
    end)

    return {
        Get = function() return math.floor(min + (max-min) * fill.Size.X.Scale) end,
        Set = function(v) local rel = math.clamp((v-min)/(max-min),0,1); fill.Size = UDim2.new(rel,0,1,0); pcall(cfg.Callback, v) end
    }
end

-- Input Box
function UI:CreateInput(cfg)
    cfg = cfg or {}
    local box = new("TextBox", {Parent = self.Frame, Size = UDim2.new(1,-12,0,34), BackgroundColor3 = Theme.Background, Text = "", PlaceholderText = cfg.Placeholder or "Enter text...", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, ClearTextOnFocus = false})
    new("UICorner", {Parent = box, CornerRadius = UDim.new(0,6)})
    box.FocusLost:Connect(function(enter)
        if enter then pcall(cfg.Callback, box.Text) end
    end)
    return box
end

-- Dropdown
function UI:CreateDropdown(cfg)
    cfg = cfg or {}
    local options = cfg.Options or {}
    local current = options[1] or "Select"

    local holder = new("Frame", {Parent = self.Frame, Size = UDim2.new(1,-12,0,34), BackgroundTransparency = 1})
    local label = new("TextLabel", {Parent = holder, Size = UDim2.new(0.5,0,1,0), BackgroundTransparency = 1, Text = cfg.Name or "Dropdown", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14})
    local chosen = new("TextLabel", {Parent = holder, Size = UDim2.new(0.45, -8, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1, Text = tostring(current), TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right})
    local arrow = new("TextButton", {Parent = holder, Size = UDim2.new(0,28,0,24), Position = UDim2.new(1, -34, 0,5), Text = "v", BackgroundColor3 = Theme.Card, TextColor3 = Theme.Text, BorderSizePixel = 0})
    new("UICorner", {Parent = arrow, CornerRadius = UDim.new(0,6)})

    local list = new("Frame", {Parent = holder, Size = UDim2.new(1,-12,0,0), Position = UDim2.new(0,6,0,36), BackgroundColor3 = Theme.Card, Visible = false, BorderSizePixel = 0})
    new("UICorner", {Parent = list, CornerRadius = UDim.new(0,6)})
    local layout = new("UIListLayout", {Parent = list, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,2)})

    local function rebuild()
        for _,c in pairs(list:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for i,opt in ipairs(options) do
            local it = new("TextButton", {Parent = list, Size = UDim2.new(1,-8,0,28), Position = UDim2.new(0,4,0, (i-1)*30), Text = opt, BackgroundColor3 = Theme.Card, TextColor3 = Theme.Text, BorderSizePixel = 0})
            it.MouseButton1Click:Connect(function()
                chosen.Text = opt
                list.Visible = false
                pcall(cfg.Callback, opt)
            end)
        end
        list.Size = UDim2.new(1,-12,0, math.min(#options*30, 6*30))
    end
    rebuild()

    arrow.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)

    return {
        Get = function() return chosen.Text end,
        Set = function(v) chosen.Text = v end,
        UpdateOptions = function(newOptions) options = newOptions; rebuild() end
    }
end

-- MultiSelect (checkbox-style dropdown)
function UI:CreateMultiSelect(cfg)
    cfg = cfg or {}
    local options = cfg.Options or {}
    local selected = {}

    local holder = new("Frame", {Parent = self.Frame, Size = UDim2.new(1,-12,0,34), BackgroundTransparency = 1})
    local label = new("TextLabel", {Parent = holder, Size = UDim2.new(0.6,0,1,0), BackgroundTransparency = 1, Text = cfg.Name or "MultiSelect", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14})
    local summary = new("TextLabel", {Parent = holder, Size = UDim2.new(0.3, -8, 1, 0), Position = UDim2.new(0.6, 0, 0, 0), BackgroundTransparency = 1, Text = "None", TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right})
    local arrow = new("TextButton", {Parent = holder, Size = UDim2.new(0,28,0,24), Position = UDim2.new(1, -34, 0,5), Text = "v", BackgroundColor3 = Theme.Card, TextColor3 = Theme.Text, BorderSizePixel = 0})
    new("UICorner", {Parent = arrow, CornerRadius = UDim.new(0,6)})

    local list = new("Frame", {Parent = holder, Size = UDim2.new(1,-12,0,0), Position = UDim2.new(0,6,0,36), BackgroundColor3 = Theme.Card, Visible = false, BorderSizePixel = 0})
    new("UICorner", {Parent = list, CornerRadius = UDim.new(0,6)})

    local function rebuild()
        for _,c in pairs(list:GetChildren()) do if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end end
        for i,opt in ipairs(options) do
            local row = new("Frame", {Parent = list, Size = UDim2.new(1,-8,0,28), Position = UDim2.new(0,4,0,(i-1)*30), BackgroundTransparency = 1})
            local txt = new("TextLabel", {Parent = row, Size = UDim2.new(1,-36,1,0), BackgroundTransparency = 1, Text = opt, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14})
            local chk = new("TextButton", {Parent = row, Size = UDim2.new(0,24,0,24), Position = UDim2.new(1,-28,0,2), Text = "", BackgroundColor3 = Theme.Background, BorderSizePixel = 0})
            new("UICorner", {Parent = chk, CornerRadius = UDim.new(0,6)})
            chk.MouseButton1Click:Connect(function()
                if selected[opt] then selected[opt] = nil; chk.BackgroundColor3 = Theme.Background else selected[opt] = true; chk.BackgroundColor3 = Theme.Accent end
                -- update summary
                local keys = {}
                for k,_ in pairs(selected) do table.insert(keys, k) end
                summary.Text = #keys == 0 and "None" or table.concat(keys, ", ")
                pcall(cfg.Callback, keys)
            end)
        end
        list.Size = UDim2.new(1,-12,0, math.min(#options*30, 6*30))
    end
    rebuild()

    arrow.MouseButton1Click:Connect(function() list.Visible = not list.Visible end)

    return {
        Get = function()
            local keys = {}
            for k,_ in pairs(selected) do table.insert(keys, k) end
            return keys
        end,
        Set = function(arr)
            selected = {}
            for _,v in ipairs(arr or {}) do selected[v] = true end
            rebuild()
        end
    }
end

-- Keybind selector
function UI:CreateKeybind(cfg)
    cfg = cfg or {}
    local boundKey = cfg.Default or Enum.KeyCode.Unknown
    local display = new("TextButton", {Parent = self.Frame, Size = UDim2.new(1,-12,0,34), BackgroundColor3 = Theme.Card, Text = (cfg.Name or "Keybind") .. ": " .. (boundKey == Enum.KeyCode.Unknown and "None" or tostring(boundKey)), TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, BorderSizePixel = 0})
    new("UICorner", {Parent = display, CornerRadius = UDim.new(0,6)})

    local listening = false
    display.MouseButton1Click:Connect(function()
        listening = true
        display.Text = (cfg.Name or "Keybind") .. ": Listening..."
        local conn
        conn = UIS.InputBegan:Connect(function(input, gpe)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                boundKey = input.KeyCode
                display.Text = (cfg.Name or "Keybind") .. ": " .. tostring(boundKey)
                listening = false
                pcall(cfg.Callback, boundKey)
                conn:Disconnect()
            end
        end)
    end)

    -- runtime listener: invoke callback when pressed
    UIS.InputBegan:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == boundKey then
            pcall(cfg.OnPressed)
        end
    end)

    return {
        Get = function() return boundKey end,
        Set = function(k) boundKey = k; display.Text = (cfg.Name or "Keybind") .. ": " .. tostring(boundKey) end
    }
end

-- Finish: expose module
return UI

-- LAYOUT UPDATE: Side Tabs + Scrollable Content
--[[
New structure:
ScreenGui
└─ MainFrame (horizontal)
   ├─ TabListFrame (left, scrollable)
   │    └─ UIListLayout + TabButtons
   └─ ContentFrame (right, scrollable)
        └─ Sections + Elements
]]

-- Build Side Tab List
local function CreateSideLayout(self)
    local Main = self._ScreenGui:FindFirstChild("MainFrame")
    if not Main then return end

    Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Main.BorderSizePixel = 0
    Main.Size = UDim2.new(0, 600, 0, 350)

    -- Left: Tab List
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Parent = Main
    TabList.Size = UDim2.new(0, 140, 1, 0)
    TabList.CanvasSize = UDim2.new(0,0,0,0)
    TabList.ScrollBarThickness = 4
    TabList.ScrollBarImageColor3 = Color3.fromRGB(120, 60, 200)
    TabList.BackgroundColor3 = Color3.fromRGB(15,15,15)

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabList
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0,6)

    -- Right: Content Holder
    local Content = Instance.new("ScrollingFrame")
    Content.Name = "ContentFrame"
    Content.Parent = Main
    Content.Size = UDim2.new(1, -150, 1, 0)
    Content.Position = UDim2.new(0, 150, 0, 0)
    Content.CanvasSize = UDim2.new(0,0,0,0)
    Content.ScrollBarThickness = 4
    Content.ScrollBarImageColor3 = Color3.fromRGB(120, 60, 200)
    Content.BackgroundColor3 = Color3.fromRGB(25,25,25)

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = Content
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0,10)

    self._TabList = TabList
    self._ContentFrame = Content
end

-- CreateSideLayout will be called after MainFrame creation
-- (Your existing window creation function must call CreateSideLayout(self) after building _ScreenGui and MainFrame)

-- CoreGui Compatibility Patch (Exploit Safe)
do
    local coregui = game:GetService("CoreGui")