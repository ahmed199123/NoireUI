--[[
    Noire UI - Toggle Component
]]--

local TweenService = game:GetService("TweenService")

local function CreateToggle(tab, utils, theme, flags, options)
    local state = options.Default or false
    local callback = options.Callback or function() end
    local flag = options.Flag

    local container = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, options.Description and 52 or 38),
        BackgroundColor3 = theme.Element.Background,
        BorderSizePixel = 0,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})
    utils.create("UIStroke", {
        Color = theme.Element.Border, Thickness = 1, Transparency = 0.5, Parent = container,
    })

    utils.create("TextLabel", {
        Text = options.Title or "Toggle",
        Size = UDim2.new(1, -70, 0, 20),
        Position = UDim2.new(0, 12, 0, options.Description and 8 or 9),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Primary,
        TextSize = 14, Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })

    if options.Description then
        utils.create("TextLabel", {
            Text = options.Description,
            Size = UDim2.new(1, -70, 0, 16),
            Position = UDim2.new(0, 12, 0, 28),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text.Secondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container,
        })
    end

    -- Toggle track
    local track = utils.create("Frame", {
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -56, 0.5, -11),
        BackgroundColor3 = state and theme.Toggle.OnBg or theme.Toggle.OffBg,
        BorderSizePixel = 0,
        Parent = container,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})

    -- Toggle thumb
    local thumb = utils.create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = theme.Toggle.Thumb,
        BorderSizePixel = 0,
        Parent = track,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = thumb})

    -- Glow effect on thumb when ON
    local glow = utils.create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = theme.Toggle.OnBg,
        BackgroundTransparency = state and 0.6 or 1,
        BorderSizePixel = 0,
        Parent = thumb,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = glow})

    local function updateVisual(val, animate)
        if animate ~= false then
            utils.tween(track, 0.25, {BackgroundColor3 = val and theme.Toggle.OnBg or theme.Toggle.OffBg})
            utils.spring(thumb, 0.3, {
                Position = val and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            })
            utils.tween(glow, 0.3, {BackgroundTransparency = val and 0.6 or 1})
        else
            track.BackgroundColor3 = val and theme.Toggle.OnBg or theme.Toggle.OffBg
            thumb.Position = val and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            glow.BackgroundTransparency = val and 0.6 or 1
        end
    end

    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            updateVisual(state)
            if flag then flags[flag] = state end
            task.spawn(callback, state)
        end
    end)
    utils.addHover(container, theme.Element.Background, theme.Element.Hover)

    if flag then flags[flag] = state end

    local obj = {}
    function obj:Set(val)
        state = val
        updateVisual(state)
        if flag then flags[flag] = state end
        task.spawn(callback, state)
    end
    function obj:Get() return state end
    function obj:Destroy() container:Destroy() end
    return obj
end

return CreateToggle
