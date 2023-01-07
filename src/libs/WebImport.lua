
local user = 'weeeeee8'
local build = 'main'
local url  = string.format('https://raw.githubusercontent.com/%s/Nexus/%s/src', user, build)

local importCache = {}

return function(assetOrRoute, ...)
    if importCache[assetOrRoute] then
        return importCache[assetOrRoute]
    end

    local foundObject
    if type(assetOrRoute) == "number" then
        foundObject = game:GetObjects(assetOrRoute)[1]
    else
        local src = loadstring(game:HttpGet(url .. assetOrRoute))()
        if typeof(src) == "function" then
            src = src(...)
        end
        foundObject = src
    end
    importCache[assetOrRoute] = foundObject

    return foundObject
end