require("map")
require("rendering")
require("config")

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
      love.image.newImageData("assets/decorations/window-1.png"),
      love.image.newImageData("assets/decorations/window-2.png")
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