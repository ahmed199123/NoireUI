--[[
    Noire UI - Theme Engine (Cyber-Luxury Edition)
    5 AAA-Grade Cyberpunk & Military HUD Presets
]]--

local Themes = {}

-- Standard Theme Schema
-- L0 (Void), L1 (Base), L2 (Float), L3 (Interact), L4 (Active), L5 (Overlay)

Themes.List = {}

-- ═══════════════════════════════════════
-- VOID (Cold, Minimal, Space HUD)
-- ═══════════════════════════════════════
Themes.List["VOID"] = {
    Name = "VOID",
    Colors = {
        L0 = Color3.fromRGB(8, 8, 12),       -- Deep void background
        L1 = Color3.fromRGB(14, 14, 20),     -- Base panels (Sidebar)
        L2 = Color3.fromRGB(20, 20, 28),     -- Floating containers (Cards)
        L3 = Color3.fromRGB(26, 26, 36),     -- Interactive elements
        L4 = Color3.fromRGB(35, 35, 48),     -- Active/Hover
        L5 = Color3.fromRGB(10, 10, 16),     -- Overlays/Tooltips
        
        AccentPrimary = Color3.fromRGB(139, 92, 246), -- Electric Violet
        AccentSecondary = Color3.fromRGB(192, 132, 252),
        AccentDark = Color3.fromRGB(76, 29, 149),
        
        TextPrimary = Color3.fromRGB(232, 232, 240),
        TextSecondary = Color3.fromRGB(136, 136, 170),
        TextTertiary = Color3.fromRGB(68, 68, 90),
        
        BorderDark = Color3.fromRGB(0, 0, 0),        -- Outer stroke
        BorderLight = Color3.fromRGB(255, 255, 255), -- Inner specular
        BorderDefault = Color3.fromRGB(42, 42, 58),
        
        Success = Color3.fromRGB(16, 185, 129),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11)
    },
    Settings = {
        NoiseOpacity = 0.04,
        ScanlineOpacity = 0.03,
        SpecularOpacity = 0.08,
        BorderLightOpacity = 0.05,
        BorderDarkOpacity = 0.45
    }
}

-- ═══════════════════════════════════════
-- EMBER (Industrial, Warm, Dangerous)
-- ═══════════════════════════════════════
Themes.List["EMBER"] = {
    Name = "EMBER",
    Colors = {
        L0 = Color3.fromRGB(12, 10, 10),
        L1 = Color3.fromRGB(20, 16, 16),
        L2 = Color3.fromRGB(28, 22, 22),
        L3 = Color3.fromRGB(36, 28, 28),
        L4 = Color3.fromRGB(48, 38, 38),
        L5 = Color3.fromRGB(15, 12, 12),
        
        AccentPrimary = Color3.fromRGB(249, 115, 22), -- Burning Amber
        AccentSecondary = Color3.fromRGB(253, 186, 116),
        AccentDark = Color3.fromRGB(154, 52, 18),
        
        TextPrimary = Color3.fromRGB(245, 240, 235),
        TextSecondary = Color3.fromRGB(170, 140, 130),
        TextTertiary = Color3.fromRGB(90, 70, 65),
        
        BorderDark = Color3.fromRGB(0, 0, 0),
        BorderLight = Color3.fromRGB(255, 230, 200),
        BorderDefault = Color3.fromRGB(58, 42, 42),
        
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(220, 38, 38),
        Warning = Color3.fromRGB(234, 179, 8)
    },
    Settings = {
        NoiseOpacity = 0.06,
        ScanlineOpacity = 0.04,
        SpecularOpacity = 0.1,
        BorderLightOpacity = 0.06,
        BorderDarkOpacity = 0.5
    }
}

-- ═══════════════════════════════════════
-- SPECTER (Ethereal, Frosted Glass)
-- ═══════════════════════════════════════
Themes.List["SPECTER"] = {
    Name = "SPECTER",
    Colors = {
        L0 = Color3.fromRGB(10, 14, 18),
        L1 = Color3.fromRGB(16, 22, 28),
        L2 = Color3.fromRGB(22, 30, 38),
        L3 = Color3.fromRGB(30, 40, 50),
        L4 = Color3.fromRGB(42, 55, 68),
        L5 = Color3.fromRGB(12, 18, 24),
        
        AccentPrimary = Color3.fromRGB(6, 182, 212), -- Pale Cyan
        AccentSecondary = Color3.fromRGB(103, 232, 249),
        AccentDark = Color3.fromRGB(8, 145, 178),
        
        TextPrimary = Color3.fromRGB(235, 245, 255),
        TextSecondary = Color3.fromRGB(130, 155, 175),
        TextTertiary = Color3.fromRGB(65, 85, 105),
        
        BorderDark = Color3.fromRGB(0, 5, 10),
        BorderLight = Color3.fromRGB(200, 240, 255),
        BorderDefault = Color3.fromRGB(40, 55, 70),
        
        Success = Color3.fromRGB(16, 185, 129),
        Error = Color3.fromRGB(244, 63, 94),
        Warning = Color3.fromRGB(251, 191, 36)
    },
    Settings = {
        NoiseOpacity = 0.02,
        ScanlineOpacity = 0.02,
        SpecularOpacity = 0.12,
        BorderLightOpacity = 0.08,
        BorderDarkOpacity = 0.4
    }
}

