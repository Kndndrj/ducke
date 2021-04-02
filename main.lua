package.path = "rawterm/rawterm.lua"
local rawterm = require("rawterm")
local string = require("string")

BlockChar = "x"
WaterChar = "~"
WaterColor = "\027[036m"
BlockColor = "\027[040m\027[030m"
PlayerColor = "\027[033m"
PlayerPosY = 4
PlayerPosX = 4
LastPlayerPosY = PlayerPosY
LastPlayerPosX = PlayerPosX

Banner = {
  "                          ▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓    ",
  "                         ▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓██████████▓▒▒▒▒▓▒░▒▓  ",
  "                       ▓▓▒▒▒▒▒▒▒▓▓▓███████████████████▓▒▓▓░░░░▒▒",
  "                    ▒▓▓▒▒▒▒▒▓▓███████████████▓▓▓▒▒▒▒▓▓▓▓▒░░░░░░▒",
  "                  ▒▓▓▒▒▒▒▒▓███▓▒▒░░░░░░▒▓█▒░░░░░░░░░░░░░▒▒▒░░░░░",
  "              ▒▓▓▓▓▒▒▒▒▒▓██▓░░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░",
  "             ▒▓▒▒▒▒▒▒▒▒▓█▒░░░░░░░░░░░░▓░░░░░░░░░░░░░░░░░░░░░░░░░",
  "            ▓██▒▒▒▒▒▒▓█▓▓▓▓▓▓▓▒▒░░░░░▒▓▒▒▒▓▓▓▒▓▓▓▓▓▓▒▒▒▒▒▒░░░░░░",
  "           ▓█▓▒▒▓▓▓▒▓█▒▒▒▒▒▒▒▒▒▒▒░░░▒▒░░▒▒░▒▒▒░░░░░░░░▒▒▒▒▒▒░░░░",
  "         ▒███        █▓░░▒▒▓▓▓██▒▒░░▒░▒▓▒▓▓▒▓▓▓▓▓▓▓▓▒▒▒▒▒▓▒▓░░░░",
  "        ▒███         █▒▒▒▒█▓█████▓░░▓▒▓░░░░▒█▒▒██▓██▒▒▒▒▒░░░░░░░",
  "        ▓            █▒▒░▒█▓█████▒▓▒▒▒▒░░░░▒██▓██▓█▓▒░▒░░░░░░░░░",
  "                     ▒▓░▒▒▓▓▓▓▓▓▓▒▒░▓▒▒▒▒▒▒▒▓▓▓▒░░░▒▒▒░░░░░░░░░░",
  "                    ▓▓▓▓▓▒░░░▒▒▓▓█▓▓▒▓▓▓▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░",
  "                   ▓▒█░░░▒▓▒▓▓▓▓▒▒▒▒▓▒▓▓█▒░░░░░░░░░░░░░░░░▓▓▓▓▓▓",
  "                   ▓▓█▓▓▓▓▓▒▒▒▒▒▒▒▒▓▓▒▒▒▓▓█▓▓▒▒░░░░▒▒▒▒▓▓▓▒▓▓▓▓▓",
  " ▒█▓▓▓▓▓▓▒▒   ▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▒░",
  "  ▓█▓▓▓▓▓▒▓▓███▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░",
  "    ▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▓▓▒▒░░░░░░░",
  "       ▒▓▓▓▓▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▓▓▓▓▒▒░░░░░░░░░░░",
  "            ▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒░░░░░░░░░░░░░░░░░",
  "                    ▒▒▓▓▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░",
  "                       ▓░░▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░",
  "                        ▓▒░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░",
  "                     ▒▒▒░░░░░░░░░▒▓▒░░▒░░░░░░░░░░░░░░░░░░░░░░░░░",
  "                   ▒▒░░░▒▒█▓▓▒▒░░▓░░█░░░▓░░░░░░░░░░░░░░░░░░░░░░░",
  "                 ▒▒░░░░░░▒▓▓▒▒▒░▒▓▒▒░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░",
  "                ▓░░░░░░▒░░░░░▒▓▒▒▓░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░",
  "               ▓░░░░░░░░▒▒░░░░▒▓▓░░░░▓░░░░░░░░░░░░░░░░░░░░░░░░░░",
  "              ▓░░▒░░▒▒░░░░▓░░▒▒░░░░░░▓░░░░░░░░░░░░░░░░░░░░░░░░░░"
}
Map = {
  "                                    ///////////////////// ///////////////////// ////////////////////",
  "                               ////  ///////////////// ///////////////////// ////////////////////   ",
  "////////////////// ////////////////////////////////////// ///////////////////// ////////////////////",
  "                                        ///////////////// ///////////////////// ////////////////////",
  "                                        ///////////////// ///////////////////// ////////////////////",
  "                                        ///////////////// ///////////////////// ////////////////////",
  "              x                         ////////////////////////////////////////////////////////////",
  "              x                       x ////////////////////////////////////////////////////////////",
  "              xxxxxxxx                  ////////////////////////////////////////////////////////////",
  "/////////////////////x//////////////////////////////////////////////////////////////////////////////",
  "/////////////////////x/////////////////////~////////////////////////////////////////////////////////",
  "//////////////xxxxxxxx//////////////////////~///////////////////////////////////////////////////////",
  "////////////////////xx//////////////////////~~////~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~////////////////////",
  "/////////////////////////////////////////////~////~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~////////////////////",
  "//////////////////////////////////////////////////~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~////////////////////",
  "//////////////////////////////////////////////////~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~////////////////////",
  "////////////////x///////////////////////////////////////////////////////////////////////////////////",
  "////////////////////////////////////////////////////////////////////////////////////////////////////",
  "////////////////////////////////////////////////////////////////////////////////////////////////////",
  "////////////////////////////////////////////////////////////////////////////////////////////////////",
  "////////////////////////////////////////////////////////////////////////////////////////////////////",
  "                                    ///////////////////// ///////////////////// ////////////////////",
  "                               ////  ///////////////// ///////////////////// ////////////////////   ",
  "////////////////// ////////////////////////////////////// ///////////////////// ////////////////////",
  "                                    ///////////////////// ///////////////////// ////////////////////",
  "                               ////  ///////////////// ///////////////////// ////////////////////   ",
  "////////////////// ////////////////////////////////////// ///////////////////// ////////////////////",
  "                                    ///////////////////// ///////////////////// ////////////////////",
  "                               ////  ///////////////// ///////////////////// ////////////////////   ",
  "////////////////// ////////////////////////////////////// ///////////////////// ////////////////////"
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


function Clear()
  -- clear terminal
  os.execute("clear")
  --print out the border (100x30)
  for row = 1,MapHeight,1 do
    io.write("\027[" .. row .. ";" .. (MapWidth+1) .. "H")
    io.write("|")
  end
  io.write("\n")
  for _ = 1,(MapWidth+1),1 do
    io.write("-")
  end
  -- send cursor home
  io.write("\027[H")
end

function PrintBanner()
    -- print out the banner
  for row, data in ipairs(Banner) do
    io.write("\027[" .. row .. ";37H")
    io.write(data)
  end
end

function DrawPlayer(position_y, position_x, direction)

  -- reprint the map after the player water character stays the same color
  local playerRow1 = string.sub(Map[LastPlayerPosY],LastPlayerPosX,(LastPlayerPosX+5))
  local playerRow2 = string.sub(Map[(LastPlayerPosY+1)],LastPlayerPosX,(LastPlayerPosX+5))
  io.write("\027[" .. LastPlayerPosY .. ";" .. LastPlayerPosX .. "H")
  io.write(playerRow1:gsub(WaterChar, WaterColor..WaterChar.."\027[0m"), "\n")
  io.write("\027[" .. (LastPlayerPosY+1) .. ";" .. LastPlayerPosX .. "H")
  io.write(playerRow2:gsub(WaterChar, WaterColor..WaterChar.."\027[0m"), "\n")

  -- remember position for map reprint
  LastPlayerPosY = position_y
  LastPlayerPosX = position_x

  -- print out the player depending on the direction
  if direction == 0 then
    io.write("\027[" .. position_y .. ";" .. position_x .. "H")
    io.write(PlayerColor..">(.)")
    io.write("\027[" .. (position_y+1) .. ";" .. (position_x+1) .. "H")
    io.write("(___/\027[0m")
  else
    io.write("\027[" .. position_y .. ";" .. (position_x+2) .. "H")
    io.write(PlayerColor.."(.)<")
    io.write("\027[" .. (position_y+1) .. ";" .. position_x .. "H")
    io.write("\\___)\027[0m")
  end
end

function MovePlayer(character,direction)
    if character == "h" and  PlayerPosX >= 2 then
      direction = 0
      if string.sub(Map[PlayerPosY],(PlayerPosX-1),(PlayerPosX-1)) ~= BlockChar
      and string.sub(Map[PlayerPosY+1],(PlayerPosX-1),(PlayerPosX-1)) ~= BlockChar
      then
        PlayerPosX = PlayerPosX - 1
      end

    elseif character == "j"
      and PlayerPosY <= (MapHeight - 2)
      and string.find(string.sub(Map[PlayerPosY+2],(PlayerPosX),(PlayerPosX+5)), BlockChar) == nil
      then
      PlayerPosY = PlayerPosY + 1

    elseif character == "k"
      and PlayerPosY >= 2
      and string.find(string.sub(Map[PlayerPosY-1],(PlayerPosX),(PlayerPosX+5)), BlockChar) == nil
      then
      PlayerPosY = PlayerPosY - 1

    elseif character == "l" and PlayerPosX <= (MapWidth - 6) then
      direction = 1
      if string.sub(Map[PlayerPosY],(PlayerPosX+6),(PlayerPosX+6)) ~= BlockChar
      and string.sub(Map[PlayerPosY+1],(PlayerPosX+6),(PlayerPosX+6)) ~= BlockChar
      then
        PlayerPosX = PlayerPosX + 1
      end
    end

    return direction
end

function GameLoop()
  -- clear terminal
  Clear()

  --direction of the player (1-right, 0-left)
  local playerDir = 1
  local char

  -- print out the whole map
  for _, data in ipairs(Map) do
    -- print walls as black blocks
    local mapRow = data:gsub(BlockChar, BlockColor..BlockChar.."\027[0m")
    mapRow = mapRow:gsub(WaterChar, WaterColor..WaterChar.."\027[0m")
    io.write(mapRow, "\n")
  end

  -- infinite loop
  while true do

    -- draw the player
    DrawPlayer(PlayerPosY,PlayerPosX,playerDir)
    -- put the cursor at the map's end
    io.write("\027[" .. MapHeight .. ";" .. (MapWidth+1) .. "H")

    -- wait for input
    char = io.read(1) or "\0"

    -- back to menu
    if char == "p" then
      -- clear terminal
      Clear()
      PrintBanner()
      break
    end

    -- move the player, detect walls and change direction
    playerDir = MovePlayer(char,playerDir)

  end
end

function MainMenu()
  local menu = {
    " ",
    " ",
    "New Game",
    "Resume Game",
    "Load Game",
    "Quit Game",
    " ",
    " "
  }
  local menuIndex = 3

  -- clear terminal
  Clear()
  -- print out the banner
  PrintBanner()

  -- enter initial loop aka main menu
  while true do
    -- show menu at 15th line
    io.write("\027[12;0H")
    io.write("-------------------------\n",
            "   ", menu[menuIndex - 2] .. "          \n",
            "   ", menu[menuIndex - 1] .. "          \n",
            "-->", menu[menuIndex] .. "          \n",
            "   ", menu[menuIndex + 1] .. "          \n",
            "   ", menu[menuIndex + 2] .. "          \n",
            "-------------------------\n")

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
      elseif menu[menuIndex] == "Quit Game" then
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
