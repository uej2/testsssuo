--[[
    Enhanced LabyModUI Library
    A modern, feature-rich UI library for Roblox
    
    Features:
    - Windows with draggable functionality
    - Tabs and sections
    - Toggles, dropdowns, sliders, color pickers, keybinds
    - Configuration saving/loading system
    - Keybind toggle for menu visibility
    - Enhanced visual styling with text outlines
    - Auto-save functionality
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LabyModUI = {}
LabyModUI.__index = LabyModUI

-- Configuration system
local ConfigSystem = {}
ConfigSystem.__index = ConfigSystem

function ConfigSystem.new()
    local self = setmetatable({}, ConfigSystem)
    self.configData = {}
    self.autoSave = false
    self.configName = "LabyModUI_Config"
    return self
end

function ConfigSystem:saveConfig()
    if not self.autoSave then return end
    
    local success, result = pcall(function()
        writefile(self.configName .. ".json", HttpService:JSONEncode(self.configData))
    end)
    
    if success then
        print("Configuration saved successfully")
    else
        warn("Failed to save configuration: " .. tostring(result))
    end
end

function ConfigSystem:loadConfig()
    local success, result = pcall(function()
        if isfile(self.configName .. ".json") then
            return HttpService:JSONDecode(readfile(self.configName .. ".json"))
        end
        return {}
    end)
    
    if success then
        self.configData = result or {}
        print("Configuration loaded successfully")
        return true
    else
        warn("Failed to load configuration: " .. tostring(result))
        self.configData = {}
        return false
    end
end

function ConfigSystem:setValue(key, value)
    self.configData[key] = value
    if self.autoSave then
        self:saveConfig()
    end
end

function ConfigSystem:getValue(key, default)
    return self.configData[key] ~= nil and self.configData[key] or default
end

function ConfigSystem:setAutoSave(enabled)
    self.autoSave = enabled
end

-- Utility functions
local function createTween(instance, properties, duration, easingStyle, easingDirection)
    local tInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tInfo, properties)
    tween:Play()
    return tween
end

local function addTextOutline(textObject)
    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(0, 0, 0)
    outline.Thickness = 1
    outline.Transparency = 0.5
    outline.Parent = textObject
    return outline
end

local function getKeyName(keyCode)
    local keyNames = {
        [Enum.KeyCode.LeftShift] = "LShift",
        [Enum.KeyCode.RightShift] = "RShift",
        [Enum.KeyCode.LeftControl] = "LCtrl",
        [Enum.KeyCode.RightControl] = "RCtrl",
        [Enum.KeyCode.LeftAlt] = "LAlt",
        [Enum.KeyCode.RightAlt] = "RAlt",
        [Enum.KeyCode.CapsLock] = "Caps",
        [Enum.KeyCode.Tab] = "Tab",
        [Enum.KeyCode.Backspace] = "Backspace",
        [Enum.KeyCode.Return] = "Enter",
        [Enum.KeyCode.Space] = "Space",
        [Enum.KeyCode.Delete] = "Delete",
        [Enum.KeyCode.Home] = "Home",
        [Enum.KeyCode.End] = "End",
        [Enum.KeyCode.PageUp] = "PgUp",
        [Enum.KeyCode.PageDown] = "PgDn",
        [Enum.KeyCode.Insert] = "Insert"
    }
    
    return keyNames[keyCode] or keyCode.Name
end

-- Create a new window
function LabyModUI.new(config)
    local self = setmetatable({}, LabyModUI)
    
    config = config or {}
    self.title = config.title or "LabyModUI"
    self.size = config.size or UDim2.new(0, 800, 0, 600)
    self.toggleKey = config.toggleKey or Enum.KeyCode.K
    self.theme = config.theme or {
        background = Color3.fromRGB(15, 15, 20),
        topbar = Color3.fromRGB(20, 20, 28),
        accent = Color3.fromRGB(64, 156, 255),
        lightAccent = Color3.fromRGB(100, 180, 255),
        text = Color3.fromRGB(255, 255, 255),
        textDark = Color3.fromRGB(160, 160, 170),
        section = Color3.fromRGB(30, 30, 40),
        option = Color3.fromRGB(35, 35, 45)
    }
    
    -- Initialize configuration system
    self.config = ConfigSystem.new()
    self.config:loadConfig()
    
    -- UI elements registry for config saving
    self.elements = {}
    
    -- Main ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "LabyModUI"
    self.screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    self.screenGui.ResetOnSpawn = false
    self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = "MainFrame"
    self.mainFrame.Size = self.size
    self.mainFrame.Position = UDim2.new(0.5, -self.size.X.Offset/2, 0.5, -self.size.Y.Offset/2)
    self.mainFrame.BackgroundColor3 = self.theme.background
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Parent = self.screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = self.mainFrame
    
    -- Outer glow effect
    local outerGlow = Instance.new("ImageLabel")
    outerGlow.Name = "OuterGlow"
    outerGlow.Size = UDim2.new(1, 40, 1, 40)
    outerGlow.Position = UDim2.new(0, -20, 0, -20)
    outerGlow.BackgroundTransparency = 1
    outerGlow.Image = "rbxasset://textures/ui/InGameMenu/gradient.png"
    outerGlow.ImageColor3 = self.theme.accent
    outerGlow.ImageTransparency = 0.8
    outerGlow.ZIndex = -2
    outerGlow.Parent = self.mainFrame
    
    -- Main border with gradient
    local mainBorder = Instance.new("Frame")
    mainBorder.Name = "MainBorder"
    mainBorder.Size = UDim2.new(1, 4, 1, 4)
    mainBorder.Position = UDim2.new(0, -2, 0, -2)
    mainBorder.BackgroundColor3 = self.theme.accent
    mainBorder.BorderSizePixel = 0
    mainBorder.ZIndex = -1
    mainBorder.Parent = self.mainFrame
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 16)
    borderCorner.Parent = mainBorder
    
    local borderGradient = Instance.new("UIGradient")
    borderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, self.theme.accent),
        ColorSequenceKeypoint.new(0.5, self.theme.lightAccent),
        ColorSequenceKeypoint.new(1, self.theme.accent)
    }
    borderGradient.Rotation = 45
    borderGradient.Parent = mainBorder
    
    -- Animate border gradient
    spawn(function()
        while self.screenGui.Parent do
            createTween(borderGradient, {Rotation = 405}, 3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            wait(3)
            borderGradient.Rotation = 45
        end
    end)
    
    -- Top bar
    self.topBar = Instance.new("Frame")
    self.topBar.Name = "TopBar"
    self.topBar.Size = UDim2.new(1, 0, 0, 60)
    self.topBar.Position = UDim2.new(0, 0, 0, 0)
    self.topBar.BackgroundColor3 = self.theme.topbar
    self.topBar.BorderSizePixel = 0
    self.topBar.Parent = self.mainFrame
    
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 14)
    topBarCorner.Parent = self.topBar
    
    -- Title
    self.titleLabel = Instance.new("TextLabel")
    self.titleLabel.Name = "Title"
    self.titleLabel.Size = UDim2.new(1, -40, 1, 0)
    self.titleLabel.Position = UDim2.new(0, 20, 0, 0)
    self.titleLabel.BackgroundTransparency = 1
    self.titleLabel.Text = self.title
    self.titleLabel.TextColor3 = self.theme.text
    self.titleLabel.TextSize = 18
    self.titleLabel.Font = Enum.Font.GothamBold
    self.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.titleLabel.Parent = self.topBar
    addTextOutline(self.titleLabel)
    
    -- Close button
    self.closeButton = Instance.new("TextButton")
    self.closeButton.Name = "CloseButton"
    self.closeButton.Size = UDim2.new(0, 40, 0, 40)
    self.closeButton.Position = UDim2.new(1, -50, 0.5, -20)
    self.closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    self.closeButton.Text = "✕"
    self.closeButton.TextColor3 = self.theme.text
    self.closeButton.TextSize = 16
    self.closeButton.Font = Enum.Font.GothamBold
    self.closeButton.Parent = self.topBar
    addTextOutline(self.closeButton)
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = self.closeButton
    
    self.closeButton.MouseButton1Click:Connect(function()
        self:hide()
    end)
    
    -- Tab container
    self.tabContainer = Instance.new("Frame")
    self.tabContainer.Name = "TabContainer"
    self.tabContainer.Size = UDim2.new(1, 0, 0, 50)
    self.tabContainer.Position = UDim2.new(0, 0, 0, 60)
    self.tabContainer.BackgroundColor3 = self.theme.topbar
    self.tabContainer.BackgroundTransparency = 0.2
    self.tabContainer.BorderSizePixel = 0
    self.tabContainer.Parent = self.mainFrame
    
    -- Content area
    self.contentArea = Instance.new("Frame")
    self.contentArea.Name = "ContentArea"
    self.contentArea.Size = UDim2.new(1, 0, 1, -110)
    self.contentArea.Position = UDim2.new(0, 0, 0, 110)
    self.contentArea.BackgroundTransparency = 1
    self.contentArea.Parent = self.mainFrame
    
    -- Make window draggable
    self:makeDraggable()
    
    -- Initialize tabs
    self.tabs = {}
    self.tabButtons = {}
    self.currentTab = nil
    
    -- Setup toggle key
    self:setupToggleKey()
    
    -- Load UI visibility state
    local isVisible = self.config:getValue("ui_visible", true)
    self.screenGui.Enabled = isVisible
    
    return self
