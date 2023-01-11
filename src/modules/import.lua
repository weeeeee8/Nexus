local user = "weeeeee8"
local branch = "main"
local url = string.format("https://raw.githubusercontent.com/%s/AquaUI/%s/src", user, branch)

local importCache = {}

return function(assetOrUrl: string)
    if importCache[assetOrUrl] then
        return importCache[assetOrUrl]
    end

    local foundPackage
    if assetOrUrl:find("rbxassetid://", 1) then
        foundPackage = game:GetObjects(assetOrUrl)[1]
    else
        local _tbl = string.split(assetOrUrl, "/")
        foundPackage = loadstring(game:HttpGet(url .. assetOrUrl), _tbl[# _tbl])()
    end

    importCache[assetOrUrl] = foundPackage
    return foundPackage
end