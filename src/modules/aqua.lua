_GLOBAL__.__AQUA_SRC_PATH__ = function(path)
    return '/packages/aqua' .. path
end

local AquaAPI = Aqua.Import(__AQUA_SRC_PATH__('/Utility/AquaAPI.lua'))

return {
    __API__ = AquaAPI,
    GetPackage = AquaAPI.GetPackage,
}