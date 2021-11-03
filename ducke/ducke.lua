local string = require("string")
local graphics = require("src.graphics")
local levels = require("src.levels").listOfLevels
local rawterm = require("rawterm.rawterm")

-- global variables (these variables can be called from anywhere)
local blockChar = ":"
local waterChar = "~"
local deathChar = "*"
local winChar = "w"
local waterColor = "\027[1;036m"
local blockColor = "\027[1;032m"
local deathColor = "\027[1;031m"
local winColor = "\027[035;45m"
local playerColor = "\027[1;033m"
local objectiveColor = "\027[1;035m"
local startPosY = 29
local startPosX = 1
local playerPosY = startPosY
local playerPosX = startPosX
local lastPlayerPosY = playerPosY
local lastPlayerPosX = playerPosX
local mapHeight = 30
local mapWidth = 100
local death = 0
local winner = 0
local started = 0
local objectives = { "f", "s", "t", "endobj" }
local level = 1
-- values across multiple functions
local level_map = {}
local currentObjective
local numOfObjectives


local function wait(msec)
  local t = os.clock()
  repeat
  until os.clock() > t + msec * 1e-3
end

local function clear()
  -- clear terminal
  os.execute("clear")
  -- print out the border (100x30)
  for row = 1,mapHeight,1 do
    io.write("\027[" .. row .. ";" .. (mapWidth+1) .. "H")
    io.write("|")
  end
  io.write("\n")
  for _ = 1,(mapWidth+1),1 do
    io.write("-")
  end
  -- send cursor home
  io.write("\027[H")
end

local function printMessage(message)
  clear()

  -- put the cursor in the middle and print the message
  for row, data in ipairs(message) do
    local messageRow = data:gsub("#", "\027[034m#\027[0m")
    io.write("\027[" .. row+10 .. ";22H")
    io.write(messageRow)
  end

  io.write("\027[" .. mapHeight .. ";" .. (mapWidth+1) .. "H\n")
end

local function printBanner()
  -- print out the title
  for row, data in ipairs(graphics.title) do
    io.write("\027[" .. row .. ";5H")
    io.write(data)
  end

  -- print out the banner
  io.write("\027[033m")
  for row, data in ipairs(graphics.banner) do
    io.write("\027[" .. row .. ";37H")
    io.write(data)
  end
  io.write("\027[0m")
end

local function printMap()
  -- send cursor home
  io.write("\027[H")
  -- print out the whole map
  for _, data in ipairs(level_map) do
    -- print different colors
    -- blocks...
    local mapRow = data:gsub(blockChar, blockColor..blockChar.."\027[0m")
    -- ...water...
    mapRow = mapRow:gsub(waterChar, waterColor..waterChar.."\027[0m")
    -- ...death...
    mapRow = mapRow:gsub(deathChar, deathColor..deathChar.."\027[0m")
    -- ...win
    mapRow = mapRow:gsub(winChar, winColor..winChar.."\027[0m")
    -- change objectives to their numbers
    for i in pairs(objectives) do
      mapRow = mapRow:gsub(objectives[i], objectiveColor..i.."\027[0m")
    end

    io.write(mapRow, "\n")
  end
end


local function endGame(reason)
  local msg
  -- disable raw mode while waiting
  rawterm.disableRawMode()
  clear()

  if reason == "gameover" then
    death = 1
    msg = graphics.gameOverMsg
  elseif reason == "gamewon" then
    winner = 1
    started = 0
    msg = graphics.wonGameMsg
  end
  -- print the message
  printMessage(msg)
  -- wait a few seconds
  wait(2000)

  clear()
  printBanner()
  -- enable raw mode again
  rawterm.enableRawMode({
    carriageOut = "\n",
    readtimeout = 2
  })
end

local function gravity(character)
  -- gravity doesn't work in the water
  if character == "\0"
    and playerPosY <= (mapHeight - 2)
    and string.find(string.sub(level_map[playerPosY+2],(playerPosX),(playerPosX+5)), blockChar) == nil
    and string.find(string.sub(level_map[playerPosY],(playerPosX),(playerPosX+5)), waterChar) == nil
    and string.find(string.sub(level_map[playerPosY+1],(playerPosX),(playerPosX+5)), waterChar) == nil
    then
    playerPosY = playerPosY + 1
  end
end

