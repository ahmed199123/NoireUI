--[[
    Noire UI - ColorPicker Component (Cyber-Luxury Edition)
]]--

local UserInputService = game:GetService("UserInputService")

local function CreateColorPicker(tab, utils, theme, flags, options)
    local cpObj = {}
    local title = options.Title or "Color Picker"
    local desc = options.Description or ""
    local default = options.Default or Color3.new(1, 1, 1)
    local flag = options.Flag or ""
    local callback = options.Callback or function() end

    local currentColor = default
    local h, s, v = Color3.toHSV(currentColor)
    if flag ~= "" then flags[flag] = currentColor end

    local height = desc == "" and 38 or 52
    local isOpen = false

    local cpFrame = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = theme.Colors.L2,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = cpFrame})
    utils.createSpecularHighlight(cpFrame, theme.Settings.SpecularOpacity)

    local titleLbl = utils.create("TextLabel", {
        Text = title,
        Size = UDim2.new(1, -60, 0, desc == "" and height or 24),
        Position = UDim2.new(0, 12, 0, desc == "" and 0 or 6),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.TextPrimary,
        TextSize = 13, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = cpFrame,
    })

    if desc ~= "" then
        utils.create("TextLabel", {
            Text = desc,
            Size = UDim2.new(1, -60, 0, 16),
            Position = UDim2.new(0, 12, 0, 26),
            BackgroundTransparency = 1,
            TextColor3 = theme.Colors.TextSecondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = cpFrame,
        })
    end

    local colorPreview = utils.create("Frame", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -52, 0, desc == "" and 9 or 16),
        BackgroundColor3 = currentColor,
        BorderSizePixel = 0,
        Parent = cpFrame,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = colorPreview})
    utils.create("UIStroke", {Color = theme.Colors.BorderDark, Thickness = 1, Parent = colorPreview})

    local interactBtn = utils.create("TextButton", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundTransparency = 1, Text = "",
        Parent = cpFrame,
    })

    local dropdownArea = utils.create("Frame", {
        Size = UDim2.new(1, -24, 0, 150),
        Position = UDim2.new(0, 12, 0, height + 8),
        BackgroundTransparency = 1,
        Parent = cpFrame,
    })

    -- Saturation/Value map
    local svMap = utils.create("ImageLabel", {
        Size = UDim2.new(1, -30, 0, 110),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromHSV(h, 1, 1),
        Image = "rbxassetid://4155801252",
        Parent = dropdownArea,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = svMap})
    utils.create("UIStroke", {Color = theme.Colors.BorderDark, Thickness = 1, Parent = svMap})

    local svCursor = utils.create("Frame", {
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(s, -4, 1 - v, -4),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0, Parent = svMap,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = svCursor})
    utils.create("UIStroke", {Color = Color3.new(0,0,0), Thickness = 1, Parent = svCursor})

    -- Hue slider
    local hueSlider = utils.create("Frame", {
        Size = UDim2.new(0, 20, 0, 110),
        Position = UDim2.new(1, -20, 0, 0),
        BackgroundColor3 = Color3.new(1,1,1),
        Parent = dropdownArea,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = hueSlider})
    utils.create("UIStroke", {Color = theme.Colors.BorderDark, Thickness = 1, Parent = hueSlider})
    utils.create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Rotation = 90, Parent = hueSlider
    })

    local hueCursor = utils.create("Frame", {
        Size = UDim2.new(1, 4, 0, 6),
        Position = UDim2.new(0, -2, h, -3),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0, Parent = hueSlider,
    })
    utils.create("UIStroke", {Color = Color3.new(0,0,0), Thickness = 1, Parent = hueCursor})

    -- Hex Input
    local hexInputContainer = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 1, -28),
        BackgroundColor3 = theme.Colors.L0,
        Parent = dropdownArea,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = hexInputContainer})
    utils.create("UIStroke", {Color = theme.Colors.BorderDark, Thickness = 1, Parent = hexInputContainer})

    local hexBox = utils.create("TextBox", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = utils.colorToHex(currentColor),
        TextColor3 = theme.Colors.AccentPrimary,
        TextSize = 12, Font = Enum.Font.Code,
        Parent = hexInputContainer,
    })

    local function updateColor()
        currentColor = Color3.fromHSV(h, s, v)
        colorPreview.BackgroundColor3 = currentColor
        svMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        hexBox.Text = utils.colorToHex(currentColor)
        
        if flag ~= "" then flags[flag] = currentColor end
        callback(currentColor)
    end

    local svDragging, hueDragging = false, false

    svMap.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            svDragging = true
            s = utils.clamp((input.Position.X - svMap.AbsolutePosition.X) / svMap.AbsoluteSize.X, 0, 1)
            v = 1 - utils.clamp((input.Position.Y - svMap.AbsolutePosition.Y) / svMap.AbsoluteSize.Y, 0, 1)
            svCursor.Position = UDim2.new(s, -4, 1 - v, -4)
            updateColor()
        end
    end)

    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            hueDragging = true
            h = utils.clamp((input.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
            hueCursor.Position = UDim2.new(0, -2, h, -3)
            updateColor()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            svDragging = false; hueDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if svDragging then
                s = utils.clamp((input.Position.X - svMap.AbsolutePosition.X) / svMap.AbsoluteSize.X, 0, 1)
                v = 1 - utils.clamp((input.Position.Y - svMap.AbsolutePosition.Y) / svMap.AbsoluteSize.Y, 0, 1)
                svCursor.Position = UDim2.new(s, -4, 1 - v, -4)
                updateColor()
            elseif hueDragging then
                h = utils.clamp((input.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                hueCursor.Position = UDim2.new(0, -2, h, -3)
                updateColor()
            end
        end
    end)

    hexBox.FocusLost:Connect(function()
        local success, c = pcall(function() return utils.hexToColor(hexBox.Text) end)
        if success and c then
            h, s, v = Color3.toHSV(c)
            svCursor.Position = UDim2.new(s, -4, 1 - v, -4)
            hueCursor.Position = UDim2.new(0, -2, h, -3)
            updateColor()
        else
            hexBox.Text = utils.colorToHex(currentColor)
        end
    end)

    interactBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            utils.tween(cpFrame, 0.3, {Size = UDim2.new(1, 0, 0, height + 160)}, Enum.EasingStyle.Quint)
        else
            utils.tween(cpFrame, 0.3, {Size = UDim2.new(1, 0, 0, height)}, Enum.EasingStyle.Quint)
        end
    end)

    function cpObj:Set(color)
        h, s, v = Color3.toHSV(color)
        svCursor.Position = UDim2.new(s, -4, 1 - v, -4)
        hueCursor.Position = UDim2.new(0, -2, h, -3)
        updateColor()
    end

    return cpObj
end

return CreateColorPicker
