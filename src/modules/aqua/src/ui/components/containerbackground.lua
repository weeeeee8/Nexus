local RoactService = GetAquaService('RoactService')

local Constants = import('/modules/aqua/src/ui/util/Constants.lua')

local e, f, r, b = RoactService.Roact.createElement, RoactService.Roact.createFragment, RoactService.Roact.createRef, RoactService.Roact.createBinding

local ContainerBackground = RoactService.Roact.Component:extend('aqua.window')
function ContainerBackground:init()
end

function ContainerBackground:render()
    if self.props.Image then
    else
        return e('Frame', {
            BorderSizePixel = 0,
            BackgroundColor3 = Constants.AquaThemeContext[self.props.Theme].Color,
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
    end
end

ContainerBackground = RoactService.RoactRodux.connect(function(state, props)
    table.move(state, 1, #state, #props+1, props)
    return props
end)(ContainerBackground)

return ContainerBackground