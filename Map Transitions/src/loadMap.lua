Transitions = {}

function LoadMap(map)
    Gamemap = Sti("Maps/" .. map .. ".lua")
    DestroyAll()

    if Gamemap.layers["Transition"] then
        for i, obj in ipairs(Gamemap.layers["Transition"].objects) do
            local transition = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height,
                { collision_class = "Transitions" })
            transition.MapTransition = obj.properties.MapTransition
            transition.PlayerX = obj.properties.PlayerX
            transition.PlayerY = obj.properties.PlayerY
            transition:setType('static')
            table.insert(Transitions, transition)
        end
    end

    if Gamemap.layers["Enemies"] then
        for i, obj in ipairs(Gamemap.layers["Enemies"].objects) do
            if obj.name == "Zombie" then
                CreateZombie(obj.x, obj.y)
            elseif obj.name == "Eye" then
                CreateEyes(obj.x, obj.y)
            end
        end
    end
end

function DestroyCollision(tableList)
    local i = #tableList
    while i > 0 do
        if tableList[i] ~= nil then
            tableList[i]:destroy()
        end
        table.remove(tableList, i)
        i = i - 1
    end
end
