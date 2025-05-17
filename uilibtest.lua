-- Kali Hub by @f3a2
-- UI Library for Roblox

local KaliHub = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Color theme (light hot pink)
local THEME = {
    PRIMARY = Color3.fromRGB(255, 105, 180),   -- Hot pink
    SECONDARY = Color3.fromRGB(255, 182, 193), -- Light pink
    BACKGROUND = Color3.fromRGB(40, 40, 40),   -- Dark gray
    SECTION = Color3.fromRGB(50, 50, 50),      -- Slightly lighter gray
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255), -- White
    TEXT_SECONDARY = Color3.fromRGB(200, 200, 200), -- Light gray
    SUCCESS = Color3.fromRGB(85, 255, 127),    -- Green
    WARNING = Color3.fromRGB(255, 230, 0),     -- Yellow
    ERROR = Color3.fromRGB(255, 75, 75),       -- Red
}

-- Create a ScreenGui
local function createGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KaliHubGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to use CoreGui for better persistence
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
            ScreenGui.Parent = CoreGui
        elseif gethui then
            ScreenGui.Parent = gethui()
        else
            ScreenGui.Parent = CoreGui
        end
    end)
    
    if ScreenGui.Parent == nil then
        ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    return ScreenGui
end

-- Create the main frame
local function createMainFrame(parent)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = THEME.BACKGROUND
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = parent
    
    -- Add corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame
    
    -- Add background gradient
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.BACKGROUND),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
    })
    UIGradient.Rotation = 45
    UIGradient.Parent = MainFrame
    
    return MainFrame
end

-- Create the sidebar
local function createSidebar(parent)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 50, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = parent
    
    -- Add corner radius (only on left side)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Sidebar
    
    -- Add padding
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.Parent = Sidebar
    
    -- Create logo
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Name = "LogoFrame"
    LogoFrame.Size = UDim2.new(1, 0, 0, 40)
    LogoFrame.BackgroundTransparency = 1
    LogoFrame.Parent = Sidebar
    
    local LogoText = Instance.new("TextLabel")
    LogoText.Name = "LogoText"
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "K"
    LogoText.Font = Enum.Font.GothamBold
    LogoText.TextColor3 = THEME.PRIMARY
    LogoText.TextSize = 24
    LogoText.Parent = LogoFrame
    
    return Sidebar, LogoFrame
end

-- Create navigation buttons
local function createNavButtons(sidebar, logoFrame)
    -- Define icons and their properties
    local navButtons = {
        {name = "Home", icon = "rbxassetid://3926305904", offset = Vector2.new(964, 204)},
        {name = "Methods", icon = "rbxassetid://3926307971", offset = Vector2.new(764, 764)},
        {name = "Settings", icon = "rbxassetid://3926307971", offset = Vector2.new(644, 204)},
        {name = "Logger", icon = "rbxassetid://3926305904", offset = Vector2.new(144, 4)},
        {name = "Info", icon = "rbxassetid://3926305904", offset = Vector2.new(524, 444)},
        {name = "User", icon = "rbxassetid://3926307971", offset = Vector2.new(4, 44)},
        {name = "Chat", icon = "rbxassetid://3926305904", offset = Vector2.new(164, 284)}
    }
    
    local NavButtons = Instance.new("Frame")
    NavButtons.Name = "NavButtons"
    NavButtons.Size = UDim2.new(1, 0, 1, -50)
    NavButtons.Position = UDim2.new(0, 0, 0, 50)
    NavButtons.BackgroundTransparency = 1
    NavButtons.Parent = sidebar
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 15)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = NavButtons
    
    local buttons = {}
    
    for i, buttonInfo in ipairs(navButtons) do
        local Button = Instance.new("ImageButton")
        Button.Name = buttonInfo.name .. "Button"
        Button.Size = UDim2.new(0, 30, 0, 30)
        Button.BackgroundTransparency = 1
        Button.Image = buttonInfo.icon
        Button.ImageRectOffset = buttonInfo.offset
        Button.ImageRectSize = Vector2.new(36, 36)
        Button.ImageColor3 = THEME.TEXT_SECONDARY
        Button.Parent = NavButtons
        
        -- Add tooltip
        local Tooltip = Instance.new("TextLabel")
        Tooltip.Name = "Tooltip"
        Tooltip.Size = UDim2.new(0, 80, 0, 30)
        Tooltip.Position = UDim2.new(1, 10, 0, 0)
        Tooltip.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Tooltip.BorderSizePixel = 0
        Tooltip.Text = buttonInfo.name
        Tooltip.Font = Enum.Font.Gotham
        Tooltip.TextColor3 = THEME.TEXT_PRIMARY
        Tooltip.TextSize = 12
        Tooltip.Visible = false
        Tooltip.ZIndex = 10
        Tooltip.Parent = Button
        
        -- Add corner radius to tooltip
        local TooltipCorner = Instance.new("UICorner")
        TooltipCorner.CornerRadius = UDim.new(0, 4)
        TooltipCorner.Parent = Tooltip
        
        -- Add hover effect
        Button.MouseEnter:Connect(function()
            Button.ImageColor3 = THEME.PRIMARY
            Tooltip.Visible = true
        end)
        
        Button.MouseLeave:Connect(function()
            if Button ~= buttons.selected then
                Button.ImageColor3 = THEME.TEXT_SECONDARY
            end
            Tooltip.Visible = false
        end)
        
        table.insert(buttons, {button = Button, name = buttonInfo.name})
    end
    
    buttons.setSelected = function(name)
        for _, btn in ipairs(buttons) do
            if btn.name == name then
                btn.button.ImageColor3 = THEME.PRIMARY
                buttons.selected = btn.button
            else
                btn.button.ImageColor3 = THEME.TEXT_SECONDARY
            end
        end
    end
    
    return buttons
