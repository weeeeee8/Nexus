local RoactService = GetAquaService('RoactService')

local Constants = import('/modules/aqua/src/ui/util/Constants.lua')

local e, f, r, b = RoactService.Roact.createElement, RoactService.Roact.createFragment, RoactService.Roact.createRef, RoactService.Roact.createBinding

local function constructUIPadding()
    return e('UIPadding', {
        PaddingLeft = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5),
    })
end

local Navlink = RoactService.Roact.Component:extend('aqua-internal.navlink')
function Navlink:init()
    self.imageBackgroundColor, self.updateImageBackgroundColor = b(Constants.AquaThemeContext[self.props.Theme].Navlink.BackgroundDefault)
end

function Navlink:render()
    if self.props.Style == "Horizontal" then
        return e('Frame', {
            Size = UDim2.new(0, 40, 1, 0),
            BackgroundTransparency = 1,
        }, {
            bg = e('ImageLabel', {
                BackgroundTransparency = 1,
                Image = 'rbxassetid://3570695787',
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(100, 100, 100, 100),
                SliceScale = 0.5,

                ImageColor3 = 
            }, {
                padding = constructUIPadding()
            }),
        })
    elseif self.props.Style == "Vertical" then
        return e('Frame', {
            Size = UDim2.fromOffset(25, 25),
            BackgroundTransparency = 1,
        })
    end
end

Navlink = RoactService.RoactRodux.connect(function(state, props)
    table.move(state, 1, #state, #props+1, props)
    return props
end, function(dispatch)
    return {
        changeRouterTarget = function(pageTitle)
            dispatch({
                type = "RequestRouterGoto",
                title = pageTitle
            })
        end
    }
end)(Navlink)

return Navlink