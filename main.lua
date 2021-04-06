package.path = "rawterm/rawterm.lua"
local rawterm = require("rawterm")
local string = require("string")

BlockChar = "o"
WaterChar = "~"
DeathChar = "x"
WinChar = "w"
WaterColor = "\027[036m"
BlockColor = "\027[030;40m"
DeathColor = "\027[031m"
WinColor = "\027[032m"
PlayerColor = "\027[033m"
StartPosY = 4
StartPosX = 4
PlayerPosY = StartPosY
PlayerPosX = StartPosX
LastPlayerPosY = PlayerPosY
LastPlayerPosX = PlayerPosX
MapHeight = 30
MapWidth = 100
Death = 0
Winner = 0
Started = 0
Level = 1

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

Level_1 = {
  "                       x######                                                                      ",
  "            ######    x#######       #####                                                          ",
  "        ##########x/#####/#####  #############                                                      ",
  "    ############/x#########--#####################                                                  ",
  "  ####         #x####################          #####                                                ",
  " ##          ###o       #########/@@              ###                                               ",
  "#          ###x         -.##/`.#/#####               ##                                             ",
  "          ##x            |$/  |,-. ####                 #                                           ",
  "         ##           oo,'$|_,'|  |  ###                                                            ",
  "         #              ooooo$$`._/   ##                               xxxx                         ",
  "                          $$o$$_/     ##                            xxxxxxxxxx                      ",
  "                          $$o$$        #                           xxxxxxxxxxxx                     ",
  "                          $$o$$                                     xxxxxxxxxx                      ",
  "                          $$o$$                                        xxxx                         ",
  "                          $$o$$                                                                     ",
  "                          $$o$$                                                                     ",
  "                         $$o$$                                                                      ",
  "                        $$o$$                                                                       ",
  "                        $o$$$                                                                       ",
  "~~~~~~~~~~~~~~~~~~~~~~~$$o$$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
  "   ~      ~  ~    ~  ~ $$o$$  ~   ~       ~          ~                                              ",
  "  ~            ~ ^   ~ $$o$$~             _______       ~                                           ",
  "_______________________$$o$$_____________///////|___________________________________________________",
  "                       $$o$$            /////// |                                                   ",
  "    _______            $$o$$           ///////  |                                                   ",
  "   /Q%=//,/            $$o$$           |#####|  /                                                   ",
  "    `------`           $$o$$           |#####| /|                                                   ",
  "                  w    $$o$$           |#####|/                                             w       ",
  "                      $$$o$$$          ||   ||                                                      ",
  "#####################$$$$$$$$$######################################################################",
}

Level_2 = {
  "                       x######                                                                      ",
  "            ######    x#######       #####                                                          ",
  "        ##########x/#####/#####  #############                                                      ",
  "    ############/x#########--#####################                                                  ",
  "  ####         #x####################          #####                                                ",
  " ##          ###o       #########/@@              ###                                               ",
  "#          ###x         -.##/`.#/#####               ##                                             ",
  "          ##x            |$/  |,-. ####                 #                                           ",
  "         ##           oo,'$|_,'|  |  ###                                                            ",
  "         #              ooooo$$`._/   ##                               xxxx                         ",
  "                          $$o$$_/     ##                            xxxxxxxxxx                      ",
  "                          $$o$$        #                           xxxxxxxxxxxx                     ",
  "                          $$o$$                                     xxxxxxxxxx                      ",
  "                          $$o$$                                        xxxx                         ",
  "                          $$o$$                                                                     ",
  "                          $$o$$                                                                     ",
  "                         $$o$$                                                                      ",
  "                        $$o$$                                                                       ",
  "                        $o$$$                                                                       ",
  "~~~~~~~~~~~~~~~~~~~~~~~$$o$$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
  "   ~      ~  ~    ~  ~ $$o$$  ~   ~       ~          ~                                              ",
  "  ~            ~ ^   ~ $$o$$~             _______       ~                                           ",
  "_______________________$$o$$_____________///////|___________________________________________________",
  "   jjjjjjjjjjjjjjjjjjjjjjjjjj           /////// |                                                   ",
  "    _______            $$o$$           ///////  |                                                   ",
  "   /Q%=//,/            $$o$$           |#####|  /                                                   ",
  "    `------`           $$o$$           |#####| /|                                                   ",
  "                    w  $$o$$           |#####|/                                             w       ",
  "                      $$$o$$$          ||   ||                                                      ",
  "#####################$$$$$$$$$######################################################################",
}

Levels = {Level_1, Level_2}

GameOverMsg = {
  "  ____                         ___",
  " / ___| __ _ _ __ ___   ___   / _ \\__   _____ _ __",
  "| |  _ / _` | '_ ` _ \\ / _ \\ | | | \\ \\ / / _ \\ '__|",
  "| |_| | (_| | | | | | |  __/ | |_| |\\ V /  __/ |",
  " \\____|\\__,_|_| |_| |_|\\___|  \\___/  \\_/ \\___|_|",
}

WonGameMsg = {
  "__        __   _ _       _                  _",
  "\\ \\      / /__| | |   __| | ___  _ __   ___| |",
  " \\ \\ /\\ / / _ \\ | |  / _` |/ _ \\| '_ \\ / _ \\ |",
  "  \\ V  V /  __/ | | | (_| | (_) | | | |  __/_|",
  "   \\_/\\_/ \\___|_|_|  \\__,_|\\___/|_| |_|\\___(_)",
}

-- enable raw mode for getting input from keyboard
rawterm.enableRawMode({
  carriageOut = "\n",
  readtimeout = 2
})

