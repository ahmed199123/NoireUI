--[[
    Noire UI - Paragraph Component (Cyber-Luxury Edition)
]]--

local function CreateParagraph(tab, utils, theme, options)
    local paraObj = {}
    local title = options.Title or "Paragraph"
    local content = options.Content or ""

    local paraFrame = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = theme.Colors.L2,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = paraFrame})
    local border, glow = utils.createDoubleBorder(paraFrame, theme.Colors.BorderDark, theme.Colors.BorderLight)
    border.Transparency = theme.Settings.BorderDarkOpacity
    glow.UIStroke.Transparency = 1 - theme.Settings.BorderLightOpacity

    -- Left decorative line
    local accent = utils.create("Frame", {
        Size = UDim2.new(0, 3, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = theme.Colors.AccentDark,
        BorderSizePixel = 0,
        Parent = paraFrame
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = accent})

    local titleLbl = utils.create("TextLabel", {
        Text = title:upper(),
        Size = UDim2.new(1, -30, 0, 20),
        Position = UDim2.new(0, 20, 0, 8),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.TextPrimary,
        TextSize = 12, Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = paraFrame,
    })

    local contentLbl = utils.create("TextLabel", {
        Text = content,
        Size = UDim2.new(1, -30, 0, 20),
        Position = UDim2.new(0, 20, 0, 28),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.TextSecondary,
        TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = paraFrame,
    })

    local function updateSize()
        local bounds = contentLbl.TextBounds.Y
        contentLbl.Size = UDim2.new(1, -30, 0, bounds)
        paraFrame.Size = UDim2.new(1, 0, 0, bounds + 40)
    end

    contentLbl:GetPropertyChangedSignal("TextBounds"):Connect(updateSize)
    updateSize()

    function paraObj:Set(newTitle, newContent)
        if newTitle then titleLbl.Text = newTitle:upper() end
        if newContent then contentLbl.Text = newContent end
    end

    return paraObj
end

return CreateParagraph
