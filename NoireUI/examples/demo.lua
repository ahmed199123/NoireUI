--[[
    Noire UI - Demo Script
    A complete showcase of all components and features.
]]--

-- In production, use: loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/Loader.lua"))()
-- For local testing:
local Noire = loadfile("NoireUI/src/Source.lua")()

-- 1. Create the Main Window
local Window = Noire:CreateWindow({
    Title = "Noire UI Premium",
    Subtitle = "Showcase v1.0",
    Theme = "Midnight", -- Try: Obsidian, Crimson, Emerald, Amethyst, Arctic
    Size = UDim2.new(0, 600, 0, 480),
    ToggleKey = Enum.KeyCode.RightControl,
    DisableBlur = false,
    SaveConfig = true,
    ConfigFolder = "NoireDemo"
})

-- Show an intro notification
Noire:Notify({
    Title = "Welcome",
    Content = "Successfully loaded Noire UI Premium.",
    Type = "Success",
    Duration = 5
})

-- 2. Create Tabs
local TabMain = Window:CreateTab({
    Title = "Main Features",
    Icon = "rbxassetid://10828073860" -- Home icon
})

local TabCombat = Window:CreateTab({
    Title = "Combat",
    Icon = "rbxassetid://10828073105" -- Target icon
})

local TabSettings = Window:CreateTab({
    Title = "Settings",
    Icon = "rbxassetid://10828073402" -- Gear icon
})

-- ══════════════════════════════════════════════════
-- MAIN TAB SHOWCASE
-- ══════════════════════════════════════════════════

TabMain:CreateSection("Basic Controls")

local mainButton = TabMain:CreateButton({
    Title = "Click Me",
    Description = "Demonstrates the ripple click effect",
    Callback = function()
        Noire:Notify({
            Title = "Button Clicked",
            Content = "You clicked the demo button!",
            Type = "Info",
            Duration = 3
        })
    end
})

local mainToggle = TabMain:CreateToggle({
    Title = "God Mode",
    Description = "Makes your character invincible",
    Default = false,
    Flag = "GodMode",
    Callback = function(state)
        print("God Mode is now:", state)
    end
})

local mainSlider = TabMain:CreateSlider({
    Title = "WalkSpeed",
    Description = "Adjust character movement speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    Suffix = " WS",
    Flag = "WalkSpeed",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

TabMain:CreateSection("Advanced Controls")

local mainDropdown = TabMain:CreateDropdown({
    Title = "Teleport Location",
    Description = "Select a place to teleport to",
    Options = {"Spawn", "Shop", "Arena", "Safezone"},
    Default = "Spawn",
    MultiSelect = false,
    Flag = "TeleportLoc",
    Callback = function(value)
        print("Teleporting to:", value)
    end
})

local multiDropdown = TabMain:CreateDropdown({
    Title = "ESP Types",
    Description = "Select what to show on ESP",
    Options = {"Players", "NPCs", "Items", "Chests"},
    Default = {"Players", "Chests"},
    MultiSelect = true,
    Flag = "ESPTypes",
    Callback = function(value)
        -- value is a table: {Players = true, Chests = true}
        print("ESP Settings updated")
    end
})

-- ══════════════════════════════════════════════════
-- COMBAT TAB SHOWCASE
-- ══════════════════════════════════════════════════

TabCombat:CreateSection("Aimbot Settings")

TabCombat:CreateToggle({
    Title = "Enable Aimbot",
    Default = false,
    Flag = "Aimbot",
})

TabCombat:CreateKeybind({
    Title = "Aimbot Hotkey",
    Default = Enum.KeyCode.E,
    Flag = "AimbotKey",
    Callback = function(key)
        print("Aimbot key pressed:", key.Name)
    end
})

TabCombat:CreateSlider({
    Title = "Smoothing",
    Min = 1,
    Max = 10,
    Default = 5,
    Increment = 0.5,
    Flag = "AimbotSmoothing"
})

TabCombat:CreateSection("Visuals")

TabCombat:CreateColorPicker({
    Title = "Target Color",
    Description = "Color of the locked target",
    Default = Color3.fromRGB(255, 50, 50),
    Flag = "TargetColor",
    Callback = function(color)
        print("Target color changed")
    end
})

-- ══════════════════════════════════════════════════
-- SETTINGS TAB SHOWCASE
-- ══════════════════════════════════════════════════

TabSettings:CreateParagraph({
    Title = "Noire UI Premium",
    Content = "This is a premium UI library created to provide a luxury experience for Roblox scripting.\n\nPress RightControl to hide/show this window."
})

TabSettings:CreateSection("Configuration")

TabSettings:CreateInput({
    Title = "Config Name",
    Placeholder = "Enter name...",
    Default = "MyConfig",
    MaxLength = 20,
    Flag = "ConfigName"
})

TabSettings:CreateButton({
    Title = "Save Config",
    Callback = function()
        -- In a real scenario, integrate with SaveManager
        Noire:Notify({
            Title = "Saved",
            Content = "Configuration saved successfully.",
            Type = "Success"
        })
    end
})

TabSettings:CreateButton({
    Title = "Destroy UI",
    Description = "Removes the UI completely",
    Callback = function()
        Window:Destroy()
    end
})
