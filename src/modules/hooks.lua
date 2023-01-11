local Hooks = {}
Hooks.__index = Hooks

function Hooks.new()
    return setmetatable({_hooks = {}}, Hooks)
end

function Hooks:FromFunction(closure, callback)
    local old
    old = hookfunction(closure, function(...)
        return callback(old, ...)
    end)
    local index = #self._hooks+1
    self._hooks[index] = {
        old = old,
        type = "metamethod",
        closure = closure,
        callback = callback,
    }
    return index
end

function Hooks:FromMetamethod(metamethod, callback)
    local old
    old = hookmetamethod(game, metamethod, function(...)
        return callback(old, ...)
    end)
    local index = #self._hooks+1
    self._hooks[index] = {
        old = old,
        type = "metamethod",
        method = metamethod,
        callback = callback,
    }
    return index
end

function Hooks:_reset(data)
    if data.type == "function" then
        hookfunction(data.closure, data.old)
    elseif data.type == "metamethod" then
        hookmetamethod(game, data.method, data.old)
    end
end

function Hooks:Reset(index)
    local stack = {}
    while #self._hooks > index do
        local data = table.remove(self._hooks, #self._hooks)
        self:_reset(data)
        table.insert(stack, data)
    end
    self:_reset(self._hooks[#self._hooks])
    while #stack > 0 do
        local data = table.remove(stack, #stack)
        if data.type == "function" then
            hookfunction(data.closure, data.callback)
        elseif data.type == "metamethod" then
            hookmetamethod(game, data.method, function(...)
                return data.callback(data.old, ...)
            end)
        end
    end
end

function Hooks:ResetAll()
    while #self._hooks > 0 do
        local data = table.remove(self._hooks, #self._hooks)
        self:_reset(data)
    end
end

return Hooks