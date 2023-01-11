local user = "weeeeeee8"
local branch = "main"
local url = string.format("https://raw.githubusercontent.com/%s/AquaUI/%s/src/main.lua", user, branch)

return loadstring(game:HttpGet(url), 'Aqua Framework')()