local HttpService = game:GetService("HttpService")

local VOID_RETURN_CALLBACK = function() return nil end

local Constants = {}

local ExtendAPI = {} do
    function ExtendAPI.Object()
        local proxy = newproxy(true)
        local meta = getmetatable(proxy)
        return meta
    end

    function ExtendAPI.Schedule()
        local task = ExtendAPI.Object()
        function task:sequence()
            for i = 1, #self do
                local success, msg = pcall(self, i)
                if not success then
                    error("[EXECTUABLE RUNTIME ERROR] " .. msg, 2)
                end
            end
        end
        function task:all()
            for i = 1, #self do
                task.spawn(self[i])
            end
        end
        function task:once(index)
            self[index]()
        end
        return setmetatable(task, {__call = function(s, fn)
            s[#s+1] = fn
        end})
    end

    function ExtendAPI.Connections()
        local holder = ExtendAPI.Object()
        holder.__connections = {}
        function holder:connect(signal, fn)
            local connection = signal:Connect(fn)
            self.__connections[connection] = true
            return connection
        end
        function holder:disconnect(connection)
            self.__connections[connection]:Disconnect()
        end
        function holder:disconnectAll()
            for connection in pairs(self.__connections) do
                connection:Disconnect()
            end
        end
        function holder:Destroy()
            self:disconnectAll()
            self.__connections = nil
            setmetatable(self, nil)
        end
        return holder
    end

    function ExtendAPI.Stack()
        local stack = ExtendAPI.Object()
        function stack:push(input)
            self:assign(input, #self+1)
        end
        function stack:pop()
            if #self <= 0 then
                warn(string.format('[STACK ERROR] Stack Underflow'))
                return nil
            end

            return self:remove(#self)
        end
        function stack:assign(input, index)
            self[index] = input
        end
        function stack:remove(index)
            local output = self[index]
            self[index] = nil
            return output
        end
        function stack:size()
            return #self
        end
        function stack:clear()
            for i = #self, 1, -1 do
                self[i] = nil
            end
        end
        function stack:Destroy()
            self:clear()
            setmetatable(self, nil)
        end
        return stack
    end

    function ExtendAPI.Switch()
        local switch = ExtendAPI.Object()
        switch.__cases = {}
        switch.__default = VOID_RETURN_CALLBACK
        function switch:case(condition, callback)
            self.__cases[condition] = callback
        end
        function switch:default(callback)
            self.__default = callback
        end
        return setmetatable(switch, {__call = function(self, input)
            local exec = self.__cases[input] or self.__default
            xpcall(exec, function(...)
                warn(string.format('[SWITCHCASE ERROR] %s', ...))
            end)

            table.clear(self)
            setmetatable(self, nil)
        end})
    end

    function ExtendAPI.Set(...)
        local set = ExtendAPI.Object()
        set.__set = {}
        function set:override(callback)
            for k in pairs(self.__set) do
                self.__set[k] = callback[k]
            end
        end
        function set:get()
            local src = self.__set
            table.clear(self)
            setmetatable(self, nil)
            return src
        end

        for _, k in ipairs{...} do
            set.__set[k] = true
        end

        return set
    end
end

local HelpfulAPI = {} do
    HelpfulAPI.opcall = {
        wrap = function(fn, ...)
            local output = {
                success = false,
                value = nil,
            }
    
            output.success, output.value = pcall(fn, ...)
    
            return output
        end,
        option = function(match, none)
            return function(fn, ...)
                local success, valueOrError = pcall(fn, ...)
                if success then
                    if match then
                        match(valueOrError)
                    end
                else
                    if none then
                        none(valueOrError)
                    end
                end
            end
        end
    }

    function HelpfulAPI.CreateAutofill()
        local autofillClass = ExtendAPI.Object()
        autofillClass.__template = nil
        function autofillClass:reconcile(src: {[string]: any} | (input: string) -> nil)
            if typeof(src) == "function" then
                self.__template = src
            elseif typeof(src) == "table" then
                self.__template = {}
                for k in pairs(src) do
                    if not self.__template[k] then
                        self.__template[k] = true
                    end
                end
            else
                error("Invalid source type; function or table expected, got: " .. typeof(src), 2)
            end
        end
        function autofillClass:try(text: string)
            if not self.__template then error("Cannot perform autofill without a template. Have you called AutofillObject:reconcile()?") end
            if #text < 0 then error("Given text cannot be an empty string!") end

            if typeof(self.__template) == "function" then
                local output = self.__template(text)
                if output then
                    return output
                end
            elseif typeof(self.__template) == "table" then
                for k in pairs(self.__template) do
                    if k:sub(1, #text) == text then
                        return k
                    end
                end
            end

            error(string.format('No correction found for "%s"!', text), 2)
        end
        return autofillClass
    end

    function HelpfulAPI.BindOnCharacterAdded(player: Player, callback: (character: Model) -> nil)
        if player.Character then callback(player.Character) end
        return player.CharacterAdded:Connect(callback)
    end

    function HelpfulAPI.Lerp(a, b, c)
        return a + (b - a) * c
    end
end

local SafeAPI = {} do
    function SafeAPI.SafeJSONDecode(input)
        return HttpService.JSONDecode(HttpService, input)
    end

    function SafeAPI.SafeJSONEncode(input)
        return HttpService.JSONEncode(HttpService, input)
    end

    function SafeAPI.SafeDestroy(obj)
        if obj ~= nil then
            obj.Destroy(obj)
        end
    end
end

local TableUtil = {} do
    function TableUtil.LenDictionary(dict)
        local n = 0; for _ in pairs(dict) do n += 1 end; return n
    end
end

local Dumpster = {} do
    Dumpster.__index = function(s, k)
        local index = rawget(s, '_index')
        if index[k] then
            return index[k]
        else
            return Dumpster[k]
        end
    end
    function Dumpster.new()
        return setmetatable({_index = {}}, Dumpster)
    end

    function Dumpster:connect(signal, callback)
        return self:throw(signal:Connect(callback))
    end

    function Dumpster:trow(object)
        local index = self._index[#self._index+1]
        self._index[index] = object
        return object
    end

    function Dumpster:create(class, ...)
        local obj
        if class.new then
            obj = class.new(...)
        elseif class.create then
            obj = class.create(...)
        end

        if obj then
            return self:throw(obj)
        else
            error("[DUMPSTER] A class object does not have a constructor!")
        end
    end

    function Dumpster:remove(index)
        local o = self._index[index]
        if o then
            self._index[index] = nil

            if typeof(o) == "function" then
                o()
            elseif typeof(o) == "Instance" then
                o:Destroy()
            elseif typeof(o) == "table" then
                if o.Destroy then
                    o:Destroy()
                else
                    warn("[DUMPSTER] A table object is passed without a ':Destroy()' method!")
                end
            elseif typeof(o) == "RBXScriptConnection" then
                o:Disconnect()
            end
        else
            warn("[DUMPSTER] Cannot find a specified object to clean")
        end
    end

    function Dumpster:empty()
        for i = #self._index, 1, -1 do
            self:remove(i)
        end
    end

    function Dumpster:Destroy()
        self:empty()
    end
end

local Utility = setmetatable({
    Dumpster = Dumpster,
}, {
    __index = function(_, k)
        if Constants[k] then
            return Constants[k]
        elseif TableUtil[k] then
            return TableUtil[k]
        elseif ExtendAPI[k] then
            return ExtendAPI[k]
        elseif SafeAPI[k] then
            return SafeAPI[k]
        elseif HelpfulAPI[k] then
            return HelpfulAPI[k]
        else
            error(string.format('"%s" is not a valid member for %s', k, script.Name), 2)
        end
    end,
    __newindex = function(_, k, _)
        error(string.format('Cannot assign "%s" on a static class', k), 2)
    end,
})

return Utility