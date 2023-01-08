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
    self.imageBackgroundColor, self.updateImageBackgroundColor = b(Constants.AquaThemeContext[self.props.Theme].Navlink['Backkground' .. if self.props.Title == self.props.ActivePageTitle then "Active" else "Default"])
    self.iconColor, self.updateIconColor = b(Constants.AquaThemeContext[self.props.Theme].Navlink['Backkground' .. if self.props.Title == self.props.ActivePageTitle then "Default" else "Active"])
end

function Navlink:getIcon()
    if self.props.Icon then
        return e('ImageLabel', {
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.fromScale(0, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Image = self.Image
        })
    end

    return nil
end

function Navlink:constructInteractionButton()
    return e('ImageButton', {
        ImageTransparency = 1,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),

        [RoactService.Roact.Event.MouseButton1Click] = function()
            self.RouterObj:goto(self.props.Reference):refresh()
        end
    })
end

function Navlink:render()
    if self.props.Title == self.props.ActivePageTitle then
        self.updateImageBackgroundColor(Constants.AquaThemeContext[self.props.Theme].Navlink.BackgroundActive)
        self.updateIconColor(Constants.AquaThemeContext[self.props.Theme].Navlink.BackgroundDefault)
    else
        self.updateImageBackgroundColor(Constants.AquaThemeContext[self.props.Theme].Navlink.BackgroundDefault)
        self.updateIconColor(Constants.AquaThemeContext[self.props.Theme].Navlink.BackgroundActive)
    end

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

                ImageColor3 = self.imageBackgroundColor
            }, {
                padding = constructUIPadding(),
                icon = self:getIcon(),
            }),
        })
    elseif self.props.Style == "Vertical" then
        return e('Frame', {
            Size = UDim2.fromOffset(25, 25),
            BackgroundTransparency = 1,
        }, {
            icon = self:getIcon(),
        })
    end
end

Navlink = RoactService.RoactRodux.connect(function(state, props)
    table.move(state, 1, #state, #props+1, props)
    return props
end)(Navlink)

return Navlink