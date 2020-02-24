require("maps.world")
require("maps.windows")
require("maps.floor")
require("rendering.rendering")
require("config")

function love.load()
    load_variables()

    love.mouse.setRelativeMode( true )

    mousedx = 0

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

    windowimages = {
      love.image.newImageData("assets/decorations/window-1.png"),
      love.image.newImageData("assets/decorations/window-2.png"),
      love.image.newImageData("assets/decorations/Airco.png")
    }

    -- arguments:
    -- xoffset is offset on wallsprite in x direction
    -- yoffset is offset on wallsprite in x direction
    -- image is the imagenumber from windowimages table
    -- side = -1, shows window on all sides of the sprite
    -- side = 1 shows it on the x
    windowpos = {
      {xoffset = 100, yoffset = 200, image = 1, side = 1},
      {xoffset = 200, yoffset = 58, image = 2, side = 1},
      {xoffset = 150+math.floor(math.random(150)), yoffset = 50+math.floor(math.random(150)), image = 1, side = -1},
      {xoffset = 150+math.floor(math.random(150)), yoffset = 50+math.floor(math.random(150)), image = 2, side = -1},
      {xoffset = 150+math.floor(math.random(150)), yoffset = 50+math.floor(math.random(150)), image = 1, side = -1},
      {xoffset = 150+math.floor(math.random(150)), yoffset = 50+math.floor(math.random(150)), image = 2, side = -1},
      {xoffset = 150+math.floor(math.random(150)), yoffset = 50+math.floor(math.random(150)), image = 3, side = -1},
    }

    windows = {}

    spritesheet = {
      love.image.newImageData("assets/lantern_pole.png"),
      love.image.newImageData("assets/example.png")
    }

    sprites = {
      {x = 5, y = 5, spriteimage = 1, xoffset = 0, yoffset = -300, scale = 1}
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

 local movespeed = runspeed * dt
 local rotspeed = turnspeed * dt

 if love.keyboard.isDown("w") then
  moveup(movespeed)
 elseif love.keyboard.isDown("s") then
  movedown(movespeed)
 end

 if love.keyboard.isDown("a") then
  rotspeed = math.pi/2
  rotateleft(rotspeed)
  moveup(movespeed)
  rotateleft(-rotspeed)
 elseif love.keyboard.isDown("d") then
  rotspeed = math.pi/2
  rotateright(rotspeed)
  moveup(movespeed)
  rotateright(-rotspeed)
 end

 if love.keyboard.isDown("q") then
  rotateleft(rotspeed)
 elseif love.keyboard.isDown("e") then
  rotateright(rotspeed)
 end

 if mousedx > 0.01 then
  rotateright(mousedx/5 * dt)
 elseif mousedx < 0.01 then
  rotateright(mousedx/5 * dt)
 end

 if love.keyboard.isDown("0") then
  h = 1920/2
  w = h*2
  reloadscreen()
  planex, planey = 0, xscale/yscale
 elseif love.keyboard.isDown("9") then
  h = 512
  w = h*2
  reloadscreen()
  planex, planey = 0, xscale/yscale
 elseif love.keyboard.isDown("8") then
  h = 256
  w = h*2
  reloadscreen()
  planex, planey = 0, xscale/yscale
 elseif love.keyboard.isDown("7") then
  planex, planey = 0, xscale/yscale
  local fieldofview = 100
  dirx = -100/fieldofview
  diry = 0  
 end
end

function love.draw()
  love.graphics.clear()

  if firstrun then
    drawfirstrun()
  end

  if fullscreen then
    love.graphics.scale(xscale, yscale)
  end

  local cnvs = draw3d()
  local screentodraw = love.graphics.newImage(cnvs)
  love.graphics.draw(screentodraw, 0, canvas_y_offset)
  cnvs = drawsprites(1)

  love.graphics.print(planey, 0, 1)
  if love.keyboard.isDown("x") then
    planey = planey - 0.1
  end
  if love.keyboard.isDown("c") then
    planey = planey + 0.1
  end

  -- I REALLY WANT TO REMOVE THIS
  collectgarbage('collect')
  firstrun = false
  mousedx = 0
end

function drawfirstrun()
  -- love.graphics.setColor(0, 0, 0)
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

  for number=1,#windowpos do
    local window = windowimages[windowpos[number].image]:clone()
    windowpos[number].width = window:getWidth()-1 
    windowpos[number].height = window:getHeight()-1
    local windowsprite = {}
    for wallx=1,window:getWidth()-1 do
      table.insert(windowsprite, {})
      for wally=1,window:getHeight()-1 do
        local r, g, b, a = window:getPixel(wallx, wally)
        windowsprite[wallx][wally] = {r, g, b, a}
      end
    end
    table.insert(windows, windowsprite)
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

function moveup(movespeed)
  if map[math.floor(posx + dirx * movespeed)][math.floor(posy)] < 1 then
   posx = posx + dirx * movespeed
  end
  if map[math.floor(posx)][math.floor(posy + diry * movespeed)] < 1 then
   posy = posy + diry * movespeed
  end
end

function movedown(movespeed)
  if map[math.floor(posx - dirx * movespeed)][math.floor(posy)] < 1 then
   posx = posx - dirx * movespeed
  end
  if map[math.floor(posx)][math.floor(posy - diry * movespeed)] < 1 then
   posy = posy - diry * movespeed
  end
end

function rotateleft(rotspeed)
  olddirx = dirx
  dirx = dirx * math.cos(rotspeed) - diry * math.sin(rotspeed)
  diry = olddirx * math.sin(rotspeed) + diry * math.cos(rotspeed)
  oldplanex = planex
  planex = planex * math.cos(rotspeed) - planey * math.sin(rotspeed)
  planey = oldplanex * math.sin(rotspeed) + planey * math.cos(rotspeed)
end

function rotateright(rotspeed)
  olddirx = dirx
  dirx = dirx * math.cos(-rotspeed) - diry * math.sin(-rotspeed)
  diry = olddirx * math.sin(-rotspeed) + diry * math.cos(-rotspeed)
  oldplanex = planex
  planex = planex * math.cos(-rotspeed) - planey * math.sin(-rotspeed)
  planey = oldplanex * math.sin(-rotspeed) + planey * math.cos(-rotspeed)
end

function love.mousemoved(x, y, dx, dy)
  mousedx = dx
end