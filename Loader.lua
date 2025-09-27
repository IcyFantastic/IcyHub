-- Branch default (kalau nggak diset manual, pake "main")
local Branch = getgenv().Branch or "main"

-- Base URL repo
local baseUrl = ("https://github.com/IcyFantastic/IcyHub/raw/%s/Game/"):format(Branch)

-- Set versi script (biar nggak fallback ke "Dev Mode")
getgenv().ScriptVersion = Branch == "dev" and "Dev Mode" or "v1.0.0"

-- Game ID
local GameId = game.GameId

-- Loader
if GameId == 7074860883 then
    loadstring(game:HttpGet(baseUrl .. "AC.lua"))()
elseif GameId == 7314989375 then
    loadstring(game:HttpGet(baseUrl .. "H.lua"))()
elseif GameId == 7095682825 then
    loadstring(game:HttpGet(baseUrl .. "B.lua"))()
elseif GameId == 7436755782 then
    loadstring(game:HttpGet(baseUrl .. "GaG.lua"))()
elseif GameId == 5682590751 then
    loadstring(game:HttpGet(baseUrl .. "L.lua"))()
else
    warn("[IcyHub Loader] Game not supported: " .. GameId)
end
