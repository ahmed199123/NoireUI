--[[
    Noire UI - ColorPicker Component
]]--

local UserInputService = game:GetService("UserInputService")

local function CreateColorPicker(tab, utils, theme, flags, options)
    local defaultColor = options.Default or Color3.fromRGB(255, 255, 255)
    local callback = options.Callback or function() end
    local flag = options.Flag
    local h, s, v = defaultColor:ToHSV()
    local color = defaultColor
    local open = false

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
        Text = options.Title or "Color Picker",
        Size = UDim2.new(1, -80, 0, 18),
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
            Size = UDim2.new(1, -80, 0, 14),
            Position = UDim2.new(0, 12, 0, 28),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text.Secondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container,
        })
    end

    local displayFrame = utils.create("Frame", {
        Size = UDim2.new(0, 36, 0, 20),
        Position = UDim2.new(1, -48, 0, options.Description and 16 or 9),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = container,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = displayFrame})
    utils.create("UIStroke", {
        Color = theme.Element.Border, Thickness = 1, Parent = displayFrame,
    })

    -- Picker UI
    local pickerContainer = utils.create("Frame", {
        Size = UDim2.new(1, -24, 0, 110),
        Position = UDim2.new(0, 12, 0, headerH + 6),
        BackgroundTransparency = 1,
        Parent = container,
    })

    -- Hue/Sat Box
    local colorBox = utils.create("Frame", {
        Size = UDim2.new(1, -24, 0, 80),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromHSV(h, 1, 1),
        BorderSizePixel = 0,
        Parent = pickerContainer,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = colorBox})
    utils.create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Parent = colorBox
    })
    local blackOverlay = utils.create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = colorBox
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = blackOverlay})
    utils.create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Rotation = 90,
        Parent = blackOverlay
    })

    local selector = utils.create("Frame", {
        Size = UDim2.new(0, 6, 0, 6),
        Position = UDim2.new(h, 0, 1 - v, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = colorBox,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = selector})
    utils.create("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 1, Parent = selector})

    -- Value (Brightness) Slider
    local hueSlider = utils.create("Frame", {
        Size = UDim2.new(0, 16, 0, 80),
        Position = UDim2.new(1, -16, 0, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = pickerContainer,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = hueSlider})
    utils.create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Rotation = 90,
        Parent = hueSlider
    })

    local hueSelector = utils.create("Frame", {
        Size = UDim2.new(1, 2, 0, 4),
        Position = UDim2.new(0.5, 0, h, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = hueSlider,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = hueSelector})
    utils.create("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 1, Parent = hueSelector})

    -- Hex Input Box
    local hexBox = utils.create("TextBox", {
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.new(0, 0, 0, 88),
        BackgroundColor3 = theme.Window.Background,
        Text = utils.colorToHex(color),
        TextColor3 = theme.Text.Primary,
        TextSize = 12, Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        Parent = pickerContainer,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = hexBox})

    local function updateColor()
        color = Color3.fromHSV(h, s, v)
        displayFrame.BackgroundColor3 = color
        colorBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        hexBox.Text = utils.colorToHex(color)
        if flag then flags[flag] = color end
        task.spawn(callback, color)
    end

    -- Interaction logic
    local dragColor, dragHue = false, false

    colorBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragColor = true end
    end)
    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragHue = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragColor = false
            dragHue = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragColor then
                local relX = math.clamp((input.Position.X - colorBox.AbsolutePosition.X) / colorBox.AbsoluteSize.X, 0, 1)
                local relY = math.clamp((input.Position.Y - colorBox.AbsolutePosition.Y) / colorBox.AbsoluteSize.Y, 0, 1)
                s = relX
                v = 1 - relY
                selector.Position = UDim2.new(s, 0, 1 - v, 0)
                updateColor()
            elseif dragHue then
                local relY = math.clamp((input.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                h = 1 - relY
                hueSelector.Position = UDim2.new(0.5, 0, relY, 0)
                updateColor()
            end
        end
    end)

    hexBox.FocusLost:Connect(function()
        local c = utils.hexToColor(hexBox.Text)
        if c then
            h, s, v = c:ToHSV()
            selector.Position = UDim2.new(s, 0, 1 - v, 0)
            hueSelector.Position = UDim2.new(0.5, 0, 1 - h, 0)
            updateColor()
        else
            hexBox.Text = utils.colorToHex(color)
        end
    end)

    -- Toggle dropdown
    local clickRegion = utils.create("TextButton", {
        Text = "", Size = UDim2.new(1, 0, 0, headerH), BackgroundTransparency = 1, Parent = container,
    })

    clickRegion.MouseButton1Click:Connect(function()
        open = not open
        if open then
            utils.tween(container, 0.3, {Size = UDim2.new(1, 0, 0, headerH + 120)})
        else
            utils.tween(container, 0.25, {Size = UDim2.new(1, 0, 0, headerH)})
        end
    end)

    if flag then flags[flag] = color end

    local obj = {}
    function obj:Set(newColor)
        h, s, v = newColor:ToHSV()
        selector.Position = UDim2.new(s, 0, 1 - v, 0)
        hueSelector.Position = UDim2.new(0.5, 0, 1 - h, 0)
        updateColor()
    end
    function obj:Get() return color end
    function obj:Destroy() container:Destroy() end
    return obj
end

return CreateColorPicker
