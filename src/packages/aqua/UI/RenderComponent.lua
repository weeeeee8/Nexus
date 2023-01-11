local FUSION_COMPONENTS = {} do
    coroutine.wrap(function()
        for _, componentName in {
            'Window',
            'Container',
            'Navbar',
        } do
            FUSION_COMPONENTS[componentName] = Aqua.Import(__AQUA_SRC_PATH__('/UI/Components/' .. componentName .. '.lua'))
        end
    end)()
end

return function(elementName)
    return FUSION_COMPONENTS[elementName]
end