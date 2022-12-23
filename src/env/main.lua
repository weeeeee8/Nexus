return {
    Default = function()
        local HydraLibrary = import('env/lib/Hydra')
        
        local __version__ = import('env/ver.txt')
        extern("NEXUS_VERSION", __version__, true)

        local Window = HydraLibrary.new("Nexus", string.format("Hello %s,\nthanks for using Nexus!", game.Players.LocalPlayer.Name), NEXUS_VERSION)
        extern("NexusWindow", Window)
        
        xpcall(function()
            local function importScriptFromGame(id)
                return ({
                    [224422602] = 'ebg.init'
                })[id]
            end

            import('scripts/main.init').Default()
            import('scripts/' .. importScriptFromGame(game.GameId)).Default()
        end, function(...)
            warn('[SCRIPT IMPORT ERROR] %s', ...)
        end)
    end
}