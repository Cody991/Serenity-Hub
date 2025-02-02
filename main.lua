local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local gameId = game.GameId
local placeId = game.PlaceId

local supportedGames = {
    [2788229376] = "DaHood.lua",
    [286090429] = "Arsenal.lua"
}

local function loadGameScript()
    local scriptToLoad = supportedGames[placeId] or supportedGames[gameId]
    
    if scriptToLoad then
        local success, result = pcall(function()
            local url = "https://raw.githubusercontent.com/Cody991/Serenity-Hub/main/" .. scriptToLoad
            return game:HttpGet(url, true)
        end)
        
        if success and result then
            local loadSuccess, loadError = pcall(function()
                local fn = loadstring(result)
                if type(fn) == "function" then
                    fn()
                else
                    error("Failed to compile script")
                end
            end)
            
            if not loadSuccess then
                warn("[Serenity Hub] Error loading script:", loadError)
            end
        else
            warn("[Serenity Hub] Failed to fetch script:", result)
        end
    else
        warn("[Serenity Hub] This game is not currently supported! Game ID:", placeId)
    end
end

pcall(loadGameScript)
