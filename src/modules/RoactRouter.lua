local RoactService = GetAquaService('RoactService')

local e, f, r, b = RoactService.Roact.createElement, RoactService.Roact.createFragment, RoactService.Roact.createRef, RoactService.Roact.createBinding

local function emptyPageTemplate()
    return e('Frame')
end

local RoactRouter = {}
RoactRouter.__index = RoactRouter

function RoactRouter:link(route: string, initComponent)
    local pageComponent, anchorInfo = initComponent()
    table.insert(self._routes, {
        title = route,
        pageComponent = pageComponent,
        anchorInfo = anchorInfo,
    })
    return self
end

function RoactRouter:goto(index: number)
    if index > #self.ro_routesutes or index <= 0 then
        console.log('route reference"' .. tostring(index) .. '" is out of bounds')
    end
    self._target = math.clamp(index, 1, #self._routes)
    return self
end

function RoactRouter:refresh()
    local foundPage = self._routes[self._target]
    if foundPage then
        self.page = foundPage
    else
        console.log('route target does not exist (' .. self._target .. ')', '@@RED@@')
    end
end

local RoactRouterObject = {}
function RoactRouterObject.new()
    local proxy = newproxy(true)
    local mt = getmetatable(proxy)

    mt.page = nil
    mt._target = 1
    mt._routes = {}

    return setmetatable(mt, RoactRouter)
end

return RoactRouterObject