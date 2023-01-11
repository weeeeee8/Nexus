local HttpService = game:GetService("HttpService")

game:GetService("StarterGui"):SetCore("SendNotification", {
    Ttile = "Aqua InitService",
    Text = "If you aren't notified within the next 5 seconds, kindly tap the F9 key on your keyboard to check console!"
})

if not KRNL_LOADED then
    error("aqua framework only supports krnl at the moment")
end

local env = assert(getgenv, "current exploit executor does not have the 'getgenv' method in it's API")
if not __GLOBAL__ then
    env.__GLOBAL__ = setmetatable({}, {
        __index = function(_, k) return env[k] end,
        __newindex = function(_, k, v) env[k] = v end
    })
end

if not Aqua then
    local function parseError()
        return {
            time = DateTime.now():FormatLocalTime("LTS", "en-us"),
            traceback = debug.traceback()
        }
    end

    local function serializeData(data)
        if typeof(data) == "CFrame" then
            return table.concat(data:GetComponents(), ",")
        elseif typeof(data) == "Vector3" then
            return table.concat({data.X, data.Y, data.Z}, ",")
        elseif type(data) == "string" or type(data) == "number" then
            return tostring(data)
        elseif type(data) == "table" then
            return HttpService:JSONEncode(data)
        else
            Aqua.Console.Error("unsupported datatype")
        end
    end

    local function makeSymbol(name)
        local proxy = newproxy(true)
        getmetatable(proxy).__tostring = function()
            return string.format('Symbol<%s>', name)
        end
        return proxy
    end

    local Console = {}
    Console.Inline = function(message: string, color: string?)
        color = if color then string.format("@@%s@@", color:gsub("@", ""):gsub(" ", "_"):upper()) else "@@WHITE@@"
        rconsoleprint(color)
        rconsoleprint(message)
    end
    Console.Log = function(message: string, color: string?)
        Console.Inline(string.format("%s\n", message), color)
    end
    Console.Print = function(message)
        local stringLiteral = serializeData(message)
        Console.Log(stringLiteral)
    end
    Console.Warn = function(message)
        local stringLiteral = serializeData(message)
        Console.Log(string.format("[WARNING] %s", stringLiteral), "brown")
    end
    Console.Error = function(message)
        local stringLiteral = serializeData(message)
        local errorInfo = parseError()
        Console.Log(string.format('[%s] %s\n-TRACEBACK-\n%s', errorInfo.time, stringLiteral, errorInfo.traceback), "light red")
    end
    Console.Input = function(message: string, messageColor: string?)
        Console.Log(message, messageColor)
        return rconsoleinput()
    end
    Console.Terminate = function()
        Console.Inline("Terminate Console? [Press any key]", "red")

        local function processFeedback()
            local feedback = Console.Inline("Are you sure? [y/n]", "red"):lower():sub(1, 1)
            if feedback == "y" then
                rconsoleclose()
                if __AQUA_MAID__ then
                    __AQUA_MAID__:DoCleaning()
                    __GLOBAL__.__AQUA_MAID__ = nil
                end

                if __AQUA_HOOKS__ then  
                    __AQUA__HOOKS__:ResetAll()
                    __GLOBAL__.__AQUA__HOOKS__ = nil
                end

                table.clear(env.Aqua)
                env.Aqua = nil

                return true
            elseif feedback == "n" then
                rconsoleclear()
                Console.Log("[CONSOLE]", "blue")

                return false
            else
                processFeedback()
            end
        end
        
        return processFeedback()
    end

    local _user = "weeeeeee8"
    local _branch = "main"
    local _url = string.format("https://raw.githubusercontent.com/%s/AquaUI/%s/src/modules/import.lua", _user, _branch)
    local Import = loadstring(game:HttpGet(_url), 'AquaImport')()

    local AquaAPI = Import('/modules/aqua.lua')
    env.Aqua = setmetatable({
        Symbol = makeSymbol,
        Console = Console,
        Import = Import,
    }, {
        __index = function(self, key)
            return rawget(self, key) or AquaAPI[key]
        end,
        __newindex = function(_, k, _)
            Aqua.Console.Warn(string.format('cannot assign property "%s" on the Aqua module', k))
        end
    })

    __GLOBAL__.__AQUA_MAID__ = Aqua.GetPackage("Maid").new()
    __GLOBAL__.__AQUA__HOOKS__ = AquaAPI.GetPackage("Hooks").new()
else
    -- We still have an Aqua global running
    Aqua.Console.Warn("Relaunching aqua...")
    Aqua.Console.Terminate()
end

return true