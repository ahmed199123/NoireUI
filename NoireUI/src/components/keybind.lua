--[[
    Noire UI - Keybind Component
]]--

local UserInputService = game:GetService("UserInputService")

local function CreateKeybind(tab, utils, theme, flags, options)
    local callback = options.Callback or function() end
    local flag = options.Flag
    local key = options.Default or Enum.KeyCode.F
    local listening = false

    local container = utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = theme.Element.Background,
        BorderSizePixel = 0,
        Parent = options._parent,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})
    utils.create("UIStroke", {
        Color = theme.Element.Border, Thickness = 1, Transparency = 0.5, Parent = container,
    })

    utils.create("TextLabel", {
        Text = options.Title or "Keybind",
        Size = UDim2.new(1, -90, 0, 18),
        Position = UDim2.new(0, 12, 0.5, -9),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text.Primary,
        TextSize = 14, Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })

    local keyBtn = utils.create("TextButton", {
        Text = key.Name,
        Size = UDim2.new(0, 60, 0, 24),
        Position = UDim2.new(1, -72, 0.5, -12),
        BackgroundColor3 = theme.Window.Background,
        TextColor3 = theme.Accent.Primary,
        TextSize = 11, Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = container,
    })
    utils.create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = keyBtn})
    local keyStroke = utils.create("UIStroke", {
        Color = theme.Element.Border, Thickness = 1, Parent = keyBtn,
    })

    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
        utils.tween(keyStroke, 0.2, {Color = theme.Accent.Primary})
        utils.tween(keyBtn, 0.15, {BackgroundColor3 = theme.Element.Active})
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                keyBtn.Text = key.Name
                listening = false
                utils.tween(keyStroke, 0.2, {Color = theme.Element.Border})
                utils.tween(keyBtn, 0.15, {BackgroundColor3 = theme.Window.Background})
                if flag then flags[flag] = key end
            end
        else
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key and not processed then
                task.spawn(callback, key)
            end
        end
    end)

    utils.addHover(container, theme.Element.Background, theme.Element.Hover)

    if flag then flags[flag] = key end

    local obj = {}
    function obj:Set(newKey)
        key = newKey
        keyBtn.Text = key.Name
        if flag then flags[flag] = key end
    end
    function obj:Get() return key end
    function obj:Destroy() container:Destroy() end
    return obj
end

return CreateKeybind
