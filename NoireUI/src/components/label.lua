--[[
    Noire UI - Label Component (Cyber-Luxury Edition)
]]--

local function CreateLabel(tab, utils, theme, options)
    local lblObj = {}
    local text = options.Text or "Label"
    
    local lblFrame = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Parent = options._parent,
    })

    -- Decorative accent
    utils.create("Frame", {
        Size = UDim2.new(0, 2, 0, 10),
        Position = UDim2.new(0, 4, 0.5, -5),
        BackgroundColor3 = theme.Colors.BorderDefault,
        BorderSizePixel = 0,
        Parent = lblFrame
    })

    local textLbl = utils.create("TextLabel", {
        Text = text,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = theme.Colors.TextSecondary,
        TextSize = 12, Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = lblFrame,
    })

    function lblObj:SetText(newText)
        textLbl.Text = newText
    end

    return lblObj
end

return CreateLabel
