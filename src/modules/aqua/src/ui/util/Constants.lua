local RoactService = GetAquaService('RoactService')

return {
    --[=[
        Template for an aqua component
        ```lua
        AquaComponent = {
            MinTextSize = 10,
            MaxTextSize = 50,
            TextSize = 10,
            TextStrokeColor = Color3.new(),
            Color = Color3.new(),
            HoverColor = Color3.new(),
            TextColor = Color3.new(),
            TextHoverColor = Color3.new()
        }
        ```
    ]=]
    AquaThemeContext = RoactService.Roact.createContext({
        Dark = {
            Background = {
                Color = Color3.fromRBG(16, 16, 16)
            }
        },
        Light = {
            Background = {
                Color = Color3.fromRBG(245, 245, 245)
            }
        }
    })
}