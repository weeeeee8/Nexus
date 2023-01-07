local RoactService = GetAquaService('RoactService')

local NavlinkComponent = import('/modules/aqua/src/ui/components/navlink.lua')
local ContainerComponent = import('/modules/aqua/src/ui/components/container.lua')

local e, f, r, b = RoactService.Roact.createElement, RoactService.Roact.createFragment, RoactService.Roact.createRef, RoactService.Roact.createBinding

local function constructUIListLayout(direction)
    return e('UIListLayout', {
        Padding = UDim.new(0, 2),
        FillDirection = direction,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    })
end

local function constructUIPadding()
    return e('UIPadding', {
        PaddingLeft = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5),
    })
end

local Navbar = RoactService.Roact.Component:extend('aqua.navbar')
function Navbar:init()
end

function Navbar:getAnchorListFragment()
    local anchors = {}

    local router = self.props.router
    for _, route in ipairs(router._routes) do
        anchors[route.title] = e(NavlinkComponent, {
            Icon = route.anchorInfo.Icon,
            AltText = route.anchorInfo.AltText,
            Style = self.props.Style,
        })
    end

    return f(anchors)
end

function Navbar:render()
    if self.props.Style == "Horizontal" then
        return e(ContainerComponent, {
            ContainerScrollable = true,
            ContainerFlexes = true,
            ContainerFlexedSize = UDim2.new(1, 0, 0, 30),
            ContainerFlexedPosition = UDim2.fromScale(1, 0),
            ContainerFlexedAnchor = Vector2.new(0.5, 0),
        }, {
            scroll = e('ScrollingFrame', {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ScrollbarThickness = 2,
                ScrollingDirection = Enum.ScrollingDirection.X,
                ScrollbarImageColor3 = Color3.fromRGB(245, 245, 245)
            }, {
                list = constructUIListLayout(Enum.FillDirection.Horizontal),
                padding = constructUIPadding(),
                self:getAnchorListFragment(),
            })
        })
    elseif self.props.Style == "Vertical" then
        return e(ContainerComponent, {
            ContainerFlexes = true,
            ContainerFlexedSize = UDim2.new(0, 30, 1, 0),
            ContainerFlexedPosition = UDim2.fromScale(1, 0),
            ContainerFlexedAnchor = Vector2.new(0.5, 0),
        }, {
            scroll = e('ScrollingFrame', {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ScrollbarThickness = 2,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                ScrollbarImageColor3 = Color3.fromRGB(245, 245, 245)
            }, {
                list = constructUIListLayout(Enum.FillDirection.Vertical),
                padding = constructUIPadding(),
                self:getAnchorListFragment(),
            })
        })
    end
end

Navbar = RoactService.RoactRodux.connect(function(state, props)
    table.move(state, 1, #state, #props+1, props)
    return props
end)(Navbar)

return Navbar