end

-- Setup toggle key functionality
function LabyModUI:setupToggleKey()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == self.toggleKey then
            self:toggle()
        end
    end)
end

-- Toggle UI visibility
function LabyModUI:toggle()
    local isVisible = not self.screenGui.Enabled
    self.screenGui.Enabled = isVisible
    self.config:setValue("ui_visible", isVisible)
end

-- Set toggle key
function LabyModUI:setToggleKey(keyCode)
    self.toggleKey = keyCode
    self.config:setValue("toggle_key", keyCode.Name)
end

-- Make the window draggable
function LabyModUI:makeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Create a new tab
function LabyModUI:addTab(name)
    local tab = {}
    tab.name = name
    tab.sections = {}
    
    -- Create tab button
    local tabCount = #self.tabs
    local tabWidth = 1 / (tabCount + 1)
    
    -- Resize existing tab buttons
    for i, button in pairs(self.tabButtons) do
        button.Size = UDim2.new(tabWidth, -5, 1, -10)
        button.Position = UDim2.new(tabWidth * (i - 1), 2.5, 0, 5)
    end
    
    -- Create new tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(tabWidth, -5, 1, -10)
    tabButton.Position = UDim2.new(tabWidth * tabCount, 2.5, 0, 5)
    tabButton.BackgroundColor3 = self.theme.option
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = self.theme.textDark
    tabButton.TextSize = 16
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Parent = self.tabContainer
    addTextOutline(tabButton)
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton
    
    -- Create tab content frame
    local tabContent = Instance.new("Frame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = self.contentArea
    
    -- Store tab data
    tab.button = tabButton
    tab.content = tabContent
    table.insert(self.tabs, tab)
    self.tabButtons[#self.tabs] = tabButton
    
    -- Tab button click handler
    tabButton.MouseButton1Click:Connect(function()
        self:selectTab(name)
    end)
    
    -- Select this tab if it's the first one
    if #self.tabs == 1 then
        self:selectTab(name)
    end
    
    -- Return tab object for method chaining
    return {
        addSection = function(sectionName)
            return self:addSection(tab, sectionName)
        end
    }
end

-- Select a tab
function LabyModUI:selectTab(name)
    for i, tab in ipairs(self.tabs) do
        local isSelected = (tab.name == name)
        
        -- Update tab button appearance
        createTween(tab.button, {
            BackgroundColor3 = isSelected and self.theme.section or self.theme.option,
            TextColor3 = isSelected and self.theme.accent or self.theme.textDark
        })
        
        -- Show/hide tab content
        tab.content.Visible = isSelected
        
        -- Add/remove border
        local border = tab.button:FindFirstChild("Border")
        if isSelected and not border then
            local newBorder = Instance.new("Frame")
            newBorder.Name = "Border"
            newBorder.Size = UDim2.new(1, 2, 1, 2)
            newBorder.Position = UDim2.new(0, -1, 0, -1)
            newBorder.BackgroundColor3 = self.theme.accent
            newBorder.BorderSizePixel = 0
            newBorder.ZIndex = -1
            newBorder.Parent = tab.button
            
            local borderCorner = Instance.new("UICorner")
            borderCorner.CornerRadius = UDim.new(0, 9)
            borderCorner.Parent = newBorder
        elseif not isSelected and border then
            border:Destroy()
        end
    end
    
    self.currentTab = name
    self.config:setValue("current_tab", name)
end

-- Add a section to a tab
function LabyModUI:addSection(tab, name)
    local section = {}
    section.name = name
    section.elements = {}
    
    -- Create section container
    local sectionCount = #tab.sections
    local sectionContainer = Instance.new("Frame")
    sectionContainer.Name = name .. "Section"
    sectionContainer.Size = UDim2.new(0, 380, 1, -20)
    sectionContainer.Position = UDim2.new(0, 10 + sectionCount * 390, 0, 10)
    sectionContainer.BackgroundColor3 = self.theme.section
    sectionContainer.BorderSizePixel = 0
    sectionContainer.Parent = tab.content
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 12)
    sectionCorner.Parent = sectionContainer
    
    -- Section border
    local sectionBorder = Instance.new("Frame")
    sectionBorder.Size = UDim2.new(1, 2, 1, 2)
    sectionBorder.Position = UDim2.new(0, -1, 0, -1)
    sectionBorder.BackgroundColor3 = self.theme.accent
    sectionBorder.BackgroundTransparency = 0.7
    sectionBorder.BorderSizePixel = 0
    sectionBorder.ZIndex = -1
    sectionBorder.Parent = sectionContainer
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 13)
    borderCorner.Parent = sectionBorder
    
    -- Section header
    local sectionHeader = Instance.new("Frame")
    sectionHeader.Name = "Header"
    sectionHeader.Size = UDim2.new(1, 0, 0, 50)
    sectionHeader.BackgroundColor3 = self.theme.option
    sectionHeader.BorderSizePixel = 0
    sectionHeader.Parent = sectionContainer
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = sectionHeader
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Size = UDim2.new(1, -20, 1, 0)
    sectionTitle.Position = UDim2.new(0, 20, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = name
    sectionTitle.TextColor3 = self.theme.text
    sectionTitle.TextSize = 16
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = sectionHeader
    addTextOutline(sectionTitle)
    
    -- Content container with scrolling
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "Content"
    scrollFrame.Size = UDim2.new(1, 0, 1, -50)
    scrollFrame.Position = UDim2.new(0, 0, 0, 50)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = self.theme.accent
    scrollFrame.ScrollBarImageTransparency = 0.3
    scrollFrame.Parent = sectionContainer
    
    -- Store section data
    section.container = sectionContainer
    section.content = scrollFrame
    section.elementCount = 0
    table.insert(tab.sections, section)
    
    -- Return section object for method chaining
    return {
        addToggle = function(toggleConfig)
            return self:addToggle(section, toggleConfig)
        end,
        addDropdown = function(dropdownConfig)
            return self:addDropdown(section, dropdownConfig)
        end,
        addSlider = function(sliderConfig)
            return self:addSlider(section, sliderConfig)
        end,
        addColorPicker = function(colorConfig)
            return self:addColorPicker(section, colorConfig)
        end,
        addKeybind = function(keybindConfig)
            return self:addKeybind(section, keybindConfig)
        end,
        addLabel = function(labelConfig)
            return self:addLabel(section, labelConfig)
        end,
        addButton = function(buttonConfig)
            return self:addButton(section, buttonConfig)
        end
    }
end

-- Register element for config saving
function LabyModUI:registerElement(elementId, element)
    self.elements[elementId] = element
end

-- Add a toggle to a section
function LabyModUI:addToggle(section, config)
    config = config or {}
    local name = config.name or "Toggle"
    local elementId = config.id or (section.name .. "_" .. name):gsub("%s+", "_"):lower()
    local default = config.default or false
    local callback = config.callback or function() end
    
    -- Load saved value
    local savedValue = self.config:getValue(elementId, default)
    
    -- Create toggle container
    local option = Instance.new("Frame")
    option.Name = name .. "Option"
    option.Size = UDim2.new(1, -20, 0, 40)
    option.Position = UDim2.new(0, 10, 0, section.elementCount * 45 + 10)
    option.BackgroundColor3 = self.theme.option
    option.BorderSizePixel = 0
    option.Parent = section.content
    
    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = UDim.new(0, 6)
    optionCorner.Parent = option
    
    -- Accent line
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(0, 3, 0.7, 0)
    accentLine.Position = UDim2.new(0, 0, 0.15, 0)
    accentLine.BackgroundColor3 = self.theme.accent
    accentLine.BorderSizePixel = 0
    accentLine.Parent = option
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 1.5)
    accentCorner.Parent = accentLine
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = self.theme.text
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = option
    addTextOutline(label)
    
    -- Toggle switch
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(0, 40, 0, 20)
    toggleContainer.Position = UDim2.new(1, -50, 0.5, -10)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = option
    
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(1, 0, 1, 0)
    toggle.BackgroundColor3 = savedValue and self.theme.accent or Color3.fromRGB(60, 60, 70)
    toggle.BorderSizePixel = 0
    toggle.Parent = toggleContainer
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggle
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Size = UDim2.new(0, 16, 0, 16)
    toggleButton.Position = savedValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    toggleButton.BackgroundColor3 = self.theme.text
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggle
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = toggleButton
    
    -- Toggle functionality
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = toggle
    
    -- State tracking
    local state = savedValue
    
    -- Toggle function that can be called externally
    local function updateToggle(newState)
        state = newState
        
        createTween(toggle, {
            BackgroundColor3 = state and self.theme.accent or Color3.fromRGB(60, 60, 70)
        })
        
        createTween(toggleButton, {
            Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        })
        
        self.config:setValue(elementId, state)
        callback(state)
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        updateToggle(not state)
    end)
    
    -- Call callback with initial value
    callback(savedValue)
    
    -- Increment element count
    section.elementCount = section.elementCount + 1
    
    -- Update canvas size
    section.content.CanvasSize = UDim2.new(0, 0, 0, section.elementCount * 45 + 20)
    
    -- Register element
    local element = {
        setValue = updateToggle,
        getValue = function() return state end,
        type = "toggle"
    }
    self:registerElement(elementId, element)
    
    return element
