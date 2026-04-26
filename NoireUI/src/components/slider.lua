--[[
    Noire UI - Slider Component (Cyber-Luxury Edition)
]]--

local UserInputService = game:GetService("UserInputService")

local function CreateSlider(tab, utils, theme, flags, options)
    local sliderObj = {}
    local title = options.Title or "Slider"
    local desc = options.Description or ""
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local inc = options.Increment or 1
    local suffix = options.Suffix or ""
    local flag = options.Flag or ""
    local callback = options.Callback or function() end
    
    local value = default
    if flag ~= "" then flags[flag] = value end

    local height = desc == "" and 56 or 70

    local sliderFrame = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = theme.Colors.L2,
        BorderSizePixel = 0,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = sliderFrame})
    utils.createSpecularHighlight(sliderFrame, theme.Settings.SpecularOpacity)
    
    local border, glow = utils.createDoubleBorder(sliderFrame, theme.Colors.BorderDark, theme.Colors.BorderLight)
    border.Transparency = theme.Settings.BorderDarkOpacity
    glow.UIStroke.Transparency = 1 - theme.Settings.BorderLightOpacity

    local titleLbl = utils.create("TextLabel", {
        Text = title,
        Size = UDim2.new(1, -70, 0, desc == "" and 30 or 24),
        Position = UDim2.new(0, 12, 0, desc == "" and 0 or 6),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.TextPrimary,
        TextSize = 13, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sliderFrame,
    })

    if desc ~= "" then
        utils.create("TextLabel", {
            Text = desc,
            Size = UDim2.new(1, -70, 0, 16),
            Position = UDim2.new(0, 12, 0, 24),
            BackgroundTransparency = 1,
            TextColor3 = theme.Colors.TextSecondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = sliderFrame,
        })
    end

    local valueLbl = utils.create("TextLabel", {
        Text = tostring(value) .. suffix,
        Size = UDim2.new(0, 60, 0, 20),
        Position = UDim2.new(1, -72, 0, desc == "" and 5 or 12),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.AccentPrimary,
        TextSize = 12, Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = sliderFrame,
    })

    -- Recessed Groove
    local trackBg = utils.create("Frame", {
        Size = UDim2.new(1, -24, 0, 6),
        Position = UDim2.new(0, 12, 1, -16),
        BackgroundColor3 = theme.Colors.L0,
        BorderSizePixel = 0,
        Parent = sliderFrame,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = trackBg})
    utils.create("UIStroke", {Color = theme.Colors.BorderDark, Thickness = 1, Parent = trackBg})

    -- Military Ticks
    for i = 1, 9 do
        utils.create("Frame", {
            Size = UDim2.new(0, 1, 0, 4),
            Position = UDim2.new(i/10, 0, 0, -4),
            BackgroundColor3 = theme.Colors.BorderDefault,
            BorderSizePixel = 0, Parent = trackBg
        })
    end

    local trackFill = utils.create("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
        Parent = trackBg,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = trackFill})
    utils.createGradient(trackFill, theme.Colors.AccentDark, theme.Colors.AccentPrimary, 0)
    
    -- White Specular End on Fill
    local fillSpecular = utils.create("Frame", {
        Size = UDim2.new(0, 2, 1, 0),
        Position = UDim2.new(1, -2, 0, 0),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0, Parent = trackFill
    })

    local thumb = utils.create("Frame", {
        Size = UDim2.new(0, 10, 0, 14),
        Position = UDim2.new(1, -5, 0.5, -7),
        BackgroundColor3 = theme.Colors.TextPrimary,
        BorderSizePixel = 0,
        Parent = trackFill,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = thumb})
    utils.createGradient(thumb, Color3.new(1,1,1), Color3.new(0.6,0.6,0.6), 90)

    local dragging = false

    local function updateSlider(input)
        local pos = utils.clamp((input.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
        local rawValue = min + (pos * (max - min))
        value = utils.round(rawValue, inc)
        local pct = (value - min) / (max - min)

        utils.tween(trackFill, 0.1, {Size = UDim2.new(pct, 0, 1, 0)}, Enum.EasingStyle.Quad)
        valueLbl.Text = tostring(value) .. suffix
        
        if flag ~= "" then flags[flag] = value end
        callback(value)
    end

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
            utils.tween(thumb, 0.2, {Size = UDim2.new(0, 14, 0, 18), Position = UDim2.new(1, -7, 0.5, -9)})
            utils.tween(sliderFrame, 0.2, {BackgroundColor3 = theme.Colors.L3})
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                utils.tween(thumb, 0.2, {Size = UDim2.new(0, 10, 0, 14), Position = UDim2.new(1, -5, 0.5, -7)})
                utils.tween(sliderFrame, 0.2, {BackgroundColor3 = theme.Colors.L2})
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    function sliderObj:Set(newValue)
        value = utils.clamp(utils.round(newValue, inc), min, max)
        local pct = (value - min) / (max - min)
        utils.tween(trackFill, 0.2, {Size = UDim2.new(pct, 0, 1, 0)})
        valueLbl.Text = tostring(value) .. suffix
        if flag ~= "" then flags[flag] = value end
        callback(value)
    end

    return sliderObj
end

return CreateSlider