local function drawPlayer(position_y, position_x, direction)
  -- reprint the map after the player
  local playerRow1 = string.sub(level_map[lastPlayerPosY],lastPlayerPosX,(lastPlayerPosX+5))
  local playerRow2 = string.sub(level_map[(lastPlayerPosY+1)],lastPlayerPosX,(lastPlayerPosX+5))
  -- water character stays the same color
  playerRow1 = playerRow1:gsub(waterChar, waterColor..waterChar.."\027[0m")
  playerRow2 = playerRow2:gsub(waterChar, waterColor..waterChar.."\027[0m")
  -- win char stays the same if picked up before completing objectives
  playerRow1 = playerRow1:gsub(winChar, winColor..winChar.."\027[0m")
  playerRow2 = playerRow2:gsub(winChar, winColor..winChar.."\027[0m")
  -- hide object characters on touch
  for i in pairs(objectives) do
    if i <= currentObjective then
      playerRow1 = playerRow1:gsub(objectives[i], " ")
      playerRow2 = playerRow2:gsub(objectives[i], " ")
    else
      playerRow1 = playerRow1:gsub(objectives[i], objectiveColor..i.."\027[0m")
      playerRow2 = playerRow2:gsub(objectives[i], objectiveColor..i.."\027[0m")
    end
  end

  -- print map
  io.write("\027[" .. lastPlayerPosY .. ";" .. lastPlayerPosX .. "H")
  io.write(playerRow1, "\n")
  io.write("\027[" .. (lastPlayerPosY+1) .. ";" .. lastPlayerPosX .. "H")
  io.write(playerRow2, "\n")

  -- remember position for map reprint
  lastPlayerPosY = position_y
  lastPlayerPosX = position_x

  -- print out the player depending on the direction
  if direction == 0 then
    io.write("\027[" .. position_y .. ";" .. position_x .. "H")
    io.write(playerColor..">(.)")
    io.write("\027[" .. (position_y+1) .. ";" .. (position_x+1) .. "H")
    io.write("(___/\027[0m")
  else
    io.write("\027[" .. position_y .. ";" .. (position_x+2) .. "H")
    io.write(playerColor.."(.)<")
    io.write("\027[" .. (position_y+1) .. ";" .. position_x .. "H")
    io.write("\\___)\027[0m")
  end
end

local function movePlayer(character,direction)
  if character == "h" and  playerPosX >= 2 then
    direction = 0
    if string.sub(level_map[playerPosY],(playerPosX-1),(playerPosX-1)) ~= blockChar
    and string.sub(level_map[playerPosY+1],(playerPosX-1),(playerPosX-1)) ~= blockChar
    then
      playerPosX = playerPosX - 1
    end

  elseif character == "j"
    and playerPosY <= (mapHeight - 2)
    and string.find(string.sub(level_map[playerPosY+2],(playerPosX),(playerPosX+5)), blockChar) == nil
    then
    playerPosY = playerPosY + 1

  elseif character == "k"
    and playerPosY >= 2
    and string.find(string.sub(level_map[playerPosY-1],(playerPosX),(playerPosX+5)), blockChar) == nil
    then
    playerPosY = playerPosY - 1

  elseif character == "l" and playerPosX <= (mapWidth - 6) then
    direction = 1
    if string.sub(level_map[playerPosY],(playerPosX+6),(playerPosX+6)) ~= blockChar
    and string.sub(level_map[playerPosY+1],(playerPosX+6),(playerPosX+6)) ~= blockChar
    then
      playerPosX = playerPosX + 1
    end
  end

  return direction
end

local function countObjectives(map, objectiveList)
  local count = 0
  for _, line in pairs(map) do
    for i in pairs(objectiveList) do
      if string.find(line, objectiveList[i]) ~= nil then
        count = count + 1
      end
    end
  end
  return count
end

local function isPlayerDead()
  if string.find(string.sub(level_map[playerPosY],(playerPosX),(playerPosX+5)), deathChar) ~= nil
  or string.find(string.sub(level_map[playerPosY+1],(playerPosX),(playerPosX+5)), deathChar) ~= nil
  then
    endGame("gameover")
    return 1
  else
    return 0
  end
end

local function hasPlayerWon()
  local character

  if string.find(string.sub(level_map[playerPosY],(playerPosX),(playerPosX+5)), winChar) ~= nil
  or string.find(string.sub(level_map[playerPosY+1],(playerPosX),(playerPosX+5)), winChar) ~= nil
  then
    level = level + 1
    if level == #levels+1 then
      -- last level completed
      endGame("gamewon")
      return 1
    else
      -- change the map and reset the position
      level_map = levels[level]
      numOfObjectives = countObjectives(level_map, objectives)
      currentObjective = 0
      playerPosX = startPosX
      playerPosY = startPosY
      -- issue a prompt for the next level
      printMessage(graphics.nextLevelMsg)
      while true do
        character = io.read(1) or "\0"
        if character == "y" or character == "n" then
          break
        end
      end
      if character == "y" then
        -- proceed
        clear()
        printMap()
        return 0
      else
        -- return to menu
        clear()
        printBanner()
        return 1
      end
    end
  end
