local RoactService = GetAquaService('RoactService')

local e, f, r, b = RoactService.Roact.createElement, RoactService.Roact.createFragment, RoactService.Roact.createRef, RoactService.Roact.createBinding

local Window = RoactService.Roact.Component:extend('aqua-internal.window')
function Window:init()
end

function Window:render()
    return e('ScreenGui', {
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    })
end

return Window