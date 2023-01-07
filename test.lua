local initAqua = loadstring(game:HttpGet('https://raw.githubusercontent.com/weeeeee8/AquaUI/main/src/libs/Aqua.lua'), 'aqua-ui')

initAqua(function()
    -- add code here if you have to initialize stuff, use __AQUA_MAID__ if you have to setup some connections, make sum instances or stuff before loading the ui
    -- if you want to setup custom components and stuff, and aswell pass some special properties, create a Rodux Reducer here and return it at the end, return nil otherwise
    
    return nil
end)

Aqua.start(
    Aqua.construct('Window', {}, {
        Aqua.construct('CanvasGroup', {
            Draggable = true,
        })
    })
)