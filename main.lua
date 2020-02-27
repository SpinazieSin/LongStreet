require("maps.world")
require("maps.windows")
require("maps.floor")
require("rendering.rendering")
require("config")
require("units.base")
require("units.characters")

function love.load()
    load_variables()

    love.mouse.setRelativeMode( true )

    mousedx = 0
    black_bar = 0
    black_bar_show = false

    success = love.window.setMode( screenw, h, {fullscreen=fullscreen} )

    -- load canvas
    canvas = love.graphics.newCanvas(w, h)
    canvas:setFilter("nearest", "nearest")
    canvas = canvas:newImageData()

    -- load floors
    floors = {}
    floorimages = {
      love.image.newImageData("assets/floors/brick_road.png"),
      love.image.newImageData("assets/floors/pavement.png")
    }

    -- load walls
    walls = {}
    wallimages = {
      love.image.newImageData("assets/walls/bricks1.png"),
      love.image.newImageData("assets/example.png")
    }

    -- load windows
    windows = {}
    windowimages = {
      love.image.newImageData("assets/decorations/window-1.png"),
      love.image.newImageData("assets/decorations/window-2.png"),
      love.image.newImageData("assets/decorations/airco.png"),
      love.image.newImageData("assets/gate.png")
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
      {xoffset = 150+math.floor(math.random(150)), yoffset = 50+math.floor(math.random(150)), image = 3, side = -1},
      {xoffset = 50, yoffset = 46, image = 4, side = -1}
    }


    spritesheet = {
      love.image.newImageData("assets/lantern_pole.png"),
      love.image.newImageData("assets/example.png"),
      love.image.newImageData("assets/bin.png"),
    }

    spriteimages = {
      {xoffset = 0, yoffset = -300, scale = 1}, -- pole
      {xoffset = 0, yoffset = 0, scale = 1}, -- example
      {xoffset = 0, yoffset = 0, scale = 0.5} -- bin
    }

    sprites = {
      {x = 5, y = 5, spriteimage = 1, character = 1},
      {x = 10, y = 20, spriteimage = 3, character = 2}
    }

    spriteims = {}
    for i=1,#spritesheet do
      table.insert(spriteims, love.graphics.newImage(spritesheet[i]))
    end

    units = {}
    -- for i=1,#sprites do
    --   map[sprites[i].x][sprites[i].y] = 9
    -- end

    for i=1,#sprites do
      local sprite = sprites[i]
      local loadsprite = spritesheet[sprites[i].spriteimage]:clone()
      add_unit(sprite.x, sprite.y, i, sprite.spriteimage, sprite.character)
    end

    spritehits = {{}}

    dialogue = {}
    dialogue_type = 0
    dialogue_print = ""
    dpress = false

    drawfirstrun()
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
 cnvs = canvas:clone()
 for i=1,#spritehits do
    table.remove(spritehits[i])
 end

 local rpress = love.keyboard.isDown("r")
 if rpress and not(dpress) then
  dpress = true
 elseif dpress and not(rpress) then
  dpress = false
 end
 local movespeed = runspeed * dt
 local rotspeed = turnspeed * dt

 if #dialogue < 1 then
   if love.keyboard.isDown("w") then
    moveup(movespeed)
   elseif love.keyboard.isDown("s") then
    movedown(movespeed)
   end
   if love.keyboard.isDown("q") then
    rotateleft(rotspeed)
   elseif love.keyboard.isDown("e") then
    rotateright(rotspeed)
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
 else
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
  h = 128
  w = h*2
  reloadscreen()
  planex, planey = 0, xscale/yscale
 elseif love.keyboard.isDown("6") then
  h = 56
  w = h*2
  reloadscreen()
  planex, planey = 0, xscale/yscale
 elseif love.keyboard.isDown("5") then
  planex, planey = 0, xscale/yscale
  local fieldofview = 100
  dirx = -100/fieldofview
  diry = 0
 end
 
 for i=1,#units do
  units[i]:update()
 end
end

function love.draw()
  local time = love.timer.getTime()
  love.graphics.clear()

  if fullscreen then
    love.graphics.scale(xscale, yscale)
  end

  draw3d()
  local screentodraw = love.graphics.newImage(cnvs)
  love.graphics.draw(screentodraw, 0, canvas_y_offset)
  drawsprites(1)
  cnvs:release()
  screentodraw:release()

  for i=1,#units do
   units[i]:draw()
  end

  if love.keyboard.isDown("x") then
    planey = planey - 0.1
  end
  if love.keyboard.isDown("c") then
    planey = planey + 0.1
  end

  if #dialogue > 0 then
    -- draw black bars
    love.graphics.rectangle("fill", 0, 0, screen_width, black_bar)
    love.graphics.rectangle("fill", 0, h-black_bar, screen_width, h)
    -- increase black bar size
    if black_bar < h*black_bar_limit then
      black_bar = black_bar + (yscale * h/1000)
    else
      -- draw dialogue
      love.graphics.print(dialogue[1], w/10, h/2)
      -- skip dialogue
      if dpress then
        table.remove(dialogue, 1)
      end
    end
  else
    black_bar = 0
  end

  mousedx = 0
  love.graphics.print("Backspace toggles floor. FPS: "..math.floor(1/(love.timer.getTime() - time)))
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
      for wally=1,wallimage:getHeight() -1 do
        local r, g, b, a = wallimage:getPixel(wallx, wally)
        wallsprite[wallx][wally] = {r, g, b, a}
      end
    end
    table.insert(walls, wallsprite)
  end

  for number=1,#floorimages do
    local floorimage = floorimages[number]:clone()
    local floorsprite = {}
    for floorx=1,floorimage:getWidth()-1 do
      table.insert(floorsprite, {})
      for floory=1,floorimage:getHeight()-1 do
        local r, g, b, a = floorimage:getPixel(floorx, floory)
        floorsprite[floorx][floory] = {r, g, b, a}
      end
    end
    table.insert(floors, floorsprite)
  end

  local windowindex = 0
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

    if windowindex < windowpos[number].image then
      windowindex = windowpos[number].image
      table.insert(windows, windowsprite)
    end
  end

  -- for number=1,#sprites do
  --   local sprite = sprites[number]
  --   local localspritedata = spritesheet[sprite.spriteimage]:clone()
  --   localspritedata:mapPixel(function(x, y, r, g, b, a) return r, g, b, a end)
  --   local spriteimage = spriteims[sprite.spriteimage]
  --   spriteimage:replacePixels(localspritedata)
  --   love.graphics.draw(spriteimage, 0, 0, 0, sprite.scale)
  -- end
  -- love.graphics.rectangle("fill", 0, 0, screen_width, screen_height)
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

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "backspace" then
   if floorcasting then
     floorcasting = false
   else
     floorcasting = true
   end
  end
 end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
     return true
   else
     return false
   end
end