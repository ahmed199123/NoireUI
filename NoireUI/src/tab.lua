--[[
    Noire UI - Tab System
]]--

-- Import components
local CreateButton = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/src/components/button.lua"))()
local CreateToggle = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/src/components/toggle.lua"))()
local CreateSlider = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/src/components/slider.lua"))()
local CreateDropdown = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/src/components/dropdown.lua"))()
local CreateInput = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/src/components/input.lua"))()
local CreateKeybind = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/src/components/keybind.lua"))()
local CreateColorPicker = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/src/components/colorpicker.lua"))()
local CreateLabel = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/src/components/label.lua"))()
local CreateParagraph = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/src/components/paragraph.lua"))()

local function SetupTabSystem(window, contentContainer, utils, theme, flags)
    local tabs = {}
    local activeTab = nil

    function tabs:CreateTab(options)
        local tabName = options.Title or "Tab"
        local icon = options.Icon or ""
        
        local tabObj = {
            Name = tabName,
            Elements = {}
        }

        -- ScrollFrame for this tab's content
        local scrollFrame = utils.create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = theme.Misc.Scrollbar,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false, -- Hidden by default
            Parent = contentContainer,
        })
        
        local layout = utils.create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = scrollFrame,
        })
        
        local padding = utils.create("UIPadding", {
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 8),
            Parent = scrollFrame,
        })

        -- Auto-resize canvas
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        end)

        tabObj.Container = scrollFrame

        -- Create Section method
        function tabObj:CreateSection(title)
            local sectionFrame = utils.create("Frame", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Parent = scrollFrame,
            })
            
            utils.create("TextLabel", {
                Text = title,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 4, 0, 4),
                BackgroundTransparency = 1,
                TextColor3 = theme.Text.Secondary,
                TextSize = 12, Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionFrame,
            })
            
            -- Divider line
            local divider = utils.create("Frame", {
                Size = UDim2.new(1, -8, 0, 1),
                Position = UDim2.new(0, 4, 1, 0),
                BackgroundColor3 = theme.Misc.Divider,
                BorderSizePixel = 0,
                Parent = sectionFrame,
            })
            utils.createGradient(divider, theme.Misc.Divider, theme.Window.Content, 0)
            
            return sectionFrame
        end

        -- Wrap component constructors
        local function injectParent(opts)
            opts = opts or {}
            opts._parent = scrollFrame
            return opts
        end

        function tabObj:CreateButton(opts)
            local btn = CreateButton(tabObj, utils, theme, injectParent(opts))
            table.insert(self.Elements, btn)
            return btn
        end

        function tabObj:CreateToggle(opts)
            local tgl = CreateToggle(tabObj, utils, theme, flags, injectParent(opts))
            table.insert(self.Elements, tgl)
            return tgl
        end

        function tabObj:CreateSlider(opts)
            local sld = CreateSlider(tabObj, utils, theme, flags, injectParent(opts))
            table.insert(self.Elements, sld)
            return sld
        end

        function tabObj:CreateDropdown(opts)
            local dpd = CreateDropdown(tabObj, utils, theme, flags, injectParent(opts))
            table.insert(self.Elements, dpd)
            return dpd
        end

        function tabObj:CreateInput(opts)
            local inp = CreateInput(tabObj, utils, theme, flags, injectParent(opts))
            table.insert(self.Elements, inp)
            return inp
        end

        function tabObj:CreateKeybind(opts)
            local kb = CreateKeybind(tabObj, utils, theme, flags, injectParent(opts))
            table.insert(self.Elements, kb)
            return kb
        end

        function tabObj:CreateColorPicker(opts)
            local cp = CreateColorPicker(tabObj, utils, theme, flags, injectParent(opts))
            table.insert(self.Elements, cp)
            return cp
        end

        function tabObj:CreateLabel(opts)
            -- Support both string and table options for label
            if type(opts) == "string" then opts = {Text = opts} end
            local lbl = CreateLabel(tabObj, utils, theme, injectParent(opts))
            table.insert(self.Elements, lbl)
            return lbl
        end

        function tabObj:CreateParagraph(opts)
            local para = CreateParagraph(tabObj, utils, theme, injectParent(opts))
            table.insert(self.Elements, para)
            return para
        end

        -- Add to window's sidebar (handled by window.lua logic, but returning the object)
        return tabObj
    end

    return tabs
end

return SetupTabSystem