-- ═══════════════════════════════════════
-- IRON (Brutalist, Military Precision)
-- ═══════════════════════════════════════
Themes.List["IRON"] = {
    Name = "IRON",
    Colors = {
        L0 = Color3.fromRGB(18, 20, 22),
        L1 = Color3.fromRGB(24, 26, 28),
        L2 = Color3.fromRGB(30, 32, 35),
        L3 = Color3.fromRGB(38, 40, 44),
        L4 = Color3.fromRGB(50, 52, 58),
        L5 = Color3.fromRGB(15, 17, 19),
        
        AccentPrimary = Color3.fromRGB(59, 130, 246), -- Steel Blue
        AccentSecondary = Color3.fromRGB(147, 197, 253),
        AccentDark = Color3.fromRGB(29, 78, 216),
        
        TextPrimary = Color3.fromRGB(220, 225, 230),
        TextSecondary = Color3.fromRGB(140, 145, 150),
        TextTertiary = Color3.fromRGB(80, 85, 90),
        
        BorderDark = Color3.fromRGB(0, 0, 0),
        BorderLight = Color3.fromRGB(255, 255, 255),
        BorderDefault = Color3.fromRGB(55, 60, 65),
        
        Success = Color3.fromRGB(22, 163, 74),
        Error = Color3.fromRGB(220, 38, 38),
        Warning = Color3.fromRGB(202, 138, 4)
    },
    Settings = {
        NoiseOpacity = 0.08,
        ScanlineOpacity = 0.05,
        SpecularOpacity = 0.06,
        BorderLightOpacity = 0.04,
        BorderDarkOpacity = 0.6
    }
}

-- ═══════════════════════════════════════
-- TOXIC (Hacker Terminal, Matrix)
-- ═══════════════════════════════════════
Themes.List["TOXIC"] = {
    Name = "TOXIC",
    Colors = {
        L0 = Color3.fromRGB(6, 12, 8),
        L1 = Color3.fromRGB(10, 18, 12),
        L2 = Color3.fromRGB(16, 26, 18),
        L3 = Color3.fromRGB(22, 36, 24),
        L4 = Color3.fromRGB(30, 50, 34),
        L5 = Color3.fromRGB(4, 8, 6),
        
        AccentPrimary = Color3.fromRGB(34, 197, 94), -- Acid Green
        AccentSecondary = Color3.fromRGB(134, 239, 172),
        AccentDark = Color3.fromRGB(21, 128, 61),
        
        TextPrimary = Color3.fromRGB(220, 255, 230),
        TextSecondary = Color3.fromRGB(110, 170, 130),
        TextTertiary = Color3.fromRGB(50, 90, 65),
        
        BorderDark = Color3.fromRGB(0, 10, 0),
        BorderLight = Color3.fromRGB(150, 255, 180),
        BorderDefault = Color3.fromRGB(35, 60, 45),
        
        Success = Color3.fromRGB(16, 185, 129),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(234, 179, 8)
    },
    Settings = {
        NoiseOpacity = 0.05,
        ScanlineOpacity = 0.06,
        SpecularOpacity = 0.15,
        BorderLightOpacity = 0.1,
        BorderDarkOpacity = 0.5
    }
}

-- ═══════════════════════════════════════
-- PORCELAIN (Polished, Clean, Minimalist White)
-- ═══════════════════════════════════════
Themes.List["PORCELAIN"] = {
    Name = "PORCELAIN",
    Colors = {
        L0 = Color3.fromRGB(240, 242, 245),
        L1 = Color3.fromRGB(248, 250, 252),
        L2 = Color3.fromRGB(255, 255, 255),
        L3 = Color3.fromRGB(235, 238, 242),
        L4 = Color3.fromRGB(225, 228, 234),
        L5 = Color3.fromRGB(250, 250, 252),
        
        AccentPrimary = Color3.fromRGB(15, 23, 42),
        AccentSecondary = Color3.fromRGB(51, 65, 85),
        AccentDark = Color3.fromRGB(0, 0, 0),
        
        TextPrimary = Color3.fromRGB(15, 23, 42),
        TextSecondary = Color3.fromRGB(71, 85, 105),
        TextTertiary = Color3.fromRGB(148, 163, 184),
        
        BorderDark = Color3.fromRGB(203, 213, 225),
        BorderLight = Color3.fromRGB(255, 255, 255),
        BorderDefault = Color3.fromRGB(226, 232, 240),
        
        Success = Color3.fromRGB(16, 185, 129),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11)
    },
    Settings = {
        NoiseOpacity = 0.02,
        ScanlineOpacity = 0.01,
        SpecularOpacity = 0.4,
        BorderLightOpacity = 0.8,
        BorderDarkOpacity = 0.4
    }
}

function Themes.get(name)
    return Themes.List[name] or Themes.List["VOID"]
end

return Themes
