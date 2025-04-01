Eyes = {}

function CreateEyes(x, y)
    local eye = {}
    eye.sprite = Love.graphics.newImage('sprites/eye.png')
    eye.x = x
    eye.y = y
    eye.vx = 0
    eye.vy = 0
    eye.width = 30
    eye.height = 30
    eye.speed = 300
    eye.hp = 3
    eye.collider = World:newBSGRectangleCollider(eye.x, eye.y, eye.width, eye.height, 3)
    eye.collider:setFixedRotation(true)
    eye.collider:setCollisionClass("Eye")
    table.insert(Eyes, eye)
end

function Eyes:update()
    for i, e in ipairs(self) do
        e.vy = 0
        e.vx = 0

        local ex, ey = e.collider:getPosition()
        local px, py = Player.collider:getPosition()
        local dist = CalculateDistance(ex, ey, px, py)
        if dist < 400 then
            -- print("Enemy x: " .. ex .. " Enemy y: " .. ey .. " Player x: " .. px .. " Player y: " .. py .. "")
            local left = false
            local right = false
            local up = false
            local down = false
            if ex < px then
                -- print("right")
                e.vx = e.speed
                right = true
            end
            if ex > px then
                -- print("left")
                e.vx = e.speed * -1
                left = true
            end
            if ey < py then
                -- print("down")
                e.vy = e.speed
                down = true
            end
            if ey > py then
                -- print("up")
                e.vy = e.speed * -1
                up = true
            end

            if up and right then
                e.vx = e.speed / math.sqrt(2)
                e.vy = e.speed * -1 / math.sqrt(2)
            end
            if up and left then
                e.vx = e.speed * -1 / math.sqrt(2)
                e.vy = e.speed * -1 / math.sqrt(2)
            end
            if down and right then
                e.vx = e.speed / math.sqrt(2)
                e.vy = e.speed / math.sqrt(2)
            end
            if down and left then
                e.vx = e.speed * -1 / math.sqrt(2)
                e.vy = e.speed / math.sqrt(2)
            end
        end
        e.collider:setLinearVelocity(e.vx, e.vy)
        e.x = e.collider:getX()
        e.y = e.collider:getY()

        if e.collider:enter("Projectile") then
            e.hp = e.hp - 1
        end

        if e.hp <= 0 then
            e.collider:destroy()
            table.remove(self, i)
        end
    end
    if Player.collider:enter("Eye") then
        print("Touching")
    end
end

function Eyes:draw()
    for i, e in ipairs(self) do
        Love.graphics.draw(e.sprite, e.x - 15, e.y - 15)
    end
end

function Eyes:DestroyCollision()
    local i = #self
    while i > 0 do
        if self[i] ~= nil then
            self[i].collider:destroy()
        end
        table.remove(self, i)
        i = i - 1
    end
end

return Eyes
