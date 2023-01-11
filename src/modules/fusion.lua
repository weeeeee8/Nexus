__GLOBAL__.__FUSION_SRC_PATH__ = function(path)
    return '/packages/fusion' .. path
end

local Types = Aqua.Import(__FUSION_SRC_PATH__('/Types.lua'))
local restrictRead = Aqua.Import(__FUSION_SRC_PATH__('/Utility/restrictRead.lua'))

export type State = Types.State
export type StateOrValue = Types.StateOrValue
export type Symbol = Types.Symbol

return restrictRead("Fusion", {
	New = Aqua.Import(__FUSION_SRC_PATH__('/Instances/New.lua')),
	Children = Aqua.Import(__FUSION_SRC_PATH__('/Instances/Children.lua')),
	OnEvent = Aqua.Import(__FUSION_SRC_PATH__('/Instances/OnEvent.lua')),
	OnChange = Aqua.Import(__FUSION_SRC_PATH__('/Instances/OnChange.lua')),

	State = Aqua.Import(__FUSION_SRC_PATH__('/State/State.lua')),
	Computed = Aqua.Import(__FUSION_SRC_PATH__('/State/Computed.lua')),
	ComputedPairs = Aqua.Import(__FUSION_SRC_PATH__('/State/ComputedPairs.lua')),
	Compat = Aqua.Import(__FUSION_SRC_PATH__('/State/Compat.lua')),

	Tween = Aqua.Import(__FUSION_SRC_PATH__('/Animation/Tween.lua')),
	Spring = Aqua.Import(__FUSION_SRC_PATH__('/Animation/Spring.lua')),
})