end

-- Create the header
local function createHeader(parent)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, -50, 0, 40)
    Header.Position = UDim2.new(0, 50, 0, 0)
    Header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Header.BorderSizePixel = 0
    Header.Parent = parent
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Info"
    Title.TextColor3 = THEME.TEXT_PRIMARY
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Size = UDim2.new(0, 200, 1, 0)
    Subtitle.Position = UDim2.new(0, 85, 0, 0)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "by @f3a2"
    Subtitle.TextColor3 = THEME.TEXT_SECONDARY
    Subtitle.TextSize = 14
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header
    
    -- Verified badge
    local VerifiedBadge = Instance.new("ImageLabel")
    VerifiedBadge.Name = "VerifiedBadge"
    VerifiedBadge.Size = UDim2.new(0, 16, 0, 16)
    VerifiedBadge.Position = UDim2.new(0, 160, 0.5, -8)
    VerifiedBadge.BackgroundTransparency = 1
    VerifiedBadge.Image = "rbxassetid://3926305904"
    VerifiedBadge.ImageRectOffset = Vector2.new(116, 4)
    VerifiedBadge.ImageRectSize = Vector2.new(24, 24)
    VerifiedBadge.ImageColor3 = Color3.fromRGB(85, 170, 255)
    VerifiedBadge.Parent = Header
    
    -- Settings button
    local SettingsButton = Instance.new("ImageButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Size = UDim2.new(0, 24, 0, 24)
    SettingsButton.Position = UDim2.new(1, -34, 0.5, -12)
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.Image = "rbxassetid://3926307971"
    SettingsButton.ImageRectOffset = Vector2.new(324, 124)
    SettingsButton.ImageRectSize = Vector2.new(36, 36)
    SettingsButton.ImageColor3 = THEME.TEXT_SECONDARY
    SettingsButton.Parent = Header
    
    -- Hover effect for settings button
    SettingsButton.MouseEnter:Connect(function()
        SettingsButton.ImageColor3 = THEME.PRIMARY
    end)
    
    SettingsButton.MouseLeave:Connect(function()
        SettingsButton.ImageColor3 = THEME.TEXT_SECONDARY
    end)
    
    return Header, Title
end

-- Create content area
local function createContentArea(parent)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -50, 1, -40)
    ContentArea.Position = UDim2.new(0, 50, 0, 40)
    ContentArea.BackgroundColor3 = THEME.BACKGROUND
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = parent
    
    return ContentArea
end

