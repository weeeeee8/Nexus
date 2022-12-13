local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

return {
    Default = function(category)
        local Utility = import('env/util/Utility')
        local Tab = category:Button('Joining Options')

        local schedule = Utility.Schedule()
        schedule(function()
            local SAVED_SAME_SERVERIDS_PATH = __NEXUS_FILE_CONSTANTS__.userdata_path .. '/same-serverids'
            local SAVED_LAST_SERVERS_TIME_CACHE_PATH = __NEXUS_FILE_CONSTANTS__.userdata_path .. '/last-servers-time-cache'

            local MAX_JOIN_ATTEMPTS = 5
            local SERVER_HOPPING_TIMEOUT = 60--seconds

            local defaultDesiredServerSize = 5
            local shouldAutoExecute = false

            local section = Tab:Section("Serverhopping Options", "Left")

            section:Checkbox({
                Title = "Re-execute script hub after teleporting?",
                Description = "will execute the script hub again after serverhopping",
                Default = true,
                --Flag = "JoiningOptionsCheckbox1"
            }, function(toggled)
                shouldAutoExecute = toggled
            end)

            section:Textbox({
                Title = "Desired Server Size",
                Description = "optional, set to default at 5. expects a number!",
                Default = "5",
            }, function(text)
                local num = tonumber(text)
                if num then
                    num = math.max(num, 0)
                    defaultDesiredServerSize = num
                else
                    --notify here
                end
            end)

            section:Button({
                Title = "Hop server",
                Description = "Scans for other servers of same place ids.",
                ButtonName = "Hop!"
            }, function()
                local START_HOUR = os.date("!*t").hour

                local _jobIds = {}
                local _foundLastServerTimeCache = nil

                local lastServerCursor
                local scannedServers, joinAttempts, startTime = 0, 0, tick()

                Utility.opcall.option(
                    function(value)
                        _foundLastServerTimeCache = tonumber(value)
                    end, function()
                        writefile(SAVED_LAST_SERVERS_TIME_CACHE_PATH, tostring(START_HOUR))
                    end
                )(readfile, SAVED_LAST_SERVERS_TIME_CACHE_PATH)

                Utility.opcall.option(
                    function(value)
                        _jobIds = Utility.SafeJSONDecode(value)
                    end,
                    function()
                        writefile(SAVED_SAME_SERVERIDS_PATH, HttpService:JSONEncode(_jobIds))
                    end
                )(readfile, SAVED_SAME_SERVERIDS_PATH)

                local function isGivenJobIdExisting(id)
                    for _, cache in ipairs(_jobIds) do
                        if tostring(id) == tostring(cache) then
                            return true
                        end
                    end
                    return false
                end

                while true do
                    if _foundLastServerTimeCache then
                        if START_HOUR ~= _foundLastServerTimeCache then
                            pcall(delfile, SAVED_LAST_SERVERS_TIME_CACHE_PATH)
                            table.clear(_jobIds)
                            _foundLastServerTimeCache = nil
                        end
                    end

                    local now = tick()
                    if now - startTime > SERVER_HOPPING_TIMEOUT then
                        -- notify here
                        break
                    end
                    local serverlist
                    if lastServerCursor then
                        serverlist = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. lastServerCursor))
                    else
                        serverlist = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
                    end

                    if serverlist.nextPageCursor and serverlist.nextPageCursor ~= "null" and serverlist.nextPageCursor ~= nil then
                        lastServerCursor = serverlist.nextPageCursor
                    end

                    local totalServers = Utility.LenDictionary(serverlist.data)
                    for _, serverdata in pairs(serverlist.data) do
                        local id = serverdata.id
                        if (tonumber(serverdata.maxPlayers) or 0) > (tonumber(serverdata.playing) or 0) and tonumber(serverdata.playing) >= defaultDesiredServerSize then
                            if not isGivenJobIdExisting(id) then
                                --notify here
                                setclipboard(id)

                                table.insert(_jobIds, id)
                                local event = Instance.new("BindableEvent")

                                writefile(SAVED_SAME_SERVERIDS_PATH, HttpService:JSONEncode(_jobIds))

                                local function tryTeleport()
                                    if joinAttempts > MAX_JOIN_ATTEMPTS then
                                        --notify here
                                        local result = Utility.opcall.wrap(readfile, SAVED_SAME_SERVERIDS_PATH)
                                        if result.success then
                                            local ids = HttpService:JSONDecode(result.value)
                                            for index, cache in ipairs(ids) do
                                                if tostring(id) == tostring(cache) then
                                                    table.remove(ids, index)
                                                end
                                            end
                                            _jobIds = HttpService:JSONEncode(ids)
                                        end
                                        event:Fire()
                                        writefile(SAVED_SAME_SERVERIDS_PATH, HttpService:JSONEncode(_jobIds))
                                        return
                                    end

                                    if shouldAutoExecute then
                                        queue_on_teleport('loadstring(game:HttpGet(string.format("https://raw.githubusercontent.com/%s/Nexus/%s/source.lua", __USER__, __BUILD__)), "Nexus")()')
                                    end
                                    TeleportService:TeleportToPlaceInstance(game.PlaceId, id, Players.LocalPlayer)
                                    local onTeleportFailed; onTeleportFailed = Players.LocalPlayer.OnTeleport:Connect(function(state)
                                        if state == Enum.TeleportState.Failed then
                                            onTeleportFailed:Disconnect()
                                            onTeleportFailed = nil
                                            --notify here
                                            joinAttempts += 1
                                            tryTeleport()
                                        end
                                    end)
                                end
                                tryTeleport()

                                event.Event:Wait()
                            end
                        end
                        scannedServers+=1
                        --notify here

                        task.wait(1)
                    end
                end
            end)
        end)

        schedule:all()
    end,
}