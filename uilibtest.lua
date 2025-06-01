-- Kali Hub UI Library
-- Clean, modern UI library for Roblox with rounded edges and smooth animations

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local KaliHub = {}

-- Colors and styling
local Colors = {
    Background = Color3.fromRGB(30, 30, 40),
    SecondaryBackground = Color3.fromRGB(35, 35, 45),
    TertiaryBackground = Color3.fromRGB(40, 40, 50),
    Border = Color3.fromRGB(70, 70, 80),
    Text = Color3.fromRGB(240, 240, 245),
    SubText = Color3.fromRGB(180, 180, 190),
    KaliPink = Color3.fromRGB(255, 182, 193),
    HubWhite = Color3.fromRGB(255, 255, 255),
    AccentHover = Color3.fromRGB(255, 192, 203),
    Success = Color3.fromRGB(120, 220, 120),
    Warning = Color3.fromRGB(255, 220, 120)
}

-- Animation settings
local AnimationInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

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
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return stroke
end

local function createTextStroke(thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 2
    stroke.Color = color or Color3.fromRGB(0, 0, 0)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
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
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 650, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    mainFrame.BackgroundColor3 = Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    mainFrame.ZIndex = 1
    
    createCorner(12).Parent = mainFrame
    createStroke(2, Colors.Border).Parent = mainFrame
    
    -- Drop shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.ZIndex = 0
    shadow.Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 55)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Colors.SecondaryBackground
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    titleBar.ZIndex = 2
    
    createCorner(12).Parent = titleBar
    createStroke(1, Colors.Border).Parent = titleBar
    
    -- Fix corner clipping for title bar
    local titleCornerFix = Instance.new("Frame")
    titleCornerFix.Size = UDim2.new(1, 0, 0, 12)
    titleCornerFix.Position = UDim2.new(0, 0, 1, -12)
    titleCornerFix.BackgroundColor3 = Colors.SecondaryBackground
    titleCornerFix.BorderSizePixel = 0
    titleCornerFix.Parent = titleBar
    titleCornerFix.ZIndex = 1
    
    -- Title frame for better text positioning
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Size = UDim2.new(0, 200, 1, 0)
    titleFrame.Position = UDim2.new(0, 20, 0, 0)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = titleBar
    titleFrame.ZIndex = 3
    
    -- "Kali" text (pink)
    local kaliText = Instance.new("TextLabel")
    kaliText.Name = "KaliText"
    kaliText.Text = "Kali"
    kaliText.Font = Enum.Font.GothamBold
    kaliText.TextSize = 20
    kaliText.TextColor3 = Colors.KaliPink
    kaliText.BackgroundTransparency = 1
    kaliText.Size = UDim2.new(0, 50, 1, 0)
    kaliText.Position = UDim2.new(0, 0, 0, 0)
    kaliText.TextXAlignment = Enum.TextXAlignment.Left
    kaliText.TextYAlignment = Enum.TextYAlignment.Center
    kaliText.Parent = titleFrame
    kaliText.ZIndex = 4
    
    createTextStroke(2, Color3.fromRGB(15, 15, 25)).Parent = kaliText
    
    -- "Hub" text (white)
    local hubText = Instance.new("TextLabel")
    hubText.Name = "HubText"
    hubText.Text = " Hub"
    hubText.Font = Enum.Font.GothamBold
    hubText.TextSize = 20
    hubText.TextColor3 = Colors.HubWhite
    hubText.BackgroundTransparency = 1
    hubText.Size = UDim2.new(0, 60, 1, 0)
    hubText.Position = UDim2.new(0, 45, 0, 0)
    hubText.TextXAlignment = Enum.TextXAlignment.Left
    hubText.TextYAlignment = Enum.TextYAlignment.Center
    hubText.Parent = titleFrame
    hubText.ZIndex = 4
    
    createTextStroke(2, Color3.fromRGB(15, 15, 25)).Parent = hubText
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 22
    closeButton.TextColor3 = Colors.Text
    closeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    closeButton.Size = UDim2.new(0, 35, 0, 35)
    closeButton.Position = UDim2.new(1, -45, 0.5, -17.5)
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    closeButton.ZIndex = 4
    
    createCorner(8).Parent = closeButton
    createStroke(1, Colors.Border).Parent = closeButton
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -55)
    contentFrame.Position = UDim2.new(0, 0, 0, 55)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    contentFrame.ZIndex = 2
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 220, 1, -15)
    sidebar.Position = UDim2.new(0, 15, 0, 15)
    sidebar.BackgroundColor3 = Colors.SecondaryBackground
    sidebar.BorderSizePixel = 0
    sidebar.Parent = contentFrame
    sidebar.ZIndex = 3
    
    createCorner(10).Parent = sidebar
    createStroke(1, Colors.Border).Parent = sidebar
    
    -- Main content area
    local mainContent = Instance.new("Frame")
    mainContent.Name = "MainContent"
    mainContent.Size = UDim2.new(1, -250, 1, -15)
    mainContent.Position = UDim2.new(0, 250, 0, 15)
    mainContent.BackgroundColor3 = Colors.TertiaryBackground
    mainContent.BorderSizePixel = 0
    mainContent.Parent = contentFrame
    mainContent.ZIndex = 3
    
    createCorner(10).Parent = mainContent
    createStroke(1, Colors.Border).Parent = mainContent
    
    -- Content header
    local contentHeader = Instance.new("Frame")
    contentHeader.Name = "ContentHeader"
    contentHeader.Size = UDim2.new(1, 0, 0, 50)
    contentHeader.BackgroundColor3 = Colors.SecondaryBackground
    contentHeader.BorderSizePixel = 0
    contentHeader.Parent = mainContent
    contentHeader.ZIndex = 4
    
    createCorner(10).Parent = contentHeader
    
    -- Fix corner clipping for content header
    local headerCornerFix = Instance.new("Frame")
    headerCornerFix.Size = UDim2.new(1, 0, 0, 10)
    headerCornerFix.Position = UDim2.new(0, 0, 1, -10)
    headerCornerFix.BackgroundColor3 = Colors.SecondaryBackground
    headerCornerFix.BorderSizePixel = 0
    headerCornerFix.Parent = contentHeader
    headerCornerFix.ZIndex = 3
    
    -- Search bar in content header
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(1, -30, 0, 30)
    searchFrame.Position = UDim2.new(0, 15, 0.5, -15)
    searchFrame.BackgroundColor3 = Colors.Background
    searchFrame.BorderSizePixel = 0
    searchFrame.Parent = contentHeader
    searchFrame.ZIndex = 5
    
    createCorner(6).Parent = searchFrame
    createStroke(1, Colors.Border).Parent = searchFrame
    
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -15, 1, 0)
    searchBox.Position = UDim2.new(0, 10, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.TextColor3 = Colors.SubText
    searchBox.PlaceholderText = "Search elements..."
    searchBox.Text = ""
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchFrame
    searchBox.ZIndex = 6
    
    -- Sidebar scrolling frame
    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Name = "SidebarScroll"
    sidebarScroll.Size = UDim2.new(1, -10, 1, -20)
    sidebarScroll.Position = UDim2.new(0, 5, 0, 10)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 6
    sidebarScroll.ScrollBarImageColor3 = Colors.KaliPink
    sidebarScroll.ScrollBarImageTransparency = 0.3
    sidebarScroll.Parent = sidebar
    sidebarScroll.ZIndex = 4
    
    createPadding(8).Parent = sidebarScroll
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.Parent = sidebarScroll
    
    -- Main content scrolling frame
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = "ContentScroll"
    contentScroll.Size = UDim2.new(1, -10, 1, -65)
    contentScroll.Position = UDim2.new(0, 5, 0, 60)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 6
    contentScroll.ScrollBarImageColor3 = Colors.KaliPink
    contentScroll.ScrollBarImageTransparency = 0.3
    contentScroll.Parent = mainContent
    contentScroll.ZIndex = 4
    
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
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        wait(0.3)
        screenGui:Destroy()
    end)
    
    -- Button hover effects
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, AnimationInfo, {
            BackgroundColor3 = Color3.fromRGB(220, 100, 100),
            Size = UDim2.new(0, 38, 0, 38)
        }):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, AnimationInfo, {
            BackgroundColor3 = Color3.fromRGB(45, 45, 55),
            Size = UDim2.new(0, 35, 0, 35)
        }):Play()
    end)
    
    -- Tab creation function
    function Window:CreateTab(name, config)
        config = config or {}
        
        -- Tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Text = name
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 15
        tabButton.TextColor3 = Colors.SubText
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.BorderSizePixel = 0
        tabButton.Parent = self.Sidebar
        tabButton.ZIndex = 5
        
        createCorner(8).Parent = tabButton
        createStroke(1, Color3.fromRGB(55, 55, 65)).Parent = tabButton
        
        -- Tab icon (optional)
        local tabIcon = Instance.new("Frame")
        tabIcon.Size = UDim2.new(0, 4, 0, 20)
        tabIcon.Position = UDim2.new(0, 8, 0.5, -10)
        tabIcon.BackgroundColor3 = Colors.SubText
        tabIcon.BorderSizePixel = 0
        tabIcon.Parent = tabButton
        tabIcon.ZIndex = 6
        
        createCorner(2).Parent = tabIcon
        
        -- Tab content
        local tabContent = Instance.new("Frame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = self.Content
        tabContent.ZIndex = 5
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 10)
        tabLayout.Parent = tabContent
        
        local Tab = {
            Button = tabButton,
            Content = tabContent,
            Layout = tabLayout,
            Icon = tabIcon,
            Elements = {}
        }
        
        -- Tab switching
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                TweenService:Create(tab.Button, AnimationInfo, {
                    TextColor3 = Colors.SubText,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                }):Play()
                TweenService:Create(tab.Icon, AnimationInfo, {
                    BackgroundColor3 = Colors.SubText
                }):Play()
            end
            
            -- Show current tab
            tabContent.Visible = true
            TweenService:Create(tabButton, AnimationInfo, {
                TextColor3 = Colors.KaliPink,
                BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            }):Play()
            TweenService:Create(tabIcon, AnimationInfo, {
                BackgroundColor3 = Colors.KaliPink
            }):Play()
            
            self.CurrentTab = Tab
            
            -- Update content size
            tabContent.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
            self.Content.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 50)
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= Tab then
                TweenService:Create(tabButton, AnimationInfo, {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 55),
                    TextColor3 = Colors.Text
                }):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= Tab then
                TweenService:Create(tabButton, AnimationInfo, {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                    TextColor3 = Colors.SubText
                }):Play()
            end
        end)
        
        self.Tabs[name] = Tab
        
        -- Auto-select first tab
        if not self.CurrentTab then
            wait(0.1)
            tabButton.MouseButton1Click:Fire()
        end
        
        -- Update sidebar size
        self.Sidebar.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 20)
        
        return Tab
    end
    
    return Window
end

return KaliHub
