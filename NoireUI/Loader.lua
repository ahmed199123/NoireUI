--[[
    Noire UI - Loader
    Use this script to load the UI library in your executor.
    
    Usage:
    local Noire = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asser/NoireUI/main/Loader.lua"))()
]]--

local url = "https://raw.githubusercontent.com/ahmed199123/NoireUI/main/NoireUI/src/Source.lua"

local success, result = pcall(function()
    return loadstring(game:HttpGet(url))()
end)

if success then
    return result
else
    warn("Failed to load Noire UI: " .. tostring(result))
    -- Fallback for local testing (only works if running from a local environment that supports loadfile)
    local fallbackSuccess, fallbackResult = pcall(function()
        return loadfile("NoireUI/src/Source.lua")()
    end)
    if fallbackSuccess then return fallbackResult end
end

return nil
