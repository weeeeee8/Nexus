-- AQUA CONCEPT

local initAqua = loadstring(game:HttpGet('https://raw.githubusercontent.com/weeeeee8/AquaUI/main/src/libs/Aqua.lua'), 'aqua-ui')
initAqua(function()
    -- add code here if you have to initialize stuff, use __AQUA_MAID__ if you have to setup some connections, make sum instances or stuff before loading the ui
    -- if you want to setup custom components and stuff, and aswell pass some special properties, create a Rodux Reducer here and return it at the end, return nil otherwise
    
    return nil
end)

local Router = Aqua.router() -- you can make multiple routers lmao
Router:link("Home", function() -- return a Roact component
    return nil
end)
Router:goto("Home"):refresh()

-- NOTE THAT YOU CANNOT ADD ANYTHING ELSE AFTER CALLING START!
Aqua.start(
    Aqua.construct('Window', {}, {
        content = Aqua.construct('Container', {
            Draggable = true,
            ContainerSize = UDim2.fromOffset(250, 250),
            ContainerPosition = UDim2.fromScale(0.5, 0.5),
            ContainerAnchor = Vector2.new(0.5, 0.5)
            -- will add "Resizable" soon
        }, {
            bg = Aqua.construct('ContainerBackground', {}),
            content = Aqua.construct('Container', {
                ContainerFlexes = true
            }, {
                header = Aqua.construct('Navbar', { -- shit creates navlinks automatically!
                    Style = "Vertical",
                    Router = Router,
                }),
                --[[body = Aqua.construct('Template', {
                    Router = Router,
                })]]
            })
        })
    })
)

-- some after startup functions
--Aqua.SetTheme(theme: string)
--Aqua.LoadConfiguration(useridUnique: boolean) -- different userid = different loaded settings
--[[ Aqua Whitelist/Blacklist System
    Aqua.Verify(url: string)
    :SetFilterType(filter: string) default to Whitelist
    :SetVerificationMethod(method: string) HWID or Player UserId
    :SetWebhook(webhookUrl: string)
    :SetPunishmentFlagsEnabled(flag: string) WebhookWarn | CrashUser | KickUser
    :RunTest()
]]