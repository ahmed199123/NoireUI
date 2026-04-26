--[[
    Noire UI - Button Component (Cyber-Luxury Edition)
]]--

local function CreateButton(tab, utils, theme, options)
    local btnObj = {}
    local title = options.Title or "Button"
    local desc = options.Description or ""
    local callback = options.Callback or function() end
    local variant = options.Variant or "Secondary" -- Primary, Secondary, Ghost
    
    local height = desc == "" and 38 or 52

    local btnFrame = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = theme.Colors.L2,
        BackgroundTransparency = variant == "Ghost" and 1 or 0,
        BorderSizePixel = 0,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btnFrame})
    
    -- Layer 3 specular
    if variant ~= "Ghost" then
        utils.createSpecularHighlight(btnFrame, theme.Settings.SpecularOpacity)
    end

    local border, glow
    if variant == "Secondary" then
        border, glow = utils.createDoubleBorder(btnFrame, theme.Colors.BorderDark, theme.Colors.BorderLight)
        border.Transparency = theme.Settings.BorderDarkOpacity
        glow.UIStroke.Transparency = 1 - theme.Settings.BorderLightOpacity
    elseif variant == "Primary" then
        btnFrame.BackgroundColor3 = theme.Colors.AccentDark
        border, glow = utils.createDoubleBorder(btnFrame, theme.Colors.BorderDark, theme.Colors.AccentSecondary)
        border.Transparency = 0.5
        glow.UIStroke.Transparency = 0.8
        utils.createGradient(btnFrame, theme.Colors.AccentPrimary, theme.Colors.AccentDark, 90)
    else
        -- Ghost
        local botLine = utils.create("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 1, -1),
            BackgroundColor3 = theme.Colors.BorderDefault,
            BorderSizePixel = 0, Parent = btnFrame
        })
    end

    local interactBtn = utils.create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 10,
        Parent = btnFrame,
    })

    local titleLbl = utils.create("TextLabel", {
        Text = title,
        Size = UDim2.new(1, -24, 0, desc == "" and height or 24),
        Position = UDim2.new(0, 12, 0, desc == "" and 0 or 6),
        BackgroundTransparency = 1,
        TextColor3 = variant == "Primary" and Color3.new(1,1,1) or theme.Colors.TextPrimary,
        TextSize = 13, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btnFrame,
    })

    if desc ~= "" then
        utils.create("TextLabel", {
            Text = desc,
            Size = UDim2.new(1, -24, 0, 16),
            Position = UDim2.new(0, 12, 0, 26),
            BackgroundTransparency = 1,
            TextColor3 = variant == "Primary" and Color3.new(0.9,0.9,0.9) or theme.Colors.TextSecondary,
            TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = btnFrame,
        })
    end

    -- Animations
    interactBtn.MouseEnter:Connect(function()
        if variant == "Secondary" then
            utils.tween(btnFrame, 0.2, {BackgroundColor3 = theme.Colors.L3})
            utils.tween(glow.UIStroke, 0.2, {Transparency = 0.8, Color = theme.Colors.AccentPrimary})
        elseif variant == "Primary" then
            utils.tween(glow.UIStroke, 0.2, {Transparency = 0.2})
        elseif variant == "Ghost" then
            utils.tween(btnFrame, 0.2, {BackgroundTransparency = 0.9})
            utils.tween(titleLbl, 0.2, {TextColor3 = theme.Colors.AccentPrimary})
        end
    end)

    interactBtn.MouseLeave:Connect(function()
        if variant == "Secondary" then
            utils.tween(btnFrame, 0.2, {BackgroundColor3 = theme.Colors.L2})
            utils.tween(glow.UIStroke, 0.2, {Transparency = 1 - theme.Settings.BorderLightOpacity, Color = theme.Colors.BorderLight})
        elseif variant == "Primary" then
            utils.tween(glow.UIStroke, 0.2, {Transparency = 0.8})
        elseif variant == "Ghost" then
            utils.tween(btnFrame, 0.2, {BackgroundTransparency = 1})
            utils.tween(titleLbl, 0.2, {TextColor3 = theme.Colors.TextPrimary})
        end
    end)

    interactBtn.MouseButton1Down:Connect(function()
        utils.tween(btnFrame, 0.1, {Size = UDim2.new(1, -6, 0, height - 2), Position = UDim2.new(0, 3, 0, 1)}, Enum.EasingStyle.Quad)
    end)

    interactBtn.MouseButton1Up:Connect(function()
        utils.tween(btnFrame, 0.3, {Size = UDim2.new(1, 0, 0, height), Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back)
    end)

    interactBtn.MouseButton1Click:Connect(function()
        task.spawn(callback)
    end)

    function btnObj:SetText(newTitle)
        titleLbl.Text = newTitle
    end

    return btnObj
end

return CreateButton
