
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
   
   if count > 15 then
    wallhit = false
    break
   end
   count = count + 1
  end
  
  if wallhit then
   local wallsprite = walls[wallnumber]
   local imageheight = #wallsprite
   local imagewidth = #wallsprite[1]
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

    local windowsprite, windowheight, windowwidth, windowx, windowy = 0
    local windowdraw = false
    if windownumber > 0 then
      windowx = windowpos[windownumber].xoffset
      windowwidth = windowpos[windownumber].width + windowx
      if texx > windowx and texx < windowwidth then
        windowy = windowpos[windownumber].yoffset + 1
        windowsprite = windows[windowpos[windownumber].image]
        windowheight = windowpos[windownumber].height + windowy
        windowdraw = true
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

    texx = math.floor(texx)
    if texx > 1 and x < w then
      for y=drawstart,drawend do

        -- Cast the texture coordinate to integer, and mask with (texHeight - 1) in case of overflow
        local texy = math.floor(texpos)
        texpos = texpos + step
        if texx > imagewidth or texy > imageheight then
          break
        end

        local rgba = wallsprite[texx][texy]
        cnvs:setPixel(x, y, rgba[1], rgba[2], rgba[3], rgba[4]/fade)

        if windowdraw then
          if texy > windowy and texy < windowheight then
            local rgba = windowsprite[texx - windowx + 1][texy-windowy]
            cnvs:setPixel(x, y, rgba[1], rgba[2], rgba[3], rgba[4]/fade)
          end
          -- love.graphics.print(windowsprite.getHeight().." - a", 0, 10)
          -- love.graphics.print(windowsprite.getWidth().." - a", 0, 20)
          -- love.graphics.print(texx.." - a", 0, 30)
          -- love.graphics.print(texy.." - a", 0, 40)
          -- local r, g, b, a = windowsprite:getPixel(texx-40, texy-40)
          -- cnvs:setPixel(x, y, r, g, b, a/fade)
        end
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
    fade = dist*2*darkness_scale
  end

  localspritedata:mapPixel(function(x, y, r, g, b, a) return r/fade, g/fade, b/fade, a end)
  local spriteimage = spriteims[sprite.spriteimage]
  spriteimage:replacePixels(localspritedata)
  love.graphics.draw(spriteimage, spritescreenx + sprite.xoffset, h/2 + sprite.yoffset/dist, 0, sprite.scale/dist)
  end
end
