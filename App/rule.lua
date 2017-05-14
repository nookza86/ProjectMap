local composer = require("composer")
local widget = require("widget" )
local json = require ("json")
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

		local filename = system.pathForFile( "Rule.json", system.ResourceDirectory )
		local decoded, pos, msg = json.decodeFile( filename )
		local nationality = "Canadaa"
		local CheckInList = false
		if not decoded then
		    print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
		else
		    print( "File successfully decoded!" )

		    for idx, val in ipairs(decoded.rule) do
		    	if (nationality == val.nationality) then
		    		CheckInList = true
		    		RuleNo = val.no
		    		print( "Rule No. " .. RuleNo )
		    		print( "User nationality is " .. val.nationality)
		    		break
		    	elseif (nationality ~= val.nationality) then
		    		CheckInList = false
		    		RuleNo = val.no
		    		print( CheckInList )
		    	end-- if nation
			end--for 1
			local RecPlace = {}
			local OtherRecPlace = {}
			if (CheckInList) then
				print( "in list" )
				for idx, val in ipairs(decoded["rule"][RuleNo]["recommend"]) do
					RecPlace[idx] = val
					print( RecPlace[idx] )
				end
			else
				print( "not in list" )
				local CountOtherRule = 1
				for idx, val in ipairs(decoded["rule"][RuleNo]["recommend"]) do
					RecPlace[idx] = val.name
					--print( RecPlace[idx] )
					print( "Place no : " ..  idx)
					print( "Place name : " ..  val.name)
						for j,v in ipairs(decoded["rule"][RuleNo]["recommend"][idx]["recommend"]) do
						OtherRecPlace[j]=  v

							print( "Recommend no : " .. j ) 
							print( "Recommend place name : " .. v ) 

						end
					print( "------------------------------------------------------------" )
				end

			end-- if else
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