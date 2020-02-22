map = {
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,1,0,1,0,1,0,0,0,1},
  {1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,0,1},
  {1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,1,1,0,1,1,0,0,0,0,1,0,1,0,1,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,0,0,0,0,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
}

-- Load some default values for our rectangle.
function love.load()
    -- player variables
    posx, posy = 22, 12
    dirx, diry = -1, 0
    planex, planey = 0, 0.66
    movespeed, rotspeed = 2, 2
    
    -- turn the lights on
    light = false

    -- h = screen height
    -- w = screen width
    h = 256
    w = 300
    screenw = 300
    screenh = h
    -- unused
    texwidth = 300
    texheight = 300

    -- set gamescreen
    fullscreen = true
    success = love.window.setMode( screenw, h, {fullscreen=fullscreen} )

    -- load canvas
    canvas = love.graphics.newCanvas(w, h)
    canvas:setFilter("nearest", "nearest")
    canvas = canvas:newImageData()
 

    -- load images
    walls = {
      love.image.newImageData("brick.jpg"),
      love.image.newImageData("example.png")
    }

    spritesheet = {
      love.image.newImageData("doompig.png")
    }

    spriteims = {
      love.graphics.newImage(spritesheet[1])
    }

    sprites = {
      {x = 20, y = 11, spriteimage = 1, xoffset = 0, yoffset = -30, scale = 0.25}
    }

    for i=1,#sprites do
      map[sprites[i].x][sprites[i].y] = 9
    end

    spritehits = {{}}
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
  if fullscreen then
    love.graphics.scale(4, 4)
  end

  love.graphics.print("posx: "..posx, 0, 0)
  love.graphics.print("posy: "..posy, 0, 10)

  local cnvs = draw3d()
  local screentodraw = love.graphics.newImage(cnvs)
  love.graphics.draw(screentodraw, 80)
  cnvs = drawsprites(1)

  -- love.graphics.setColor(255,0,0)

  -- love.graphics.rectangle("fill", screenw, 0, w-screenw, h )

  collectgarbage('collect')
end

function drawsprites(number)

  local sprite = sprites[number]
  if spritehits[sprite.x] == nil then
    return
  end
  if spritehits[sprite.x][sprite.y] == nil then
    return
  end

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

  local fade = dist*2
  localspritedata:mapPixel(function(x, y, r, g, b, a) return r/fade, g/fade, b/fade, a end)
  local spriteimage = spriteims[sprite.spriteimage]
  spriteimage:replacePixels(localspritedata)
  love.graphics.draw(spriteimage, spritescreenx + sprite.xoffset + 80, h/2 + sprite.yoffset/dist, 0, sprite.scale/dist)

end

function draw3d()
 local cnvs = canvas:clone()

 for x=0,w do
  local camerax = (2 * x) / w - 1
  
  local raydirx = dirx + planex * camerax
  local raydiry = diry + planey * camerax

  local mapx = math.floor(posx)
  local mapy = math.floor(posy)

  local deltadistx = math.abs(1 / raydirx)
  local deltadisty = math.abs(1 / raydiry)

  -- step direction
  local stepx = 0
  local stepy = 0

  local wallhit = false
  local side = 0

  if raydirx < 0 then
   stepx = -1
   sidedistx = (posx - mapx) * deltadistx
  else
   stepx = 1
   sidedistx = (mapx + 1 - posx) * deltadistx
  end
  if raydiry < 0 then
   stepy = -1
   sidedisty = (posy - mapy) * deltadisty
  else
   stepy = 1
   sidedisty = (mapy + 1 - posy) * deltadisty
  end

  local wallnumber = 0
  local count = 0
  while not(wallhit) do
   if sidedistx < sidedisty then
    sidedistx = sidedistx + deltadistx
    mapx = mapx + stepx
    side = 0
   else
    sidedisty = sidedisty + deltadisty
    mapy = mapy + stepy
    side = 1
   end
   
   local mapval = map[mapx][mapy]
   if mapval > 0 and mapval < 9 then
    wallhit = true
    wallnumber = map[mapx][mapy]
    break
   elseif mapval == 9 then
    spritehits[mapx] = {}
    spritehits[mapx][mapy] = true
   end
   
   if count > 15 then
    wallhit = false
    break
   end
   count = count + 1
  end
  
  if wallhit then
   local wallsprite = walls[wallnumber]:clone()
   local imageheight = wallsprite:getHeight()-1
   local imagewidth = wallsprite:getWidth()-1
   local perpwalldist = 0
   
   if side == 0 then
    perpwalldist = (mapx - posx + (1 - stepx) / 2) / raydirx
   else
    perpwalldist = (mapy - posy + (1 - stepy) / 2) / raydiry
   end

   local lineheight = (h / perpwalldist)
   local drawstart = -lineheight / 2 + h / 2
   if drawstart < 0 then
    drawstart = 0
   end
   drawend = lineheight / 2 + h / 2
   if drawend > h then
    drawend = h - 1
   end

    --texturing calculations
    -- texNum = worldMap[mapX][mapY] - 1 --1 subtracted from it so that texture 0 can be used!

    --calculate value of wallX
    local wallx = 0 --where exactly the wall was hit
    if (side == 0) then
      wallx = posy + perpwalldist * raydiry
    else
      wallx = posx + perpwalldist * raydirx
    end
    wallx = wallx - math.floor(wallx)

    --x coordinate on the texture
    local texx = wallx * texwidth
    if (side == 0 and raydirx > 0) then
      texx = texwidth - texx - 1
    end
    if (side == 1 and raydiry < 0) then
      texx = texwidth - texx - 1
    end

    -- How much to increase the texture coordinate per screen pixel
    local step = 1.0 * texheight / lineheight
    -- Starting texture coordinate
    local texpos = (drawstart - h / 2 + lineheight / 2) * step + 1
    local fade = perpwalldist*perpwalldist/4
    if texx > 0 and x < w then
      for y=drawstart,drawend do
        -- Cast the texture coordinate to integer, and mask with (texHeight - 1) in case of overflow
        local texy = texpos
        texpos = texpos + step
        if texx > imagewidth or texy > imageheight then
          break
        end

        local r, g, b, a = wallsprite:getPixel(texx, texy)
        cnvs:setPixel(x, y, r, g, b, a/fade)
      end
    end
    -- DRAWBUFFER
    -- love.graphics.line(x, 0, x, drawstart)
    -- love.graphics.line(x, drawstart, x, drawend)
    -- love.graphics.line(x+80, drawend, x+80, h)
  end
 end
 return cnvs
end