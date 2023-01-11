local user = "weeeeee8"
local branch = "main"
local url = string.format("https://raw.githubusercontent.com/%s/AquaUI/%s/source.lua", user, branch)

loadstring(game:HttpGet(url))()

local UILibrary = Aqua.UI

UILibrary.RenderComponent"Window"{
    [UILibrary.Fusion.Children] = {
        UILibrary.RenderComponent"Container"{
            BackgroundColor3 = Color3.fromRGB(16, 16, 16),
            Size = UDim2.fromOffset(300, 250),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.one * 0.5
        }
    }
}