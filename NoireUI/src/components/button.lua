--[[
    Noire UI - Button Component
]]--

local function CreateButton(tab, utils, theme, options)
    local callback = options.Callback or function() end

    local container = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, options.Description and 52 or 38),
        BackgroundColor3 = theme.Element.Background,
        BorderSizePixel = 0,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})
    utils.create("UIStroke", {
        Color = theme.Element.Border,
        Thickness = 1,
        Transparency = 0.5,
        Parent = container,
    })

    local title = utils.create("TextLabel", {
        Text = options.Title or "Button",
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 12, 0, options.Description and 8 or 9),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Primary,
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })

    if options.Description then
        utils.create("TextLabel", {
            Text = options.Description,
            Size = UDim2.new(1, -24, 0, 16),
            Position = UDim2.new(0, 12, 0, 28),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text.Secondary,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container,
        })
    end

    -- Arrow indicator
    utils.create("TextLabel", {
        Text = "→",
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Tertiary,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = container,
    })

    -- Hover & click
    container.ClipsDescendants = true
    utils.addHover(container, theme.Element.Background, theme.Element.Hover, theme.Element.Active)

    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            utils.createRipple(container, input.Position)
            task.spawn(callback)
        end
    end)

    local obj = {}
    function obj:SetCallback(fn) callback = fn end
    function obj:SetTitle(t) title.Text = t end
    function obj:Destroy() container:Destroy() end
    return obj
end

return CreateButton
