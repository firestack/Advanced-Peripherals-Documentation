-- https://gist.github.com/Seniorendi/dbbe08502ce51d59173c3b5e119d3558

-- This method exists to connect a peripheral easier
function wrapPs(peripheralName)
  periTab={}
  sideTab={}
  if peripheralName==nil then
    print("Error")
  end
  local peripherals = peripheral.getNames()
  local i2 = 1
  for i =1, #peripherals do
    if peripheral.getType(peripherals[i])==peripheralName then
      periTab[i2]=peripheral.wrap(peripherals[i])
      sideTab[i2]=peripherals[i]
      i2=i2+1
    end
  end
  if periTab~={} then
    return periTab,sideTab
  else
  return nil
  end
end
 
--String of the title of the monitor
label = "AutomaticAutocraft"

-- me Bridge
me = wrapPs("meBridge")[1]
-- Monitor
mon = wrapPs("monitor")[1]

-- Items for the computer
-- Name(Just a name, you can type everything), minecraft name, minimum amount
meItems = {
[1] = {"Oak Planks","minecraft:oak_planks",100},
[2] = {"Furnace", "minecraft:furnace", 5},
[3] = {"Fence", "minecraft:oak_fence", 400}
}

--Checks the item and craft more of it if too few exist
function checkMe(checkName, name, low)
  melist = me.listItems()
  for a = 1, #melist do
    -- for each of the meItems table
    size = tostring(melist[a].amount)
    ItemName = melist[a].name
    -- Checks if the "minecraft name" of the table and the "minecraft name" of the table of the listItems method are equals.
    if checkName == ItemName then
      row = row+1
      CenterT(name ,row+1, colors.black, colors.lightGray,"left")
    if tonumber(size) <= tonumber(low)-1 then
        -- Checks if the amount of the item is too low
      CenterT(size.. "/".. low ,row+1, colors.black, colors.red,"right")
      if me.isItemCrafting(ItemName) == false then -- checks if already a job for the item exists
        me.craftItem(ItemName,low-size)
        print("Craft ".. low-size .. " ".. name) --A Log message which appears in the computer
      end
    else
      CenterT(size.. "/".. low ,row+1, colors.black, colors.green,"right")
    end
    end
  end
end

-- Runs checkMe with every item
function checkTable()
  row = 1
  clearScreen()
  for i = 1, #meItems do
    checkName = meItems[i][2]
    name = meItems[i][1]
    low = meItems[i][3]
    checkMe(checkName, name, low)
  end
end
 
-- Clears the screen and writes the title
function clearScreen()
  mon.setBackgroundColor(colors.black)
  mon.clear()
  mon.setCursorPos(1,1)
  CenterT(label ,1, colors.black, colors.white,"head")
end
 
-- Just a method to writes textes easier
function CenterT(text, line, txtback , txtcolor, pos)
  monX,monY = mon.getSize()
  mon.setBackgroundColor(txtback)
  mon.setTextColor(txtcolor)
  length = string.len(text)
  dif = math.floor(monX-length)
  x = math.floor(dif/2)
 
  if pos == "head" then
    mon.setCursorPos(x+1, line)
    mon.write(text)
  elseif pos == "left" then
    mon.setCursorPos(2,line)
    mon.write(text)
  elseif pos == "right" then
    mon.setCursorPos(monX-length, line)
    mon.write(text)
  end
end
 

while true do
  checkTable()
  -- CheckTable runs every 30 seconds, you can increase that.
  sleep(10)
end