end

local function checkObjectives(objectiveList, objectiveNum, allObjectives)
  if string.find(string.sub(level_map[playerPosY],(playerPosX),(playerPosX+5)), objectiveList[objectiveNum+1]) ~= nil
  or string.find(string.sub(level_map[playerPosY+1],(playerPosX),(playerPosX+5)), objectiveList[objectiveNum+1]) ~= nil
  then
    -- increment objectives
    if objectiveNum < allObjectives then
      objectiveNum = objectiveNum + 1
    end
  end
  return objectiveNum
end

local function gameLoop()
  -- clear terminal
  clear()

  --direction of the player (1-right, 0-left)
  local playerDir = 1
  local char

  -- none out of n objectives is completed
  currentObjective = 0
  numOfObjectives = countObjectives(level_map, objectives)

  -- player is alive and didn't win yet
  death = 0
  winner = 0

  -- print out the whole map
  printMap()

  -- infinite loop
  while true do
    -- draw the player
    drawPlayer(playerPosY,playerPosX,playerDir)
    -- put the cursor at the map's end
    io.write("\027[" .. mapHeight .. ";" .. (mapWidth+1) .. "H")

    -- wait for input
    char = io.read(1) or "\0"

    -- back to menu
    if char == "p" then
      clear()
      printBanner()
      return
    end
    -- apply gravity
    gravity(char)
    -- move the player, detect walls and change direction
    playerDir = movePlayer(char,playerDir)
    -- kill player and return to menu
    if isPlayerDead() == 1 then
      return
    end
    -- check for completed objectives
    currentObjective = checkObjectives(objectives, currentObjective, numOfObjectives)
    if currentObjective == numOfObjectives then
      -- check to see if player has ended the level or finished the game
      if hasPlayerWon() == 1 then
        return
      end
    end

    -- print objective info (has to be seperate condition, otherwise it breaks on next level)
    if currentObjective == numOfObjectives then
      if numOfObjectives ~= 0 then
        io.write("\027[" .. (mapHeight+2) .. ";" .. 0 .. "H")
        io.write(objectiveColor .. "All objectives completed\027[0m")
        io.write("\027[" .. mapHeight .. ";" .. (mapWidth+1) .. "H")
      end
    else
      io.write("\027[" .. (mapHeight+2) .. ";" .. 0 .. "H")
      io.write("Current objective:" .. objectiveColor .. (currentObjective+1) .. "\027[0m/" .. numOfObjectives)
      io.write("\027[" .. mapHeight .. ";" .. (mapWidth+1) .. "H")
    end

  end
end

local function parseMenu(menuItem)
  local character

  if menuItem == "New Game" then
    if started == 1 and death == 0 then
      printMessage(graphics.newGameMsg)
      while true do
        character = io.read(1) or "\0"
        if character == "y" or character == "n" then
          break
        end
      end
      if character == "y" then
        playerPosX = startPosX
        playerPosY = startPosY
        started = 1
        level = 1
        level_map = levels[level]
        gameLoop()
      else
        clear()
        printBanner()
        return
      end
    else
      playerPosX = startPosX
      playerPosY = startPosY
      started = 1
      level = 1
      level_map = levels[level]
      gameLoop()
    end

  elseif menuItem == "Resume Game" then
    if death == 1 then
      io.write("You died, start a new game!\n")
    elseif winner == 1 then
      io.write("You won! What else do you want?\n")
    elseif started == 0 then
      io.write("Start the game first!\n")
    else
      gameLoop()
    end

  elseif menuItem == "Quit Game" then
    printMessage(graphics.quitMsg)
    while true do
      character = io.read(1) or "\0"
      if character == "y" or character == "n" then
        break
      end
    end
    if character == "y" then
      return "quit"
    else
      clear()
      printBanner()
    end
  end
end

local function mainMenu()
  local menu = {
    " ",
    "New Game",
    "Resume Game",
    "Quit Game",
    " ",
  }
  local menuIndex = 2
  local char
  local action

  -- clear terminal
  clear()
  -- print out the banner
  printBanner()

  -- enter initial loop aka main menu
  while true do
    -- show menu at 12th line
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
      action = parseMenu(menu[menuIndex])
      if action == "quit" then
        return
      end
    end
  end
end

-- enable raw mode for getting input from keyboard
rawterm.enableRawMode({
  carriageOut = "\n",
  readtimeout = 2
})

-- Entry point
mainMenu()

-- disable raw mode and clear the terminal
os.execute("clear")
rawterm.disableRawMode()