end

-- Add a dropdown to a section (ENHANCED WITH FIXED SELECTION)
function LabyModUI:addDropdown(section, config)
    config = config or {}
    local name = config.name or "Dropdown"
    local elementId = config.id or (section.name .. "_" .. name):gsub("%s+", "_"):lower()
    local options = config.options or {"Option 1", "Option 2", "Option 3"}
    local default = config.default or options[1]
    local callback = config.callback or function() end
    
    -- Load saved value
    local savedValue = self.config:getValue(elementId, default)
    if not table.find(options, savedValue) then
        savedValue = default
    end
    
    -- Create dropdown container
    local option = Instance.new("Frame")
    option.Name = name .. "Option"
    option.Size = UDim2.new(1, -20, 0, 40)
    option.Position = UDim2.new(0, 10, 0, section.elementCount * 45 + 10)
    option.BackgroundColor3 = self.theme.option
    option.BorderSizePixel = 0
    option.Parent = section.content
    
    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = UDim.new(0, 6)
    optionCorner.Parent = option
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = self.theme.text
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = option
    addTextOutline(label)
    
    -- Dropdown button
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(0, 120, 0, 25)
    dropdown.Position = UDim2.new(1, -130, 0.5, -12.5)
    dropdown.BackgroundColor3 = self.theme.section
    dropdown.BorderSizePixel = 0
    dropdown.Text = savedValue .. " ▼"
    dropdown.TextColor3 = self.theme.text
    dropdown.TextSize = 12
    dropdown.Font = Enum.Font.GothamMedium
    dropdown.Parent = option
    addTextOutline(dropdown)
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    dropdownCorner.Parent = dropdown
    
    -- Dropdown menu
    local dropdownMenu = Instance.new("Frame")
    dropdownMenu.Name = "DropdownMenu"
    dropdownMenu.Size = UDim2.new(0, 120, 0, #options * 25)
    dropdownMenu.Position = UDim2.new(1, -130, 1, 2)
    dropdownMenu.BackgroundColor3 = self.theme.section
    dropdownMenu.BorderSizePixel = 0
    dropdownMenu.Visible = false
    dropdownMenu.ZIndex = 15
    dropdownMenu.Parent = option
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 4)
    menuCorner.Parent = dropdownMenu
    
    -- Menu border
    local menuBorder = Instance.new("Frame")
    menuBorder.Size = UDim2.new(1, 2, 1, 2)
    menuBorder.Position = UDim2.new(0, -1, 0, -1)
    menuBorder.BackgroundColor3 = self.theme.accent
    menuBorder.BackgroundTransparency = 0.5
    menuBorder.BorderSizePixel = 0
    menuBorder.ZIndex = 14
    menuBorder.Parent = dropdownMenu
    
    local menuBorderCorner = Instance.new("UICorner")
    menuBorderCorner.CornerRadius = UDim.new(0, 5)
    menuBorderCorner.Parent = menuBorder
    
    -- Current selection tracking
    local currentValue = savedValue
    
    -- Function to update dropdown value externally
    local function updateDropdown(newValue)
        if table.find(options, newValue) then
            currentValue = newValue
            dropdown.Text = currentValue .. " ▼"
            
            -- Update all option appearances
            for _, child in pairs(dropdownMenu:GetChildren()) do
                if child:IsA("TextButton") then
                    local isSelected = child.Text == currentValue
                    child.BackgroundColor3 = isSelected and self.theme.accent or self.theme.section
                    child.TextColor3 = isSelected and self.theme.text or Color3.fromRGB(200, 200, 210)
                end
            end
            
            self.config:setValue(elementId, currentValue)
            callback(currentValue)
        end
    end
    
    -- Create dropdown options
    for i, optionText in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, 25)
        optionBtn.Position = UDim2.new(0, 0, 0, (i-1) * 25)
        optionBtn.BackgroundColor3 = optionText == currentValue and self.theme.accent or self.theme.section
        optionBtn.BorderSizePixel = 0
        optionBtn.Text = optionText
        optionBtn.TextColor3 = optionText == currentValue and self.theme.text or Color3.fromRGB(200, 200, 210)
        optionBtn.TextSize = 11
        optionBtn.Font = Enum.Font.GothamMedium
        optionBtn.ZIndex = 16
        optionBtn.Parent = dropdownMenu
        addTextOutline(optionBtn)
        
        -- Hover effect
        optionBtn.MouseEnter:Connect(function()
            if optionText ~= currentValue then
                createTween(optionBtn, {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 60),
                    TextColor3 = self.theme.text
                })
            end
        end)
        
        optionBtn.MouseLeave:Connect(function()
            if optionText ~= currentValue then
                createTween(optionBtn, {
                    BackgroundColor3 = self.theme.section,
                    TextColor3 = Color3.fromRGB(200, 200, 210)
                })
            end
        end)
        
        -- Selection - FIXED: Now properly updates the dropdown text and saves config
        optionBtn.MouseButton1Click:Connect(function()
            updateDropdown(optionText)
            dropdownMenu.Visible = false
            isOpen = false
        end)
    end
    
    -- Dropdown toggle
    local isOpen = false
    dropdown.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        dropdownMenu.Visible = isOpen
        dropdown.Text = currentValue .. (isOpen and " ▲" or " ▼")
    end)
    
    -- Close dropdown when clicking outside
    local closeConnection
    closeConnection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
            local mouse = Players.LocalPlayer:GetMouse()
            if mouse.Target and not dropdownMenu:IsAncestorOf(mouse.Target) and mouse.Target ~= dropdown then
                isOpen = false
                dropdownMenu.Visible = false
                dropdown.Text = currentValue .. " ▼"
            end
        end
    end)
    
    -- Call callback with initial value
    callback(savedValue)
    
    -- Increment element count
    section.elementCount = section.elementCount + 1
    
    -- Update canvas size
    section.content.CanvasSize = UDim2.new(0, 0, 0, section.elementCount * 45 + 20)
    
    -- Register element
    local element = {
        setValue = updateDropdown,
        getValue = function() return currentValue end,
        refresh = function(newOptions)
            -- Clear old options
            for _, child in pairs(dropdownMenu:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            options = newOptions
            dropdownMenu.Size = UDim2.new(0, 120, 0, #options * 25)
            
            -- If current value is not in new options, reset to first option
            if not table.find(options, currentValue) and #options > 0 then
                updateDropdown(options[1])
            end
            
            -- Create new option buttons
            for i, optionText in ipairs(options) do
                local optionBtn = Instance.new("TextButton")
                optionBtn.Size = UDim2.new(1, 0, 0, 25)
                optionBtn.Position = UDim2.new(0, 0, 0, (i-1) * 25)
                optionBtn.BackgroundColor3 = optionText == currentValue and self.theme.accent or self.theme.section
                optionBtn.BorderSizePixel = 0
                optionBtn.Text = optionText
                optionBtn.TextColor3 = optionText == currentValue and self.theme.text or Color3.fromRGB(200, 200, 210)
                optionBtn.TextSize = 11
                optionBtn.Font = Enum.Font.GothamMedium
                optionBtn.ZIndex = 16
                optionBtn.Parent = dropdownMenu
                addTextOutline(optionBtn)
                
                -- Hover effect
                optionBtn.MouseEnter:Connect(function()
                    if optionText ~= currentValue then
                        createTween(optionBtn, {
                            BackgroundColor3 = Color3.fromRGB(50, 50, 60),
                            TextColor3 = self.theme.text
                        })
                    end
                end)
                
                optionBtn.MouseLeave:Connect(function()
                    if optionText ~= currentValue then
                        createTween(optionBtn, {
                            BackgroundColor3 = self.theme.section,
                            TextColor3 = Color3.fromRGB(200, 200, 210)
                        })
                    end
                end)
                
                -- Selection
                optionBtn.MouseButton1Click:Connect(function()
                    updateDropdown(optionText)
                    dropdownMenu.Visible = false
                    isOpen = false
                end)
            end
        end,
        type = "dropdown"
    }
    self:registerElement(elementId, element)
    
    return element
end

-- Add a slider to a section
function LabyModUI:addSlider(section, config)
    config = config or {}
    local name = config.name or "Slider"
    local elementId = config.id or (section.name .. "_" .. name):gsub("%s+", "_"):lower()
    local min = config.min or 0
    local max = config.max or 100
    local default = math.clamp(config.default or min, min, max)
    local increment = config.increment or 1
    local suffix = config.suffix or ""
    local callback = config.callback or function() end
    
    -- Load saved value
    local savedValue = math.clamp(self.config:getValue(elementId, default), min, max)
    
    -- Create slider container
    local option = Instance.new("Frame")
    option.Name = name .. "Option"
    option.Size = UDim2.new(1, -20, 0, 50)
    option.Position = UDim2.new(0, 10, 0, section.elementCount * 45 + 10)
    option.BackgroundColor3 = self.theme.option
    option.BorderSizePixel = 0
    option.Parent = section.content
    
    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = UDim.new(0, 6)
    optionCorner.Parent = option
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = self.theme.text
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = option
    addTextOutline(label)
    
    -- Value display
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Size = UDim2.new(0, 50, 0, 20)
    valueDisplay.Position = UDim2.new(1, -60, 0, 5)
    valueDisplay.BackgroundTransparency = 1
    valueDisplay.Text = tostring(savedValue) .. suffix
    valueDisplay.TextColor3 = self.theme.accent
    valueDisplay.TextSize = 14
    valueDisplay.Font = Enum.Font.GothamBold
    valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    valueDisplay.Parent = option
    addTextOutline(valueDisplay)
    
    -- Slider background
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "SliderBackground"
    sliderBg.Size = UDim2.new(1, -30, 0, 6)
    sliderBg.Position = UDim2.new(0, 15, 0, 35)
    sliderBg.BackgroundColor3 = self.theme.section
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = option
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 3)
    bgCorner.Parent = sliderBg
    
    -- Slider fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((savedValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = self.theme.accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill
    
    -- Slider knob
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "SliderKnob"
    sliderKnob.Size = UDim2.new(0, 12, 0, 12)
    sliderKnob.Position = UDim2.new((savedValue - min) / (max - min), -6, 0.5, -6)
    sliderKnob.BackgroundColor3 = self.theme.text
    sliderKnob.BorderSizePixel = 0
    sliderKnob.ZIndex = 2
    sliderKnob.Parent = sliderBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 6)
    knobCorner.Parent = sliderKnob
    
    -- Slider functionality
    local isDragging = false
    local currentValue = savedValue
    
    -- Function to update slider value
    local function updateSlider(value)
        -- Round to increment
        value = min + math.floor((value - min) / increment + 0.5) * increment
        value = math.clamp(value, min, max)
        
        if value ~= currentValue then
            currentValue = value
            valueDisplay.Text = tostring(value) .. suffix
            
            local percent = (value - min) / (max - min)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderKnob.Position = UDim2.new(percent, -6, 0.5, -6)
            
            self.config:setValue(elementId, value)
            callback(value)
        end
    end
    
    -- Slider input handling
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            local mousePos = input.Position.X
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local value = min + (max - min) * percent
            updateSlider(value)
        end
    end)
    
    sliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local value = min + (max - min) * percent
            updateSlider(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    -- Call callback with initial value
    callback(savedValue)
    
    -- Increment element count
    section.elementCount = section.elementCount + 1
    
    -- Update canvas size
    section.content.CanvasSize = UDim2.new(0, 0, 0, section.elementCount * 45 + 20)
    
    -- Register element
    local element = {
        setValue = function(value)
            updateSlider(value)
        end,
        getValue = function()
            return currentValue
        end,
        type = "slider"
    }
    self:registerElement(elementId, element)
    
    return element
end

-- Add a color picker to a section
function LabyModUI:addColorPicker(section, config)
    config = config or {}
    local name = config.name or "Color"
    local elementId = config.id or (section.name .. "_" .. name):gsub("%s+", "_"):lower()
    local default = config.default or Color3.fromRGB(255, 255, 255)
    local callback = config.callback or function() end
    
    -- Load saved value
    local savedValue = self.config:getValue(elementId, {default.R, default.G, default.B})
    if type(savedValue) == "table" then
        savedValue = Color3.fromRGB(savedValue[1] * 255, savedValue[2] * 255, savedValue[3] * 255)
    else
        savedValue = default
    end
    
    -- Create color picker container
    local option = Instance.new("Frame")
    option.Name = name .. "Option"
    option.Size = UDim2.new(1, -20, 0, 40)
    option.Position = UDim2.new(0, 10, 0, section.elementCount * 45 + 10)
    option.BackgroundColor3 = self.theme.option
    option.BorderSizePixel = 0
    option.Parent = section.content
    
    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = UDim.new(0, 6)
    optionCorner.Parent = option
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = self.theme.text
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = option
    addTextOutline(label)
    
    -- Color preview
    local colorPreview = Instance.new("TextButton")
    colorPreview.Size = UDim2.new(0, 25, 0, 25)
    colorPreview.Position = UDim2.new(1, -35, 0.5, -12.5)
    colorPreview.BackgroundColor3 = savedValue
    colorPreview.BorderSizePixel = 0
    colorPreview.Text = ""
    colorPreview.Parent = option
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 4)
    colorCorner.Parent = colorPreview
    
    -- Color border
    local colorBorder = Instance.new("Frame")
    colorBorder.Size = UDim2.new(1, 2, 1, 2)
    colorBorder.Position = UDim2.new(0, -1, 0, -1)
    colorBorder.BackgroundColor3 = self.theme.accent
    colorBorder.BackgroundTransparency = 0.5
    colorBorder.BorderSizePixel = 0
    colorBorder.ZIndex = -1
    colorBorder.Parent = colorPreview
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 5)
    borderCorner.Parent = colorBorder
    
    -- Current color value
    local currentColor = savedValue
    
    -- Function to update color
    local function updateColor(color)
        currentColor = color
        colorPreview.BackgroundColor3 = color
        self.config:setValue(elementId, {color.R, color.G, color.B})
        callback(color)
    end
    
    -- Color picker functionality
    colorPreview.MouseButton1Click:Connect(function()
        self:openColorPicker(colorPreview, currentColor, updateColor)
    end)
    
    -- Call callback with initial value
    callback(savedValue)
    
    -- Increment element count
    section.elementCount = section.elementCount + 1
    
    -- Update canvas size
    section.content.CanvasSize = UDim2.new(0, 0, 0, section.elementCount * 45 + 20)
    
    -- Register element
    local element = {
        setValue = updateColor,
        getValue = function() return currentColor end,
        type = "colorpicker"
    }
    self:registerElement(elementId, element)
    
    return element
