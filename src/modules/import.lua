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
    elseif assetOrUrl:find("https://", 1) then
        local _tbl = string.split(assetOrUrl, "/")
        foundPackage = loadstring(game:HttpGet(url .. assetOrUrl), _tbl[# _tbl])()
    else
        local errMsg = string.format('"%s" is faulty or unsupported URL.', assetOrUrl)
        if Aqua then
            Aqua.Console.Error(errMsg)
            Aqua.Console.Terminate()
        else
            error(errMsg)
        end
    end

    importCache[assetOrUrl] = foundPackage
    return foundPackage
end