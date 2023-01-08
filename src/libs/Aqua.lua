if not KRNL_LOADED then
    error('this exploit only supports krnl')
end

if __AQUA_INIT__ then
    console.input('Terminate framework?', '@@BROWN@@')
    if __AQUA_INTERNAL__ then
        __AQUA_INTERNAL__:terminate()
        console.log('Terminated successfully!', '@@GREEN@@')
    else
        console.log('There was no running Aqua frameworks!', '@@RED@@')
    end
    task.wait(5)
    console.clear()
    rconsoleclose()
    __AQUA_INIT__ = nil
end

do
    local env = assert(getgenv, 'current executor does not support "getgenv" method.')()
    if not __GLOBAL__ then
        env.__GLOBAL__ = setmetatable({}, {
            __index = function(_,k)
                return env[k]
            end,
            __newindex = function(_, k, v)
                env[k] = v
            end
        })
    end

    if not import then
        local webimportapi = loadstring(game:HttpGet('https://raw.githubusercontent.com/weeeeee8/Nexus/main/src/libs/WebImport.lua'), 'webimportapi')
        env.import = webimportapi
    end

    if not console then
        env.console = {
            log = function(message: string, color: string?)
                color = color or "@@WHITE@@"
                rconsoleprint(color)
                rconsoleprint(message..'\n')
            end,
            input = function(message, color)
                console.log(message, color)
                rconsoleinput()
            end,
            assert = function(condition, message)
                if not condition then
                    console.log(message, "@@RED@@")
                    console.log(debug.traceback(), "@@BROWN@@")
                    error('aqua internal error, please refer to the console window for information')
                end
                return condition
            end,
            clear = rconsoleclear
        }
    end
end

return function(initFn)
    print(1)
    if __AQUA_INIT__ then
        console.log('Cannot create a new Aqua window without terminating the old one!')
        return
    end
    print(2)
    rconsolename('aqua')
    console.log('Initializing Aqua', '@@BROWN@@')
    local igniteManager = import('/modules/aqua/main.lua')
    console.log('Aqua has been initialized!', '@@GREEN@@')
    igniteManager()
    print(igniteManager)
    if initFn then
        console.log('Initializing script caller(s)', '@@BROWN@@')
        local reducerTemplate = initFn()
        local reducer = function(state, action)
            local newState = state or {
                WindowShown = true,
                Theme = "Dark",
                ActivePageTitle = "None"
            }

            if action.type == "HideWindow" then
                newState.WindowShown = false
            elseif action.type == "ShowWindow" then
                newState.WindowShown = true
            elseif action.type == "UpdateActiveTitle" then
                newState.ActivePageTitle = action.pageTitle
            end

            if reducerTemplate then
                reducerTemplate(newState, action)
            end

            return newState
        end

        __GLOBAL__.__AQUA_STORE__ = GetAquaService('RoactService').Rodux.Store.new(reducer)
        console.log('Script caller(s) has been initialized!', '@@GREEN@@')
    end
    task.wait(1)
    console.clear()
    console.log('[DEBUG INFORMATION ARE SHOWN HERE]')
end