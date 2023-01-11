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

ImportPackage("maid")
ImportPackage("fusion")
ImportPackage("hooks")

return {
    GetPackage = GetPackage,
}