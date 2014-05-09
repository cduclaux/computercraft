--created by Arclight306

--dependencies
os.loadAPI("/include/persist")

local state = {}

local f=io.open("currState", "r") --try to open the state file
if f~=nil then --if the state file already exists then load it
   io.close(f)
   state = persist.persist.load("currState") 
else    --set up the default state if a state file does not exist
   state.xPos = 0
   state.yPos = 0
   state.zPos = 0
   state.face = "north"
   state.odometer = 0
end

local function saveState() --saves the state to persitent variables
   persist.persist.store("currState", state)
end

local function getState() --gets the state from the persitent variables
   state = persist.persist.load("currState")
end

local function odometer() -- Add one to the odometer, the Odometer never lets you take one off
	state.odometer = state.odometer + 1
	saveState()
end

function updateXPos(x) --update the x position
	state.xPos = state.xPos + x
	odometer()
end

function updateYPos(y) --update the y position
	state.yPos = state.yPos + y
   odometer()
end

function updateZPos(z) --update the z positon
	state.zPos = state.zPos + z
   odometer()
end

function updateFace(face) --update the facing.
   if(face == "right") then
      if state.face == "north" then
         state.face = "east"
      elseif state.face == "east" then
         state.face = "south"
      elseif state.face == "south" then
         state.face = "west"
      elseif state.face == "west" then
         state.face = "north"
      end
	else
      if state.face == "north" then
         state.face = "west"
		elseif state.face == "west" then
         state.face = "south"
		elseif state.face == "south" then
         state.face = "east"
      elseif state.face == "east" then
         state.face = "north"
      end
   end
   saveState()
 end
 
 function getOdometer() -- returns the odometer reading
	return state.odometer
end

function getPosition() --returns the current position and facing
	return state.xPos, state.yPos, state.zPos, state.face
end

function getFace() -- returns just the facing
   return state.face
end

function setPosition(x, y, z, face) --sets the x, y, z position and facing
	state.xPos = x
   state.yPos = y
   state.zPos = z
   state.face = face
   saveState()
end
