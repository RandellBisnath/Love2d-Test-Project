--create player
local Player = {}
--creates the players load functions
function Player:load()
    --described in main
    Love.graphics.setDefaultFilter("nearest", "nearest")

    --sets variables for player
    self.x = 400
    self.y = 200
    self.speed = 600
    self.vx = 0
    self.vy = 0
    self.dir = "left"

    --gets player animation spriteSheet
    self.spriteSheet = Love.graphics.newImage('sprites/player-sheet.png')
    --width and height of each animation frame in spritesheet
    self.width = 12
    self.height = 18

    --creates grid based on width and height of individual animation frames and whole spritesheet width and height
    self.grid = Anim8.newGrid(self.width, self.height, self.spriteSheet:getWidth(),
        self.spriteSheet:getHeight())

    --new table of animations
    self.animations = {}
    --gets animations based on grid (the 0.2 is the animation speed)
    self.animations.down = Anim8.newAnimation(self.grid('1-4', 1), 0.2)
    self.animations.up = Anim8.newAnimation(self.grid('1-4', 4), 0.2)
    self.animations.left = Anim8.newAnimation(self.grid('1-4', 2), 0.2)
    self.animations.right = Anim8.newAnimation(self.grid('1-4', 3), 0.2)

    --sets starting anim to left
    self.anim = self.animations.left


    --adds player collision to world
    World:addCollisionClass('Player')
    self.collider = World:newBSGRectangleCollider(400, 250, 50, 100, 10)
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass('Player')
end

--creates the update function of the player
function Player:update(dt)
    --player movement function
    PlayerMovement()

    CheckTransition()
    --updates animations
    self.anim:update(dt)
end

function PlayerMovement()
    --x and y velocity
    Player.vx = 0
    Player.vy = 0
    local isMoving = false
    local k = Love.keyboard


    --pretty self explanitory movement code
    if k.isDown("d") then
        Player.vx = Player.speed
        --sets animations based on movement direction
        Player.anim = Player.animations.right
        Player.dir = "right"
        isMoving = true
    end

    if k.isDown("a") then
        Player.vx = Player.speed * -1
        Player.anim = Player.animations.left
        Player.dir = "left"
        isMoving = true
    end

    if k.isDown("s") then
        Player.vy = Player.speed
        Player.anim = Player.animations.down
        Player.dir = "down"
        isMoving = true
    end

    if k.isDown("w") then
        Player.vy = Player.speed * -1
        Player.anim = Player.animations.up
        Player.dir = "up"
        isMoving = true
    end

    --code for diagonal movement
    if k.isDown('w') and k.isDown('d') then
        Player.vx = Player.speed / math.sqrt(2)
        Player.vy = Player.speed * -1 / math.sqrt(2)
    end

    if k.isDown('w') and k.isDown('a') then
        Player.vx = Player.speed * -1 / math.sqrt(2)
        Player.vy = Player.speed * -1 / math.sqrt(2)
    end

    if k.isDown('s') and k.isDown('d') then
        Player.vx = Player.speed / math.sqrt(2)
        Player.vy = Player.speed / math.sqrt(2)
    end

    if k.isDown('s') and k.isDown('a') then
        Player.vx = Player.speed * -1 / math.sqrt(2)
        Player.vy = Player.speed / math.sqrt(2)
    end

    -- idk but im guessing it makes the Collider move based on x and y variables
    Player.collider:setLinearVelocity(Player.vx, Player.vy)

    --sets the player sprite to the colliders position, ensuring that the collider and sprite match
    Player.x = Player.collider:getX()
    Player.y = Player.collider:getY()

    --if player isnt moving then move to frame 2 of current animation (standing anim)
    if isMoving == false then
        Player.anim:gotoFrame(2)
    end
end

function SetPlayerPos(x, y)
    Player.x = x
    Player.y = y
    Player.collider:setPosition(x, y)
end

function CheckTransition()
    if Player.collider:enter("Transitions") then
        local collision_data = Player.collider:getEnterCollisionData("Transitions")
        if collision_data.collider.MapTransition == "MapOne" then
            LoadMap("MapOne")
            SetPlayerPos(collision_data.collider.PlayerX, collision_data.collider.PlayerY)
        elseif collision_data.collider.MapTransition == "MapTwo" then
            LoadMap("MapTwo")
            SetPlayerPos(collision_data.collider.PlayerX, collision_data.collider.PlayerY)
        end
    end
end

function Love.keypressed(key)
    if key == 'space' then
        local px, py = Player.collider:getPosition()
        if Player.dir == "right" then
            px = px + 60
        elseif Player.dir == "left" then
            px = px - 60
        elseif Player.dir == "down" then
            py = py + 60
        elseif Player.dir == "up" then
            py = py - 60
        end

        print("PlayerX " .. px .. " PlayerY " .. py .. "")
        local buttons = World:queryCircleArea(px, py, 50, { "Button" })
        if #buttons > 0 then
            print("Touching")
        end
    end
end

--creates the players draw function
function Player:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 6, nil, 6, 9)
end

return Player
