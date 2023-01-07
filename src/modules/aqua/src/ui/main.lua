local RoactService = GetAquaService('RoactService')
local MaidService = GetAquaService('MaidService')

local WINDOW_PARENT = if gethui then gethui() else game:GetService("CoreGui")

local components = {} do
    coroutine.wrap(function()
        local componentsPath = '/modules/aqua/src/ui/components/'
        for _, componentName in {
            'Window', 'Head', 'Container'
        } do
            components[componentName] = import(componentsPath .. componentName:lower() .. '.lua')
        end
    end)()
end

return {
    construct = function(componentName, props, children)
        return RoactService.Roact.createElement(console.assert(components[componentName], 'component "' .. componentName .. '" does not exist!'), props, children)
    end,
    start = function(windowObject)
        local app = RoactService.Roact.createElement(RoactService.RoactRodux)
        __GLOBAL__.__AQUA_ROACT_HANDLER__ = RoactService.Roact.mount(windowObject, WINDOW_PARENT)
    end
}