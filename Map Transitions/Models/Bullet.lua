Bullets = {}
local TimePassed = 0
function Shoot(dt)
    local k = Love.keyboard
    TimePassed = TimePassed + dt
    local bullet
    local bulletXDir = 0
    local bulletYDir = 0
    local playerXDiff = 0
    local playerYDiff = 0
    local btnPressed = false
    -- if k.isDown("up") then
    --     bullet = World:newCircleCollider(Player.x, Player.y - 55, 5)
    --     bullet:setCollisionClass("Projectile")
    --     bullet:setLinearVelocity(0, -700)
    -- elseif k.isDown("down") then
    --     bullet = World:newCircleCollider(Player.x, Player.y + 55, 5)
    --     bullet:setCollisionClass("Projectile")
    --     bullet:setLinearVelocity(0, 700)
    -- elseif k.isDown("left") then
    --     bullet = World:newCircleCollider(Player.x - 30, Player.y, 5)
    --     bullet:setCollisionClass("Projectile")
    --     bullet:setLinearVelocity(-700, 0)
    -- elseif k.isDown("right") then
    --     bullet = World:newCircleCollider(Player.x + 30, Player.y, 5)
    --     bullet:setCollisionClass("Projectile")
    --     bullet:setLinearVelocity(700, 0)
    -- end
    if k.isDown('up') then
        bulletXDir = 0
        bulletYDir = -700
        playerXDiff = 0
        playerYDiff = -55
        btnPressed = true
    elseif k.isDown('down') then
        bulletXDir = 0
        bulletYDir = 700
        playerXDiff = 0
        playerYDiff = 55
        btnPressed = true
    elseif k.isDown('left') then
        bulletXDir = -700
        bulletYDir = 0
        playerXDiff = -30
        playerYDiff = 0
        btnPressed = true
    elseif k.isDown('right') then
        bulletXDir = 700
        bulletYDir = 0
        playerXDiff = 30
        playerYDiff = 0
        btnPressed = true
    else
        btnPressed = false
    end

    if TimePassed > .5 and btnPressed == true then
        bullet = World:newCircleCollider(Player.x + playerXDiff, Player.y + playerYDiff, 5)
        bullet.sprite = Love.graphics.newImage('sprites/bullet.png')
        bullet:setCollisionClass("Projectile")
        bullet:setLinearVelocity(bulletXDir, bulletYDir)
        bullet.x = bullet:getX()
        bullet.y = bullet:getY()
        bullet.timeTraveled = 0
        table.insert(Bullets, bullet)
        TimePassed = 0
    end
end

function Bullets:CheckBulletCollision(dt)
    for i, b in ipairs(self) do
        b.timeTraveled = b.timeTraveled + dt
        b.x = b:getX()
        b.y = b:getY()
        if b:enter("Zombie") then
            b:destroy()
            table.remove(self, i)
        end
        if b:enter("Eye") then
            b:destroy()
            table.remove(self, i)
        end
        if b.timeTraveled > 3 then
            b:destroy()
            table.remove(self, i)
        end
    end
end

function Bullets:update(dt)
    Shoot(dt)
    Bullets:CheckBulletCollision(dt)
end

function Bullets:draw()
    for i, b in ipairs(self) do
        Love.graphics.draw(b.sprite, b.x - 5, b.y - 5, nil, 2.5, 2.5)
    end
end

return Bullets
