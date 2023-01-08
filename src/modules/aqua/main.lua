local env = assert(getgenv, 'current executor does not support "getgenv" method.')()

local aqua_service = game:FindFirstChild("Aqua")
if not aqua_service then
    aqua_service = Instance.new("Folder")
    aqua_service.Name = "Aqua"
    aqua_service.Parent = game

    local services = {}
    local function _import_and_save(asset, serviceName)
        console.assert(asset:find('rbxassetid://'), 'service "' .. serviceName .. '" is not a service (is considered a service when an imported asset is from the roblox marketplace, not github!)')
        local service = import(asset)
        console.assert(service:IsA('ModuleScript'), 'service "' .. serviceName .. '" must be a module script')
        service.Name = serviceName
        service.Parent = aqua_service
        services[serviceName] = service
    end
    local function _link_util_class_as_service(serviceName, utilClassName)
        local service = console.assert(services[serviceName], 'service "' .. serviceName .. '" cannot be found')
        services[utilClassName] = service[utilClassName .. 'Service']
    end

    _import_and_save('rbxassetid://10669647943', 'RoactService')
    _import_and_save('rbxassetid://12079824279', 'MaidService')
    _link_util_class_as_service('RoactService', 'Signal')

    env.GetAquaService = function(serviceName)
        return console.assert(services[serviceName], 'service "' .. serviceName .. '" cannot be found')
    end
end

return function()
    __GLOBAL__.__AQUA_INIT__ = true

    __GLOBAL__.__AQUA_MAID__ = GetAquaService('MaidService').new()
    __GLOBAL__.__AQUA_INTERNAL__ = {
        terminate = function(self)
            if __AQUA_ROACT_HANDLER__ then
                GetAquaService('MaidService').Roact.unmount(__AQUA_ROACT_HANDLER__)
                __GLOBAL__.__AQUA_ROACT_HANDLER__ = nil
            end

            if __AQUA_MAID__ then
                __AQUA_MAID__:DoCleaning()
                __GLOBAL__.__AQUA_MAID__ = nil
            end
        end
    }

    __GLOBAL__.Aqua = import('/modules/aqua/src/ui/main.lua')
    print(__GLOBAL__, __GLOBAL__.Aqua)
end