function Wait(msec)
   local t = os.clock()
   repeat
   until os.clock() > t + msec * 1e-3
end


function Clear()
  -- clear terminal
  os.execute("clear")
  -- print out the border (100x30)
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

function PrintMap()
  -- send cursor home
  io.write("\027[H")
  -- print out the whole map
  for _, data in ipairs(Map) do
    -- print walls as black boxes
    local mapRow = data:gsub(BlockChar, BlockColor..BlockChar.."\027[0m")
    -- print water blue
    mapRow = mapRow:gsub(WaterChar, WaterColor..WaterChar.."\027[0m")
    mapRow = mapRow:gsub(DeathChar, DeathColor..DeathChar.."\027[0m")
    io.write(mapRow, "\n")
  end
end

function WonGame()
  -- disable raw mode while waiting
  rawterm.disableRawMode()
  Clear()
  -- put the cursor in the middle and print the message
  for row, data in ipairs(WonGameMsg) do
    io.write("\027[" .. row+10 .. ";22H")
    io.write(data)
  end
  io.write("\027[" .. MapHeight .. ";" .. (MapWidth+1) .. "H\n")
  -- wait a few seconds
  Wait(2000)
  -- enable raw mode again
  rawterm.enableRawMode({
    carriageOut = "\n",
    readtimeout = 2
  })
end

function GameOver()
  -- disable raw mode while waiting
  rawterm.disableRawMode()
  Clear()
  -- put the cursor int the middle and print the message
  for row, data in ipairs(GameOverMsg) do
    io.write("\027[" .. row+10 .. ";22H")
    io.write(data)
  end
  io.write("\027[" .. MapHeight .. ";" .. (MapWidth+1) .. "H\n")
  -- wait a few seconds
  Wait(2000)
  -- enable raw mode again
  rawterm.enableRawMode({
    carriageOut = "\n",
    readtimeout = 2
  })
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

  -- player is alive and didn't win yet
  Death = 0
  Winner = 0

  -- print out the whole map
  PrintMap()

  -- infinite loop
  while true do

    -- draw the player
    DrawPlayer(PlayerPosY,PlayerPosX,playerDir)
    -- put the cursor at the map's end
    io.write("\027[" .. MapHeight .. ";" .. (MapWidth+1) .. "H")

    -- wait for input or press the "down key"
    char = io.read(1) or "j"

    -- back to menu
    if char == "p" then
      -- clear terminal
      Clear()
      PrintBanner()
      break
    end

    -- move the player, detect walls and change direction
    playerDir = MovePlayer(char,playerDir)

    -- kill player and return to menu
    if string.find(string.sub(Map[PlayerPosY],(PlayerPosX),(PlayerPosX+5)), DeathChar) ~= nil
    or string.find(string.sub(Map[PlayerPosY+1],(PlayerPosX),(PlayerPosX+5)), DeathChar) ~= nil
    then
      Death = 1
      GameOver()
      Clear()
      PrintBanner()
      break
    end

    -- check to see if player has ended the level or finished the game
    if string.find(string.sub(Map[PlayerPosY],(PlayerPosX),(PlayerPosX+5)), WinChar) ~= nil
    or string.find(string.sub(Map[PlayerPosY+1],(PlayerPosX),(PlayerPosX+5)), WinChar) ~= nil
    then
      Level = Level + 1
      WonGame()
      if Level == 3 then
        Clear()
        PrintBanner()
        Winner = 1
        break
      else
        Map = Levels[Level]
        PlayerPosX = StartPosX
        PlayerPosY = StartPosY
        Clear()
        PrintMap()
      end
    end

  end
end

function MainMenu()
  local menu = {
    " ",
    "New Game",
    "Resume Game",
    "Quit Game",
    " ",
  }
  local menuIndex = 2
  local char

  -- clear terminal
  Clear()
  -- print out the banner
  PrintBanner()

  -- enter initial loop aka main menu
  while true do
    -- show menu at 15th line
    io.write("\027[12;0H")
    io.write("h,j,k,l to move, p for pause\n")
    io.write("-------------------------\n",
            "   ", menu[menuIndex - 1] .. "          \n",
            "-->", menu[menuIndex] .. "          \n",
            "   ", menu[menuIndex + 1] .. "          \n",
            "-------------------------\n")

    -- wait for input
    char = io.read(1) or "\0"

    -- test characters
    if char == "j" and menuIndex < 4 then
      menuIndex = menuIndex + 1
    elseif char == "k" and menuIndex > 2 then
      menuIndex = menuIndex - 1
    elseif char == "l" then
      char = "\0"
      if menu[menuIndex] == "New Game" then
        PlayerPosX = StartPosX
        PlayerPosY = StartPosY
        Started = 1
        Level = 1
        Map = Levels[Level]
        GameLoop()
      elseif menu[menuIndex] == "Resume Game" then
        if Death == 1 then
          io.write("You died, start a new game\n")
        elseif Winner == 1 then
          io.write("You won! what else do you want?\n")
        elseif Started == 0 then
          io.write("Start the game first\n")
        else
          GameLoop()
        end
      elseif menu[menuIndex] == "Quit Game" then
        Clear()
        io.write("do you really want to quit? (y)(n)")
        while true do
          char = io.read(1) or "\0"
          if char == "y" or char == "n" then
            break
          end
        end
        if char == "y" then
          break
        else
          Clear()
          PrintBanner()
        end
      end
    end
 end
end

-- Entry point
MainMenu()

-- disable raw mode and clear the terminal
os.execute("clear")
rawterm.disableRawMode()
