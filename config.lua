
function load_variables()
    -- player location on the map
    -- x is height and y is width because of some stupid warping 
    posx, posy = 7.5, 12.5

    -- player speed
    movespeed, rotspeed = 3, 3
    
    -- turn the lights off
    darkness = true

    -- amount of darkness
    darkness_scale = 1

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
    scale = 4
end