--[[
    Noire UI - Window System (Cyber-Luxury Edition)
]]--

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local SetupTabSystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/tab.lua"))()

local function CreateWindow(utils, theme, flags, options, notificationSystem)
    local title = options.Title or "Noire UI"
    local subtitle = options.Subtitle or ""
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightControl
    local size = options.Size or UDim2.new(0, 600, 0, 480)
    
    local guiParent = utils.getGuiParent()
    local screenGui = utils.create("ScreenGui", {
        Name = "NoireUI_" .. utils.uid(),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = guiParent,
    })
    utils.protectGui(screenGui)

    -- Wrapper (handles scaling and materialize anim)
    local wrapperFrame = utils.create("Frame", {
        Name = "Wrapper",
        Size = UDim2.new(0, size.X.Offset, 0, 1), -- Starts as 1px line
        Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
        BackgroundTransparency = 1,
        Parent = screenGui,
    })

    -- Depth Layer 0: Blur + Drop Shadow
    if not options.DisableBlur then
        utils.create("BlurEffect", { Size = 15, Parent = game:GetService("Lighting"), Name = "NoireBlur" })
    end

    local shadow = utils.create("ImageLabel", {
        Name = "L0_Shadow",
        Image = "rbxassetid://6015897843",
        SliceCenter = Rect.new(49, 49, 450, 450),
        Size = UDim2.new(1, 60, 1, 60),
        Position = UDim2.new(0, -30, 0, -30),
        BackgroundTransparency = 1,
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        ZIndex = 0,
        Parent = wrapperFrame,
    })

    -- Main Container (CanvasGroup for corner clipping and group transparency)
    local mainGroup = utils.create("CanvasGroup", {
        Name = "MainGroup",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = theme.Colors.L1,
        BorderSizePixel = 0,
        GroupTransparency = 1, -- Start invisible
        Parent = wrapperFrame,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = mainGroup})
    
    -- Aesthetic details
    utils.createNoise(mainGroup, theme.Settings.NoiseOpacity)
    utils.createScanlines(mainGroup, theme.Settings.ScanlineOpacity)
    utils.createCornerBrackets(wrapperFrame, theme.Colors.AccentPrimary, 8, 1, 3)

    -- Double Border (Layer 1 Base)
    local borderStroke, innerGlow = utils.createDoubleBorder(
        mainGroup, 
        theme.Colors.BorderDark, 
        theme.Colors.BorderLight,
        UDim.new(0, 12)
    )
    borderStroke.Transparency = theme.Settings.BorderDarkOpacity
    innerGlow.UIStroke.Transparency = 1 - theme.Settings.BorderLightOpacity

    -- Specular Highlight
    utils.createSpecularHighlight(mainGroup, theme.Settings.SpecularOpacity)

    -- Top Bar (Draggable)
    local topBar = utils.create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = theme.Colors.L1,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = mainGroup,
    })
    utils.create("UIGradient", {
        Color = ColorSequence.new(theme.Colors.L2, theme.Colors.L1),
        Rotation = 90, Parent = topBar
    })
    utils.makeDraggable(wrapperFrame, topBar)

    -- Accent Line on TopBar
    local accentLine = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = theme.Colors.BorderDefault,
        BorderSizePixel = 0,
        Parent = topBar,
    })

    -- Drag Handle texture
    local dragGrip = utils.create("Frame", {
        Size = UDim2.new(0, 40, 0, 8),
        Position = UDim2.new(0.5, -20, 0, 18),
        BackgroundTransparency = 1,
        Parent = topBar
    })
    for i=0, 2 do
        utils.create("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 0, i * 3),
            BackgroundColor3 = theme.Colors.TextTertiary,
            BorderSizePixel = 0, Parent = dragGrip
        })
    end

    -- Title
    local titleLbl = utils.create("TextLabel", {
        Text = title:upper(),
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.TextPrimary,
        TextSize = 13, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar,
    })
    
    if subtitle ~= "" then
        utils.create("TextLabel", {
            Text = subtitle:upper(),
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(0, 24 + titleLbl.TextBounds.X, 0, 1),
            BackgroundTransparency = 1,
            TextColor3 = theme.Colors.AccentPrimary,
            TextSize = 10, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = topBar,
        })
    end

    -- Layer 2: Sidebar Container
    local sidebar = utils.create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 160, 1, -44),
        Position = UDim2.new(0, 0, 0, 44),
        BackgroundColor3 = theme.Colors.L2,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = mainGroup,
    })

    local tabListContainer = utils.create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -16),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Colors.AccentPrimary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = sidebar,
    })
    
    local tabLayout = utils.create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = tabListContainer,
    })

    -- Content Area
    local contentArea = utils.create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -160, 1, -44),
        Position = UDim2.new(0, 160, 0, 44),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = mainGroup,
    })

    -- Depth Shadow for sidebar divider
    local sidebarShadow = utils.create("ImageLabel", {
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://13192853245", -- Linear gradient shadow
        ImageColor3 = Color3.new(0,0,0),
        ImageTransparency = 0.5,
        Parent = contentArea
    })

    -- Materialize Spawn Animation
    utils.materialize(wrapperFrame, size, 0.7)
    utils.tween(mainGroup, 0.5, {GroupTransparency = 0})

    -- Logic state
    local windowObj = {}
    local tabs = {}
    local activeTabBtn = nil
    local activeTabContent = nil
    local isVisible = true

    -- Toggle Logic
    local function toggleWindow()
        isVisible = not isVisible
        if isVisible then
            screenGui.Enabled = true
            wrapperFrame.Size = UDim2.new(0, size.X.Offset, 0, 1)
            utils.materialize(wrapperFrame, size, 0.6)
            utils.tween(mainGroup, 0.4, {GroupTransparency = 0})
            utils.tween(shadow, 0.4, {ImageTransparency = 0.5})
            if game.Lighting:FindFirstChild("NoireBlur") then
                utils.tween(game.Lighting.NoireBlur, 0.3, {Size = 15})
            end
        else
            utils.tween(shadow, 0.2, {ImageTransparency = 1})
            utils.tween(mainGroup, 0.2, {GroupTransparency = 1})
            local t = utils.tween(wrapperFrame, 0.3, { Size = UDim2.new(0, size.X.Offset, 0, 1) })
            if game.Lighting:FindFirstChild("NoireBlur") then
                utils.tween(game.Lighting.NoireBlur, 0.3, {Size = 0})
            end
            t.Completed:Connect(function()
                if not isVisible then screenGui.Enabled = false end
            end)
        end
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == toggleKey and not processed then
            toggleWindow()
        end
    end)

    local TabSys = SetupTabSystem(windowObj, contentArea, utils, theme, flags)

    -- Create Tab Method (Skewed Aesthetic)
    function windowObj:CreateTab(tabOptions)
        local tabData = TabSys:CreateTab(tabOptions)
        table.insert(tabs, tabData)

        local tabBtn = utils.create("TextButton", {
            Text = "",
            Size = UDim2.new(1, -12, 0, 34),
            BackgroundColor3 = theme.Colors.L1,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = tabListContainer,
        })
        
        -- Skewed Background
        local tabBg = utils.create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://13210439062", -- Skewed quad image (placeholder for raw geometry)
            ImageColor3 = theme.Colors.L3,
            ImageTransparency = 1,
            Parent = tabBtn
        })
        utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = tabBg})

        local topGlow = utils.create("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = theme.Colors.AccentPrimary,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = tabBg
        })

        local tabIcon = utils.create("ImageLabel", {
            Image = tabOptions.Icon or "",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 16, 0.5, -8),
            BackgroundTransparency = 1,
            ImageColor3 = theme.Colors.TextSecondary,
            Visible = (tabOptions.Icon ~= nil and tabOptions.Icon ~= ""),
            Parent = tabBtn,
        })

        local textPos = (tabOptions.Icon and tabOptions.Icon ~= "") and 42 or 16
        local tabText = utils.create("TextLabel", {
            Text = tabOptions.Title or "TAB",
            Size = UDim2.new(1, -textPos - 10, 1, 0),
            Position = UDim2.new(0, textPos, 0, 0),
            BackgroundTransparency = 1,
            TextColor3 = theme.Colors.TextSecondary,
            TextSize = 12, Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn,
        })

        local function selectTab()
            if activeTabBtn == tabBtn then return end
            
            if activeTabBtn then
                utils.tween(activeTabBtn.Bg, 0.2, {ImageTransparency = 1})
                utils.tween(activeTabBtn.Glow, 0.2, {BackgroundTransparency = 1})
                utils.tween(activeTabBtn.TextLabel, 0.2, {TextColor3 = theme.Colors.TextSecondary})
                utils.tween(activeTabBtn.Icon, 0.2, {ImageColor3 = theme.Colors.TextSecondary})
                
                if activeTabContent then
                    local oldContent = activeTabContent
                    local t = utils.tween(oldContent, 0.15, {Position = UDim2.new(0, 0, 0, 20), GroupTransparency = 1})
                    t.Completed:Connect(function() oldContent.Visible = false end)
                end
            end

            activeTabBtn = {Button = tabBtn, Bg = tabBg, Glow = topGlow, TextLabel = tabText, Icon = tabIcon}
            activeTabContent = tabData.Container

            utils.tween(tabBg, 0.3, {ImageTransparency = 0})
            utils.tween(topGlow, 0.3, {BackgroundTransparency = 0})
            utils.tween(tabText, 0.2, {TextColor3 = theme.Colors.TextPrimary})
            utils.tween(tabIcon, 0.2, {ImageColor3 = theme.Colors.AccentPrimary})

            tabData.Container.Visible = true
            tabData.Container.Position = UDim2.new(0, 0, 0, 15)
            tabData.Container.GroupTransparency = 1
            utils.tween(tabData.Container, 0.3, {Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0}, Enum.EasingStyle.Quint)
        end

        tabBtn.MouseButton1Click:Connect(selectTab)

        if #tabs == 1 then selectTab() end
        return tabData
    end

    function windowObj:Destroy()
        if game.Lighting:FindFirstChild("NoireBlur") then game.Lighting.NoireBlur:Destroy() end
        screenGui:Destroy()
    end

    return windowObj, screenGui
end

return CreateWindow
