local Packages = {}
local function ImportPackage(packageName: string)
    local name = packageName:lower()
    local package = Aqua.Import(string.format('/modules/%s.lua', name))
    Packages[name:sub(1, 1):upper()..name:sub(2,#name)] = package
    return package
end

local function GetPackage(packageName: string)
    local foundPackage = Packages[packageName]
    if not foundPackage then
        foundPackage = ImportPackage(packageName)
    end
    return foundPackage
end

local function connectCrossComms(outbound) -- inner boud
    return function(relays) -- middle bound
        outbound(relays)
    end
end

ImportPackage("maid")
ImportPackage("fusion")
ImportPackage("hooks")

return {
    GetPackage = GetPackage,
    UI = setmetatable({
        Fusion = GetPackage("Fusion"),
        RenderComponent = Aqua.Import(__AQUA_SRC_PATH__("/UI/RenderComponent.lua")),
    }, {
        __index = function(s, k)
            return rawget(s, k)
        end,
        __newindex = function(_, k)
            Aqua.Console.Warn('cannot assign property "' .. k .. '" on Aqua')
        end
    }),

    ConnectCrossCommunication = connectCrossComms,
    CrossCommunicationMarker = Aqua.Symbol("CrossCommunicationMarker")
}