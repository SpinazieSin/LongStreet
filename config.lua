
function load_variables()
    -- player location on the map
    -- x is height and y is width because of some stupid warping 
    posx, posy = 7.5, 12.5

    -- player speed
    runspeed, turnspeed = 2, 2
    
    -- turn the lights off
    darkness = true

    -- amount of darkness
    darkness_scale = 1

    -- h = screen height
    -- w = screen width
    h = 256
    w = h*2
    screenw = w
    screenh = h
    
    -- default texture size 
    texwidth = 512
    texheight = 512

    -- field of view in percentage scaling
    local fieldofview = 80
    dirx = -100/fieldofview

    -- don't touch
    diry = 0

    -- set gamescreen
    fullscreen = true
    
    --Record the screen dimensions
    success = love.window.setMode( 0, 0, {fullscreen=true} )
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()

    -- set fullscreen scaling
    yscale = (screen_height/h)
    xscale = screen_width/w

    -- plane warping
    planex, planey = 0, xscale/yscale

    -- canvas offsets
    canvas_y_offset = 0--(screen_height/6)*(h/screen_height)--h/(screen_height/h)

    -- the proportion of screen space that the black/white bar uses
    black_bar_limit = 1/8
end

function reloadscreen()
    -- set fullscreen scaling
    yscale = (screen_height/h)
    xscale = screen_width/w

    planex, planey = 0, xscale/yscale
    canvas_y_offset = 0--(screen_height/6)*(h/screen_height)--h/(screen_height/h)
    local fieldofview = 100
    -- dirx = -100/fieldofview
    -- diry = 0
    -- load canvas
    canvas:release()
    cnvs:release()
    canvas = love.graphics.newCanvas(w, h)
    canvas:setFilter("nearest", "nearest")
    canvas = canvas:newImageData()
    cnvs = canvas:clone()
end