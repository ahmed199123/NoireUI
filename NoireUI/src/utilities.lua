--[[
    Noire UI - Utilities Module
    Core helper functions used throughout the library
]]--

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Utilities = {}

-- Instance creation helper (sets Parent last for performance)
function Utilities.create(className, properties)
    local inst = Instance.new(className)
    local parent = nil
    for k, v in next, properties do
        if k == "Parent" then
            parent = v
        else
            inst[k] = v
        end
    end
    if parent then
        inst.Parent = parent
    end
    return inst
end

-- Shorthand
local create = Utilities.create

-- Tween helper with defaults
function Utilities.tween(instance, duration, properties, style, direction)
    local info = TweenInfo.new(
        duration or 0.25,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(instance, info, properties)
    t:Play()
    return t
end

-- Spring-like tween for premium feel
function Utilities.spring(instance, duration, properties)
    return Utilities.tween(instance, duration or 0.35, properties, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

-- Make a frame draggable via a handle
function Utilities.makeDraggable(frame, handle)
    local dragging = false
    local dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Ripple click effect
function Utilities.createRipple(parent, inputPos)
    local absPos = parent.AbsolutePosition
    local absSize = parent.AbsoluteSize

    local ripple = create("Frame", {
        Parent = parent,
        Position = UDim2.new(0, (inputPos and inputPos.X or absSize.X / 2) - absPos.X, 0, (inputPos and inputPos.Y or absSize.Y / 2) - absPos.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        ZIndex = parent.ZIndex + 1,
        ClipsDescendants = false,
    })
    create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ripple})

    local maxDim = math.max(absSize.X, absSize.Y) * 2.5
    local t = Utilities.tween(ripple, 0.45, {
        Size = UDim2.new(0, maxDim, 0, maxDim),
        BackgroundTransparency = 1
    }, Enum.EasingStyle.Quad)
    t.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Get safe GUI parent for executor environment
function Utilities.getGuiParent()
    local ok, result = pcall(function() return gethui() end)
    if ok and result then return result end
    ok, result = pcall(function() return game:GetService("CoreGui") end)
    if ok then return result end
    return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- Protect GUI from game detection (executor-specific)
function Utilities.protectGui(gui)
    local ok, _ = pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        end
    end)
end

-- JSON encode/decode wrappers
function Utilities.jsonEncode(data)
    return HttpService:JSONEncode(data)
end

function Utilities.jsonDecode(str)
    return HttpService:JSONDecode(str)
end

-- Deep copy a table
function Utilities.deepCopy(t)
    if type(t) ~= "table" then return t end
    local copy = {}
    for k, v in next, t do
        copy[Utilities.deepCopy(k)] = Utilities.deepCopy(v)
    end
    return setmetatable(copy, getmetatable(t))
end

-- Hex to Color3
function Utilities.hexToColor(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
    )
end

-- Color3 to Hex
function Utilities.colorToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255)
    )
end

-- Lerp between two colors
function Utilities.lerpColor(a, b, t)
    return Color3.new(
        a.R + (b.R - a.R) * t,
        a.G + (b.G - a.G) * t,
        a.B + (b.B - a.B) * t
    )
end

-- Truncate text to fit width
function Utilities.truncateText(text, maxLen)
    if #text <= maxLen then return text end
    return text:sub(1, maxLen - 3) .. "..."
end

-- Generate unique ID
function Utilities.uid()
    return HttpService:GenerateGUID(false):sub(1, 8)
end

-- Clamp value
function Utilities.clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

-- Round to increment
function Utilities.round(val, increment)
    if increment == 0 then return val end
    return math.floor(val / increment + 0.5) * increment
end

-- Create accent gradient
function Utilities.createGradient(parent, c1, c2, rotation)
    return create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(1, c2),
        }),
        Rotation = rotation or 0,
        Parent = parent,
    })
end

-- Add hover effect to a frame
function Utilities.addHover(frame, normalColor, hoverColor, clickColor)
    frame.MouseEnter:Connect(function()
        Utilities.tween(frame, 0.2, {BackgroundColor3 = hoverColor})
    end)
    frame.MouseLeave:Connect(function()
        Utilities.tween(frame, 0.2, {BackgroundColor3 = normalColor})
    end)
    if clickColor then
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Utilities.tween(frame, 0.1, {BackgroundColor3 = clickColor})
            end
        end)
        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Utilities.tween(frame, 0.15, {BackgroundColor3 = hoverColor})
            end
        end)
    end
end

return Utilities
