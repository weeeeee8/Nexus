local HttpService = game:GetService("HttpService")

local safe_makefolder = function(folderpath)
    local some = pcall(readfile, foldername)
    if not some then
        makefolder(folderpath)
    end
end
__GLOBAL__.safe_makefolder = safe_makefolder

local FOLDER_NAME = 'aqua'
local CONFIGURATION_FOLDER_PATH = 'aqua/config'
local FLAG_SETTINGS_FOLDER_PATH = 'aqua/flags'

safe_makefolder(FOLDER_NAME)
safe_makefolder(CONFIGURATION_FOLDER_PATH)
safe_makefolder(FLAG_SETTINGS_FOLDER_PATH)

return {
    constants = {
        CONFIGURATION_FOLDER_PATH = CONFIGURATION_FOLDER_PATH,
        FLAG_SETTINGS_FOLDER_PATH = FLAG_SETTINGS_FOLDER_PATH,
        FOLDER_NAME = FOLDER_NAME
    },
    writeFlagStorageFile = function(name, src) -- use 1 single file for this shit
        local path = FLAG_SETTINGS_FOLDER_PATH .. '/' .. name:lower()
        if not type(src) == "string" then
            console.assert(type(src) == "table", 'argument 2 must be a table')
            src = HttpService:JSONEncode(src)
        end
        writefile(path, src or "")
    end,
    readFlagStorageFile = function(name)
        local path = FLAG_SETTINGS_FOLDER_PATH .. '/' .. name:lower()
        local foundfile, src = pcall(isfile, path)
        if not foundfile then
            console.log('could not find settings "' .. name .. '"', "@@BROWN@@")
            return nil
        end
        return HttpService:JSONDecode(src)
    end
}