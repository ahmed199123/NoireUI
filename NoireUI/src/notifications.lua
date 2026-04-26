--[[
    Noire UI - Notification System
]]--

local TweenService = game:GetService("TweenService")

local function SetupNotifications(screenGui, utils, theme)
    local container = utils.create("Frame", {
        Name = "NotificationContainer",
        Size = UDim2.new(0, 300, 1, -40),
        Position = UDim2.new(1, -320, 0, 20),
        BackgroundTransparency = 1,
        Parent = screenGui,
        ZIndex = 100,
    })

    local listLayout = utils.create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent = container,
    })

    local notificationSystem = {}

    function notificationSystem:Notify(options)
        local title = options.Title or "Notification"
        local content = options.Content or ""
        local notifType = options.Type or "Info" -- Success, Error, Warning, Info
        local duration = options.Duration or 5
        local actions = options.Actions or nil

        local accentColor = theme.Status[notifType] or theme.Accent.Primary

        -- Auto calculate height
        local contentBounds = game:GetService("TextService"):GetTextSize(
            content, 12, Enum.Font.Gotham, Vector2.new(240, math.huge)
        )
        local baseHeight = 40 + contentBounds.Y
        local hasActions = actions and type(actions) == "table"
        if hasActions then baseHeight = baseHeight + 36 end

        local notifFrame = utils.create("Frame", {
            Size = UDim2.new(0, 280, 0, baseHeight),
            Position = UDim2.new(1, 300, 0, 0), -- Start off screen
            BackgroundColor3 = theme.Misc.Notification,
            BorderSizePixel = 0,
            Parent = container,
        })
        utils.create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = notifFrame})
        utils.create("UIStroke", {
            Color = theme.Element.Border, Thickness = 1, Parent = notifFrame,
        })

        -- Drop shadow
        local shadow = utils.create("ImageLabel", {
            Image = "rbxassetid://6015897843",
            SliceCenter = Rect.new(49, 49, 450, 450),
            Size = UDim2.new(1, 30, 1, 30),
            Position = UDim2.new(0, -15, 0, -15),
            BackgroundTransparency = 1,
            ImageColor3 = Color3.new(0, 0, 0),
            ImageTransparency = 0.5,
            ZIndex = notifFrame.ZIndex - 1,
            Parent = notifFrame,
        })

        -- Colored side bar
        local sideBar = utils.create("Frame", {
            Size = UDim2.new(0, 4, 1, 0),
            BackgroundColor3 = accentColor,
            BorderSizePixel = 0,
            Parent = notifFrame,
        })
        utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = sideBar})

        -- Title
        utils.create("TextLabel", {
            Text = title,
            Size = UDim2.new(1, -40, 0, 20),
            Position = UDim2.new(0, 16, 0, 10),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text.Primary,
            TextSize = 14, Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notifFrame,
        })

        -- Content
        utils.create("TextLabel", {
            Text = content,
            Size = UDim2.new(1, -32, 0, contentBounds.Y),
            Position = UDim2.new(0, 16, 0, 30),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text.Secondary,
            TextSize = 12, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            Parent = notifFrame,
        })

        local dismissed = false
        local function dismiss()
            if dismissed then return end
            dismissed = true
            local outTween = utils.tween(notifFrame, 0.4, {Position = UDim2.new(1, 300, 0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            outTween.Completed:Connect(function()
                notifFrame:Destroy()
            end)
        end

        -- Close button
        local closeBtn = utils.create("TextButton", {
            Text = "×",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -26, 0, 10),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text.Tertiary,
            TextSize = 18, Font = Enum.Font.Gotham,
            Parent = notifFrame,
        })
        closeBtn.MouseButton1Click:Connect(dismiss)

        -- Actions (Buttons)
        if hasActions then
            local actionContainer = utils.create("Frame", {
                Size = UDim2.new(1, -32, 0, 28),
                Position = UDim2.new(0, 16, 1, -34),
                BackgroundTransparency = 1,
                Parent = notifFrame,
            })
            local actionLayout = utils.create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8),
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Parent = actionContainer,
            })

            for i, actionData in next, actions do
                local btn = utils.create("TextButton", {
                    Text = actionData.Name or "Action",
                    Size = UDim2.new(0, 80, 1, 0), -- Width adjusted below
                    BackgroundColor3 = theme.Element.Background,
                    TextColor3 = theme.Text.Primary,
                    TextSize = 12, Font = Enum.Font.Gotham,
                    BorderSizePixel = 0,
                    LayoutOrder = i,
                    Parent = actionContainer,
                })
                utils.create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = btn})
                utils.create("UIStroke", {Color = theme.Element.Border, Thickness = 1, Parent = btn})
                
                -- Auto sizing based on text
                local textWidth = game:GetService("TextService"):GetTextSize(btn.Text, 12, Enum.Font.Gotham, Vector2.new(math.huge, 28)).X
                btn.Size = UDim2.new(0, textWidth + 16, 1, 0)

                btn.MouseEnter:Connect(function() utils.tween(btn, 0.2, {BackgroundColor3 = theme.Element.Hover}) end)
                btn.MouseLeave:Connect(function() utils.tween(btn, 0.2, {BackgroundColor3 = theme.Element.Background}) end)
                
                btn.MouseButton1Click:Connect(function()
                    if actionData.Callback then
                        task.spawn(actionData.Callback)
                    end
                    dismiss()
                end)
            end
        end

        -- Progress Bar
        local progressBg = utils.create("Frame", {
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2),
            BackgroundColor3 = theme.Element.Border,
            BorderSizePixel = 0,
            Parent = notifFrame,
        })
        utils.create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = progressBg})
        
        local progressFill = utils.create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = accentColor,
            BorderSizePixel = 0,
            Parent = progressBg,
        })
        utils.create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = progressFill})

        -- Slide in animation
        utils.tween(notifFrame, 0.5, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        -- Progress bar animation and auto dismiss
        local progTween = utils.tween(progressFill, duration, {Size = UDim2.new(0, 0, 1, 0)}, Enum.EasingStyle.Linear)
        progTween.Completed:Connect(function()
            if not dismissed then dismiss() end
        end)
    end

    return notificationSystem
end

return SetupNotifications
