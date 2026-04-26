--[[
    Noire UI - Window System
]]--

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local SetupTabSystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/tab.lua"))()

local function CreateWindow(utils, theme, flags, options, notificationSystem)
    local title = options.Title or "Noire UI"
    local subtitle = options.Subtitle or ""
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightControl
    local size = options.Size or UDim2.new(0, 580, 0, 460)
    local disableBlur = options.DisableBlur or false
    
    local guiParent = utils.getGuiParent()
    
    local screenGui = utils.create("ScreenGui", {
        Name = "NoireUI_" .. utils.uid(),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = guiParent,
    })
    utils.protectGui(screenGui)

    -- Background Blur
    local blurEffect
    if not disableBlur then
        local lighting = game:GetService("Lighting")
        blurEffect = utils.create("BlurEffect", {
            Size = 0,
            Parent = lighting,
        })
        utils.tween(blurEffect, 0.5, {Size = 15})
    end

    -- Main Window Container
    local mainFrame = utils.create("Frame", {
        Name = "Main",
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
        BackgroundColor3 = theme.Window.Background,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Parent = screenGui,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = mainFrame})
    utils.create("UIStroke", {Color = theme.Window.Border, Thickness = 1, Parent = mainFrame})

    -- Drop Shadow
    local shadow = utils.create("ImageLabel", {
        Name = "Shadow",
        Image = "rbxassetid://6015897843",
        SliceCenter = Rect.new(49, 49, 450, 450),
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        ImageColor3 = theme.Window.Shadow,
        ImageTransparency = 0.4,
        ZIndex = -1,
        Parent = mainFrame,
    })

    -- Top Bar (Draggable)
    local topBar = utils.create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Window.TopBar,
        BorderSizePixel = 0,
        Parent = mainFrame,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = topBar})
    
    -- Fix corner rounding at the bottom of topbar
    local topBarPatch = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = theme.Window.TopBar,
        BorderSizePixel = 0,
        Parent = topBar,
    })

    -- Accent Line
    local accentLine = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = theme.Accent.Primary,
        BorderSizePixel = 0,
        Parent = topBar,
    })
    utils.createGradient(accentLine, theme.Accent.Primary, theme.Accent.Secondary, 0)

    -- Make window draggable
    utils.makeDraggable(mainFrame, topBar)

    -- Title Text
    local titleLbl = utils.create("TextLabel", {
        Text = title,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Primary,
        TextSize = 15, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar,
    })
    
    if subtitle ~= "" then
        local subLbl = utils.create("TextLabel", {
            Text = subtitle,
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(0, 16 + titleLbl.TextBounds.X + 6, 0, 1),
            BackgroundTransparency = 1,
            TextColor3 = theme.Accent.Primary,
            TextSize = 11, Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = topBar,
        })
    end

    -- Close Button
    local closeBtn = utils.create("TextButton", {
        Text = "✕",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Secondary,
        TextSize = 14, Font = Enum.Font.Gotham,
        Parent = topBar,
    })
    closeBtn.MouseEnter:Connect(function() utils.tween(closeBtn, 0.2, {TextColor3 = theme.Status.Error}) end)
    closeBtn.MouseLeave:Connect(function() utils.tween(closeBtn, 0.2, {TextColor3 = theme.Text.Secondary}) end)

    -- Sidebar
    local sidebar = utils.create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 160, 1, -42),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundColor3 = theme.Window.Sidebar,
        BorderSizePixel = 0,
        Parent = mainFrame,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = sidebar})
    utils.create("Frame", { -- Patch right corner
        Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0),
        BackgroundColor3 = theme.Window.Sidebar, BorderSizePixel = 0, Parent = sidebar
    })
    utils.create("Frame", { -- Patch top corner
        Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = theme.Window.Sidebar, BorderSizePixel = 0, Parent = sidebar
    })

    local tabListContainer = utils.create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -16),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Misc.Scrollbar,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = sidebar,
    })
    
    local tabLayout = utils.create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = tabListContainer,
    })
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabListContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Content Area
    local contentArea = utils.create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -160, 1, -42),
        Position = UDim2.new(0, 160, 0, 42),
        BackgroundColor3 = theme.Window.Content,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = mainFrame,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = contentArea})
    utils.create("Frame", { -- Patch top left corner
        Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = theme.Window.Content, BorderSizePixel = 0, Parent = contentArea
    })

    -- Divider between sidebar and content
    utils.create("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = theme.Window.Border,
        BorderSizePixel = 0,
        Parent = contentArea,
    })

    -- Initialization animation
    mainFrame.Size = UDim2.new(0, size.X.Offset * 0.9, 0, size.Y.Offset * 0.9)
    mainFrame.GroupTransparency = 1
    utils.spring(mainFrame, 0.5, {Size = size})
    utils.tween(mainFrame, 0.4, {GroupTransparency = 0})

    -- Logic state
    local windowObj = {}
    local tabs = {}
    local activeTabBtn = nil
    local activeTabContent = nil
    local isVisible = true

    -- Toggle Window visibility
    local function toggleWindow()
        isVisible = not isVisible
        if isVisible then
            screenGui.Enabled = true
            utils.spring(mainFrame, 0.4, {Size = size})
            utils.tween(mainFrame, 0.3, {GroupTransparency = 0})
            if blurEffect then utils.tween(blurEffect, 0.3, {Size = 15}) end
        else
            local t = utils.tween(mainFrame, 0.3, {
                Size = UDim2.new(0, size.X.Offset * 0.9, 0, size.Y.Offset * 0.9),
                GroupTransparency = 1
            })
            if blurEffect then utils.tween(blurEffect, 0.3, {Size = 0}) end
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

    -- Close Button logic
    closeBtn.MouseButton1Click:Connect(function()
        if blurEffect then utils.tween(blurEffect, 0.4, {Size = 0}) end
        local t = utils.tween(mainFrame, 0.4, {
            Size = UDim2.new(0, size.X.Offset * 0.8, 0, size.Y.Offset * 0.8),
            GroupTransparency = 1
        })
        t.Completed:Connect(function()
            screenGui:Destroy()
            if blurEffect then blurEffect:Destroy() end
        end)
    end)

    local TabSys = SetupTabSystem(windowObj, contentArea, utils, theme, flags)

    -- Create Tab Method
    function windowObj:CreateTab(tabOptions)
        local tabData = TabSys:CreateTab(tabOptions)
        table.insert(tabs, tabData)

        local tabBtn = utils.create("TextButton", {
            Text = "",
            Size = UDim2.new(1, -16, 0, 34),
            BackgroundColor3 = theme.Window.Sidebar,
            BorderSizePixel = 0,
            Parent = tabListContainer,
        })
        utils.create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = tabBtn})

        local tabIndicator = utils.create("Frame", {
            Size = UDim2.new(0, 3, 0, 0), -- Starts hidden
            Position = UDim2.new(0, 4, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = theme.Misc.TabIndicator,
            BorderSizePixel = 0,
            Parent = tabBtn,
        })
        utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = tabIndicator})

        local tabIcon = utils.create("ImageLabel", {
            Image = tabOptions.Icon or "",
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 14, 0.5, -9),
            BackgroundTransparency = 1,
            ImageColor3 = theme.Text.Secondary,
            Visible = (tabOptions.Icon ~= nil and tabOptions.Icon ~= ""),
            Parent = tabBtn,
        })

        local textPos = (tabOptions.Icon and tabOptions.Icon ~= "") and 40 or 14
        local tabText = utils.create("TextLabel", {
            Text = tabOptions.Title or "Tab",
            Size = UDim2.new(1, -textPos - 10, 1, 0),
            Position = UDim2.new(0, textPos, 0, 0),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text.Secondary,
            TextSize = 13, Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn,
        })

        -- Switch tab logic
        local function selectTab()
            if activeTabBtn == tabBtn then return end
            
            -- Reset old tab
            if activeTabBtn then
                utils.tween(activeTabBtn.Indicator, 0.2, {Size = UDim2.new(0, 3, 0, 0)})
                utils.tween(activeTabBtn.TextLabel, 0.2, {TextColor3 = theme.Text.Secondary})
                utils.tween(activeTabBtn.Icon, 0.2, {ImageColor3 = theme.Text.Secondary})
                utils.tween(activeTabBtn.Button, 0.2, {BackgroundColor3 = theme.Window.Sidebar})
                if activeTabContent then
                    -- Fade out old content
                    local oldContent = activeTabContent
                    local t = utils.tween(oldContent, 0.15, {Position = UDim2.new(0, 10, 0, 0)})
                    t.Completed:Connect(function() oldContent.Visible = false end)
                end
            end

            activeTabBtn = {Button = tabBtn, Indicator = tabIndicator, TextLabel = tabText, Icon = tabIcon}
            activeTabContent = tabData.Container

            -- Animate new tab
            utils.spring(tabIndicator, 0.3, {Size = UDim2.new(0, 3, 0, 18)})
            utils.tween(tabText, 0.2, {TextColor3 = theme.Text.Primary})
            utils.tween(tabIcon, 0.2, {ImageColor3 = theme.Text.Primary})
            utils.tween(tabBtn, 0.2, {BackgroundColor3 = theme.Element.Hover})

            -- Show new content
            tabData.Container.Visible = true
            tabData.Container.Position = UDim2.new(0, -10, 0, 0)
            utils.tween(tabData.Container, 0.25, {Position = UDim2.new(0, 0, 0, 0)})
        end

        tabBtn.MouseButton1Click:Connect(selectTab)
        tabBtn.MouseEnter:Connect(function()
            if activeTabBtn and activeTabBtn.Button == tabBtn then return end
            utils.tween(tabBtn, 0.2, {BackgroundColor3 = theme.Element.Background})
            utils.tween(tabText, 0.2, {TextColor3 = theme.Text.Primary})
            utils.tween(tabIcon, 0.2, {ImageColor3 = theme.Text.Primary})
        end)
        tabBtn.MouseLeave:Connect(function()
            if activeTabBtn and activeTabBtn.Button == tabBtn then return end
            utils.tween(tabBtn, 0.2, {BackgroundColor3 = theme.Window.Sidebar})
            utils.tween(tabText, 0.2, {TextColor3 = theme.Text.Secondary})
            utils.tween(tabIcon, 0.2, {ImageColor3 = theme.Text.Secondary})
        end)

        -- Select first tab automatically
        if #tabs == 1 then
            selectTab()
        end

        return tabData
    end

    function windowObj:Destroy()
        if blurEffect then blurEffect:Destroy() end
        screenGui:Destroy()
    end

    return windowObj, screenGui
end

return CreateWindow
