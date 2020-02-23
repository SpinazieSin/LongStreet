require("map")
require("rendering")
require("config")

-- Load some default values for our rectangle.
function love.load()
    load_variables()

    success = love.window.setMode( screenw, h, {fullscreen=fullscreen} )

    -- load canvas
    canvas = love.graphics.newCanvas(w, h)
    canvas:setFilter("nearest", "nearest")
    canvas = canvas:newImageData()
 
    -- load images
    wallimages = {
      love.image.newImageData("assets/walls/Bricks-2.jpg"),
      love.image.newImageData("assets/example.png")
    }

    walls = {}

    windows = {
      love.image.newImageData("assets/decorations/window-1.png")
    }

    spritesheet = {
      love.image.newImageData("assets/people/doompig.png"),
      love.image.newImageData("assets/example.png")
    }

    sprites = {
      {x = 2, y = 9, spriteimage = 1, xoffset = 0, yoffset = -30, scale = 0.25}
    }

    spriteims = {
      love.graphics.newImage(spritesheet[1])
    }

    for i=1,#sprites do
      map[sprites[i].x][sprites[i].y] = 9
    end

    for i=1,#sprites do
      local loadsprite = spritesheet[sprites[i].spriteimage]:clone()
    end

    spritehits = {{}}

    firstrun = true
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
 spritehits = {{}}

 local movespeed = movespeed * dt
 local rotspeed = rotspeed * dt
 if love.keyboard.isDown("w") then
  if map[math.floor(posx + dirx * movespeed)][math.floor(posy)] < 1 then
   posx = posx + dirx * movespeed
  end
  if map[math.floor(posx)][math.floor(posy + diry * movespeed)] < 1 then
   posy = posy + diry * movespeed
  end
 elseif love.keyboard.isDown("s") then
  if map[math.floor(posx - dirx * movespeed)][math.floor(posy)] < 1 then
   posx = posx - dirx * movespeed
  end
  if map[math.floor(posx)][math.floor(posy - diry * movespeed)] < 1 then
   posy = posy - diry * movespeed
  end
 end

 if love.keyboard.isDown("a") then
  olddirx = dirx
  dirx = dirx * math.cos(rotspeed) - diry * math.sin(rotspeed)
  diry = olddirx * math.sin(rotspeed) + diry * math.cos(rotspeed)
  oldplanex = planex
  planex = planex * math.cos(rotspeed) - planey * math.sin(rotspeed)
  planey = oldplanex * math.sin(rotspeed) + planey * math.cos(rotspeed)
 elseif love.keyboard.isDown("d") then
  olddirx = dirx
  dirx = dirx * math.cos(-rotspeed) - diry * math.sin(-rotspeed)
  diry = olddirx * math.sin(-rotspeed) + diry * math.cos(-rotspeed)
  oldplanex = planex
  planex = planex * math.cos(-rotspeed) - planey * math.sin(-rotspeed)
  planey = oldplanex * math.sin(-rotspeed) + planey * math.cos(-rotspeed)
 end
end

function love.draw()
  love.graphics.clear()

  if firstrun then
    drawfirstrun()
  end

  if fullscreen then
    love.graphics.scale(4, 4)
  end

  local cnvs = draw3d()
  local screentodraw = love.graphics.newImage(cnvs)
  love.graphics.draw(screentodraw)
  cnvs = drawsprites(1)

  -- love.graphics.setColor(255,0,0)
  -- love.graphics.rectangle("fill", screenw, 0, w-screenw, h )
  
  -- I REALLY WANT TO REMOVE THIS
  collectgarbage('collect')
  firstrun = false
end

function drawsprites(number)

  local sprite = sprites[number]
  if spritehits[sprite.x] ~= nil and spritehits[sprite.x][sprite.y] ~= nil then

  local spritex = sprite.x - posx + 0.5
  local spritey = sprite.y - posy + 0.5
  
  local dist = math.sqrt((spritex^2) + (spritey^2))
  if dist > 10 then
    return
  end

  local localspritedata = spritesheet[sprite.spriteimage]:clone()

    --transform sprite with the inverse camera matrix
    -- [ planeX   dirX ] -1                                       [ dirY      -dirX ]
    -- [               ]       =  1/(planeX*dirY-dirX*planeY) *   [                 ]
    -- [ planeY   dirY ]                                          [ -planeY  planeX ]

  local invdet = 1.0 / (planex * diry - dirx * planey) --required for correct matrix multiplication

  local transformx = invdet * (diry * spritex - dirx * spritey)
  local transformy = invdet * (-planey * spritex + planex * spritey)--this is actually the depth inside the screen, that what Z is in 3D

  -- sprite is behind player
  if transformy < 0 then
    return
  end

  local spritescreenx = math.floor((w / 2) * (1 + transformx / transformy))
  if spritescreenx < 0-localspritedata:getWidth() or spritescreenx > w+localspritedata:getWidth() then
    return
  end

  --calculate height of the sprite on screen
  local spriteheight = math.floor(h / transformy) --using 'transformY' instead of the real distance prevents fisheye
  
  --calculate lowest and highest pixel to fill in current stripe
  local drawstarty = -spriteheight / 2 + h / 2
  local drawendy = spriteheight / 2 + h / 2

  --calculate width of the sprite
  local spritewidth = math.abs( math.floor(h / (transformy)))
  local drawstartx = -spritewidth / 2 + spritescreenx
  if (drawstartx < 0) then
    drawstartx = 0
  end
  local drawendx = spritewidth / 2 + spritescreenx
  if (drawendx >= w) then
    drawendx = w - 1
  end

  local fade = 1
  if darkness then
    fade = dist*2
  end

  localspritedata:mapPixel(function(x, y, r, g, b, a) return r/fade, g/fade, b/fade, a end)
  local spriteimage = spriteims[sprite.spriteimage]
  spriteimage:replacePixels(localspritedata)
  love.graphics.draw(spriteimage, spritescreenx + sprite.xoffset, h/2 + sprite.yoffset/dist, 0, sprite.scale/dist)
  end
end

function drawfirstrun()
  local rotspeed = 3.141
  olddirx = dirx
  dirx = dirx * math.cos(rotspeed) - diry * math.sin(rotspeed)
  diry = olddirx * math.sin(rotspeed) + diry * math.cos(rotspeed)
  oldplanex = planex
  planex = planex * math.cos(rotspeed) - planey * math.sin(rotspeed)
  planey = oldplanex * math.sin(rotspeed) + planey * math.cos(rotspeed)

  for number=1,#wallimages do
    local wallimage = wallimages[number]:clone()
    local wallsprite = {}
    for wallx=1,wallimage:getWidth()-1 do
      table.insert(wallsprite, {})
      for wally=1,wallimage:getHeight()-1 do
        local r, g, b, a = wallimage:getPixel(wallx, wally)
        wallsprite[wallx][wally] = {r, g, b, a}
      end
    end
    table.insert(walls, wallsprite)
  end
  for number=1,#sprites do
    local sprite = sprites[number]
    local localspritedata = spritesheet[sprite.spriteimage]:clone()
    localspritedata:mapPixel(function(x, y, r, g, b, a) return r, g, b, a end)
    local spriteimage = spriteims[sprite.spriteimage]
    spriteimage:replacePixels(localspritedata)
    love.graphics.draw(spriteimage, 0, 0, 0, sprite.scale)
  end
  love.graphics.rectangle("fill", 0, 0, screenw, h)
end