--[[
    Noire UI - Input Component (Cyber-Luxury Edition)
]]--

local function CreateInput(tab, utils, theme, flags, options)
    local inputObj = {}
    local title = options.Title or "Textbox"
    local desc = options.Description or ""
    local placeholder = options.Placeholder or "Enter text..."
    local numeric = options.Numeric or false
    local finished = options.Finished or false
    local clearOnFocus = options.ClearOnFocus or false
    local flag = options.Flag or ""
    local callback = options.Callback or function() end
    
    local height = desc == "" and 42 or 56

    local inputContainer = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = theme.Colors.L2,
        BorderSizePixel = 0,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = inputContainer})
    utils.createSpecularHighlight(inputContainer, theme.Settings.SpecularOpacity)

    local titleLbl = utils.create("TextLabel", {
        Text = title,
        Size = UDim2.new(1, -160, 0, desc == "" and height or 24),
        Position = UDim2.new(0, 12, 0, desc == "" and 0 or 6),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.TextPrimary,
        TextSize = 13, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = inputContainer,
    })

    if desc ~= "" then
        utils.create("TextLabel", {
            Text = desc,
            Size = UDim2.new(1, -160, 0, 16),
            Position = UDim2.new(0, 12, 0, 26),
            BackgroundTransparency = 1,
            TextColor3 = theme.Colors.TextSecondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = inputContainer,
        })
    end

    -- Recessed Input Field
    local fieldFrame = utils.create("Frame", {
        Size = UDim2.new(0, 140, 0, 30),
        Position = UDim2.new(1, -152, 0.5, -15),
        BackgroundColor3 = theme.Colors.L0, -- Deepest layer for input
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = inputContainer,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = fieldFrame})
    
    local fieldStroke = utils.create("UIStroke", {
        Color = theme.Colors.BorderDark,
        Thickness = 1,
        Parent = fieldFrame
    })

    -- Animated Glow Trace
    local glowTrace = utils.create("UIStroke", {
        Color = theme.Colors.AccentPrimary,
        Thickness = 2,
        Transparency = 1,
        Parent = fieldFrame
    })
    local traceGradient = utils.create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.Colors.AccentPrimary),
            ColorSequenceKeypoint.new(0.5, theme.Colors.AccentSecondary),
            ColorSequenceKeypoint.new(1, theme.Colors.AccentPrimary)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.4, 0),
            NumberSequenceKeypoint.new(0.6, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Rotation = -45,
        Parent = glowTrace
    })

    local textbox = utils.create("TextBox", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = placeholder,
        PlaceholderColor3 = theme.Colors.TextTertiary,
        TextColor3 = theme.Colors.AccentPrimary,
        TextSize = 12, Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = clearOnFocus,
        Parent = fieldFrame,
    })

    local isFocused = false

    textbox.Focused:Connect(function()
        isFocused = true
        utils.tween(fieldStroke, 0.2, {Color = theme.Colors.BorderLight})
        utils.tween(glowTrace, 0.3, {Transparency = 0})
        
        -- Continuous trace animation loop
        task.spawn(function()
            while isFocused do
                local t = utils.tween(traceGradient, 1.5, {Rotation = 315}, Enum.EasingStyle.Linear)
                t.Completed:Wait()
                traceGradient.Rotation = -45
            end
        end)
    end)

    textbox.FocusLost:Connect(function(enterPressed)
        isFocused = false
        utils.tween(fieldStroke, 0.2, {Color = theme.Colors.BorderDark})
        utils.tween(glowTrace, 0.2, {Transparency = 1})

        local t = textbox.Text
        if numeric then t = t:gsub("%D", "") end
        textbox.Text = t
        
        if finished and not enterPressed then return end
        if flag ~= "" then flags[flag] = t end
        callback(t)
    end)

    textbox:GetPropertyChangedSignal("Text"):Connect(function()
        if isFocused then
            -- Typing Micro-scale animation
            textbox.TextSize = 13
            utils.tween(textbox, 0.1, {TextSize = 12}, Enum.EasingStyle.Quint)
        end
    end)

    return inputObj
end

return CreateInput
