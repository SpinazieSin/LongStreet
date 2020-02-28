
local floor = math.floor
local abs = math.abs
function draw3d()
 local drawend = h/2
 local wallx = 0
 local side = 0

 -- step direction
 local stepx = 0
 local stepy = 0
 for x=1,w do
  local wallhit = false
  local camerax = (2 * x) / w - 1
  local raydirx = dirx + planex * camerax
  local raydiry = diry + planey * camerax
  local deltadistx = math.abs(1 / raydirx)
  local deltadisty = math.abs(1 / raydiry)
 
   local mapx = math.floor(posx)
   local mapy = math.floor(posy)
   
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
  local windownumber = 0
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
    windownumber = windowmap[mapx][mapy]
    break
   elseif mapval == 9 then
    spritehits[mapx] = {}
    spritehits[mapx][mapy] = true
   end
   
   if count > 50 then
    wallhit = false
    break
   end
   count = count + 1
  end

  if wallhit then
   local wallsprite = walls[wallnumber]
   local imageheight = #wallsprite
   local imagewidth = #wallsprite[1]
   perpwalldist = 0
   
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

    --calculate value of wallX
     --where exactly the wall was hit
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

    local windowsprite, windowheight, windowwidth, windowx, windowy = 0
    local windowdraw = false
    if windownumber > 0 then
      local window = windowpos[windownumber]
      if window.side == side or window.side == -1 then
        windowx = window.xoffset
        windowwidth = window.width + windowx
        if texx > windowx and texx < windowwidth then
          windowy = window.yoffset + 1
          windowsprite = windows[window.image]
          windowheight = window.height + windowy
          windowdraw = true
        end
      end
    end

    -- How much to increase the texture coordinate per screen pixel
    local step = 1.0 * texheight / lineheight
    -- Starting texture coordinate
    local texpos = (drawstart - h / 2 + lineheight / 2) * step + 1.1

    local fade = 1
    if darkness then
      fade = darkness_scale*perpwalldist*perpwalldist/4
    end

    if side == 0 then
      fade = fade * 2
    end

    -- for y=1,drawstart do
    --   canvas.setPixel(x, y, 0, 0, 0, 0)
    -- end
    -- for y=drawend,h do
    --   canvas.setPixel(x, y, 0, 0, 0, 0)
    -- end

    texx = math.floor(texx)
    if texx > 1 and x < w then
      for y=drawstart,drawend do
        -- Cast the texture coordinate to integer, and mask with (texHeight - 1) in case of overflow
        local texy = math.floor(texpos)
        texpos = texpos + step
        
        if texy < imageheight then
          local rgba = wallsprite[texx][texy]
          cnvs:setPixel(x, y, rgba[1], rgba[2], rgba[3], rgba[4]/fade)
          if y > lineheight then
            cnvs:setPixel(x, y-lineheight, rgba[1], rgba[2], rgba[3], rgba[4]/fade)
          end
          if y + lineheight < h then
            -- cnvs:setPixel(x, y+lineheight, rgba[1], rgba[2], rgba[3], rgba[4]/fade)
          end
        end

        if windowdraw then
          if texy > windowy and texy < windowheight then
            local rgba = windowsprite[texx - windowx + 1][texy-windowy]
            cnvs:setPixel(x, y, rgba[1], rgba[2], rgba[3], rgba[4]/fade)
          end
        end
      end
    end
    -- DRAWBUFFER
    -- love.graphics.line(x, 0, x, drawstart)
    -- love.graphics.line(x, drawstart, x, drawend)
    -- love.graphics.line(x, drawend, x, h)

  end
  if floorcasting then
    local floorsprite = floors[1]
    --FLOOR CASTING (vertical version, directly after drawing the vertical wall stripe for the current x)
    local floorxwall, floorywall = 0, 0 --x, y position of the floor texel at the bottom of the wall
    if side == 0 and raydirx > 0 then
      floorxwall = mapx
      floorywall = mapy + wallx
    elseif side == 0 and raydirx < 0 then
      floorxwall = mapx + 1.0
      floorywall = mapy + wallx
    elseif side == 1 and raydiry > 0 then
      floorxwall = mapx + wallx
      floorywall = mapy
    else
      floorxwall = mapx + wallx
      floorywall = mapy + 1.0
    end

    local distwall = perpwalldist
    local distplayer = 0.0

    if (drawend < 0) then
      drawend = h --becomes < 0 when the integer overflows
    end

    --draw the floor from drawEnd to the bottom of the screen
    for y = drawend + 1, h-1 do
        local currentdist = h / (2.0 * y - h) --you could make a small lookup table for this instead
        if currentdist < 3.5 then
          local fade = (darkness_scale * currentdist^3)
          local weight = (currentdist - distplayer) / (distwall - distplayer)

          local currentfloorx = weight * floorxwall + (1.0 - weight) * posx
          local currentfloory = weight * floorywall + (1.0 - weight) * posy

          local floortexx = math.floor(currentfloorx * texwidth) % texwidth
          local floortexy = math.floor(currentfloory * texheight) % texheight
          local rgba = floorsprite[floortexx+1][floortexy+1]
          cnvs:setPixel(x-1, y, rgba[1], rgba[2], rgba[3], rgba[4]/fade)
        end
    end
   end
  end
  -- -- rayDir for leftmost ray (x = 0) and rightmost ray (x = w)
  -- local raydirx0 = dirx - planex
  -- local raydiryy = diry - planey
  -- local raydirx1 = dirx + planex
  -- local raydiry1 = dirx + planey

  -- -- Vertical position of the camera.
  -- local posz = h / 2
  -- --FLOOR CASTING
  -- for y=1,h-1 do
  --   -- Current y position compared to the center of the screen (the horizon)
  --   local p = y - posz

  --   -- Horizontal distance from the camera to the floor for the current row.
  --   -- 0.5 is the z position exactly in the middle between floor and ceiling.
  --   local rowdistance = posz / p

  --   -- calculate the real world step vector we have to add for each x (parallel to camera plane)
  --   -- adding step by step avoids multiplications with a weight in the inner loop
  --   local floorstepx = rowdistance * (raydirx1 - raydirx0) / w
  --   local floorstepy = rowdistance * (raydiry1 - raydiry0) / w
  --   -- real world coordinates of the leftmost column. This will be updated as we step to the right.
  --   local floorx = posx + rowdistance * raydirx0
  --   local floory = posy + rowdistance * raydiry0

  --   for x=1,w-1 do
  --     -- the cell coord is simply got from the integer parts of floorX and floorY
  --     local cellx = math.floor(floorx)
  --     local celly = math.floor(floory)

  --     -- get the texture coordinate from the fractional part
  --     local tx = math.floor(texwidth * (floorx - cellx)) + 1
  --     local ty = math.floor(texheight * (floory - celly)) + 1
  --     print(cellx)
  --     print(floorx)
  --     local floorx = floorx + floorstepx
  --     local floory = floory + floorstepy

  --     -- print(x)
  --     -- print(y)
  --     print(tx)
  --     print(x)
  --     print(y)
  --     print("-")
  --     local rgba = floors[1][tx][ty]
  --     canvas:setPixel(x, y, rgba[1], rgba[2], rgba[3], rgba[4]/(y/h))
  --   end
  -- end
end


function drawsprites(spritex, spritey, number)

  local sprite = spriteimages[number]

  if spritehits[spritex] ~= nil and spritehits[spritex][spritey] ~= nil then

  local spritex = spritex - posx + 0.5
  local spritey = spritey - posy + 0.5

  local invdet = 1.0 / (planex * diry - dirx * planey) --required for correct matrix multiplication

  local transformx = invdet * (diry * spritex - dirx * spritey)
  local transformy = invdet * (-planey * spritex + planex * spritey)--this is actually the depth inside the screen, that what Z is in 3D
  local dist = math.sqrt((spritex^2) + (spritey^2))


  if dist > 10 then
    return
  end

  local localspritedata = spritesheet[number]:clone()

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
    fade = dist*2*darkness_scale
  end

  localspritedata:mapPixel(function(x, y, r, g, b, a) return r/fade, g/fade, b/fade, a end)
  local spriteimage = spriteims[number]
  spriteimage:replacePixels(localspritedata)
  love.graphics.draw(spriteimage, spritescreenx + sprite.xoffset/transformy, h/2 + sprite.yoffset/transformy + canvas_y_offset, 0, sprite.scale/transformy)
  -- localspritedata:release()
  end
end
