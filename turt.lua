-- Turtle Self-tracking System created by Arclight306

--dependencies
os.loadAPI("/include/state")

function gpsLocation(facing) -- get gps using other computers
   xPos, yPos, zPos = gps.locate()
   if xPos == nil then
      return false
   else
      if facing == "north" or facing == "east" or facing == "south" or facing == "west" then
         state.setPosition(xPos, yPos, zPos, facing)
         return true
      else 
         assert(false, "Facing must be north, south, east or west")
      end
      return false
   end
end

function setLocation(x, y, z, facing) -- manually set location
   
   assert(type(x) == "number", "x must be a number")
   assert(type(y) == "number", "y must be a number")
   assert(type(z) == "number", "z must be a number")
       
   if facing == "north" or facing == "east" or facing == "south" or facing == "west" then
   state.setPosition(x, y, z, facing)
   else 
      assert(false, "Facing must be north, south, east or west")
   end 
   
end

function getLocation() -- return the location
      return state.getPosition()
end

function getOdometer() -- returns the odometer
   return state.getOdometer()
end

function turnLeft() -- turn left
   if(turtle.turnLeft()) then
      state.updateFace("left")
      return true
   end
   return false
end

function turnRight() -- turn right
   if(turtle.turnRight()) then
      state.updateFace("right")
      return true
   end
   return false
end

function forward() -- go forward

   if(turtle.forward()) then
      if state.getFace() == "north" then
         state.updateZPos(-1)
      elseif state.getFace() == "west" then
         state.updateXPos(-1)
      elseif state.getFace() == "south" then
         state.updateZPos(1)
      elseif state.getFace() == "east" then
         state.updateXPos(1)
      end
      return true
   end
   return false
end

function back() -- go back

   if(turtle.back()) then
      if state.getFace() == "north" then
         state.updateZPos(1)
      elseif state.getFace() == "west" then
         state.updateXPos(1)
      elseif state.getFace() == "south" then
         state.updateZPos(-1)
      elseif state.getFace() == "east" then
         state.updateXPos(-1)
      end
      return true
   else
      return false
   end
end

function up() -- go up
   if(turtle.up()) then
      state.updateYPos(1)
      return true
   else
      return false
   end
end

function down() -- go down
   if(turtle.down()) then
      state.updateYPos(-1)
      return true
   else
      return false
   end
end
