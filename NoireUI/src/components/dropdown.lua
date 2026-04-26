--[[
    Noire UI - Dropdown Component (Cyber-Luxury Edition)
]]--

local function CreateDropdown(tab, utils, theme, flags, options)
    local ddObj = {}
    local title = options.Title or "Dropdown"
    local desc = options.Description or ""
    local items = options.Values or {}
    local multi = options.Multi or false
    local default = options.Default or (multi and {} or nil)
    local flag = options.Flag or ""
    local callback = options.Callback or function() end
    
    local selected = default
    if flag ~= "" then flags[flag] = selected end

    local isOpen = false
    local baseHeight = desc == "" and 38 or 52

    local ddFrame = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, baseHeight),
        BackgroundColor3 = theme.Colors.L2,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ddFrame})
    utils.createSpecularHighlight(ddFrame, theme.Settings.SpecularOpacity)
    
    local border, glow = utils.createDoubleBorder(ddFrame, theme.Colors.BorderDark, theme.Colors.BorderLight)
    border.Transparency = theme.Settings.BorderDarkOpacity
    glow.UIStroke.Transparency = 1 - theme.Settings.BorderLightOpacity

    local mainBtn = utils.create("TextButton", {
        Size = UDim2.new(1, 0, 0, baseHeight),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 10,
        Parent = ddFrame,
    })

    local titleLbl = utils.create("TextLabel", {
        Text = title,
        Size = UDim2.new(1, -50, 0, desc == "" and baseHeight or 24),
        Position = UDim2.new(0, 12, 0, desc == "" and 0 or 6),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.TextPrimary,
        TextSize = 13, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ddFrame,
    })

    if desc ~= "" then
        utils.create("TextLabel", {
            Text = desc,
            Size = UDim2.new(1, -50, 0, 16),
            Position = UDim2.new(0, 12, 0, 26),
            BackgroundTransparency = 1,
            TextColor3 = theme.Colors.TextSecondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = ddFrame,
        })
    end

    local function getSelectedText()
        if multi then
            local count = 0
            for _ in pairs(selected) do count = count + 1 end
            if count == 0 then return "None" end
            if count == 1 then
                for k, v in pairs(selected) do if v then return k end end
            end
            return count .. " Selected"
        else
            return selected and tostring(selected) or "None"
        end
    end

    local valueLbl = utils.create("TextLabel", {
        Text = getSelectedText(),
        Size = UDim2.new(0, 100, 0, 20),
        Position = UDim2.new(1, -136, 0, desc == "" and 9 or 16),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.AccentPrimary,
        TextSize = 11, Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = ddFrame,
    })

    local chevron = utils.create("ImageLabel", {
        Image = "rbxassetid://6031090990",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -28, 0, desc == "" and 11 or 18),
        BackgroundTransparency = 1,
        ImageColor3 = theme.Colors.TextSecondary,
        Parent = ddFrame,
    })

    local container = utils.create("ScrollingFrame", {
        Size = UDim2.new(1, -16, 0, 0),
        Position = UDim2.new(0, 8, 0, baseHeight + 4),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Colors.AccentPrimary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = ddFrame,
    })
    local layout = utils.create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = container,
    })
    utils.create("UIPadding", {PaddingTop = UDim.new(0,2), PaddingBottom = UDim.new(0,6), Parent = container})

    local optionFrames = {}

    local function buildOptions()
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        optionFrames = {}

        for i, opt in ipairs(items) do
            local isSelected = multi and selected[opt] or (not multi and selected == opt)

            local optFrame = utils.create("TextButton", {
                Size = UDim2.new(1, -12, 0, 30),
                BackgroundColor3 = theme.Colors.L3,
                BackgroundTransparency = 1, -- Start invisible for stagger
                BorderSizePixel = 0,
                Text = "",
                Parent = container,
            })
            utils.create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = optFrame})

            local sweepBar = utils.create("Frame", {
                Size = isSelected and UDim2.new(0, 3, 1, -12) or UDim2.new(0, 0, 1, -12),
                Position = UDim2.new(0, 6, 0.5, -9),
                BackgroundColor3 = theme.Colors.AccentPrimary,
                BorderSizePixel = 0,
                Parent = optFrame
            })
            utils.create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = sweepBar})

            local optLbl = utils.create("TextLabel", {
                Text = tostring(opt),
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.new(0, 16, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = isSelected and theme.Colors.AccentPrimary or theme.Colors.TextSecondary,
                TextTransparency = 1,
                TextSize = 12, Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = optFrame,
            })

            optFrame.MouseEnter:Connect(function()
                utils.tween(optFrame, 0.2, {BackgroundColor3 = theme.Colors.L4})
                utils.tween(sweepBar, 0.2, {Size = UDim2.new(0, 3, 1, -12)})
            end)

            optFrame.MouseLeave:Connect(function()
                utils.tween(optFrame, 0.2, {BackgroundColor3 = theme.Colors.L3})
                if not (multi and selected[opt]) and not (not multi and selected == opt) then
                    utils.tween(sweepBar, 0.2, {Size = UDim2.new(0, 0, 1, -12)})
                end
            end)

            optFrame.MouseButton1Click:Connect(function()
                if multi then
                    selected[opt] = not selected[opt]
                    utils.tween(optLbl, 0.2, {TextColor3 = selected[opt] and theme.Colors.AccentPrimary or theme.Colors.TextSecondary})
                else
                    selected = opt
                    for _, fr in pairs(optionFrames) do
                        utils.tween(fr.lbl, 0.2, {TextColor3 = theme.Colors.TextSecondary})
                        utils.tween(fr.bar, 0.2, {Size = UDim2.new(0, 0, 1, -12)})
                    end
                    utils.tween(optLbl, 0.2, {TextColor3 = theme.Colors.AccentPrimary})
                    utils.tween(sweepBar, 0.2, {Size = UDim2.new(0, 3, 1, -12)})
                    
                    -- Close dropdown
                    isOpen = false
                    utils.tween(chevron, 0.3, {Rotation = 0})
                    utils.tween(ddFrame, 0.3, {Size = UDim2.new(1, 0, 0, baseHeight)}, Enum.EasingStyle.Quint)
                end
                
                valueLbl.Text = getSelectedText()
                if flag ~= "" then flags[flag] = selected end
                callback(selected)
            end)

            table.insert(optionFrames, {frame = optFrame, lbl = optLbl, bar = sweepBar, val = opt})
        end
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end

    mainBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            buildOptions()
            local contentHeight = math.min(layout.AbsoluteContentSize.Y + 12, 160)
            utils.tween(chevron, 0.3, {Rotation = 180})
            utils.tween(container, 0.3, {Size = UDim2.new(1, -16, 0, contentHeight)})
            utils.tween(ddFrame, 0.4, {Size = UDim2.new(1, 0, 0, baseHeight + contentHeight + 8)}, Enum.EasingStyle.Quint)
            
            -- Staggered appear animation
            for i, optData in ipairs(optionFrames) do
                task.delay((i-1) * 0.03, function()
                    utils.tween(optData.frame, 0.2, {BackgroundTransparency = 0})
                    utils.tween(optData.lbl, 0.2, {TextTransparency = 0})
                end)
            end
        else
            utils.tween(chevron, 0.3, {Rotation = 0})
            utils.tween(container, 0.2, {Size = UDim2.new(1, -16, 0, 0)})
            utils.tween(ddFrame, 0.3, {Size = UDim2.new(1, 0, 0, baseHeight)}, Enum.EasingStyle.Quint)
        end
    end)

    function ddObj:Refresh(newItems, newDefault)
        items = newItems
        selected = newDefault or (multi and {} or nil)
        valueLbl.Text = getSelectedText()
        if isOpen then buildOptions() end
    end

    return ddObj
end

return CreateDropdown
