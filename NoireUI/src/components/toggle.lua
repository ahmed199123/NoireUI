--[[
    Noire UI - Toggle Component (Cyber-Luxury Edition)
]]--

local function CreateToggle(tab, utils, theme, flags, options)
    local toggleObj = {}
    local title = options.Title or "Toggle"
    local desc = options.Description or ""
    local state = options.Default or false
    local flag = options.Flag or ""
    local callback = options.Callback or function() end
    
    if flag ~= "" then
        flags[flag] = state
    end

    local height = desc == "" and 38 or 52

    local toggleFrame = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = theme.Colors.L2,
        BorderSizePixel = 0,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = toggleFrame})
    utils.createSpecularHighlight(toggleFrame, theme.Settings.SpecularOpacity)
    
    local border, glow = utils.createDoubleBorder(toggleFrame, theme.Colors.BorderDark, theme.Colors.BorderLight)
    border.Transparency = theme.Settings.BorderDarkOpacity
    glow.UIStroke.Transparency = 1 - theme.Settings.BorderLightOpacity

    local titleLbl = utils.create("TextLabel", {
        Text = title,
        Size = UDim2.new(1, -70, 0, desc == "" and height or 24),
        Position = UDim2.new(0, 12, 0, desc == "" and 0 or 6),
        BackgroundTransparency = 1,
        TextColor3 = state and theme.Colors.AccentPrimary or theme.Colors.TextPrimary,
        TextSize = 13, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggleFrame,
    })

    if desc ~= "" then
        utils.create("TextLabel", {
            Text = desc,
            Size = UDim2.new(1, -70, 0, 16),
            Position = UDim2.new(0, 12, 0, 26),
            BackgroundTransparency = 1,
            TextColor3 = theme.Colors.TextSecondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = toggleFrame,
        })
    end

    -- Diamond Track (Rotated square inside a clipped frame)
    local trackContainer = utils.create("Frame", {
        Size = UDim2.new(0, 44, 0, 18),
        Position = UDim2.new(1, -56, 0.5, -9),
        BackgroundColor3 = theme.Colors.L1,
        BorderSizePixel = 0,
        Parent = toggleFrame,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = trackContainer})
    utils.create("UIStroke", {Color = theme.Colors.BorderDark, Thickness = 1, Parent = trackContainer})
    
    local trackFill = utils.create("Frame", {
        Size = state and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = theme.Colors.AccentPrimary,
        BorderSizePixel = 0,
        Parent = trackContainer,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = trackFill})
    local fillGrad = utils.createGradient(trackFill, theme.Colors.AccentSecondary, theme.Colors.AccentDark, 45)

    -- Metallic Thumb
    local thumb = utils.create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = theme.Colors.TextPrimary,
        BorderSizePixel = 0,
        Parent = trackContainer,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = thumb})
    utils.createGradient(thumb, Color3.new(1,1,1), Color3.new(0.7,0.7,0.7), 90)
    utils.create("UIStroke", {Color = Color3.new(0,0,0), Thickness = 1, Transparency = 0.5, Parent = thumb})

    local interactBtn = utils.create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 10,
        Parent = toggleFrame,
    })

    local function toggle(override)
        if override ~= nil then state = override else state = not state end
        if flag ~= "" then flags[flag] = state end
        
        if state then
            utils.tween(thumb, 0.3, {Position = UDim2.new(1, -16, 0.5, -7)}, Enum.EasingStyle.Back)
            utils.tween(trackFill, 0.3, {Size = UDim2.new(1, 0, 1, 0)}, Enum.EasingStyle.Quint)
            utils.tween(titleLbl, 0.2, {TextColor3 = theme.Colors.AccentPrimary})
            -- Energy flow animation
            task.spawn(function()
                local t = utils.tween(fillGrad, 0.5, {Rotation = 225})
                t.Completed:Wait()
                fillGrad.Rotation = 45
            end)
        else
            utils.tween(thumb, 0.3, {Position = UDim2.new(0, 2, 0.5, -7)}, Enum.EasingStyle.Back)
            utils.tween(trackFill, 0.3, {Size = UDim2.new(0, 0, 1, 0)}, Enum.EasingStyle.Quint)
            utils.tween(titleLbl, 0.2, {TextColor3 = theme.Colors.TextPrimary})
        end
        
        callback(state)
    end

    interactBtn.MouseButton1Click:Connect(function() toggle() end)
    
    interactBtn.MouseEnter:Connect(function()
        utils.tween(toggleFrame, 0.2, {BackgroundColor3 = theme.Colors.L3})
    end)
    interactBtn.MouseLeave:Connect(function()
        utils.tween(toggleFrame, 0.2, {BackgroundColor3 = theme.Colors.L2})
    end)

    function toggleObj:Set(newState)
        toggle(newState)
    end

    return toggleObj
end

return CreateToggle
