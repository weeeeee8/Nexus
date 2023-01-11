local Fusion = Aqua.GetPackage("Fusion")

return function(componentProps)
    local animatedComponent = Fusion.State(false)
    local groupTransparency = Fusion.State(0)

    if componentProps[Aqua.CrossCommunicationMarker] then
        Aqua._handleCrossCommunication(componentProps[Aqua.CrossCommunicationMarker]{
            AnimatedComponent = animatedComponent,
            GroupTransparency = groupTransparency,
        })
    end

    local function tryConstructContainerBackground()
        if componentProps.BackgroundColor3 then
            return Fusion.New "Frame" {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = componentProps.BackgroundColor3,
                AnchorPoint = Vector2.one * 0.5,
                Position = UDim2.fromScale(0.5, 0.5),
                BorderSizePixel = 0,
            }
        elseif componentProps.Image then
            return Fusion.New "ImageLabel" {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.one * 0.5,
                Position = UDim2.fromScale(0.5, 0.5),
                Image = componentProps.Image,
                ScaleType = componentProps.ScaleType or Enum.ScaleType.Fit,
                SliceCenter = componentProps.SliceCenter or Rect.new(0, 0, 0, 0),
                SliceScale = componentProps.SliceScale or 1
            }
        end

        return nil
    end

    return Fusion.New "CanvasGroup" {
        Name = ".container",

        Size = if componentProps.Flexed then componentProps.Size or UDim2.fromScale(1, 1) else componentProps.Size or UDim2.fromOffset(50, 50),
        Position = if componentProps.Flexed then componentProps.Position or UDim2.fromScale(0.5, 0.5) else componentProps.Position or UDim2.fromOffset(0, 0),
        AnchorPoint = if componentProps.Flexed then componentProps.AnchorPoint or Vector2.one * 0.5 else componentProps.AnchorPoint or Vector3.zero,

        BackgroundTransparency = 1,
        GroupTransparency = Fusion.Computed(function()
            return groupTransparency:get()
        end),

        [Fusion.Children] = {
            Fusion.New ".container-content" {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.one * 0.5,
                Position = UDim2.fromScale(0.5, 0.5),
                BorderSizePixel = 0,
                
                [Fusion.Children] = {
                    componentProps[Fusion.Children],
                }
            },
            tryConstructContainerBackground()
        }
    }
end