end

-- Add a keybind to a section
function LabyModUI:addKeybind(section, config)
    config = config or {}
    local name = config.name or "Keybind"
    local elementId = config.id or (section.name .. "_" .. name):gsub("%s+", "_"):lower()
    local default = config.default or Enum.KeyCode.F
    local callback = config.callback or function() end
    
    -- Load saved value
    local savedKeyName = self.config:getValue(elementId, default.Name)
    local savedKey = Enum.KeyCode[savedKeyName] or default
    
    -- Create keybind container
    local option = Instance.new("Frame")
    option.Name = name .. "Option"
    option.Size = UDim2.new(1, -20, 0, 40)
    option.Position = UDim2.new(0, 10, 0, section.elementCount * 45 + 10)
    option.BackgroundColor3 = self.theme.option
    option.BorderSizePixel = 0
    option.Parent = section.content
    
    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = UDim.new(0, 6)
    optionCorner.Parent = option
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = self.theme.text
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = option
    addTextOutline(label)
    
    -- Keybind button
    local keybindButton = Instance.new("TextButton")
    keybindButton.Size = UDim2.new(0, 80, 0, 25)
    keybindButton.Position = UDim2.new(1, -90, 0.5, -12.5)
    keybindButton.BackgroundColor3 = self.theme.section
    keybindButton.BorderSizePixel = 0
    keybindButton.Text = getKeyName(savedKey)
    keybindButton.TextColor3 = self.theme.text
    keybindButton.TextSize = 12
    keybindButton.Font = Enum.Font.GothamMedium
    keybindButton.Parent = option
    addTextOutline(keybindButton)
    
    local keybindCorner = Instance.new("UICorner")
    keybindCorner.CornerRadius = UDim.new(0, 4)
    keybindCorner.Parent = keybindButton
    
    -- Current key tracking
    local currentKey = savedKey
    local isBinding = false
    
    -- Function to update keybind
    local function updateKeybind(newKey)
        currentKey = newKey
        keybindButton.Text = getKeyName(newKey)
        self.config:setValue(elementId, newKey.Name)
    end
    
    -- Keybind functionality
    local bindConnection
    keybindButton.MouseButton1Click:Connect(function()
        if isBinding then return end
        
        isBinding = true
        keybindButton.Text = "Press Key..."
        keybindButton.BackgroundColor3 = self.theme.accent
        
        if bindConnection then
            bindConnection:Disconnect()
        end
        
        bindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                updateKeybind(input.KeyCode)
                isBinding = false
                keybindButton.BackgroundColor3 = self.theme.section
                bindConnection:Disconnect()
            end
        end)
    end)
    
    -- Key press detection
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or isBinding then return end
        
        if input.KeyCode == currentKey then
            callback(currentKey)
        end
    end)
    
    -- Increment element count
    section.elementCount = section.elementCount + 1
    
    -- Update canvas size
    section.content.CanvasSize = UDim2.new(0, 0, 0, section.elementCount * 45 + 20)
    
    -- Register element
    local element = {
        setValue = updateKeybind,
        getValue = function() return currentKey end,
        type = "keybind"
    }
    self:registerElement(elementId, element)
    
    return element
