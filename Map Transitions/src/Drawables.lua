function DrawAllInCam()
    if Gamemap.layers["Background"] then
        Gamemap:drawLayer(Gamemap.layers["Background"])
    end
    Player:draw()
    Bullets:draw()
    Zombies:draw()
    Eyes:draw()
    if Gamemap.layers["Foreground"] then
        Gamemap:drawLayer(Gamemap.layers["Foreground"])
    end
    -- World:draw()
end

function DrawAllOutCam()

end