-- Create a section
local function createSection(parent, title, isCollapsible)
    local Section = Instance.new("Frame")
    Section.Name = title .. "Section"
    Section.Size = UDim2.new(1, -20, 0, 30) -- Initial size, will be updated
    Section.Position = UDim2.new(0, 10, 0, 10)
    Section.BackgroundColor3 = THEME.SECTION
    Section.BorderSizePixel = 0
    Section.Parent = parent
    
    -- Add corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Section
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundTransparency = 1
    Header.Parent = Section
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -30, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = title
    Title.TextColor3 = THEME.TEXT_PRIMARY
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Dropdown arrow (if collapsible)
    local Arrow
    if isCollapsible then
        Arrow = Instance.new("ImageButton")
        Arrow.Name = "Arrow"
        Arrow.Size = UDim2.new(0, 20, 0, 20)
        Arrow.Position = UDim2.new(1, -25, 0.5, -10)
        Arrow.BackgroundTransparency = 1
        Arrow.Image = "rbxassetid://3926305904"
        Arrow.ImageRectOffset = Vector2.new(564, 284)
        Arrow.ImageRectSize = Vector2.new(36, 36)
        Arrow.ImageColor3 = THEME.TEXT_SECONDARY
        Arrow.Parent = Header
    end
    
    -- Content container
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 0, 0) -- Will be updated dynamically
    Content.Position = UDim2.new(0, 0, 0, 30)
    Content.BackgroundTransparency = 1
    Content.ClipsDescendants = true
    Content.Parent = Section
    
    -- Add padding
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 5)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.Parent = Content
    
    -- Add list layout
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Content
    
    -- Update section size when content changes
    local function updateSectionSize()
        if Content.Visible then
            Section.Size = UDim2.new(1, -20, 0, 30 + UIListLayout.AbsoluteContentSize.Y + 15)
            Content.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + 15)
        else
            Section.Size = UDim2.new(1, -20, 0, 30)
            Content.Size = UDim2.new(1, 0, 0, 0)
        end
    end
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSize)
    
    -- Toggle collapse if collapsible
    if isCollapsible and Arrow then
        local isExpanded = true
        
        Arrow.MouseButton1Click:Connect(function()
            isExpanded = not isExpanded
            
            -- Rotate arrow
            local targetRotation = isExpanded and 0 or 180
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(Arrow, tweenInfo, {Rotation = targetRotation})
            tween:Play()
            
            -- Toggle content visibility
            Content.Visible = isExpanded
            updateSectionSize()
        end)
        
        -- Hover effect for arrow
        Arrow.MouseEnter:Connect(function()
            Arrow.ImageColor3 = THEME.PRIMARY
        end)
        
        Arrow.MouseLeave:Connect(function()
            Arrow.ImageColor3 = THEME.TEXT_SECONDARY
        end)
    end
    
    -- Initial update
    updateSectionSize()
    
    return Section, Content
end

-- Create a toggle button
local function createToggle(parent, text, default)
    local Toggle = Instance.new("Frame")
    Toggle.Name = text .. "Toggle"
    Toggle.Size = UDim2.new(1, 0, 0, 30)
    Toggle.BackgroundTransparency = 1
    Toggle.Parent = parent
    
    -- Text
    local Text = Instance.new("TextLabel")
    Text.Name = "Text"
    Text.Size = UDim2.new(1, -60, 1, 0)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.Gotham
    Text.Text = text
    Text.TextColor3 = THEME.TEXT_SECONDARY
    Text.TextSize = 14
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Toggle
    
    -- Toggle background
    local ToggleBackground = Instance.new("Frame")
    ToggleBackground.Name = "ToggleBackground"
    ToggleBackground.Size = UDim2.new(0, 40, 0, 20)
    ToggleBackground.Position = UDim2.new(1, -45, 0.5, -10)
    ToggleBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleBackground.BorderSizePixel = 0
    ToggleBackground.Parent = Toggle
    
    -- Add corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = ToggleBackground
    
    -- Toggle knob
    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = THEME.TEXT_PRIMARY
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleBackground
    
    -- Add corner radius to knob
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob
    
    -- Toggle functionality
    local isEnabled = default or false
    
    local function updateToggle()
        local targetPosition = isEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = isEnabled and THEME.PRIMARY or Color3.fromRGB(60, 60, 60)
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local positionTween = TweenService:Create(Knob, tweenInfo, {Position = targetPosition})
        local colorTween = TweenService:Create(ToggleBackground, tweenInfo, {BackgroundColor3 = targetColor})
        
        positionTween:Play()
        colorTween:Play()
    end
    
    -- Set initial state
    if isEnabled then
        updateToggle()
    end
    
    -- Make the entire toggle clickable
    Toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isEnabled = not isEnabled
            updateToggle()
        end
    end)
    
    ToggleBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isEnabled = not isEnabled
            updateToggle()
        end
    end)
    
    -- Return the toggle and its state
    local toggleAPI = {}
    
    function toggleAPI:SetValue(value)
        if isEnabled ~= value then
            isEnabled = value
            updateToggle()
        end
    end
    
    function toggleAPI:GetValue()
        return isEnabled
    end
    
    function toggleAPI:Toggle()
        isEnabled = not isEnabled
        updateToggle()
        return isEnabled
    end
    
    return toggleAPI, Toggle