end

-- Open color picker
function LabyModUI:openColorPicker(colorPreview, initialColor, callback)
    -- Color picker frame
    local colorPicker = Instance.new("Frame")
    colorPicker.Name = "ColorPicker"
    colorPicker.Size = UDim2.new(0, 220, 0, 200)
    colorPicker.Position = UDim2.new(0.5, -110, 0.5, -100)
    colorPicker.BackgroundColor3 = self.theme.section
    colorPicker.BorderSizePixel = 0
    colorPicker.ZIndex = 25
    colorPicker.Parent = self.screenGui
    
    local pickerCorner = Instance.new("UICorner")
    pickerCorner.CornerRadius = UDim.new(0, 8)
    pickerCorner.Parent = colorPicker
    
    -- Color picker border
    local pickerBorder = Instance.new("Frame")
    pickerBorder.Size = UDim2.new(1, 2, 1, 2)
    pickerBorder.Position = UDim2.new(0, -1, 0, -1)
    pickerBorder.BackgroundColor3 = self.theme.accent
    pickerBorder.BorderSizePixel = 0
    pickerBorder.ZIndex = 24
    pickerBorder.Parent = colorPicker
    
    local pickerBorderCorner = Instance.new("UICorner")
    pickerBorderCorner.CornerRadius = UDim.new(0, 9)
    pickerBorderCorner.Parent = pickerBorder
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "🎨 Choose Color"
    title.TextColor3 = self.theme.text
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 26
    title.Parent = colorPicker
    addTextOutline(title)
    
    -- Color grid
    local colors = {
        -- Row 1: Grayscale
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200), Color3.fromRGB(127, 127, 127), Color3.fromRGB(64, 64, 64), Color3.fromRGB(0, 0, 0),
        -- Row 2: Reds
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 127), Color3.fromRGB(200, 0, 0), Color3.fromRGB(127, 0, 0), Color3.fromRGB(64, 0, 0),
        -- Row 3: Oranges/Yellows
        Color3.fromRGB(255, 127, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 127), Color3.fromRGB(200, 200, 0), Color3.fromRGB(127, 127, 0),
        -- Row 4: Greens
        Color3.fromRGB(0, 255, 0), Color3.fromRGB(127, 255, 127), Color3.fromRGB(0, 200, 0), Color3.fromRGB(0, 127, 0), Color3.fromRGB(0, 64, 0),
        -- Row 5: Cyans/Blues
        Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 127, 255), Color3.fromRGB(0, 0, 255), Color3.fromRGB(0, 0, 200), Color3.fromRGB(0, 0, 127),
        -- Row 6: Purples/Magentas
        Color3.fromRGB(127, 0, 255), Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 127, 255), Color3.fromRGB(200, 0, 200), Color3.fromRGB(127, 0, 127)
    }
    
    for i, color in ipairs(colors) do
        local row = math.floor((i-1) / 5)
        local col = (i-1) % 5
        
        local colorBtn = Instance.new("TextButton")
        colorBtn.Size = UDim2.new(0, 30, 0, 25)
        colorBtn.Position = UDim2.new(0, 15 + col * 38, 0, 40 + row * 27)
        colorBtn.BackgroundColor3 = color
        colorBtn.BorderSizePixel = 0
        colorBtn.Text = ""
        colorBtn.ZIndex = 27
        colorBtn.Parent = colorPicker
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = colorBtn
        
        -- Color button border
        local colorBtnBorder = Instance.new("Frame")
        colorBtnBorder.Size = UDim2.new(1, 2, 1, 2)
        colorBtnBorder.Position = UDim2.new(0, -1, 0, -1)
        colorBtnBorder.BackgroundColor3 = self.theme.accent
        colorBtnBorder.BackgroundTransparency = 0.7
        colorBtnBorder.BorderSizePixel = 0
        colorBtnBorder.ZIndex = 26
        colorBtnBorder.Parent = colorBtn
        
        local colorBtnBorderCorner = Instance.new("UICorner")
        colorBtnBorderCorner.CornerRadius = UDim.new(0, 5)
        colorBtnBorderCorner.Parent = colorBtnBorder
        
        -- Hover effect
        colorBtn.MouseEnter:Connect(function()
            createTween(colorBtnBorder, {BackgroundTransparency = 0.3})
        end)
        
        colorBtn.MouseLeave:Connect(function()
            createTween(colorBtnBorder, {BackgroundTransparency = 0.7})
        end)
        
        colorBtn.MouseButton1Click:Connect(function()
            callback(color)
            colorPicker:Destroy()
        end)
    end
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 60, 0, 25)
    closeBtn.Position = UDim2.new(0.5, -30, 1, -35)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Close"
    closeBtn.TextColor3 = self.theme.text
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamMedium
    closeBtn.ZIndex = 27
    closeBtn.Parent = colorPicker
    addTextOutline(closeBtn)
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        colorPicker:Destroy()
    end)
