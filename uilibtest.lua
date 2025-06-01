-- Kali Hub UI Library
-- Clean, modern UI library for Roblox with rounded edges and smooth animations

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local KaliHub = {}

-- Colors and styling
local Colors = {
    Background = Color3.fromRGB(25, 25, 35),
    SecondaryBackground = Color3.fromRGB(35, 35, 45),
    Border = Color3.fromRGB(60, 60, 70),
    Text = Color3.fromRGB(220, 220, 225),
    SubText = Color3.fromRGB(160, 160, 170),
    Accent = Color3.fromRGB(255, 182, 193), -- Light pink
    AccentHover = Color3.fromRGB(255, 192, 203),
    Success = Color3.fromRGB(100, 200, 100),
    Warning = Color3.fromRGB(255, 200, 100)
}

-- Animation settings
local AnimationInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

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
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    createCorner(12).Parent = mainFrame
    createStroke(1, Colors.Border).Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Colors.SecondaryBackground
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    createCorner(12).Parent = titleBar
    createStroke(1, Colors.Border).Parent = titleBar
    
    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Text = "Kali Hub"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 18
    titleText.TextColor3 = Colors.Accent
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(0, 200, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = Colors.Text
    closeButton.BackgroundColor3 = Colors.Background
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0.5, -15)
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    createCorner(6).Parent = closeButton
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -50)
    contentFrame.Position = UDim2.new(0, 0, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.BackgroundColor3 = Colors.SecondaryBackground
    sidebar.BorderSizePixel = 0
    sidebar.Parent = contentFrame
    
    createCorner(8).Parent = sidebar
    createStroke(1, Colors.Border).Parent = sidebar
    
    -- Main content area
    local mainContent = Instance.new("Frame")
    mainContent.Name = "MainContent"
    mainContent.Size = UDim2.new(1, -210, 1, 0)
    mainContent.Position = UDim2.new(0, 210, 0, 0)
    mainContent.BackgroundColor3 = Colors.Background
    mainContent.BorderSizePixel = 0
    mainContent.Parent = contentFrame
    
    createCorner(8).Parent = mainContent
    createStroke(1, Colors.Border).Parent = mainContent
    createPadding(15).Parent = mainContent
    
    -- Sidebar scrolling frame
    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Name = "SidebarScroll"
    sidebarScroll.Size = UDim2.new(1, 0, 1, 0)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 4
    sidebarScroll.ScrollBarImageColor3 = Colors.Accent
    sidebarScroll.Parent = sidebar
    
    createPadding(10).Parent = sidebarScroll
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 5)
    sidebarLayout.Parent = sidebarScroll
    
    -- Main content scrolling frame
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = "ContentScroll"
    contentScroll.Size = UDim2.new(1, 0, 1, 0)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 4
    contentScroll.ScrollBarImageColor3 = Colors.Accent
    contentScroll.Parent = mainContent
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = contentScroll
    
    -- Window object
    local Window = {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        Sidebar = sidebarScroll,
        Content = contentScroll,
        Tabs = {},
        CurrentTab = nil
    }
    
    -- Make window draggable
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
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Button hover effects
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, AnimationInfo, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, AnimationInfo, {BackgroundColor3 = Colors.Background}):Play()
    end)
    
    -- Tab creation function
    function Window:CreateTab(name, config)
        config = config or {}
        
        -- Tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Text = name
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.TextColor3 = Colors.SubText
        tabButton.BackgroundColor3 = Colors.Background
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.BorderSizePixel = 0
        tabButton.Parent = self.Sidebar
        
        createCorner(6).Parent = tabButton
        createStroke(1, Colors.Border).Parent = tabButton
        
        -- Tab content
        local tabContent = Instance.new("Frame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = self.Content
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout.Parent = tabContent
        
        local Tab = {
            Button = tabButton,
            Content = tabContent,
            Layout = tabLayout,
            Elements = {}
        }
        
        -- Tab switching
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                tab.Button.TextColor3 = Colors.SubText
                tab.Button.BackgroundColor3 = Colors.Background
            end
            
            -- Show current tab
            tabContent.Visible = true
            tabButton.TextColor3 = Colors.Accent
            tabButton.BackgroundColor3 = Colors.SecondaryBackground
            self.CurrentTab = Tab
            
            -- Update content size
            tabContent.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
            self.Content.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= Tab then
                TweenService:Create(tabButton, AnimationInfo, {BackgroundColor3 = Colors.SecondaryBackground}):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= Tab then
                TweenService:Create(tabButton, AnimationInfo, {BackgroundColor3 = Colors.Background}):Play()
            end
        end)
        
        -- Section creation
        function Tab:CreateSection(name)
            local section = Instance.new("Frame")
            section.Name = name .. "Section"
            section.Size = UDim2.new(1, 0, 0, 30)
            section.BackgroundColor3 = Colors.SecondaryBackground
            section.BorderSizePixel = 0
            section.Parent = tabContent
            
            createCorner(8).Parent = section
            createStroke(1, Colors.Border).Parent = section
            createPadding(12).Parent = section
            
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Name = "SectionLabel"
            sectionLabel.Text = name
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextSize = 16
            sectionLabel.TextColor3 = Colors.Accent
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Size = UDim2.new(1, 0, 1, 0)
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = section
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 8)
            sectionLayout.Parent = section
            
            local Section = {
                Frame = section,
                Layout = sectionLayout
            }
            
            -- Button creation
            function Section:CreateButton(text, callback)
                local button = Instance.new("TextButton")
                button.Name = text .. "Button"
                button.Text = text
                button.Font = Enum.Font.Gotham
                button.TextSize = 14
                button.TextColor3 = Colors.Text
                button.BackgroundColor3 = Colors.Background
                button.Size = UDim2.new(1, 0, 0, 30)
                button.BorderSizePixel = 0
                button.LayoutOrder = #section:GetChildren()
                button.Parent = section
                
                createCorner(6).Parent = button
                createStroke(1, Colors.Border).Parent = button
                
                button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
                
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, AnimationInfo, {BackgroundColor3 = Colors.AccentHover}):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, AnimationInfo, {BackgroundColor3 = Colors.Background}):Play()
                end)
                
                -- Update section size
                section.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 24)
                tabContent.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
                Window.Content.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
                
                return button
            end
            
            -- Toggle creation
            function Section:CreateToggle(text, default, callback)
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = text .. "Toggle"
                toggleFrame.Size = UDim2.new(1, 0, 0, 30)
                toggleFrame.BackgroundColor3 = Colors.Background
                toggleFrame.BorderSizePixel = 0
                toggleFrame.LayoutOrder = #section:GetChildren()
                toggleFrame.Parent = section
                
                createCorner(6).Parent = toggleFrame
                createStroke(1, Colors.Border).Parent = toggleFrame
                createPadding(8).Parent = toggleFrame
                
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Text = text
                toggleLabel.Font = Enum.Font.Gotham
                toggleLabel.TextSize = 14
                toggleLabel.TextColor3 = Colors.Text
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Size = UDim2.new(1, -50, 1, 0)
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.Parent = toggleFrame
                
                local toggleButton = Instance.new("TextButton")
                toggleButton.Size = UDim2.new(0, 40, 0, 20)
                toggleButton.Position = UDim2.new(1, -45, 0.5, -10)
                toggleButton.BackgroundColor3 = default and Colors.Accent or Color3.fromRGB(60, 60, 70)
                toggleButton.BorderSizePixel = 0
                toggleButton.Text = ""
                toggleButton.Parent = toggleFrame
                
                createCorner(10).Parent = toggleButton
                
                local toggleState = default or false
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggleState = not toggleState
                    local newColor = toggleState and Colors.Accent or Color3.fromRGB(60, 60, 70)
                    TweenService:Create(toggleButton, AnimationInfo, {BackgroundColor3 = newColor}):Play()
                    
                    if callback then
                        callback(toggleState)
                    end
                end)
                
                -- Update section size
                section.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 24)
                tabContent.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
                Window.Content.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
                
                return {Frame = toggleFrame, State = toggleState}
            end
            
            return Section
        end
        
        self.Tabs[name] = Tab
        
        -- Auto-select first tab
        if not self.CurrentTab then
            tabButton.MouseButton1Click:Fire()
        end
        
        -- Update sidebar size
        self.Sidebar.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y)
        
        return Tab
    end
    
    return Window
end

return KaliHub
