# 🌌 Noire UI Premium

A modern, luxury, glassmorphism-inspired UI library for Roblox Executor Scripts (Luau). Designed with fluid animations, dynamic themes, and a highly modular component architecture.

![Noire UI Version](https://img.shields.io/badge/Version-1.0.0-8B5CF6?style=for-the-badge)
![Luau](https://img.shields.io/badge/Language-Luau-00A2FF?style=for-the-badge&logo=lua)

## ✨ Features

- **Premium Design:** Dark luxury aesthetic with smooth accent gradients.
- **Fluid Animations:** Spring physics, ripple effects, hover transitions, and glowing elements.
- **Theme Engine:** 6 built-in themes (Midnight, Obsidian, Crimson, Emerald, Amethyst, Arctic) with support for full custom theme creation.
- **Complete Component Suite:**
  - 🔘 Buttons (with descriptions & ripple effects)
  - 🎚️ Sliders (gradient fill, animated thumb)
  - 🔄 Toggles (sliding animated switch with glow)
  - 📜 Dropdowns (single and multi-select support)
  - ⌨️ Inputs (with validation and focus effects)
  - 🔑 Keybinds (interactive capture system)
  - 🎨 Color Pickers (Full HSV map + Hex input)
- **Advanced Notification System:** Slide-in toasts with progress bars and action buttons.
- **Window Management:** Draggable, responsive, Sidebar navigation, background blur, and shadow drops.
- **SaveManager Integration:** Easily save and load flag configurations via JSON.

## 🚀 Quick Start (Loader)

Load the library directly in your executor using our secure loader:

```lua
local Noire = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/Loader.lua"))()

local Window = Noire:CreateWindow({
    Title = "My Premium Hub",
    Subtitle = "v1.0",
    Theme = "Midnight", -- Midnight, Obsidian, Crimson, Emerald, Amethyst, Arctic
    Size = UDim2.new(0, 580, 0, 460),
    ToggleKey = Enum.KeyCode.RightControl,
    SaveConfig = true,
    ConfigFolder = "MyScriptConfig"
})

local Tab = Window:CreateTab({
    Title = "Main",
    Icon = "rbxassetid://10828073860"
})

Tab:CreateButton({
    Title = "Execute Action",
    Description = "Click this to do something awesome",
    Callback = function()
        Noire:Notify({
            Title = "Success",
            Content = "Action executed!",
            Type = "Success"
        })
    end
})
```

## 📚 Component Examples

### Toggle
```lua
Tab:CreateToggle({
    Title = "Auto Farm",
    Description = "Automatically farm enemies",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        print("Auto Farm:", Value)
    end
})
```

### Slider
```lua
Tab:CreateSlider({
    Title = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    Suffix = " WS",
    Flag = "SpeedSlider",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})
```

### Dropdown
```lua
Tab:CreateDropdown({
    Title = "Select Target",
    Options = {"Head", "Torso", "Random"},
    Default = "Head",
    MultiSelect = false,
    Flag = "TargetPart",
    Callback = function(Value)
        print("Targetting:", Value)
    end
})
```

### Color Picker
```lua
Tab:CreateColorPicker({
    Title = "ESP Color",
    Default = Color3.fromRGB(139, 92, 246),
    Flag = "ESPColor",
    Callback = function(Color)
        print("New Color Selected!")
    end
})
```

## 🛠️ Custom Themes

You can pass a custom table instead of a string to the `Theme` parameter:

```lua
local Window = Noire:CreateWindow({
    Title = "Custom Theme",
    Theme = {
        Accent = {
            Primary = Color3.fromRGB(255, 100, 100),
            Secondary = Color3.fromRGB(200, 50, 50)
        },
        Window = {
            Background = Color3.fromRGB(15, 15, 15)
        }
    }
})
```

## 📜 License

MIT License - Free to use and modify. Please credit the original authors.
