local composer = require("composer")
local widget = require("widget" )
local json = require ("json")
require ("cal")
local scene = composer.newScene()
local myNewData 
local decodedData 
local cx, cy, cw, ch

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Rule : create")
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		local PlaceName = "Patong Beach"
		local d = 0
		local Userd = 0
		local InArea = false
		local point1 = {}
		local point2 = {}
		local user = {}
		--Out of radius
		--user.latitude = 7.827127
		--user.longitude = 98.312174

		--In radius Big
		--user.latitude = 7.827534
		--user.longitude = 98.312649
		--Patong
		user.latitude = 7.889264
		user.longitude = 98.292195
		

		local filename = system.pathForFile( "distance.json", system.ResourceDirectory )
		local decoded, pos, msg = json.decodeFile( filename )

		if not decoded then
		    print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
		else
		    print( "File successfully decoded!" )

		    for idx, val in ipairs(decoded.rule) do
		    	if (PlaceName == val.name) then
		    		CheckInList = true
		    		RuleNo = val.no
		    		print( "Place No. " .. RuleNo )
		    		print( "Attraction name is " .. val.name)	 
		    		break
		    	end-- if name
			end--for 1
			

		   	for idx, val in ipairs(decoded.rule[RuleNo]["information"]) do
				
				point1.latitude = val.latitude1
			    point1.longitude = val.longitude1
			    point2.latitude = val.latitude2
			    point2.longitude = val.longitude2
			    d = sphericalDistanceBetween( point1, point2 )
			    Userd = sphericalDistanceBetween( point1, user )

			    ---- Check distance User and Attraction -----
			    if(Userd <= d) then
			    	InArea = true
			    else
			    	InArea = false
			    end

			    print( "Rule No : " .. idx .. " Distance : " .. d .. " User distance : " .. Userd .. " In Area : " .. tostring(InArea))
			end
		
	end -- decode

	elseif (phase == "did") then
		print("Scene #Rule : show (did)")
	
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then


		
		print("Scene #Rule : hide (will)")
	elseif (phase == "did") then
		print("Scene #Rule : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #Rule : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene