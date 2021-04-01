package.path = "rawterm/rawterm.lua"
local rawterm = require("rawterm")
local string = require("string")

BlockChar = "x"
PlayerPosY = 4
PlayerPosX = 4
LastPlayerPosY = PlayerPosY
LastPlayerPosX = PlayerPosX

Map = {
  "                                        ",
  "                                        ",
  "////////////////// /////////////////////",
  "                                        ",
  "                                        ",
  "                                        ",
  "              x                         ",
  "              x                       x ",
  "              xxxxxxxx                  ",
  "/////////////////////x//////////////////",
  "/////////////////////x//////////////////",
  "//////////////xxxxxxxx//////////////////",
  "////////////////////xx//////////////////",
  "////////////////////////////////////////",
  "////////////////////////////////////////",
  "////////////////////////////////////////",
  "////////////////x///////////////////////",
  "////////////////////////////////////////",
  "////////////////////////////////////////",
  "////////////////////////////////////////",
  "////////////////////////////////////////"
  }

-- get map width and height
for row in pairs(Map) do
  MapHeight = row
end
MapWidth = Map[1]:len()

-- enable raw mode for getting input from keyboard
rawterm.enableRawMode({
  carriageOut = "\n"
})
function DrawPlayer(position_y, position_x, direction)

  -- reprint the map after the player
  io.write("\027[" .. LastPlayerPosY .. ";" .. LastPlayerPosX .. "H")
  io.write(string.sub(Map[LastPlayerPosY],LastPlayerPosX,(LastPlayerPosX+5)))
  io.write("\027[" .. (LastPlayerPosY+1) .. ";" .. LastPlayerPosX .. "H")
  io.write(string.sub(Map[(LastPlayerPosY+1)],LastPlayerPosX,(LastPlayerPosX+5)))

  -- remember position for map reprint
  LastPlayerPosY = position_y
  LastPlayerPosX = position_x

  -- print out the player depending on the direction
  if direction == 0 then
    io.write("\027[" .. position_y .. ";" .. position_x .. "H")
    io.write(">(.)")
    io.write("\027[" .. (position_y+1) .. ";" .. (position_x+1) .. "H")
    io.write("(___/")
  else
    io.write("\027[" .. position_y .. ";" .. (position_x+2) .. "H")
    io.write("(.)<")
    io.write("\027[" .. (position_y+1) .. ";" .. position_x .. "H")
    io.write("\\___)")
  end
end

function GameLoop()
  os.execute("clear")
  --direction of the player (1-right, 0-left)
  local playerDir = 1

  -- print out the whole map
  for _, data in ipairs(Map) do
    io.write(data, "\n")
  end

  -- infinite loop
  while true do

    -- draw the player
    DrawPlayer(PlayerPosY,PlayerPosX,playerDir)
    -- put the cursor at the map's end
    io.write("\027[" .. MapHeight .. ";" .. (MapWidth+1) .. "H")

    -- wait for input
    local char = io.read(1) or "\0"

    -- back to menu
    if char == "p" then
      break

    -- move the player and detect walls
    elseif char == "h" and  PlayerPosX >= 2 then
      playerDir = 0
      if string.sub(Map[PlayerPosY],(PlayerPosX-1),(PlayerPosX-1)) ~= BlockChar
      and string.sub(Map[PlayerPosY+1],(PlayerPosX-1),(PlayerPosX-1)) ~= BlockChar
      then
        PlayerPosX = PlayerPosX - 1
      end

    elseif char == "j"
      and PlayerPosY <= (MapHeight - 2)
      and string.find(string.sub(Map[PlayerPosY+2],(PlayerPosX),(PlayerPosX+5)), BlockChar) == nil
      then
      PlayerPosY = PlayerPosY + 1

    elseif char == "k"
      and PlayerPosY >= 2
      and string.find(string.sub(Map[PlayerPosY-1],(PlayerPosX),(PlayerPosX+5)), BlockChar) == nil
      then
      PlayerPosY = PlayerPosY - 1

    elseif char == "l" and PlayerPosX <= (MapWidth - 6) then
      playerDir = 1
      if string.sub(Map[PlayerPosY],(PlayerPosX+6),(PlayerPosX+6)) ~= BlockChar
      and string.sub(Map[PlayerPosY+1],(PlayerPosX+6),(PlayerPosX+6)) ~= BlockChar
      then
        PlayerPosX = PlayerPosX + 1
      end
    end
  end
end

function MainMenu()
  local menu = {" ", " ", "New Game", "Resume Game", "Load Game", "Quit", " ", " "}
  local menuIndex = 3

  -- enter initial loop aka main menu
  while true do
        -- clear terminal every cycle
        os.execute("clear")

        -- show menu at 10th line
        io.write("\027[10;0H")
        io.write("-----------------------------\n",
                "   ", menu[menuIndex - 2] .. "\n",
                "   ", menu[menuIndex - 1] .. "\n",
                "-->", menu[menuIndex] .. "\n",
                "   ", menu[menuIndex + 1] .. "\n",
                "   ", menu[menuIndex + 2] .. "\n",
                "-----------------------------\n")

        -- wait for input
        local char = io.read(1) or "\0"

        -- test characters
        if char == "j" and menuIndex < 6 then
            menuIndex = menuIndex + 1
        elseif char == "k" and menuIndex > 3 then
            menuIndex = menuIndex - 1
        elseif char == "l" then
            if menu[menuIndex] == "New Game" then
              PlayerPosX = 4
              PlayerPosY = 4
              GameLoop()
            elseif menu[menuIndex] == "Resume Game" then
              GameLoop()
            elseif menu[menuIndex] == "Load Game" then
              GameLoop()
            elseif menu[menuIndex] == "Quit" then
              break
            end
        end
   end
end

-- Entry point
MainMenu()

-- disable raw mode and clear the terminal
os.execute("clear")
rawterm.disableRawMode()
