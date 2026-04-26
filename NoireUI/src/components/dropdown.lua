--[[
    Noire UI - Dropdown Component
]]--

local function CreateDropdown(tab, utils, theme, flags, options)
    local opts = options.Options or {}
    local multi = options.MultiSelect or false
    local callback = options.Callback or function() end
    local flag = options.Flag
    local selected = multi and {} or (options.Default or nil)
    local open = false

    if multi and options.Default then
        if type(options.Default) == "table" then
            for _, v in next, options.Default do selected[v] = true end
        end
    end

    local container = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, options.Description and 52 or 38),
        BackgroundColor3 = theme.Element.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})
    utils.create("UIStroke", {
        Color = theme.Element.Border, Thickness = 1, Transparency = 0.5, Parent = container,
    })

    local headerH = options.Description and 52 or 38

    utils.create("TextLabel", {
        Text = options.Title or "Dropdown",
        Size = UDim2.new(0.5, -12, 0, 18),
        Position = UDim2.new(0, 12, 0, options.Description and 8 or 10),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Primary,
        TextSize = 14, Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })

    if options.Description then
        utils.create("TextLabel", {
            Text = options.Description,
            Size = UDim2.new(1, -24, 0, 14),
            Position = UDim2.new(0, 12, 0, 28),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text.Secondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container,
        })
    end

    local function getDisplayText()
        if multi then
            local names = {}
            for name, v in next, selected do
                if v then table.insert(names, name) end
            end
            return #names > 0 and table.concat(names, ", ") or "None"
        else
            return selected or "Select..."
        end
    end

    local display = utils.create("TextLabel", {
        Text = getDisplayText(),
        Size = UDim2.new(0.5, -30, 0, 18),
        Position = UDim2.new(0.5, 0, 0, options.Description and 8 or 10),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Secondary,
        TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = container,
    })

    local arrow = utils.create("TextLabel", {
        Text = "▼",
        Size = UDim2.new(0, 20, 0, 18),
        Position = UDim2.new(1, -26, 0, options.Description and 8 or 10),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Tertiary,
        TextSize = 10, Font = Enum.Font.GothamBold,
        Parent = container,
    })

    -- Options list container
    local listFrame = utils.create("Frame", {
        Size = UDim2.new(1, -16, 0, 0),
        Position = UDim2.new(0, 8, 0, headerH + 4),
        BackgroundColor3 = theme.Window.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = container,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = listFrame})

    local listLayout = utils.create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = listFrame,
    })

    local optionButtons = {}

    local function refreshOptions()
        for _, btn in next, optionButtons do btn:Destroy() end
        optionButtons = {}

        for i, opt in ipairs(opts) do
            local isSelected = multi and selected[opt] or (selected == opt)

            local optBtn = utils.create("TextButton", {
                Text = "",
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = isSelected and theme.Element.Active or theme.Element.Background,
                BorderSizePixel = 0,
                LayoutOrder = i,
                Parent = listFrame,
            })
            utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = optBtn})

            local check = utils.create("TextLabel", {
                Text = isSelected and "✓" or "",
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(0, 6, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = theme.Accent.Primary,
                TextSize = 12, Font = Enum.Font.GothamBold,
                Parent = optBtn,
            })

            utils.create("TextLabel", {
                Text = opt,
                Size = UDim2.new(1, -34, 1, 0),
                Position = UDim2.new(0, 28, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = isSelected and theme.Text.Primary or theme.Text.Secondary,
                TextSize = 12, Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = optBtn,
            })

            optBtn.MouseEnter:Connect(function()
                utils.tween(optBtn, 0.15, {BackgroundColor3 = theme.Element.Hover})
            end)
            optBtn.MouseLeave:Connect(function()
                local sel = multi and selected[opt] or (selected == opt)
                utils.tween(optBtn, 0.15, {BackgroundColor3 = sel and theme.Element.Active or theme.Element.Background})
            end)

            optBtn.MouseButton1Click:Connect(function()
                if multi then
                    selected[opt] = not selected[opt]
                else
                    selected = opt
                end
                display.Text = getDisplayText()
                if flag then flags[flag] = multi and selected or selected end
                refreshOptions()
                if not multi then
                    -- Close after single select
                    open = false
                    local totalH = headerH
                    utils.tween(container, 0.25, {Size = UDim2.new(1, 0, 0, totalH)})
                    utils.tween(arrow, 0.25, {Rotation = 0})
                end
                task.spawn(callback, multi and selected or selected)
            end)

            table.insert(optionButtons, optBtn)
        end

        local listH = #opts * 32 - 2
        listFrame.Size = UDim2.new(1, -16, 0, math.min(listH, 150))
    end

    -- Toggle dropdown
    local clickRegion = utils.create("TextButton", {
        Text = "",
        Size = UDim2.new(1, 0, 0, headerH),
        BackgroundTransparency = 1,
        Parent = container,
    })

    clickRegion.MouseButton1Click:Connect(function()
        open = not open
        if open then
            refreshOptions()
            local listH = math.min(#opts * 32, 150)
            local totalH = headerH + listH + 12
            utils.tween(container, 0.3, {Size = UDim2.new(1, 0, 0, totalH)})
            utils.tween(arrow, 0.3, {Rotation = 180})
        else
            utils.tween(container, 0.25, {Size = UDim2.new(1, 0, 0, headerH)})
            utils.tween(arrow, 0.25, {Rotation = 0})
        end
    end)

    if flag then flags[flag] = multi and selected or selected end

    local obj = {}
    function obj:Set(val)
        selected = val
        display.Text = getDisplayText()
        if flag then flags[flag] = selected end
        task.spawn(callback, selected)
    end
    function obj:Refresh(newOpts, default)
        opts = newOpts
        if default then selected = default end
        display.Text = getDisplayText()
        if open then refreshOptions() end
    end
    function obj:Get() return selected end
    function obj:Destroy() container:Destroy() end
    return obj
end

return CreateDropdown
