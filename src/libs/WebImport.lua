
local user = 'weeeeee8'
local build = 'main'
local url  = string.format('https://raw.githubusercontent.com/%s/Nexus/%s/src', user, build)

local importCache = {}

return function(assetOrRoute, ...)
    if importCache[assetOrRoute] then
        return importCache[assetOrRoute]
    end

    local foundObject
    local success, err = pcall(function(...)
        if assetOrRoute:find("rbxassetid://") then
            foundObject = game:GetObjects(assetOrRoute)[1]
        else
            local src = loadstring(game:HttpGet(url .. assetOrRoute))()
            if typeof(src) == "function" then
                src = src(...)
            end
            print(typeof(src), assert)
            foundObject = src
        end
    end, ...)

    if success then
        importCache[assetOrRoute] = foundObject

        return foundObject
    else
        console.log(err, "@@RED@@")
        return {}
    end
end