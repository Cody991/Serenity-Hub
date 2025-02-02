local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local gameId = game.GameId
local placeId = game.PlaceId

local supportedGames = {
    [2788229376] = "DaHood.lua",
    [286090429] = "Arsenal.lua" -- Added Arsenal game ID
}

local function loadGameScript()
    local scriptToLoad = supportedGames[placeId] or supportedGames[gameId]
    
    if scriptToLoad then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Cody991/Serenity-Hub/main/Games/"..scriptToLoad))()
    else
        warn("[Serenity Hub] This game is not currently supported!")
    end
end

loadGameScript()
