local RoactService = GetAquaService('RoactService')

local RoactRouter = import('/modules/RoactRouter.lua')

local WINDOW_PARENT = if gethui then gethui() else game:GetService("CoreGui")

local components = {} do
    coroutine.wrap(function()
        local componentsPath = '/modules/aqua/src/ui/components/'
        for _, componentName in {
            'Window', 'ContainerBackground', 'Container',
            'Navbar',
        } do
            components[componentName] = import(componentsPath .. componentName:lower() .. '.lua')
        end
    end)()
end

return {
    router = function()
        return RoactRouter.new()
    end,
    construct = function(componentName, props, children)
        return RoactService.Roact.createElement(console.assert(components[componentName], 'component "' .. componentName .. '" does not exist!'), props, children)
    end,
    start = function(windowObject)
        local success, err = pcall(function()
            local app = RoactService.Roact.createElement(RoactService.RoactRodux.StoreProvider, {
                store = __AQUA_STORE__
            }, {
                Aqua = windowObject
            })
            __GLOBAL__.__AQUA_ROACT_HANDLER__ = RoactService.Roact.mount(app, WINDOW_PARENT)
        end)

        if not success then
            console.log(err, "@@RED@@")
        end
    end
}