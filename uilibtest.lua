-- Kali Hub UI Library - Fixed Version
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local KaliHub = {}

-- Colors
local Colors = {
    Background = Color3.fromRGB(30, 30, 40),
    Secondary = Color3.fromRGB(35, 35, 45),
    Tertiary = Color3.fromRGB(40, 40, 50),
    Border = Color3.fromRGB(70, 70, 80),
    Text = Color3.fromRGB(240, 240, 245),
    SubText = Color3.fromRGB(180, 180, 190),
    KaliPink = Color3.fromRGB(255, 182, 193),
    HubWhite = Color3.fromRGB(255, 255, 255),
    AccentHover = Color3.fromRGB(255, 192, 203),
    Success = Color3.fromRGB(120, 220, 120),
    Danger = Color3.fromRGB(220, 100, 100),
    DropdownBg = Color3.fromRGB(25, 25, 35)
}

-- Animation settings
local AnimationInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local FastAnimation = TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- Utility functions
local function createCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    return corner
end

local function createStroke(thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Colors.Border
    return stroke
end

local function createTextStroke(thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(0, 0, 0)
    return stroke
end

local function createPadding(padding)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, padding or 8)
    pad.PaddingBottom = UDim.new(0, padding or 8)
    pad.PaddingLeft = UDim.new(0, padding or 8)
    pad.PaddingRight = UDim.new(0, padding or 8)
    return pad
end

-- Main window creation
function KaliHub:CreateWindow(config)
    config = config or {}
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KaliHub"
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 650, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    mainFrame.BackgroundColor3 = Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    createCorner(12).Parent = mainFrame
    createStroke(2, Colors.Border).Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 55)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Colors.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    createCorner(12).Parent = titleBar
    
    -- Fix corner clipping
    local cornerFix = Instance.new("Frame")
    cornerFix.Size = UDim2.new(1, 0, 0, 12)
    cornerFix.Position = UDim2.new(0, 0, 1, -12)
    cornerFix.BackgroundColor3 = Colors.Secondary
    cornerFix.BorderSizePixel = 0
    cornerFix.Parent = titleBar
    
    -- Title container - Adjusted spacing
    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.new(0, 120, 1, 0)
    titleContainer.Position = UDim2.new(0, 20, 0, 0)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = titleBar
    
    -- "Kali" text (pink with stroke)
    local kaliText = Instance.new("TextLabel")
    kaliText.Text = "Kali"
    kaliText.Font = Enum.Font.GothamBold
    kaliText.TextSize = 20
    kaliText.TextColor3 = Colors.KaliPink
    kaliText.BackgroundTransparency = 1
    kaliText.Size = UDim2.new(0, 40, 1, 0)
    kaliText.Position = UDim2.new(0, 0, 0, 0)
    kaliText.TextXAlignment = Enum.TextXAlignment.Left
    kaliText.TextYAlignment = Enum.TextYAlignment.Center
    kaliText.Parent = titleContainer
    
    createTextStroke(2, Color3.fromRGB(15, 15, 25)).Parent = kaliText
    
    -- "Hub" text (white with stroke) - Reduced spacing further
    local hubText = Instance.new("TextLabel")
    hubText.Text = "Hub"
    hubText.Font = Enum.Font.GothamBold
    hubText.TextSize = 20
    hubText.TextColor3 = Colors.HubWhite
    hubText.BackgroundTransparency = 1
    hubText.Size = UDim2.new(0, 40, 1, 0)
    hubText.Position = UDim2.new(0, 37, 0, 0) -- Reduced from 40 to 37 for closer spacing
    hubText.TextXAlignment = Enum.TextXAlignment.Left
    hubText.TextYAlignment = Enum.TextYAlignment.Center
    hubText.Parent = titleContainer
    
    createTextStroke(2, Color3.fromRGB(15, 15, 25)).Parent = hubText
    
    -- Hide button (changed from minimize)
    local hideButton = Instance.new("TextButton")
    hideButton.Text = "−"
    hideButton.Font = Enum.Font.GothamBold
    hideButton.TextSize = 20
    hideButton.TextColor3 = Colors.Text
    hideButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    hideButton.Size = UDim2.new(0, 35, 0, 35)
    hideButton.Position = UDim2.new(1, -85, 0.5, -17.5)
    hideButton.BorderSizePixel = 0
    hideButton.Parent = titleBar
    
    createCorner(8).Parent = hideButton
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 22
    closeButton.TextColor3 = Colors.Text
    closeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    closeButton.Size = UDim2.new(0, 35, 0, 35)
    closeButton.Position = UDim2.new(1, -45, 0.5, -17.5)
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    createCorner(8).Parent = closeButton
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -55)
    contentFrame.Position = UDim2.new(0, 0, 0, 55)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 220, 1, -15)
    sidebar.Position = UDim2.new(0, 15, 0, 15)
    sidebar.BackgroundColor3 = Colors.Secondary
    sidebar.BorderSizePixel = 0
    sidebar.Parent = contentFrame
    
    createCorner(10).Parent = sidebar
    createStroke(1, Colors.Border).Parent = sidebar
    
    -- Main content area
    local mainContent = Instance.new("Frame")
    mainContent.Size = UDim2.new(1, -250, 1, -15)
    mainContent.Position = UDim2.new(0, 250, 0, 15)
    mainContent.BackgroundColor3 = Colors.Tertiary
    mainContent.BorderSizePixel = 0
    mainContent.Parent = contentFrame
    
    createCorner(10).Parent = mainContent
    createStroke(1, Colors.Border).Parent = mainContent
    
    -- Sidebar scroll
    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Size = UDim2.new(1, -10, 1, -20)
    sidebarScroll.Position = UDim2.new(0, 5, 0, 10)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 6
    sidebarScroll.ScrollBarImageColor3 = Colors.KaliPink
    sidebarScroll.Parent = sidebar
    
    createPadding(8).Parent = sidebarScroll
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.Parent = sidebarScroll
    
    -- Content scroll
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Size = UDim2.new(1, -10, 1, -10)
    contentScroll.Position = UDim2.new(0, 5, 0, 5)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 6
    contentScroll.ScrollBarImageColor3 = Colors.KaliPink
    contentScroll.Parent = mainContent
    
    createPadding(15).Parent = contentScroll
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 12)
    contentLayout.Parent = contentScroll
    
    -- Window object
    local Window = {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        Sidebar = sidebarScroll,
        Content = contentScroll,
        Tabs = {},
        CurrentTab = nil,
        IsHidden = false
    }
    
    -- Make draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Hide/Show functionality
    local function toggleVisibility()
        if Window.IsHidden then
            -- Show
            mainFrame.Visible = true
            TweenService:Create(mainFrame, AnimationInfo, {
                Position = UDim2.new(0.5, -325, 0.5, -225)
            }):Play()
            Window.IsHidden = false
        else
            -- Hide
            TweenService:Create(mainFrame, AnimationInfo, {
                Position = UDim2.new(0.5, -325, 1.5, 0)
            }):Play()
            spawn(function()
                wait(0.15)
                if Window.IsHidden then
                    mainFrame.Visible = false
                end
            end)
            Window.IsHidden = true
        end
    end
    
    hideButton.MouseButton1Click:Connect(toggleVisibility)
    
    -- Left Ctrl to hide/show
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
            toggleVisibility()
        end
    end)
    
    -- Close functionality
    closeButton.MouseButton1Click:Connect(function()
        TweenService:Create(mainFrame, FastAnimation, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        wait(0.1)
        screenGui:Destroy()
    end)
    
    -- Button hover effects
    hideButton.MouseEnter:Connect(function()
        TweenService:Create(hideButton, AnimationInfo, {BackgroundColor3 = Colors.AccentHover}):Play()
    end)
    
    hideButton.MouseLeave:Connect(function()
        TweenService:Create(hideButton, AnimationInfo, {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
    end)
    
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, AnimationInfo, {BackgroundColor3 = Colors.Danger}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, AnimationInfo, {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
    end)
    
    -- Tab creation
    function Window:CreateTab(name)
        -- Tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Text = name
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 15
        tabButton.TextColor3 = Colors.SubText
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.BorderSizePixel = 0
        tabButton.Parent = self.Sidebar
        
        createCorner(8).Parent = tabButton
        createStroke(1, Color3.fromRGB(55, 55, 65)).Parent = tabButton
        createTextStroke(1, Color3.fromRGB(10, 10, 15)).Parent = tabButton
        
        -- Tab indicator
        local tabIcon = Instance.new("Frame")
        tabIcon.Size = UDim2.new(0, 4, 0, 20)
        tabIcon.Position = UDim2.new(0, 8, 0.5, -10)
        tabIcon.BackgroundColor3 = Colors.SubText
        tabIcon.BorderSizePixel = 0
        tabIcon.Parent = tabButton
        
        createCorner(2).Parent = tabIcon
        
        -- Tab content
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = self.Content
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 10)
        tabLayout.Parent = tabContent
        
        -- Auto-populate with example content based on tab name
        if name == "Farming" then
            self:CreateFarmingContent(tabContent, tabLayout)
        elseif name == "Auto Buy" then
            self:CreateAutoBuyContent(tabContent, tabLayout)
        end
        
        local Tab = {
            Button = tabButton,
            Content = tabContent,
            Layout = tabLayout,
            Icon = tabIcon
        }
        
        -- Tab switching with improved animation
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                TweenService:Create(tab.Button, AnimationInfo, {
                    TextColor3 = Colors.SubText,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                }):Play()
                TweenService:Create(tab.Icon, AnimationInfo, {BackgroundColor3 = Colors.SubText}):Play()
            end
            
            -- Show current tab with animation
            tabContent.Visible = true
            TweenService:Create(tabButton, AnimationInfo, {
                TextColor3 = Colors.KaliPink,
                BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            }):Play()
            TweenService:Create(tabIcon, AnimationInfo, {BackgroundColor3 = Colors.KaliPink}):Play()
            
            self.CurrentTab = Tab
            
            -- Update sizes
            spawn(function()
                wait(0.1)
                tabContent.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
                self.Content.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 50)
            end)
        end)
        
        -- Enhanced hover effects
        tabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= Tab then
                TweenService:Create(tabButton, AnimationInfo, {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 55),
                    TextColor3 = Colors.Text
                }):Play()
                TweenService:Create(tabIcon, AnimationInfo, {BackgroundColor3 = Colors.Text}):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= Tab then
                TweenService:Create(tabButton, AnimationInfo, {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                    TextColor3 = Colors.SubText
                }):Play()
                TweenService:Create(tabIcon, AnimationInfo, {BackgroundColor3 = Colors.SubText}):Play()
            end
        end)
        
        self.Tabs[name] = Tab
        
        -- Auto-select first tab
        if not self.CurrentTab then
            spawn(function()
                wait(0.1)
                tabButton.MouseButton1Click:Fire()
            end)
        end
        
        -- Update sidebar size
        self.Sidebar.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 20)
        
        return Tab
    end
    
    -- Create Farming tab content
    function Window:CreateFarmingContent(parent, layout)
        -- Auto Favourite section
        local autoFavSection = self:CreateSection("Auto Favourite", parent, layout)
        
        -- Auto Harvest Toggle
        self:CreateToggle("Auto Harvest", false, autoFavSection)
        
        -- Auto Plant Toggle
        self:CreateToggle("Auto Plant", false, autoFavSection)
        
        -- Priority Mutation Toggle
        self:CreateToggle("Priority Mutation", false, autoFavSection)
        
        -- Harvest Mutations Only Toggle
        self:CreateToggle("Harvest Mutations Only", false, autoFavSection)
        
        -- Mutations Dropdown
        self:CreateDropdown("Mutations", {"None", "Fire", "Water", "Earth", "Air", "Lightning"}, autoFavSection)
        
        -- Plant Method Dropdown
        self:CreateDropdown("Plant Method", {"Random", "Sequential", "Priority"}, autoFavSection)
    end
    
    -- Create Auto Buy tab content
    function Window:CreateAutoBuyContent(parent, layout)
        -- Auto Buy section
        local autoBuySection = self:CreateSection("Auto Buy", parent, layout)
        
        -- Auto Buy Seed Toggle
        self:CreateToggle("Auto Buy Seed", false, autoBuySection)
        
        -- Buy Seeds Dropdown
        self:CreateDropdown("Buy Seeds", {"None", "Basic Seeds", "Premium Seeds", "Rare Seeds"}, autoBuySection)
        
        -- Buy Gear Toggle
        self:CreateToggle("Buy Gear", false, autoBuySection)
        
        -- Gear Dropdown
        self:CreateDropdown("Gear", {"None", "Watering Can", "Fertilizer", "Harvester"}, autoBuySection)
        
        -- Auto Buy Event Shop Toggle
        self:CreateToggle("Auto Buy Event Shop", false, autoBuySection)
        
        -- Stock Dropdown
        self:CreateDropdown("Stock", {"None", "Low Stock", "Medium Stock", "High Stock"}, autoBuySection)
    end
    
    -- Create section
    function Window:CreateSection(name, parent, layout)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, 0, 0, 35)
        section.BackgroundColor3 = Colors.Secondary
        section.BorderSizePixel = 0
        section.Parent = parent
        
        createCorner(8).Parent = section
        createStroke(1, Colors.Border).Parent = section
        
        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.Text = "🔸 " .. name
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.TextSize = 16
        sectionLabel.TextColor3 = Colors.KaliPink
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Size = UDim2.new(1, -20, 1, 0)
        sectionLabel.Position = UDim2.new(0, 15, 0, 0)
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Parent = section
        
        createTextStroke(1, Color3.fromRGB(10, 10, 15)).Parent = sectionLabel
        
        return section
    end
    
    -- Create toggle (improved from option)
    function Window:CreateToggle(name, defaultValue, parent)
        local toggle = Instance.new("Frame")
        toggle.Size = UDim2.new(1, 0, 0, 35)
        toggle.BackgroundColor3 = Colors.Background
        toggle.BorderSizePixel = 0
        toggle.Parent = parent.Parent
        
        createCorner(6).Parent = toggle
        createStroke(1, Colors.Border).Parent = toggle
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Text = name
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 14
        toggleLabel.TextColor3 = Colors.Text
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        toggleLabel.Position = UDim2.new(0, 15, 0, 0)
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggle
        
        createTextStroke(1, Color3.fromRGB(5, 5, 10)).Parent = toggleLabel
        
        -- Toggle switch
        local toggleButton = Instance.new("TextButton")
        toggleButton.Text = ""
        toggleButton.BackgroundColor3 = defaultValue and Colors.KaliPink or Color3.fromRGB(60, 60, 70)
        toggleButton.Size = UDim2.new(0, 45, 0, 20)
        toggleButton.Position = UDim2.new(1, -55, 0.5, -10)
        toggleButton.BorderSizePixel = 0
        toggleButton.Parent = toggle
        
        createCorner(10).Parent = toggleButton
        
        -- Toggle circle
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 16, 0, 16)
        toggleCircle.Position = defaultValue and UDim2.new(0, 27, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        toggleCircle.BackgroundColor3 = Colors.Text
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleButton
        
        createCorner(8).Parent = toggleCircle
        
        local isToggled = defaultValue
        
        toggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            
            TweenService:Create(toggleButton, AnimationInfo, {
                BackgroundColor3 = isToggled and Colors.KaliPink or Color3.fromRGB(60, 60, 70)
            }):Play()
            
            TweenService:Create(toggleCircle, AnimationInfo, {
                Position = isToggled and UDim2.new(0, 27, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }):Play()
        end)
        
        -- Hover effect
        toggleButton.MouseEnter:Connect(function()
            TweenService:Create(toggleCircle, AnimationInfo, {
                Size = UDim2.new(0, 18, 0, 18),
                Position = isToggled and UDim2.new(0, 26, 0.5, -9) or UDim2.new(0, 1, 0.5, -9)
            }):Play()
        end)
        
        toggleButton.MouseLeave:Connect(function()
            TweenService:Create(toggleCircle, AnimationInfo, {
                Size = UDim2.new(0, 16, 0, 16),
                Position = isToggled and UDim2.new(0, 27, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }):Play()
        end)
        
        return toggle
    end
    
    -- Create functional dropdown (fixed version)
    function Window:CreateDropdown(name, options, parent)
        local dropdown = Instance.new("Frame")
        dropdown.Size = UDim2.new(1, 0, 0, 35)
        dropdown.BackgroundColor3 = Colors.Background
        dropdown.BorderSizePixel = 0
        dropdown.Parent = parent.Parent
        
        createCorner(6).Parent = dropdown
        createStroke(1, Colors.Border).Parent = dropdown
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Text = name
        dropdownLabel.Font = Enum.Font.Gotham
        dropdownLabel.TextSize = 14
        dropdownLabel.TextColor3 = Colors.Text
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Size = UDim2.new(0.5, 0, 1, 0)
        dropdownLabel.Position = UDim2.new(0, 15, 0, 0)
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.Parent = dropdown
        
        createTextStroke(1, Color3.fromRGB(5, 5, 10)).Parent = dropdownLabel
        
        local selectedValue = options[1] or "None"
        local isOpen = false
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Text = selectedValue .. " ▼"
        dropdownButton.Font = Enum.Font.Gotham
        dropdownButton.TextSize = 12
        dropdownButton.TextColor3 = Colors.KaliPink
        dropdownButton.BackgroundColor3 = Colors.Secondary
        dropdownButton.Size = UDim2.new(0, 120, 0, 25)
        dropdownButton.Position = UDim2.new(1, -130, 0.5, -12.5)
        dropdownButton.BorderSizePixel = 0
        dropdownButton.ZIndex = 5
        dropdownButton.Parent = dropdown
        
        createCorner(4).Parent = dropdownButton
        createStroke(1, Colors.Border).Parent = dropdownButton
        createTextStroke(1, Color3.fromRGB(5, 5, 10)).Parent = dropdownButton
        
        -- Create dropdown container that goes outside the main frame
        local dropdownContainer = Instance.new("Frame")
        dropdownContainer.Size = UDim2.new(0, 120, 0, 0)
        dropdownContainer.Position = UDim2.new(1, -130, 1, 5)
        dropdownContainer.BackgroundTransparency = 1
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.Visible = false
        dropdownContainer.ZIndex = 10
        dropdownContainer.Parent = dropdown
        
        -- Dropdown list
        local dropdownList = Instance.new("Frame")
        dropdownList.Size = UDim2.new(1, 0, 1, 0)
        dropdownList.Position = UDim2.new(0, 0, 0, 0)
        dropdownList.BackgroundColor3 = Colors.DropdownBg
        dropdownList.BorderSizePixel = 0
        dropdownList.ZIndex = 10
        dropdownList.Parent = dropdownContainer
        
        createCorner(4).Parent = dropdownList
        createStroke(1, Colors.Border).Parent = dropdownList
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = dropdownList
        
        -- Create option buttons
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Text = option
            optionButton.Font = Enum.Font.Gotham
            optionButton.TextSize = 12
            optionButton.TextColor3 = Colors.Text
            optionButton.BackgroundTransparency = 1
            optionButton.Size = UDim2.new(1, 0, 0, 25)
            optionButton.BorderSizePixel = 0
            optionButton.ZIndex = 11
            optionButton.Parent = dropdownList
            
            createTextStroke(1, Color3.fromRGB(5, 5, 10)).Parent = optionButton
            
            optionButton.MouseEnter:Connect(function()
                optionButton.BackgroundTransparency = 0
                optionButton.BackgroundColor3 = Colors.Secondary
            end)
            
            optionButton.MouseLeave:Connect(function()
                optionButton.BackgroundTransparency = 1
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                selectedValue = option
                dropdownButton.Text = selectedValue .. " ▼"
                
                -- Close dropdown
                isOpen = false
                dropdownContainer.Size = UDim2.new(0, 120, 0, 0)
                dropdownContainer.Visible = false
            end)
        end
        
        -- Toggle dropdown
        dropdownButton.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            
            if isOpen then
                dropdownButton.Text = selectedValue .. " ▲"
                dropdownContainer.Visible = true
                dropdownContainer.Size = UDim2.new(0, 120, 0, #options * 25)
            else
                dropdownButton.Text = selectedValue .. " ▼"
                dropdownContainer.Size = UDim2.new(0, 120, 0, 0)
                dropdownContainer.Visible = false
            end
        end)
        
        -- Close dropdown when clicking elsewhere
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                local mousePos = UserInputService:GetMouseLocation()
                local buttonPos = dropdownButton.AbsolutePosition
                local buttonSize = dropdownButton.AbsoluteSize
                local listPos = dropdownList.AbsolutePosition
                local listSize = dropdownList.AbsoluteSize
                
                -- Check if click is outside dropdown area
                if not (mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and
                        mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y) and
                   not (mousePos.X >= listPos.X and mousePos.X <= listPos.X + listSize.X and
                        mousePos.Y >= listPos.Y and mousePos.Y <= listPos.Y + listSize.Y) then
                    isOpen = false
                    dropdownButton.Text = selectedValue .. " ▼"
                    dropdownContainer.Size = UDim2.new(0, 120, 0, 0)
                    dropdownContainer.Visible = false
                end
            end
        end)
        
        -- Hover effects
        dropdownButton.MouseEnter:Connect(function()
            TweenService:Create(dropdownButton, AnimationInfo, {BackgroundColor3 = Colors.AccentHover}):Play()
        end)
        
        dropdownButton.MouseLeave:Connect(function()
            TweenService:Create(dropdownButton, AnimationInfo, {BackgroundColor3 = Colors.Secondary}):Play()
        end)
        
        return dropdown
    end
    
    return Window
end

return KaliHub
