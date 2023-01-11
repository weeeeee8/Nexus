local Fusion = Aqua.GetPackage("Fusion")

local HUI = if gethui then gethui() else game:GetService("CoreGui")

local function getHighestDisplayOrder()
    local order = 0
    local function fromService(service)
        for _, gui in service:GetChildren() do
            if not gui:IsA("ScreenGui") or gui.Name == "AquaInterface" then continue end
            if gui.DisplayOrder > order then
                order = gui.DisplayOrder
            end
        end
    end

    fromService(game:GetService("CoreGui"))
    fromService(game:GetService("StarterGui"))
    return order + 1
end

return function(componentProps)
    return Fusion.New "ScreenGui" {
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = getHighestDisplayOrder(),
        Name = "AquaInterface",
        Parent = HUI,

        componentProps[Fusion.Children],
    }
end