end

-- Add a label to a section
function LabyModUI:addLabel(section, config)
    config = config or {}
    local text = config.text or "Label"
    
    -- Create label container
    local option = Instance.new("Frame")
    option.Name = "LabelOption"
    option.Size = UDim2.new(1, -20, 0, 30)
    option.Position = UDim2.new(0, 10, 0, section.elementCount * 45 + 10)
    option.BackgroundColor3 = self.theme.option
    option.BorderSizePixel = 0
    option.Parent = section.content
    
    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = UDim.new(0, 6)
    optionCorner.Parent = option
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.theme.text
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = option
    addTextOutline(label)
    
    -- Increment element count
    section.elementCount = section.elementCount + 1
    
    -- Update canvas size
    section.content.CanvasSize = UDim2.new(0, 0, 0, section.elementCount * 45 + 20)
    
    -- Return label API
    return {
        setText = function(newText)
            label.Text = newText
        end,
        getText = function()
            return label.Text
        end,
        type = "label"
    }
end

-- Add a button to a section
function LabyModUI:addButton(section, config)
    config = config or {}
    local name = config.name or "Button"
    local callback = config.callback or function() end
    
    -- Create button container
    local option = Instance.new("Frame")
    option.Name = name .. "Option"
    option.Size = UDim2.new(1, -20, 0, 40)
    option.Position = UDim2.new(0, 10, 0, section.elementCount * 45 + 10)
    option.BackgroundColor3 = self.theme.option
    option.BorderSizePixel = 0
    option.Parent = section.content
    
    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = UDim.new(0, 6)
    optionCorner.Parent = option
    
    -- Button
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0.5, -15)
    button.BackgroundColor3 = self.theme.accent
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = self.theme.text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = option
    addTextOutline(button)
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    -- Button functionality
    button.MouseButton1Click:Connect(function()
        callback()
        
        -- Click effect
        createTween(button, {BackgroundColor3 = self.theme.lightAccent}, 0.1)
        task.wait(0.1)
        createTween(button, {BackgroundColor3 = self.theme.accent}, 0.1)
    end)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        createTween(button, {BackgroundColor3 = self.theme.lightAccent}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        createTween(button, {BackgroundColor3 = self.theme.accent}, 0.2)
    end)
    
    -- Increment element count
    section.elementCount = section.elementCount + 1
    
    -- Update canvas size
    section.content.CanvasSize = UDim2.new(0, 0, 0, section.elementCount * 45 + 20)
    
    -- Return button API
    return {
        setText = function(newText)
            button.Text = newText
        end,
        getText = function()
            return button.Text
        end,
        type = "button"
    }
end

-- Configuration management functions
function LabyModUI:saveConfig(configName)
    configName = configName or "default"
    self.config.configName = "LabyModUI_" .. configName
    self.config:saveConfig()
end

function LabyModUI:loadConfig(configName)
    configName = configName or "default"
    self.config.configName = "LabyModUI_" .. configName
    local success = self.config:loadConfig()
    
    if success then
        -- Apply loaded values to all elements
        for elementId, element in pairs(self.elements) do
            local savedValue = self.config:getValue(elementId)
            if savedValue ~= nil and element.setValue then
                element.setValue(savedValue)
            end
        end
    end
    
    return success
end

function LabyModUI:setAutoSave(enabled)
    self.config:setAutoSave(enabled)
end

-- Show the UI
function LabyModUI:show()
    self.screenGui.Enabled = true
    self.config:setValue("ui_visible", true)
end

-- Hide the UI
function LabyModUI:hide()
    self.screenGui.Enabled = false
    self.config:setValue("ui_visible", false)
end

-- Destroy the UI
function LabyModUI:destroy()
    self.config:saveConfig()
    self.screenGui:Destroy()
end

return LabyModUI
