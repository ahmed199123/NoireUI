--[[
    Noire UI - Input Component
]]--

local function CreateInput(tab, utils, theme, flags, options)
    local callback = options.Callback or function() end
    local flag = options.Flag
    local value = options.Default or ""

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

    utils.create("TextLabel", {
        Text = options.Title or "Input",
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.new(0, 12, 0, 8),
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
            Position = UDim2.new(0, 12, 0, 26),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text.Secondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container,
        })
    end

    local inputY = options.Description and 44 or 30
    local inputBox = utils.create("Frame", {
        Size = UDim2.new(1, -24, 0, 26),
        Position = UDim2.new(0, 12, 0, inputY),
        BackgroundColor3 = theme.Window.Background,
        BorderSizePixel = 0,
        Parent = container,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = inputBox})
    local inputStroke = utils.create("UIStroke", {
        Color = theme.Element.Border, Thickness = 1, Transparency = 0.3, Parent = inputBox,
    })

    local textBox = utils.create("TextBox", {
        Text = value,
        PlaceholderText = options.Placeholder or "Type here...",
        PlaceholderColor3 = theme.Text.Tertiary,
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Primary,
        TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = inputBox,
    })

    -- Focus glow effect
    textBox.Focused:Connect(function()
        utils.tween(inputStroke, 0.2, {Color = theme.Accent.Primary, Transparency = 0})
    end)
    textBox.FocusLost:Connect(function(enterPressed)
        utils.tween(inputStroke, 0.2, {Color = theme.Element.Border, Transparency = 0.3})
        value = textBox.Text
        if options.MaxLength and #value > options.MaxLength then
            value = value:sub(1, options.MaxLength)
            textBox.Text = value
        end
        if flag then flags[flag] = value end
        task.spawn(callback, value)
    end)

    if flag then flags[flag] = value end

    local obj = {}
    function obj:Set(val)
        value = val
        textBox.Text = val
        if flag then flags[flag] = val end
        task.spawn(callback, val)
    end
    function obj:Get() return value end
    function obj:Destroy() container:Destroy() end
    return obj
end

return CreateInput
