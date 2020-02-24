
function load_variables()
    -- player location on the map
    -- x is height and y is width because of some stupid warping 
    posx, posy = 7.5, 12.5

    -- player speed
    runspeed, turnspeed = 3, 3
    
    -- turn the lights off
    darkness = true

    -- amount of darkness
    darkness_scale = 1

    -- h = screen height
    -- w = screen width
    h = 270
    w = 270*2
    screenw = w
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
    planex, planey = 0, 1.2

    -- set gamescreen
    fullscreen = true
    xscale = 3.5--*(16/9)
    yscale = 3
end