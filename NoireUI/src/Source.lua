--[[
    Noire UI - Main Library File
    Premium UI Library for Roblox Executor Scripts
    Author: Noire Team
    Version: 1.0.0
]]--

local HttpService = game:GetService("HttpService")

local NoireUI = {}

-- Load internal modules
-- In a real scenario these would be bundled into one file by a builder
-- For development, we load them dynamically from the src folder
local repo = "https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/"
local function require_url(path)
    return loadstring(game:HttpGet(repo .. path))()
end

local Utilities = require_url("utilities.lua")
local Themes = require_url("themes.lua")
local SetupNotifications = require_url("notifications.lua")
local CreateWindow = require_url("window.lua")

NoireUI.Flags = {}
NoireUI.Windows = {}

-- Internal configuration and saving system
local SaveManager = {
    Folder = "NoireUI_Configs",
    File = "default.json",
    Enabled = false
}

function SaveManager:Init(folderName)
    self.Enabled = true
    if folderName then self.Folder = folderName end
    
    if isfolder and not isfolder(self.Folder) then
        makefolder(self.Folder)
    end
end

function SaveManager:SaveConfig(fileName)
    if not self.Enabled or not isfile then return false end
    local name = fileName or self.File
    local path = self.Folder .. "/" .. name
    
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(NoireUI.Flags)
    end)
    
    if success then
        writefile(path, encoded)
        return true
    end
    return false
end

function SaveManager:LoadConfig(fileName)
    if not self.Enabled or not isfile then return false end
    local name = fileName or self.File
    local path = self.Folder .. "/" .. name
    
    if isfile(path) then
        local content = readfile(path)
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(content)
        end)
        
        if success and type(decoded) == "table" then
            for key, value in next, decoded do
                -- In a full implementation, we would dispatch events to update UI elements here
                NoireUI.Flags[key] = value
            end
            return true
        end
    end
    return false
end

NoireUI.SaveManager = SaveManager

-- Main API

function NoireUI:CreateWindow(options)
    options = options or {}
    
    -- Setup Theme
    local themeData
    if type(options.Theme) == "table" then
        themeData = Themes.custom("Midnight", options.Theme) -- Override base with custom
    else
        themeData = Themes.get(options.Theme or "Midnight")
    end
    
    -- Setup Save Config
    if options.SaveConfig then
        SaveManager:Init(options.ConfigFolder)
    end

    -- Create Window & Gui
    local windowObj, screenGui = CreateWindow(Utilities, themeData, self.Flags, options, nil)
    
    -- Setup Notifications
    local notifSystem = SetupNotifications(Utilities, themeData)
    windowObj.Notify = function(_, notifOptions)
        notifSystem:Notify(notifOptions)
    end
    
    -- Expose Notify globally on library instance
    self.Notify = function(_, notifOptions)
        notifSystem:Notify(notifOptions)
    end

    table.insert(self.Windows, windowObj)
    return windowObj
end

function NoireUI:GetTheme(name)
    return Themes.get(name)
end

function NoireUI:Destroy()
    for _, win in ipairs(self.Windows) do
        win:Destroy()
    end
    self.Windows = {}
end

return NoireUI
