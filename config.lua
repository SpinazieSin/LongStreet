
function load_variables()
    -- player location
    posx, posy = 7.5, 12.5

    -- player speed
    movespeed, rotspeed = 2, 2
    
    -- turn the lights off
    darkness = true

    -- h = screen height
    -- w = screen width
    h = 256
    w = 256
    screenw = 256
    screenh = h
    
    -- default texture size 
    texwidth = 512
    texheight = 512

    -- field of view in percentage scaling
    local fieldofview = 100
    dirx = -100/fieldofview

    -- don't touch
    diry = 0

    -- plane warping
    planex, planey = 0, 0.5

    -- set gamescreen
    fullscreen = true
end