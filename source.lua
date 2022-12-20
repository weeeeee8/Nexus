local USER = 'weeeeee8'
local BUILD = 'main'

local env = assert(getgenv, 'Current exploit executor is not supported, recommended to use KRNL or Synapse for this.')()

local function hasGlobal(key)
    return env[key]
end

local function makeGlobal(key, value, overrideGlobal)
    if not hasGlobal(key) or overrideGlobal then
        env[key] = value
    else
        error(string.format('Global "%s" is already defined', key), 2)
    end
end

local function removeGlobal(key)
    if hasGlobal(key) then
        local global = env[key]
        if typeof(global) == "function" then
            global()
        elseif type(global) == "table" then
            if global.Destroy then
                global:Destroy()
            end
        elseif typeof(global) == "RBXScriptConnection" then
            global:Disconnect()
        end
        env[key] = nil
    end
end

makeGlobal('ifexterned', hasGlobal)
makeGlobal('extern', makeGlobal)
makeGlobal('gcg', removeGlobal)

makeGlobal('__USER__', USER)
makeGlobal('__BUILD__', BUILD)
makeGlobal('__NEXUS_FILE_PATH__', 'nexus.config')
makeGlobal('__NEXUS_FILE_CONSTANTS__', {
    save_path = __NEXUS_FILE_PATH__ .. '/saved-data',
    userdata_path = __NEXUS_FILE_PATH__ .. '/userdata'
})

local import = loadstring(game:HttpGet(string.format('https://raw.githubusercontent.com/%s/Nexus/%s/src/env/util/Import.lua', USER, BUILD)), 'Import.lua')()

makeGlobal('import', import)

import:CreateDirectory('env/lib')
import:CreateDirectory('env/util')
import:CreateDirectory('scripts')
import('env/main').Default()