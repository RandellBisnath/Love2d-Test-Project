require('src.initialize')

Switch = true

function Love.load()
    LoadMap('MapOne')
    Player:load()
    print(Love._version)
end

function Love.update(dt)
    Player:update(dt)
    Bullets:update(dt)
    Cam:update()
    Zombies:update()
    Eyes:update()
    World:update(dt)
end

function Love.draw()
    Cam:attach()
    DrawAllInCam()
    Cam:detach()
    DrawAllOutCam()
end
