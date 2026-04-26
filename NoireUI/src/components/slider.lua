--[[
    Noire UI - Slider Component
]]--

local UserInputService = game:GetService("UserInputService")

local function CreateSlider(tab, utils, theme, flags, options)
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local increment = options.Increment or 1
    local suffix = options.Suffix or ""
    local callback = options.Callback or function() end
    local flag = options.Flag
    local value = utils.clamp(default, min, max)

    local container = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, options.Description and 68 or 54),
        BackgroundColor3 = theme.Element.Background,
        BorderSizePixel = 0,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})
    utils.create("UIStroke", {
        Color = theme.Element.Border, Thickness = 1, Transparency = 0.5, Parent = container,
    })

    local titleY = options.Description and 8 or 8
    utils.create("TextLabel", {
        Text = options.Title or "Slider",
        Size = UDim2.new(1, -80, 0, 18),
        Position = UDim2.new(0, 12, 0, titleY),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Primary,
        TextSize = 14, Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })

    local valueLabel = utils.create("TextLabel", {
        Text = tostring(value) .. suffix,
        Size = UDim2.new(0, 60, 0, 18),
        Position = UDim2.new(1, -72, 0, titleY),
        BackgroundTransparency = 1,
        TextColor3 = theme.Accent.Primary,
        TextSize = 13, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = container,
    })

    if options.Description then
        utils.create("TextLabel", {
            Text = options.Description,
            Size = UDim2.new(1, -24, 0, 14),
            Position = UDim2.new(0, 12, 0, 26),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text.Secondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container,
        })
    end

    local trackY = options.Description and 46 or 34
    -- Track background
    local track = utils.create("Frame", {
        Size = UDim2.new(1, -24, 0, 6),
        Position = UDim2.new(0, 12, 0, trackY),
        BackgroundColor3 = theme.Slider.Track,
        BorderSizePixel = 0,
        Parent = container,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})

    -- Fill bar
    local fillPct = (value - min) / (max - min)
    local fill = utils.create("Frame", {
        Size = UDim2.new(fillPct, 0, 1, 0),
        BackgroundColor3 = theme.Slider.Fill,
        BorderSizePixel = 0,
        Parent = track,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})
    utils.createGradient(fill, theme.Accent.Primary, theme.Accent.Secondary, 0)

    -- Thumb
    local thumbFrame = utils.create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(fillPct, -7, 0.5, -7),
        BackgroundColor3 = theme.Slider.Thumb,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = track,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = thumbFrame})
    -- Thumb shadow ring
    utils.create("UIStroke", {
        Color = theme.Accent.Primary, Thickness = 2, Transparency = 0.4, Parent = thumbFrame,
    })

    local dragging = false

    local function updateSlider(pct)
        pct = utils.clamp(pct, 0, 1)
        local raw = min + (max - min) * pct
        value = utils.round(raw, increment)
        value = utils.clamp(value, min, max)

        local actualPct = (value - min) / (max - min)
        fill.Size = UDim2.new(actualPct, 0, 1, 0)
        thumbFrame.Position = UDim2.new(actualPct, -7, 0.5, -7)
        valueLabel.Text = tostring(value) .. suffix
        if flag then flags[flag] = value end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pct = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
            updateSlider(pct)
            -- Scale up thumb
            utils.spring(thumbFrame, 0.2, {Size = UDim2.new(0, 18, 0, 18)})
        end
    end)

    thumbFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            utils.spring(thumbFrame, 0.2, {Size = UDim2.new(0, 18, 0, 18)})
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pct = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
            updateSlider(pct)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            utils.spring(thumbFrame, 0.2, {Size = UDim2.new(0, 14, 0, 14)})
            task.spawn(callback, value)
        end
    end)

    utils.addHover(container, theme.Element.Background, theme.Element.Hover)

    if flag then flags[flag] = value end

    local obj = {}
    function obj:Set(val)
        value = utils.clamp(val, min, max)
        value = utils.round(value, increment)
        local pct = (value - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        thumbFrame.Position = UDim2.new(pct, -7, 0.5, -7)
        valueLabel.Text = tostring(value) .. suffix
        if flag then flags[flag] = value end
        task.spawn(callback, value)
    end
    function obj:Get() return value end
    function obj:Destroy() container:Destroy() end
    return obj
end

return CreateSlider
