local RoactService = GetAquaService('RoactService')

local e, f, r, b = RoactService.Roact.createElement, RoactService.Roact.createFragment, RoactService.Roact.createRef, RoactService.Roact.createBinding

local Container = RoactService.Roact.Component:extend('aqua.container')
function Container:init()
    self.containerRef = r()
    self.groupTransparency, self.updateGroupTransparency = b(1)
    self.dragPosition, self.updateDragPosition = b(UDim2.fromScale(0.5, 0.5))
    self.tweenGroupTransparency = RoactService.Otter.createSingleMotor(0)
    self.tweenGroupTransparency:onStep(function(a)
        self.updateGroupTransparency(a)
    end)
end

function Container:didMount()
    local container = self.containerRef:getValue()
    if container then
        if self.props.Draggable then
            local can_drag = false
            local drag_start
            local container_origin
            container.InputBegan:Connect(function(input)
                can_drag = true
                drag_start = input.Position
                container_origin = container.Position
            end)
            container.InputEnded:Connect(function()
                can_drag = false
            end)
            container.MouseMoved:Connect(function(x, y)
                if can_drag then
                    local delta = Vector2.new(x - y) - drag_start
                    self.updateDragPosition(UDim2.new(container_origin.X.Scale, container_origin.X.Offset + delta.X, container_origin.Y.Scale, container_origin.Y.Offset + delta.Y))
                end
            end)
        end
    else
        if self.props.Draggable then
            console.log('a container element has the "Draggable" property on but was not initialized! hence, this element cannot be dragged', '@@BROWN@@')
        end
    end
end

function Container:render()
    if self.props.WindowShown then
        self.tweenGroupTransparency:setGoal(RoactService.Otter.spring.new(0, {frequency = 4}))
    else
        self.tweenGroupTransparency:setGoal(RoactService.Otter.spring.new(1, {frequency = 4}))
    end

    return e('CanvasGroup', {
        [RoactService.Roact.Ref] = self.containerRef,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        GroupTransparency = self.groupTransparency,
        ZIndex = 50,
        Size = if self.props.ContainerFlexes then (self.props.ContainerFlexedSize or UDim2.fromScale(1, 1)) else (self.props.ContainerSize or UDim2.fromOffset(50, 50)),
        Position = if self.props.Draggable then self.dragPosition else if self.props.ContainerFlexes then (self.props.ContainerFlexedPosition or UDim2.fromScale(0.5, 0.5)) else (self.props.ContainerPosition or UDim2.fromOffset(0, 0)),
        AnchorPoint = if self.props.ContainerFlexes then (self.props.ContainerFlexedAnchor or Vector2.new(0.5, 0.5)) else (self.props.ContainerAnchor or Vector2.zero)
    })
end

Container = RoactService.RoactRodux.connect(function(state, props)
    table.move(state, 1, #state, #props+1, props)
    return props
end)(Container)

return Container