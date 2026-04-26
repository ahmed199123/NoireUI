--[[
    Noire UI - Tab System (Cyber-Luxury Edition)
]]--

local CreateButton = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/components/button.lua"))()
local CreateToggle = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/components/toggle.lua"))()
local CreateSlider = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/components/slider.lua"))()
local CreateDropdown = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/components/dropdown.lua"))()
local CreateInput = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/components/input.lua"))()
local CreateKeybind = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/components/keybind.lua"))()
local CreateColorPicker = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/components/colorpicker.lua"))()
local CreateLabel = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/components/label.lua"))()
local CreateParagraph = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/components/paragraph.lua"))()

local function SetupTabSystem(window, contentContainer, utils, theme, flags)
    local tabs = {}

    function tabs:CreateTab(options)
        local tabObj = { Name = options.Title or "Tab", Elements = {} }

        -- Using CanvasGroup for fade in/out sliding animations
        local scrollGroup = utils.create("CanvasGroup", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = false,
            Parent = contentContainer,
        })

        local scrollFrame = utils.create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = theme.Colors.AccentDark,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = scrollGroup,
        })
        
        local layout = utils.create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = scrollFrame,
        })
        
        utils.create("UIPadding", {
            PaddingTop = UDim.new(0, 6),
            PaddingBottom = UDim.new(0, 16),
            PaddingLeft = UDim.new(0, 16),
            PaddingRight = UDim.new(0, 20),
            Parent = scrollFrame,
        })

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
        end)

        tabObj.Container = scrollGroup

        function tabObj:CreateSection(title)
            local sectionFrame = utils.create("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                Parent = scrollFrame,
            })
            
            -- Decorative diamond
            local diamond = utils.create("Frame", {
                Size = UDim2.new(0, 6, 0, 6),
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = theme.Colors.AccentPrimary,
                Rotation = 45,
                BorderSizePixel = 0,
                Parent = sectionFrame
            })
            
            local lbl = utils.create("TextLabel", {
                Text = title:upper(),
                Size = UDim2.new(0, 200, 1, 0),
                Position = UDim2.new(0, 16, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = theme.Colors.TextPrimary,
                TextSize = 11, Font = Enum.Font.Code, -- Monospace header
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionFrame,
            })
            
            -- Horizontal trailing rule
            local rule = utils.create("Frame", {
                Size = UDim2.new(1, -(lbl.TextBounds.X + 30), 0, 1),
                Position = UDim2.new(0, lbl.TextBounds.X + 24, 0.5, 0),
                BackgroundColor3 = theme.Colors.BorderDefault,
                BorderSizePixel = 0,
                Parent = sectionFrame,
            })
            utils.createGradient(rule, theme.Colors.BorderDefault, theme.Colors.L1, 0)
            
            return sectionFrame
        end

        local function injectParent(opts)
            opts = opts or {}
            opts._parent = scrollFrame
            return opts
        end

        function tabObj:CreateButton(opts) local c = CreateButton(tabObj, utils, theme, injectParent(opts)); table.insert(self.Elements, c); return c end
        function tabObj:CreateToggle(opts) local c = CreateToggle(tabObj, utils, theme, flags, injectParent(opts)); table.insert(self.Elements, c); return c end
        function tabObj:CreateSlider(opts) local c = CreateSlider(tabObj, utils, theme, flags, injectParent(opts)); table.insert(self.Elements, c); return c end
        function tabObj:CreateDropdown(opts) local c = CreateDropdown(tabObj, utils, theme, flags, injectParent(opts)); table.insert(self.Elements, c); return c end
        function tabObj:CreateInput(opts) local c = CreateInput(tabObj, utils, theme, flags, injectParent(opts)); table.insert(self.Elements, c); return c end
        function tabObj:CreateKeybind(opts) local c = CreateKeybind(tabObj, utils, theme, flags, injectParent(opts)); table.insert(self.Elements, c); return c end
        function tabObj:CreateColorPicker(opts) local c = CreateColorPicker(tabObj, utils, theme, flags, injectParent(opts)); table.insert(self.Elements, c); return c end
        function tabObj:CreateLabel(opts) if type(opts) == "string" then opts = {Text = opts} end; local c = CreateLabel(tabObj, utils, theme, injectParent(opts)); table.insert(self.Elements, c); return c end
        function tabObj:CreateParagraph(opts) local c = CreateParagraph(tabObj, utils, theme, injectParent(opts)); table.insert(self.Elements, c); return c end

        return tabObj
    end

    return tabs
end

return SetupTabSystem
