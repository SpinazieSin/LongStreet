map = {
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
  {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1},
  {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
}

-- Load some default values for our rectangle.
function love.load()
    -- player variables
    posx, posy = 22, 12
    dirx, diry = -1, 0
    planex, planey = 0, 0.66
    movespeed, rotspeed = 0.01, 0.01
    
    -- h = screen height
    -- w = screen width
    h = 512
    w = 512

    -- unused
    texwidth = 100
    texheight = 100

    -- set gamescreen
    fullscreen = false
    success = love.window.setMode( w, h, {fullscreen=fullscreen} )

    -- load canvas and images
    canvas = love.graphics.newCanvas(w, h)
    canvas = canvas:newImageData()
    imagedata = love.image.newImageData("example.png")
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
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
  local cnvs = draw3d()
  local screentodraw = love.graphics.newImage(cnvs)
  if fullscreen then
    love.graphics.scale(2.5, 2.5)
  end
  love.graphics.draw(screentodraw)
  collectgarbage('collect')
end

function draw3d()
 local cnvs = canvas:clone()

 for x=0,w do
  camerax = (2 * x) / w - 1
  
  raydirx = dirx + planex * camerax
  raydiry = diry + planey * camerax

  mapx = math.floor(posx)
  mapy = math.floor(posy)

  deltadistx = math.abs(1 / raydirx)
  deltadisty = math.abs(1 / raydiry)

  -- step direction
  stepx = 0
  stepy = 0

  wallhit = false
  side = 0

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

  wallcolor = 8
  count = 0
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
   if map[mapx][mapy] > 0 or count > 50 then
    wallhit = true
    wallcolor = map[mapx][mapy]
    break
   end
   count = count + 1
  end
  
  if wallhit then
   if side == 0 then
    perpwalldist = (mapx - posx + (1 - stepx) / 2) / raydirx
   else
    perpwalldist = (mapy - posy + (1 - stepy) / 2) / raydiry
   end

   lineheight = (h / perpwalldist)
   drawstart = -lineheight / 2 + h / 2
   if drawstart < 0 then
    drawstart = 0
   end
   drawend = lineheight / 2 + h / 2
   if drawend >= h then
    drawend = h - 1
   end

    --texturing calculations
    -- texNum = worldMap[mapX][mapY] - 1 --1 subtracted from it so that texture 0 can be used!

    --calculate value of wallX
    wallx = 0 --where exactly the wall was hit
    if (side == 0) then
      wallx = posy + perpwalldist * raydiry
    else
      wallx = posx + perpwalldist * raydirx
    end
    wallx = wallx - math.floor(wallx)

    --x coordinate on the texture
    texx = wallx * texwidth
    if (side == 0 and raydirx > 0) then
      texx = texwidth - texx - 1
    end
    if (side == 1 and raydiry < 0) then
      texx = texwidth - texx - 1
    end

    -- How much to increase the texture coordinate per screen pixel
    step = 1.0 * texheight / lineheight
    -- Starting texture coordinate
    texpos = (drawstart - h / 2 + lineheight / 2) * step + 1
    local imageheight = imagedata:getHeight()
    local imagewidth = imagedata:getWidth()
    if texx > 0 and x < w then
      for y=drawstart,drawend do
        -- Cast the texture coordinate to integer, and mask with (texHeight - 1) in case of overflow
        texy = texpos
        if texx > imagewidth or texy > imageheight then
          break
        end
        texpos = texpos + step

        local r, g, b, a = imagedata:getPixel(texx, texy)
        cnvs:setPixel(x, y, r, g, b, a)
        --make color darker for y-sides: R, G and B byte each divided through two with a "shift" and an "and"
        --if (side == 1) color = (color >> 1) & 8355711
      end
    end

    -- DRAWBUFFER
    if not(fullscreen) then
     love.graphics.line(x, drawstart, x, drawend)
    end
  end
 end
 return cnvs
end