end

-- Create a dropdown
local function createDropdown(parent, text, options, default)
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = text .. "Dropdown"
    Dropdown.Size = UDim2.new(1, 0, 0, 60)
    Dropdown.BackgroundTransparency = 1
    Dropdown.ClipsDescendants = true
    Dropdown.Parent = parent
    
    -- Label
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = THEME.TEXT_SECONDARY
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Dropdown
    
    -- Dropdown button
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "DropdownButton"
    DropdownButton.Size = UDim2.new(1, 0, 0, 30)
    DropdownButton.Position = UDim2.new(0, 0, 0, 25)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Text = default or options[1] or "Select..."
    DropdownButton.TextColor3 = THEME.TEXT_SECONDARY
    DropdownButton.TextSize = 14
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    DropdownButton.AutoButtonColor = false
    DropdownButton.Parent = Dropdown
    
    -- Add padding to text
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.Parent = DropdownButton
    
    -- Add corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = DropdownButton
    
    -- Arrow
    local Arrow = Instance.new("ImageLabel")
    Arrow.Name = "Arrow"
    Arrow.Size = UDim2.new(0, 20, 0, 20)
    Arrow.Position = UDim2.new(1, -25, 0.5, -10)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://3926305904"
    Arrow.ImageRectOffset = Vector2.new(564, 284)
    Arrow.ImageRectSize = Vector2.new(36, 36)
    Arrow.ImageColor3 = THEME.TEXT_SECONDARY
    Arrow.Parent = DropdownButton
    
    -- Options container
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Name = "OptionsContainer"
    OptionsContainer.Size = UDim2.new(1, 0, 0, #options * 30)
    OptionsContainer.Position = UDim2.new(0, 0, 0, 60)
    OptionsContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    OptionsContainer.BorderSizePixel = 0
    OptionsContainer.Visible = false
    OptionsContainer.ZIndex = 5
    OptionsContainer.Parent = Dropdown
    
    -- Add corner radius to options
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 6)
    OptionsCorner.Parent = OptionsContainer
    
    -- Add list layout
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 0)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = OptionsContainer
    
    -- Create option buttons
    local selectedOption = default or options[1] or "Select..."
    local optionButtons = {}
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Name = option .. "Option"
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.BackgroundTransparency = 1
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = THEME.TEXT_SECONDARY
        OptionButton.TextSize = 14
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.ZIndex = 5
        OptionButton.Parent = OptionsContainer
        
        -- Add padding to text
        local OptionPadding = Instance.new("UIPadding")
        OptionPadding.PaddingLeft = UDim.new(0, 10)
        OptionPadding.Parent = OptionButton
        
        -- Option selection
        OptionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            DropdownButton.Text = option
            OptionsContainer.Visible = false
            Dropdown.Size = UDim2.new(1, 0, 0, 60)
            Arrow.Rotation = 0
        end)
        
        -- Hover effect
        OptionButton.MouseEnter:Connect(function()
            OptionButton.BackgroundColor3 = THEME.PRIMARY
            OptionButton.BackgroundTransparency = 0.8
        end)
        
        OptionButton.MouseLeave:Connect(function()
            OptionButton.BackgroundTransparency = 1
        end)
        
        table.insert(optionButtons, OptionButton)
    end
    
    -- Toggle dropdown
    local isOpen = false
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            Dropdown.Size = UDim2.new(1, 0, 0, 60 + #options * 30)
            OptionsContainer.Visible = true
            Arrow.Rotation = 180
        else
            Dropdown.Size = UDim2.new(1, 0, 0, 60)
            OptionsContainer.Visible = false
            Arrow.Rotation = 0
        end
    end)
    
    -- Close dropdown when clicking elsewhere
    UserInputService.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isOpen then
            local position = input.Position
            local inDropdown = false
            
            -- Check if click is within dropdown or options
            if DropdownButton.AbsolutePosition.X <= position.X and 
               position.X <= DropdownButton.AbsolutePosition.X + DropdownButton.AbsoluteSize.X and
               DropdownButton.AbsolutePosition.Y <= position.Y and
               position.Y <= DropdownButton.AbsolutePosition.Y + DropdownButton.AbsoluteSize.Y then
                inDropdown = true
            end
            
            if OptionsContainer.Visible then
                for _, button in ipairs(optionButtons) do
                    if button.AbsolutePosition.X <= position.X and 
                       position.X <= button.AbsolutePosition.X + button.AbsoluteSize.X and
                       button.AbsolutePosition.Y <= position.Y and
                       position.Y <= button.AbsolutePosition.Y + button.AbsoluteSize.Y then
                        inDropdown = true
                        break
                    end
                end
            end
            
            if not inDropdown then
                isOpen = false
                Dropdown.Size = UDim2.new(1, 0, 0, 60)
                OptionsContainer.Visible = false
                Arrow.Rotation = 0
            end
        end
    end)
    
    -- Dropdown API
    local dropdownAPI = {}
    
    function dropdownAPI:SetValue(value)
        for _, option in ipairs(options) do
            if option == value then
                selectedOption = value
                DropdownButton.Text = value
                return true
            end
        end
        return false
    end
    
    function dropdownAPI:GetValue()
        return selectedOption
    end
    
    function dropdownAPI:AddOption(option)
        if table.find(options, option) then return false end
        
        table.insert(options, option)
        
        local OptionButton = Instance.new("TextButton")
        OptionButton.Name = option .. "Option"
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.BackgroundTransparency = 1
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = THEME.TEXT_SECONDARY
        OptionButton.TextSize = 14
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.ZIndex = 5
        OptionButton.Parent = OptionsContainer
        
        -- Add padding to text
        local OptionPadding = Instance.new("UIPadding")
        OptionPadding.PaddingLeft = UDim.new(0, 10)
        OptionPadding.Parent = OptionButton
        
        -- Option selection
        OptionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            DropdownButton.Text = option
            OptionsContainer.Visible = false
            Dropdown.Size = UDim2.new(1, 0, 0, 60)
            Arrow.Rotation = 0
        end)
        
        -- Hover effect
        OptionButton.MouseEnter:Connect(function()
            OptionButton.BackgroundColor3 = THEME.PRIMARY
            OptionButton.BackgroundTransparency = 0.8
        end)
        
        OptionButton.MouseLeave:Connect(function()
            OptionButton.BackgroundTransparency = 1
        end)
        
        table.insert(optionButtons, OptionButton)
        OptionsContainer.Size = UDim2.new(1, 0, 0, #options * 30)
        
        return true
    end
    
    function dropdownAPI:RemoveOption(option)
        local index = table.find(options, option)
        if not index then return false end
        
        table.remove(options, index)
        optionButtons[index]:Destroy()
        table.remove(optionButtons, index)
        
        OptionsContainer.Size = UDim2.new(1, 0, 0, #options * 30)
        
        if selectedOption == option then
            selectedOption = options[1] or "Select..."
            DropdownButton.Text = selectedOption
        end
        
        return true
    end
    
    return dropdownAPI, Dropdown
end

-- Create a notification
local function createNotification(parent, icon, text, color)
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Size = UDim2.new(1, 0, 0, 40)
    Notification.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
    Notification.BorderSizePixel = 0
    Notification.Parent = parent
    
    -- Add corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Notification
    
    -- Icon
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Position = UDim2.new(0, 8, 0.5, -12)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://3926305904"
    Icon.ImageRectOffset = icon or Vector2.new(4, 844)
    Icon.ImageRectSize = Vector2.new(36, 36)
    Icon.ImageColor3 = THEME.PRIMARY
    Icon.Parent = Notification
    
    -- Text
    local Text = Instance.new("TextLabel")
    Text.Name = "Text"
    Text.Size = UDim2.new(1, -50, 1, 0)
    Text.Position = UDim2.new(0, 40, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.Gotham
    Text.Text = text
    Text.TextColor3 = THEME.TEXT_PRIMARY
    Text.TextSize = 14
    Text.TextWrapped = true
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Notification
    
    return Notification
end

-- Create a button
local function createButton(parent, text, color)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = UDim2.new(1, 0, 0, 36)
    Button.BackgroundColor3 = color or THEME.PRIMARY
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.GothamSemibold
    Button.Text = text
    Button.TextColor3 = THEME.TEXT_PRIMARY
    Button.TextSize = 14
    Button.AutoButtonColor = false
    Button.Parent = parent
    
    -- Add corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Button
    
    -- Hover and click effects
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = color and color:Lerp(Color3.fromRGB(255, 255, 255), 0.2) or THEME.PRIMARY:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = color or THEME.PRIMARY
    end)
    
    Button.MouseButton1Down:Connect(function()
        Button.BackgroundColor3 = color and color:Lerp(Color3.fromRGB(0, 0, 0), 0.2) or THEME.PRIMARY:Lerp(Color3.fromRGB(0, 0, 0), 0.2)
    end)
    
    Button.MouseButton1Up:Connect(function()
        Button.BackgroundColor3 = color and color:Lerp(Color3.fromRGB(255, 255, 255), 0.2) or THEME.PRIMARY:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
    end)
    
    -- Button API
    local buttonAPI = {}
    
    function buttonAPI:SetText(newText)
        Button.Text = newText
    end
    
    function buttonAPI:SetCallback(callback)
        Button.MouseButton1Click:Connect(callback)
    end
    
    return buttonAPI, Button
end

-- Create a logger
local function createLogger(parent)
    local Logger = Instance.new("Frame")
    Logger.Name = "Logger"
    Logger.Size = UDim2.new(1, 0, 0, 150)
    Logger.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Logger.BorderSizePixel = 0
    Logger.Parent = parent
    
    -- Add corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Logger
    
    -- Log text
    local LogText = Instance.new("TextLabel")
    LogText.Name = "LogText"
    LogText.Size = UDim2.new(1, -20, 1, -60)
    LogText.Position = UDim2.new(0, 10, 0, 10)
    LogText.BackgroundTransparency = 1
    LogText.Font = Enum.Font.Code
    LogText.Text = "[Kali Hub]: Waiting for new messages..."
    LogText.TextColor3 = THEME.TEXT_SECONDARY
    LogText.TextSize = 14
    LogText.TextXAlignment = Enum.TextXAlignment.Left
    LogText.TextYAlignment = Enum.TextYAlignment.Top
    LogText.TextWrapped = true
    LogText.Parent = Logger
    
    -- Buttons container
    local ButtonsContainer = Instance.new("Frame")
    ButtonsContainer.Name = "ButtonsContainer"
    ButtonsContainer.Size = UDim2.new(1, -20, 0, 30)
    ButtonsContainer.Position = UDim2.new(0, 10, 1, -40)
    ButtonsContainer.BackgroundTransparency = 1
    ButtonsContainer.Parent = Logger
    
    -- Copy to clipboard button
    local copyAPI, CopyButton = createButton(ButtonsContainer, "Copy to clipboard", Color3.fromRGB(60, 60, 60))
    CopyButton.Size = UDim2.new(0.5, -5, 1, 0)
    
    -- Clear button
    local clearAPI, ClearButton = createButton(ButtonsContainer, "Clear", Color3.fromRGB(60, 60, 60))
    ClearButton.Size = UDim2.new(0.5, -5, 1, 0)
    ClearButton.Position = UDim2.new(0.5, 5, 0, 0)
    
    -- Button functionality
    copyAPI:SetCallback(function()
        if setclipboard then
            setclipboard(LogText.Text)
        end
    end)
    
    clearAPI:SetCallback(function()
        LogText.Text = "[Kali Hub]: Log cleared."
    end)
    
    -- Logger API
    local loggerAPI = {}
    
    function loggerAPI:Log(message)
        LogText.Text = LogText.Text .. "\n" .. message
    end
    
    function loggerAPI:Clear()
        LogText.Text = "[Kali Hub]: Log cleared."
    end
    
    function loggerAPI:GetLogs()
        return LogText.Text
    end
    
    return loggerAPI, Logger
end

-- Create tab content
local function createTabContent(parent, name)
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = THEME.PRIMARY
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.Parent = parent
    
    -- Add padding
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.Parent = TabContent
    
    -- Add list layout
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = TabContent
    
    -- Update canvas size when children change
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    return TabContent
end

-- Create the UI
function KaliHub:CreateWindow(title)
    local window = {}
    window.tabs = {}
    window.currentTab = nil
    
    -- Create the GUI
    local ScreenGui = createGui()
    local MainFrame = createMainFrame(ScreenGui)
    local Sidebar, LogoFrame = createSidebar(MainFrame)
    local Header, HeaderTitle = createHeader(MainFrame)
    local ContentArea = createContentArea(MainFrame)
    
    -- Create navigation buttons
    local navButtons = createNavButtons(Sidebar, LogoFrame)
    
    -- Update header title
    HeaderTitle.Text = title or "Kali Hub"
    
    -- Create a tab
    function window:CreateTab(name, icon)
        local tab = {}
        tab.name = name
        tab.sections = {}
        
        -- Create tab content
        local TabContent = createTabContent(ContentArea, name)
        tab.content = TabContent
        
        -- Add to tabs table
        table.insert(window.tabs, tab)
        
        -- If this is the first tab, select it
        if #window.tabs == 1 then
            TabContent.Visible = true
            window.currentTab = tab
            HeaderTitle.Text = name
            navButtons.setSelected(name)
        end
        
        -- Create a section
        function tab:CreateSection(title, isCollapsible)
            local section, content = createSection(TabContent, title, isCollapsible ~= false)
            local sectionAPI = {}
            
            -- Add a notification
            function sectionAPI:AddNotification(text, icon, color)
                local notification = createNotification(content, icon, text, color)
                return notification
            end
            
            -- Add a toggle
            function sectionAPI:AddToggle(text, default)
                local toggleAPI, toggle = createToggle(content, text, default)
                return toggleAPI
            end
            
            -- Add a dropdown
            function sectionAPI:AddDropdown(text, options, default)
                local dropdownAPI, dropdown = createDropdown(content, text, options or {}, default)
                return dropdownAPI
            end
            
            -- Add a button
            function sectionAPI:AddButton(text, callback, color)
                local buttonAPI, button = createButton(content, text, color)
                
                if callback then
                    buttonAPI:SetCallback(callback)
                end
                
                return buttonAPI
            end
            
            -- Add a logger
            function sectionAPI:AddLogger()
                local loggerAPI, logger = createLogger(content)
                return loggerAPI
            end
            
            table.insert(tab.sections, sectionAPI)
            return sectionAPI
        end
        
        return tab
    end
    
    -- Switch to tab
    function window:SelectTab(name)
        for _, tab in ipairs(window.tabs) do
            tab.content.Visible = (tab.name == name)
            
            if tab.name == name then
                window.currentTab = tab
                HeaderTitle.Text = name
                navButtons.setSelected(name)
            end
        end
    end
    
    -- Set up tab switching
    for i, buttonInfo in ipairs(navButtons) do
        if i <= #window.tabs then
            buttonInfo.button.MouseButton1Click:Connect(function()
                window:SelectTab(buttonInfo.name)
            end)
        end
    end
    
    -- Mobile optimization
    if isMobile then
        -- Adjust main frame size
        MainFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
        MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
        
        -- Add close button for mobile
        local CloseButton = Instance.new("TextButton")
        CloseButton.Name = "CloseButton"
        CloseButton.Size = UDim2.new(0, 40, 0, 40)
        CloseButton.Position = UDim2.new(1, -50, 0, 0)
        CloseButton.BackgroundTransparency = 1
        CloseButton.Text = "✕"
        CloseButton.TextColor3 = THEME.TEXT_SECONDARY
        CloseButton.TextSize = 24
        CloseButton.Font = Enum.Font.GothamBold
        CloseButton.Parent = Header
        
        CloseButton.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
        
        -- Hover effect
        CloseButton.MouseEnter:Connect(function()
            CloseButton.TextColor3 = THEME.PRIMARY
        end)
        
        CloseButton.MouseLeave:Connect(function()
            CloseButton.TextColor3 = THEME.TEXT_SECONDARY
        end)
    end
    
    return window
end

-- Initialize the UI
local function Initialize()
    local window = KaliHub:CreateWindow("Kali Hub")
    
    -- Create tabs
    local homeTab = window:CreateTab("Home")
    local methodsTab = window:CreateTab("Methods")
    local settingsTab = window:CreateTab("Settings")
    local loggerTab = window:CreateTab("Logger")
    local infoTab = window:CreateTab("Info")
    
    -- Add content to Home tab
    local homeSection = homeTab:CreateSection("Guide")
    homeSection:AddNotification("You need to set your language to Ka3ak Tiri for this to work!", Vector2.new(364, 324), Color3.fromRGB(71, 71, 10))
    homeSection:AddNotification("Try out the brand new and upgraded Premade Manager!", Vector2.new(4, 844), Color3.fromRGB(10, 71, 10))
    
    -- Add content to Methods tab
    local methodsSection = methodsTab:CreateSection("Methods")
    
    local recursiveButton = methodsSection:AddButton("Recursive", function()
        print("Recursive method selected")
    end)
    
    local legitButton = methodsSection:AddButton("Legit", function()
        print("Legit method selected")
    end)
    
    local arrowButton = methodsSection:AddButton("Arrow", function()
        print("Arrow method selected")
    end)
    
    -- Add descriptions
    methodsSection:AddNotification("Recursive → Tries all methods (Legit, Arrow) until one works.", nil, Color3.fromRGB(40, 40, 40))
    methodsSection:AddNotification("Legit → Fully legit messages, atleast one word required, medium-high success rate.", nil, Color3.fromRGB(40, 40, 40))
    methodsSection:AddNotification("Arrow → Uses arrows in place of letters, effective for specific inputs.", nil, Color3.fromRGB(40, 40, 40))
    
    -- Add content to Settings tab
    local settingsSection = settingsTab:CreateSection("Settings")
    settingsSection:AddToggle("Filtering check")
    settingsSection:AddToggle("Message tagging")
    settingsSection:AddToggle("Attempt tagging")
    settingsSection:AddToggle("Flag all words")
    
    local moduleSection = settingsTab:CreateSection("Module")
    moduleSection:AddToggle("Enable this module")
    moduleSection:AddToggle("Respond to nearest users within Proximity Range")
    
    local gameSettingsSection = settingsTab:CreateSection("In-Game Settings")
    gameSettingsSection:AddDropdown("Personality", {"Base Level", "Aggressive", "Friendly", "Random"}, "Base Level")
    
    -- Add content to Logger tab
    local loggerSection = loggerTab:CreateSection("Chat Logs")
    local logger = loggerSection:AddLogger()
    logger:Log("[Kali Hub]: Initialized successfully.")
    
    local autoReportSection = loggerTab:CreateSection("Auto Report")
    autoReportSection:AddDropdown("Action to take", {"None", "Report", "Block", "Report and Block"}, "None")
    
    -- Add content to Info tab
    local infoSection = infoTab:CreateSection("Client Information")
    
    -- Get executor info using identifyexecutor()
    local executorName = "Unknown"
    pcall(function()
        if identifyexecutor then
            executorName = identifyexecutor()
        end
    end)
    
    infoSection:AddNotification("Executor: " .. executorName, Vector2.new(764, 244), Color3.fromRGB(40, 40, 40))
    infoSection:AddNotification("Application Version: 1.0.0", Vector2.new(764, 244), Color3.fromRGB(40, 40, 40))
    infoSection:AddNotification("Kali Hub Version: 1.0.0", Vector2.new(764, 244), Color3.fromRGB(40, 40, 40))
    
    local uiSection = infoTab:CreateSection("User Interface")
    uiSection:AddToggle("Disable Chat Notifications")
    
    -- Select the Info tab by default
    window:SelectTab("Info")
    
    return window
end

-- Return the library
KaliHub.Initialize = Initialize
return KaliHub
