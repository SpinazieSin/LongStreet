
function add_unit(x, y, index, spritenumber, character)
  local x = x or 1
  local y = y or 1
  local sprite = spritenumber or 1
  local index = index or 1

  local character = character or 1  
  local chardialogue = getdialogue(character)
  local speaks = false
  if #chardialogue > 0 then
    speaks = true
  end
  
  table.insert(units, {
    x = x,
    y = y,
    index = index,
    sprite = sprite,
    chardialogue = chardialogue,
    speaks = speaks,
    update = function(self)
      map[self.x][self.y] = 9
      if self.speaks then
        if dpress and #dialogue < 1 then
          if math.sqrt((self.x - posx)^2 + (self.y - posy)^2) < 3 then
            table.insert(dialogue, self.chardialogue[1][1])
          end
        end
      end
    end,
    draw = function(self)
      drawsprites(self.x, self.y, self.sprite)
    end,
    drawshadow = function(self)
    end,
    done = true}
  )
end