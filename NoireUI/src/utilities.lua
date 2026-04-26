--[[
    Noire UI - Utilities Engine (Cyber-Luxury Edition)
    Advanced visual effects, mathematical easings, and instance wrappers.
]]--

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Utilities = {}

-- Basic Instance creation
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
    if parent then inst.Parent = parent end
    return inst
end
local create = Utilities.create

-- Advanced Tweening (Custom easing simulation)
function Utilities.tween(instance, duration, properties, style, direction)
    -- Using Quint for ultra-smooth cubic-bezier-like curves
    local info = TweenInfo.new(
        duration or 0.25,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(instance, info, properties)
    t:Play()
    return t
end

-- Materialize Spawn Animation
function Utilities.materialize(instance, targetSize, duration)
    local originalSize = targetSize or instance.Size
    local width = originalSize.X.Offset
    local height = originalSize.Y.Offset
    
    -- Start as a 1px thin line
    instance.Size = UDim2.new(0, width, 0, 1)
    instance.GroupTransparency = 1
    
    -- Phase 1: Fade in as a line
    local t1 = Utilities.tween(instance, duration * 0.3, {GroupTransparency = 0}, Enum.EasingStyle.Cubic)
    
    -- Phase 2: Expand vertically
    t1.Completed:Connect(function()
        Utilities.tween(instance, duration * 0.7, {Size = originalSize}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end)
end

-- Staggered Tween (for lists/dropdowns)
function Utilities.staggerTween(instances, delayOffset, duration, propertyFunc)
    for i, inst in ipairs(instances) do
        task.delay((i - 1) * delayOffset, function()
            Utilities.tween(inst, duration, propertyFunc(i, inst))
        end)
    end
end

-- Cyber-Luxury Visual Elements

function Utilities.createNoise(parent, opacity)
    return create("ImageLabel", {
        Name = "NoiseTexture",
        Image = "rbxassetid://13426749419", -- Subtle grain noise
        TileSize = UDim2.new(0, 256, 0, 256),
        ScaleType = Enum.ScaleType.Tile,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ImageTransparency = 1 - (opacity or 0.03),
        ZIndex = parent.ZIndex,
        Parent = parent,
    })
end

function Utilities.createScanlines(parent, opacity)
    return create("ImageLabel", {
        Name = "Scanlines",
        Image = "rbxassetid://1527756184", -- Horizontal scanline pattern
        TileSize = UDim2.new(1, 0, 0, 4),
        ScaleType = Enum.ScaleType.Tile,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ImageTransparency = 1 - (opacity or 0.02),
        ZIndex = parent.ZIndex + 1,
        Parent = parent,
    })
end

function Utilities.createCornerBrackets(parent, color, size, thickness, offset)
    local brackets = create("Folder", {Name = "Brackets", Parent = parent})
    local offsetVal = offset or 2
    local lSize = size or 6
    local th = thickness or 1
    
    local positions = {
        {UDim2.new(0, offsetVal, 0, offsetVal), UDim2.new(0, lSize, 0, th)}, -- TL h
        {UDim2.new(0, offsetVal, 0, offsetVal), UDim2.new(0, th, 0, lSize)}, -- TL v
        {UDim2.new(1, -offsetVal - lSize, 0, offsetVal), UDim2.new(0, lSize, 0, th)}, -- TR h
        {UDim2.new(1, -offsetVal - th, 0, offsetVal), UDim2.new(0, th, 0, lSize)}, -- TR v
        {UDim2.new(0, offsetVal, 1, -offsetVal - th), UDim2.new(0, lSize, 0, th)}, -- BL h
        {UDim2.new(0, offsetVal, 1, -offsetVal - lSize), UDim2.new(0, th, 0, lSize)}, -- BL v
        {UDim2.new(1, -offsetVal - lSize, 1, -offsetVal - th), UDim2.new(0, lSize, 0, th)}, -- BR h
        {UDim2.new(1, -offsetVal - th, 1, -offsetVal - lSize), UDim2.new(0, th, 0, lSize)}  -- BR v
    }
    
    for _, dat in ipairs(positions) do
        create("Frame", {
            Position = dat[1], Size = dat[2],
            BackgroundColor3 = color, BorderSizePixel = 0,
            ZIndex = parent.ZIndex + 2, Parent = brackets
        })
    end
    return brackets
end

function Utilities.createSpecularHighlight(parent, opacity)
    return create("Frame", {
        Name = "SpecularHighlight",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1 - (opacity or 0.08),
        BorderSizePixel = 0,
        ZIndex = parent.ZIndex + 1,
        Parent = parent
    })
end

function Utilities.createDoubleBorder(parent, outerColor, innerColor, cornerRadius)
    local outerStroke = create("UIStroke", {
        Color = outerColor, Thickness = 1, Parent = parent
    })
    
    local innerGlow = create("Frame", {
        Name = "InnerGlow",
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        ZIndex = parent.ZIndex,
        Parent = parent
    })
    create("UICorner", {CornerRadius = cornerRadius or UDim.new(0, 8), Parent = innerGlow})
    create("UIStroke", {
        Color = innerColor, Thickness = 1, Parent = innerGlow
    })
    
    return outerStroke, innerGlow
end

-- Core Handlers
function Utilities.makeDraggable(frame, handle)
    local dragging, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Utilities.getGuiParent()
    local ok, result = pcall(function() return gethui() end)
    if ok and result then return result end
    ok, result = pcall(function() return game:GetService("CoreGui") end)
    if ok then return result end
    return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

function Utilities.protectGui(gui)
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
end

function Utilities.uid()
    return HttpService:GenerateGUID(false):sub(1, 8)
end

function Utilities.clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

function Utilities.round(val, inc)
    if inc == 0 then return val end
    return math.floor(val / inc + 0.5) * inc
end

function Utilities.createGradient(parent, c1, c2, rot)
    return create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(1, c2),
        }),
        Rotation = rot or 0,
        Parent = parent,
    })
end

function Utilities.hexToColor(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16))
end

function Utilities.colorToHex(color)
    return string.format("#%02X%02X%02X", math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255))
end

return Utilities
