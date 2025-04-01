Cam = Camera()

function Cam:update()
    CamMovement()
end

function CamMovement()
    Cam:lookAt(Player.x, Player.y)

    --gets width and height of screen (note screen and map have different w and h (map w and h are the whole tiled map whilst screen w and h are only the window))
    local w = Love.graphics.getWidth()
    local h = Love.graphics.getHeight()

    --stops cam from going past maps left and top borders
    if Cam.x < w / 2 then
        Cam.x = w / 2
    end
    if Cam.y < h / 2 then
        Cam.y = h / 2
    end

    -- gets total tiled
    local mapW = Gamemap.width * Gamemap.tilewidth
    local mapH = Gamemap.height * Gamemap.tileheight

    -- Cam stops at bounds of maps right and bottom borders
    if Cam.x > (mapW - w / 2) then
        Cam.x = (mapW - w / 2)
    end
    if Cam.y > (mapH - h / 2) then
        Cam.y = (mapH - h / 2)
    end
end
