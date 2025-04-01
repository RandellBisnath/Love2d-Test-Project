Zombies = {}

function CreateZombie(x, y)
    local zombie = {}
    zombie.sprite = Love.graphics.newImage('sprites/zombie.png')
    zombie.x = x
    zombie.y = y
    zombie.vx = 0
    zombie.vy = 0
    zombie.width = 40
    zombie.height = 100
    zombie.speed = 200
    zombie.hp = 5
    zombie.collider = World:newBSGRectangleCollider(zombie.x, zombie.y, zombie.width, zombie.height, 10)
    zombie.collider:setFixedRotation(true)
    zombie.collider:setCollisionClass("Zombie")
    table.insert(Zombies, zombie)
end

function Zombies:update()
    for i, z in ipairs(self) do
        z.vx = 0
        z.vy = 0
        local zx, zy = z.collider:getPosition()
        local px, py = Player.collider:getPosition()
        local dist = CalculateDistance(zx, zy, px, py)
        if dist < 300 then
            -- print("Enemy x: " .. ex .. " Enemy y: " .. ey .. " Player x: " .. px .. " Player y: " .. py .. "")
            local left = false
            local right = false
            local up = false
            local down = false
            if zx < px then
                -- print("right")
                z.vx = z.speed
                right = true
            end
            if zx > px then
                -- print("left")
                z.vx = z.speed * -1
                left = true
            end
            if zy < py then
                -- print("down")
                z.vy = z.speed
                down = true
            end
            if zy > py then
                -- print("up")
                z.vy = z.speed * -1
                up = true
            end

            if up and right then
                z.vx = z.speed / math.sqrt(2)
                z.vy = z.speed * -1 / math.sqrt(2)
            end
            if up and left then
                z.vx = z.speed * -1 / math.sqrt(2)
                z.vy = z.speed * -1 / math.sqrt(2)
            end
            if down and right then
                z.vx = z.speed / math.sqrt(2)
                z.vy = z.speed / math.sqrt(2)
            end
            if down and left then
                z.vx = z.speed * -1 / math.sqrt(2)
                z.vy = z.speed / math.sqrt(2)
            end
        end
        z.collider:setLinearVelocity(z.vx, z.vy)
        z.x = z.collider:getX()
        z.y = z.collider:getY()

        if z.collider:enter("Projectile") then
            z.hp = z.hp - 1
        end

        if z.hp <= 0 then
            z.collider:destroy()
            table.remove(self, i)
        end
    end
    if Player.collider:enter("Zombie") then
        print("Touching")
    end
end

function Zombies:draw()
    for i, z in ipairs(self) do
        Love.graphics.draw(z.sprite, z.x - 20, z.y - 50)
    end
end

function Zombies:DestroyCollision()
    local i = #self
    while i > 0 do
        if self[i] ~= nil then
            self[i].collider:destroy()
        end
        table.remove(self, i)
        i = i - 1
    end
end

return Zombies
