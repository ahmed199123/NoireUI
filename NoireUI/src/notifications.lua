--[[
    Noire UI - Notification System (Cyber-Luxury Edition)
]]--

local CoreGui = game:GetService("CoreGui")

local function SetupNotifications(utils, theme)
    local sys = {}
    
    local guiParent = utils.getGuiParent()
    local notifGui = utils.create("ScreenGui", {
        Name = "NoireNotifs_" .. utils.uid(),
        Parent = guiParent,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    utils.protectGui(notifGui)

    -- Container positioned at the bottom right
    local container = utils.create("Frame", {
        Size = UDim2.new(0, 320, 1, -20),
        Position = UDim2.new(1, -340, 0, 0),
        BackgroundTransparency = 1,
        Parent = notifGui,
    })

    local layout = utils.create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Parent = container,
    })

    function sys:Notify(options)
        local title = options.Title or "Notification"
        local content = options.Content or ""
        local duration = options.Duration or 5
        local nType = options.Type or "Default" -- Default, Success, Error, Warning

        local borderColor = theme.Colors.BorderDefault
        if nType == "Success" then borderColor = theme.Colors.Success
        elseif nType == "Error" then borderColor = theme.Colors.Error
        elseif nType == "Warning" then borderColor = theme.Colors.Warning
        elseif nType == "Info" then borderColor = theme.Colors.AccentPrimary end

        -- Calculate height
        local titleHeight = 24
        local contentHeight = content == "" and 0 or 20 -- Will wrap dynamically
        local totalHeight = titleHeight + contentHeight + 16

        local notifFrame = utils.create("Frame", {
            Size = UDim2.new(0, 300, 0, totalHeight),
            BackgroundTransparency = 1,
            Parent = container,
        })

        -- Wrapper for Slide Animation
        local slideFrame = utils.create("CanvasGroup", {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(1, 320, 0, 0), -- Start offscreen right
            BackgroundColor3 = theme.Colors.L1,
            BorderSizePixel = 0,
            GroupTransparency = 0.1,
            Parent = notifFrame,
        })
        utils.create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = slideFrame})
        
        -- Color Coded Left Border
        local colorStrip = utils.create("Frame", {
            Size = UDim2.new(0, 4, 1, 0),
            BackgroundColor3 = borderColor,
            BorderSizePixel = 0,
            Parent = slideFrame,
        })
        utils.create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = colorStrip})

        local border, glow = utils.createDoubleBorder(slideFrame, theme.Colors.BorderDark, theme.Colors.BorderLight, UDim.new(0, 6))
        border.Transparency = theme.Settings.BorderDarkOpacity
        glow.UIStroke.Transparency = 1 - theme.Settings.BorderLightOpacity

        -- Texts
        utils.create("TextLabel", {
            Text = title:upper(),
            Size = UDim2.new(1, -30, 0, 20),
            Position = UDim2.new(0, 16, 0, 8),
            BackgroundTransparency = 1,
            TextColor3 = theme.Colors.TextPrimary,
            TextSize = 12, Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = slideFrame,
        })

        if content ~= "" then
            local cLbl = utils.create("TextLabel", {
                Text = content,
                Size = UDim2.new(1, -30, 0, 20),
                Position = UDim2.new(0, 16, 0, 28),
                BackgroundTransparency = 1,
                TextColor3 = theme.Colors.TextSecondary,
                TextSize = 12, Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                Parent = slideFrame,
            })
            
            -- Adjust height based on wrapped text
            local bY = math.max(20, cLbl.TextBounds.Y)
            cLbl.Size = UDim2.new(1, -30, 0, bY)
            notifFrame.Size = UDim2.new(0, 300, 0, 40 + bY)
        end

        -- Progress Bar
        local pBg = utils.create("Frame", {
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2),
            BackgroundColor3 = theme.Colors.L0,
            BorderSizePixel = 0, Parent = slideFrame
        })
        local pFill = utils.create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = borderColor,
            BorderSizePixel = 0, Parent = pBg
        })

        -- Slide In (Spring Overshoot)
        utils.spring(slideFrame, 0.6, {Position = UDim2.new(0, 0, 0, 0)})

        -- Progress Animation & Dismiss
        utils.tween(pFill, duration, {Size = UDim2.new(0, 0, 1, 0)}, Enum.EasingStyle.Linear).Completed:Connect(function()
            -- Slide Out
            local outT = utils.tween(slideFrame, 0.3, {Position = UDim2.new(1, 320, 0, 0), GroupTransparency = 1})
            outT.Completed:Connect(function()
                notifFrame:Destroy()
            end)
        end)
    end

    return sys
end

return SetupNotifications
