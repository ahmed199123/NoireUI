--[[
    Noire UI - Keybind Component (Cyber-Luxury Edition)
]]--

local UserInputService = game:GetService("UserInputService")

local function CreateKeybind(tab, utils, theme, flags, options)
    local keyObj = {}
    local title = options.Title or "Keybind"
    local desc = options.Description or ""
    local default = options.Default or Enum.KeyCode.Unknown
    local flag = options.Flag or ""
    local callback = options.Callback or function() end
    
    local currentKey = default
    local isListening = false
    if flag ~= "" then flags[flag] = currentKey end

    local height = desc == "" and 42 or 56

    local keyFrame = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = theme.Colors.L2,
        BorderSizePixel = 0,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = keyFrame})
    utils.createSpecularHighlight(keyFrame, theme.Settings.SpecularOpacity)

    local titleLbl = utils.create("TextLabel", {
        Text = title,
        Size = UDim2.new(1, -120, 0, desc == "" and height or 24),
        Position = UDim2.new(0, 12, 0, desc == "" and 0 or 6),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.TextPrimary,
        TextSize = 13, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = keyFrame,
    })

    if desc ~= "" then
        utils.create("TextLabel", {
            Text = desc,
            Size = UDim2.new(1, -120, 0, 16),
            Position = UDim2.new(0, 12, 0, 26),
            BackgroundTransparency = 1,
            TextColor3 = theme.Colors.TextSecondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = keyFrame,
        })
    end

    local keyBtnFrame = utils.create("Frame", {
        Size = UDim2.new(0, 90, 0, 26),
        Position = UDim2.new(1, -102, 0.5, -13),
        BackgroundColor3 = theme.Colors.L3,
        BorderSizePixel = 0,
        Parent = keyFrame,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = keyBtnFrame})
    local btnStroke = utils.create("UIStroke", {
        Color = theme.Colors.BorderDefault,
        Thickness = 1, Parent = keyBtnFrame
    })

    local keyLbl = utils.create("TextLabel", {
        Text = currentKey == Enum.KeyCode.Unknown and "NONE" or currentKey.Name:upper(),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.AccentPrimary,
        TextSize = 12, Font = Enum.Font.Code,
        Parent = keyBtnFrame,
    })

    local interactBtn = utils.create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Text = "",
        Parent = keyBtnFrame,
    })

    interactBtn.MouseEnter:Connect(function()
        if not isListening then
            utils.tween(keyBtnFrame, 0.2, {BackgroundColor3 = theme.Colors.L4})
            utils.tween(btnStroke, 0.2, {Color = theme.Colors.BorderLight})
        end
    end)

    interactBtn.MouseLeave:Connect(function()
        if not isListening then
            utils.tween(keyBtnFrame, 0.2, {BackgroundColor3 = theme.Colors.L3})
            utils.tween(btnStroke, 0.2, {Color = theme.Colors.BorderDefault})
        end
    end)

    interactBtn.MouseButton1Click:Connect(function()
        isListening = true
        utils.tween(keyBtnFrame, 0.2, {BackgroundColor3 = theme.Colors.AccentDark})
        utils.tween(keyLbl, 0.2, {TextColor3 = Color3.new(1,1,1)})
        keyLbl.Text = "PRESS KEY"
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if isListening and input.UserInputType == Enum.UserInputType.Keyboard then
            isListening = false
            currentKey = input.KeyCode
            keyLbl.Text = currentKey.Name:upper()
            
            utils.tween(keyBtnFrame, 0.2, {BackgroundColor3 = theme.Colors.L3})
            utils.tween(keyLbl, 0.2, {TextColor3 = theme.Colors.AccentPrimary})
            
            if flag ~= "" then flags[flag] = currentKey end
        elseif not isListening and not processed and input.KeyCode == currentKey then
            task.spawn(callback)
            
            -- Pulse effect on press
            local clone = keyBtnFrame:Clone()
            clone.Parent = keyBtnFrame.Parent
            clone.ZIndex = 0
            utils.tween(clone, 0.4, {Size = UDim2.new(0, 110, 0, 36), Position = UDim2.new(1, -112, 0.5, -18), BackgroundTransparency = 1})
            task.delay(0.4, function() clone:Destroy() end)
        end
    end)

    return keyObj
end

return CreateKeybind
