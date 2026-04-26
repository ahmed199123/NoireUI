--[[
    Noire UI - Label Component
]]--

local function CreateLabel(tab, utils, theme, options)
    local container = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        Parent = options._parent,
    })

    local labelText = utils.create("TextLabel", {
        Text = options.Title or options.Text or "Label",
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Primary,
        TextSize = 13, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })

    local obj = {}
    function obj:Set(text)
        labelText.Text = text
    end
    function obj:Destroy()
        container:Destroy()
    end
    return obj
end

return CreateLabel
