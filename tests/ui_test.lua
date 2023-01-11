local user = "weeeeeee8"
local branch = "main"
local url = string.format("https://raw.githubusercontent.com/%s/AquaUI/%s/source.lua", user, branch)

loadstring(game:HttpGet(url), 'Aqua UI Test')()

local UILibrary = Aqua.UI

UILibrary.RenderComponent"Window"{
    [UILibrary.Fusion.Children]
}