
return {
    Default = function(category)
        local Utility = import('env/util/Utility')
        local tab = category:Button("Common")

        local schedule = Utility.Schedule()
        schedule(function()
            local FLIGHT_SPEED_LIMIT = NumberRange.new(100, 10000)

            local flightEnabled = false
            local flightSpeed = 200

            local section = tab:Section("Fly Options", "Left")

            local flyToggleObject = section:Toggle({
                Title = "Enable flying",
                Default = false,
            }, function(toggled)
                flightEnabled = toggled
            end)
            section:Keybind({
                Default = Enum.KeyCode.F,
                Description = "",
                Title = "Toggle flight"
            }, function()
                flyToggleObject:setValue(not flightEnabled)
            end)
            section:Slider({
                Title = "Set flight speed",
                Description = "",
            })
        end)

        schedule:sequence()
    end
}