--[[
    Noire UI - Paragraph Component
]]--

local function CreateParagraph(tab, utils, theme, options)
    local titleText = options.Title or ""
    local contentText = options.Content or ""

    local container = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), -- Auto size calculated below
        BackgroundColor3 = theme.Element.Background,
        BorderSizePixel = 0,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})
    utils.create("UIStroke", {
        Color = theme.Element.Border, Thickness = 1, Transparency = 0.5, Parent = container,
    })

    local titleLbl = utils.create("TextLabel", {
        Text = titleText,
        Size = UDim2.new(1, -24, 0, titleText ~= "" and 20 or 0),
        Position = UDim2.new(0, 12, 0, 10),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Primary,
        TextSize = 14, Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })

    local contentLbl = utils.create("TextLabel", {
        Text = contentText,
        Size = UDim2.new(1, -24, 0, 20), -- Updated below
        Position = UDim2.new(0, 12, 0, titleText ~= "" and 32 or 10),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Secondary,
        TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = container,
    })

    local function updateSize()
        local textBounds = game:GetService("TextService"):GetTextSize(
            contentLbl.Text, contentLbl.TextSize, contentLbl.Font, Vector2.new(contentLbl.AbsoluteSize.X, math.huge)
        )
        contentLbl.Size = UDim2.new(1, -24, 0, textBounds.Y)
        container.Size = UDim2.new(1, 0, 0, (titleText ~= "" and 32 or 10) + textBounds.Y + 10)
    end

    -- Defer update to allow AbsoluteSize to be accurate if just parented
    task.defer(updateSize)
    contentLbl:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)

    local obj = {}
    function obj:Set(newTitle, newContent)
        if newTitle then
            titleLbl.Text = newTitle
            titleText = newTitle
        end
        if newContent then
            contentLbl.Text = newContent
            contentText = newContent
        end
        updateSize()
    end
    function obj:Destroy() container:Destroy() end
    return obj
end

return CreateParagraph
