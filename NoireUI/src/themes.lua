--[[
    Noire UI - Theme Engine
    Built-in premium themes and theme management
]]--

local Themes = {}

-- Theme template structure
--[[
    Each theme has:
    - Window: Background, Sidebar, Content, Border, Shadow
    - Accent: Primary, Secondary (for gradients)
    - Text: Primary, Secondary, Tertiary, Disabled
    - Element: Background, Hover, Active, Border
    - Status: Success, Error, Warning, Info
    - Toggle: OnBg, OffBg, Thumb
    - Slider: Fill, Track, Thumb
    - Misc: Overlay, Divider, Scrollbar
]]

Themes.List = {}

-- ═══════════════════════════════════════
-- MIDNIGHT (Default) - Purple/Blue luxury
-- ═══════════════════════════════════════
Themes.List["Midnight"] = {
    Name = "Midnight",
    Window = {
        Background = Color3.fromRGB(13, 13, 18),
        Sidebar = Color3.fromRGB(18, 18, 26),
        Content = Color3.fromRGB(13, 13, 18),
        TopBar = Color3.fromRGB(16, 16, 23),
        Border = Color3.fromRGB(42, 42, 62),
        Shadow = Color3.fromRGB(0, 0, 0),
        Footer = Color3.fromRGB(11, 11, 15),
    },
    Accent = {
        Primary = Color3.fromRGB(139, 92, 246),
        Secondary = Color3.fromRGB(99, 102, 241),
    },
    Text = {
        Primary = Color3.fromRGB(248, 248, 255),
        Secondary = Color3.fromRGB(136, 136, 170),
        Tertiary = Color3.fromRGB(85, 85, 112),
        Disabled = Color3.fromRGB(60, 60, 80),
    },
    Element = {
        Background = Color3.fromRGB(28, 28, 40),
        Hover = Color3.fromRGB(36, 36, 58),
        Active = Color3.fromRGB(44, 44, 68),
        Border = Color3.fromRGB(42, 42, 62),
    },
    Status = {
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Info = Color3.fromRGB(59, 130, 246),
    },
    Toggle = {
        OnBg = Color3.fromRGB(139, 92, 246),
        OffBg = Color3.fromRGB(51, 51, 80),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Slider = {
        Fill = Color3.fromRGB(139, 92, 246),
        Track = Color3.fromRGB(40, 40, 60),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Misc = {
        Overlay = Color3.fromRGB(0, 0, 0),
        Divider = Color3.fromRGB(35, 35, 52),
        Scrollbar = Color3.fromRGB(139, 92, 246),
        TabIndicator = Color3.fromRGB(139, 92, 246),
        Notification = Color3.fromRGB(20, 20, 30),
    },
}

-- ═══════════════════════════════════════
-- OBSIDIAN - Deep dark with cyan accent
-- ═══════════════════════════════════════
Themes.List["Obsidian"] = {
    Name = "Obsidian",
    Window = {
        Background = Color3.fromRGB(10, 10, 14),
        Sidebar = Color3.fromRGB(14, 14, 20),
        Content = Color3.fromRGB(10, 10, 14),
        TopBar = Color3.fromRGB(13, 13, 18),
        Border = Color3.fromRGB(35, 45, 55),
        Shadow = Color3.fromRGB(0, 0, 0),
        Footer = Color3.fromRGB(8, 8, 12),
    },
    Accent = {
        Primary = Color3.fromRGB(6, 182, 212),
        Secondary = Color3.fromRGB(34, 211, 238),
    },
    Text = {
        Primary = Color3.fromRGB(240, 245, 255),
        Secondary = Color3.fromRGB(120, 140, 160),
        Tertiary = Color3.fromRGB(70, 85, 100),
        Disabled = Color3.fromRGB(50, 60, 70),
    },
    Element = {
        Background = Color3.fromRGB(20, 25, 32),
        Hover = Color3.fromRGB(28, 35, 45),
        Active = Color3.fromRGB(35, 45, 55),
        Border = Color3.fromRGB(35, 45, 55),
    },
    Status = {
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Info = Color3.fromRGB(6, 182, 212),
    },
    Toggle = {
        OnBg = Color3.fromRGB(6, 182, 212),
        OffBg = Color3.fromRGB(40, 50, 65),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Slider = {
        Fill = Color3.fromRGB(6, 182, 212),
        Track = Color3.fromRGB(30, 38, 48),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Misc = {
        Overlay = Color3.fromRGB(0, 0, 0),
        Divider = Color3.fromRGB(28, 35, 45),
        Scrollbar = Color3.fromRGB(6, 182, 212),
        TabIndicator = Color3.fromRGB(6, 182, 212),
        Notification = Color3.fromRGB(14, 18, 25),
    },
}

-- ═══════════════════════════════════════
-- CRIMSON - Dark with red/rose accent
-- ═══════════════════════════════════════
Themes.List["Crimson"] = {
    Name = "Crimson",
    Window = {
        Background = Color3.fromRGB(14, 10, 12),
        Sidebar = Color3.fromRGB(20, 14, 17),
        Content = Color3.fromRGB(14, 10, 12),
        TopBar = Color3.fromRGB(18, 13, 15),
        Border = Color3.fromRGB(60, 30, 40),
        Shadow = Color3.fromRGB(0, 0, 0),
        Footer = Color3.fromRGB(12, 8, 10),
    },
    Accent = {
        Primary = Color3.fromRGB(225, 29, 72),
        Secondary = Color3.fromRGB(251, 113, 133),
    },
    Text = {
        Primary = Color3.fromRGB(255, 245, 248),
        Secondary = Color3.fromRGB(160, 120, 135),
        Tertiary = Color3.fromRGB(100, 75, 85),
        Disabled = Color3.fromRGB(70, 50, 58),
    },
    Element = {
        Background = Color3.fromRGB(32, 20, 26),
        Hover = Color3.fromRGB(45, 28, 35),
        Active = Color3.fromRGB(55, 32, 42),
        Border = Color3.fromRGB(60, 30, 40),
    },
    Status = {
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Info = Color3.fromRGB(59, 130, 246),
    },
    Toggle = {
        OnBg = Color3.fromRGB(225, 29, 72),
        OffBg = Color3.fromRGB(60, 35, 42),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Slider = {
        Fill = Color3.fromRGB(225, 29, 72),
        Track = Color3.fromRGB(45, 28, 35),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Misc = {
        Overlay = Color3.fromRGB(0, 0, 0),
        Divider = Color3.fromRGB(40, 25, 32),
        Scrollbar = Color3.fromRGB(225, 29, 72),
        TabIndicator = Color3.fromRGB(225, 29, 72),
        Notification = Color3.fromRGB(20, 14, 18),
    },
}

-- ═══════════════════════════════════════
-- EMERALD - Dark with green accent
-- ═══════════════════════════════════════
Themes.List["Emerald"] = {
    Name = "Emerald",
    Window = {
        Background = Color3.fromRGB(10, 14, 12),
        Sidebar = Color3.fromRGB(14, 20, 17),
        Content = Color3.fromRGB(10, 14, 12),
        TopBar = Color3.fromRGB(13, 18, 15),
        Border = Color3.fromRGB(30, 55, 42),
        Shadow = Color3.fromRGB(0, 0, 0),
        Footer = Color3.fromRGB(8, 12, 10),
    },
    Accent = {
        Primary = Color3.fromRGB(16, 185, 129),
        Secondary = Color3.fromRGB(52, 211, 153),
    },
    Text = {
        Primary = Color3.fromRGB(240, 255, 248),
        Secondary = Color3.fromRGB(120, 160, 140),
        Tertiary = Color3.fromRGB(70, 100, 85),
        Disabled = Color3.fromRGB(50, 70, 60),
    },
    Element = {
        Background = Color3.fromRGB(18, 30, 24),
        Hover = Color3.fromRGB(24, 40, 32),
        Active = Color3.fromRGB(30, 50, 40),
        Border = Color3.fromRGB(30, 55, 42),
    },
    Status = {
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Info = Color3.fromRGB(59, 130, 246),
    },
    Toggle = {
        OnBg = Color3.fromRGB(16, 185, 129),
        OffBg = Color3.fromRGB(35, 55, 45),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Slider = {
        Fill = Color3.fromRGB(16, 185, 129),
        Track = Color3.fromRGB(24, 40, 32),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Misc = {
        Overlay = Color3.fromRGB(0, 0, 0),
        Divider = Color3.fromRGB(22, 36, 28),
        Scrollbar = Color3.fromRGB(16, 185, 129),
        TabIndicator = Color3.fromRGB(16, 185, 129),
        Notification = Color3.fromRGB(14, 20, 17),
    },
}

-- ═══════════════════════════════════════
-- AMETHYST - Warm purple/pink
-- ═══════════════════════════════════════
Themes.List["Amethyst"] = {
    Name = "Amethyst",
    Window = {
        Background = Color3.fromRGB(16, 12, 18),
        Sidebar = Color3.fromRGB(22, 16, 25),
        Content = Color3.fromRGB(16, 12, 18),
        TopBar = Color3.fromRGB(20, 14, 22),
        Border = Color3.fromRGB(55, 35, 65),
        Shadow = Color3.fromRGB(0, 0, 0),
        Footer = Color3.fromRGB(13, 10, 15),
    },
    Accent = {
        Primary = Color3.fromRGB(168, 85, 247),
        Secondary = Color3.fromRGB(217, 70, 239),
    },
    Text = {
        Primary = Color3.fromRGB(250, 245, 255),
        Secondary = Color3.fromRGB(150, 130, 170),
        Tertiary = Color3.fromRGB(95, 80, 110),
        Disabled = Color3.fromRGB(65, 55, 75),
    },
    Element = {
        Background = Color3.fromRGB(28, 22, 35),
        Hover = Color3.fromRGB(38, 30, 48),
        Active = Color3.fromRGB(48, 38, 58),
        Border = Color3.fromRGB(55, 35, 65),
    },
    Status = {
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Info = Color3.fromRGB(139, 92, 246),
    },
    Toggle = {
        OnBg = Color3.fromRGB(168, 85, 247),
        OffBg = Color3.fromRGB(50, 38, 60),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Slider = {
        Fill = Color3.fromRGB(168, 85, 247),
        Track = Color3.fromRGB(35, 28, 42),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Misc = {
        Overlay = Color3.fromRGB(0, 0, 0),
        Divider = Color3.fromRGB(32, 25, 38),
        Scrollbar = Color3.fromRGB(168, 85, 247),
        TabIndicator = Color3.fromRGB(168, 85, 247),
        Notification = Color3.fromRGB(22, 16, 25),
    },
}

-- ═══════════════════════════════════════
-- ARCTIC - Clean light-ish dark with white/blue
-- ═══════════════════════════════════════
Themes.List["Arctic"] = {
    Name = "Arctic",
    Window = {
        Background = Color3.fromRGB(18, 20, 28),
        Sidebar = Color3.fromRGB(22, 24, 34),
        Content = Color3.fromRGB(18, 20, 28),
        TopBar = Color3.fromRGB(20, 22, 32),
        Border = Color3.fromRGB(45, 50, 70),
        Shadow = Color3.fromRGB(0, 0, 0),
        Footer = Color3.fromRGB(15, 17, 24),
    },
    Accent = {
        Primary = Color3.fromRGB(96, 165, 250),
        Secondary = Color3.fromRGB(147, 197, 253),
    },
    Text = {
        Primary = Color3.fromRGB(248, 250, 255),
        Secondary = Color3.fromRGB(140, 150, 180),
        Tertiary = Color3.fromRGB(85, 95, 120),
        Disabled = Color3.fromRGB(60, 65, 85),
    },
    Element = {
        Background = Color3.fromRGB(28, 32, 45),
        Hover = Color3.fromRGB(36, 40, 58),
        Active = Color3.fromRGB(44, 50, 68),
        Border = Color3.fromRGB(45, 50, 70),
    },
    Status = {
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Info = Color3.fromRGB(96, 165, 250),
    },
    Toggle = {
        OnBg = Color3.fromRGB(96, 165, 250),
        OffBg = Color3.fromRGB(45, 50, 68),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Slider = {
        Fill = Color3.fromRGB(96, 165, 250),
        Track = Color3.fromRGB(35, 40, 55),
        Thumb = Color3.fromRGB(255, 255, 255),
    },
    Misc = {
        Overlay = Color3.fromRGB(0, 0, 0),
        Divider = Color3.fromRGB(32, 36, 50),
        Scrollbar = Color3.fromRGB(96, 165, 250),
        TabIndicator = Color3.fromRGB(96, 165, 250),
        Notification = Color3.fromRGB(22, 24, 34),
    },
}

-- Get a theme by name (returns Midnight if not found)
function Themes.get(name)
    return Themes.List[name] or Themes.List["Midnight"]
end

-- Create a custom theme from a base + overrides
function Themes.custom(baseName, overrides)
    local base = Themes.get(baseName)
    local theme = {}
    for category, props in next, base do
        if type(props) == "table" then
            theme[category] = {}
            for k, v in next, props do
                theme[category][k] = v
            end
        else
            theme[category] = props
        end
    end
    -- Apply overrides
    if overrides then
        for category, props in next, overrides do
            if type(props) == "table" and theme[category] then
                for k, v in next, props do
                    theme[category][k] = v
                end
            else
                theme[category] = props
            end
        end
    end
    return theme
end

return Themes
