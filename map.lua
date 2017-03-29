local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local params

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Map : create")
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	params = event.params
	
	if (phase == "will") then
		print( "User Click " .. params.PlaceName .. " From HomePage" )

		if(params.PlaceName == "Chalong Temple") then
			system.openURL( "https://www.google.com/maps/place/%E0%B8%A7%E0%B8%B1%E0%B8%94%E0%B9%84%E0%B8%8A%E0%B8%A2%E0%B8%98%E0%B8%B2%E0%B8%A3%E0%B8%B2%E0%B8%A3%E0%B8%B2%E0%B8%A1/@7.8426086,98.3334015,14.75z/data=!4m5!3m4!1s0x30502fbb832d2361:0x8f6bd319c24a4986!8m2!3d7.8467839!4d98.3369041" )
			local options = {params = {PlaceName = "Chalong Temple"}}
			composer.gotoScene("HomePlace", options)

		elseif(params.PlaceName == "BangPae") then
			system.openURL( "https://www.google.com/maps/place/%E0%B8%99%E0%B9%89%E0%B8%B3%E0%B8%95%E0%B8%81%E0%B8%9A%E0%B8%B2%E0%B8%87%E0%B9%81%E0%B8%9B/@8.0441569,98.4489292,13.75z/data=!4m5!3m4!1s0x30503606d3242a97:0xcbb7565e7ef6c5cf!8m2!3d8.0392798!4d98.3913003" )
			local options = {params = {PlaceName = "BangPae"}}
			composer.gotoScene("HomePlace", options)

		elseif(params.PlaceName == "Big buddha") then
			system.openURL( "https://www.google.com/maps/place/The+Big+Buddha+Phuket/@7.8276567,98.3105492,17z/data=!3m1!4b1!4m5!3m4!1s0x30502f60cf972939:0x7fcb3b1b04652c5c!8m2!3d7.8276567!4d98.3127379" )
			local options = {params = {PlaceName = "Big buddha"}}
		composer.gotoScene("HomePlace", options)

		elseif(params.PlaceName == "Kata Beach") then
			system.openURL( "https://www.google.com/maps/place/%E0%B8%AB%E0%B8%B2%E0%B8%94%E0%B8%81%E0%B8%B0%E0%B8%95%E0%B8%B0/@7.8175211,98.2956312,14.5z/data=!4m5!3m4!1s0x3050258d7413d501:0x8d2199a8537543f8!8m2!3d7.8206945!4d98.2976473" )
			local options = {params = {PlaceName = "Kata Beach"}}
		composer.gotoScene("HomePlace", options)

		elseif(params.PlaceName == "Kamala Beach") then
			system.openURL( "https://www.google.com/maps/place/%E0%B8%AB%E0%B8%B2%E0%B8%94%E0%B8%81%E0%B8%A1%E0%B8%A5%E0%B8%B2/@7.9564421,98.2716033,15z/data=!3m1!4b1!4m5!3m4!1s0x30503a3b6645b1a7:0x8af77c32a71c5ed8!8m2!3d7.9569221!4d98.2830983" )
			local options = {params = {PlaceName = "Kamala Beach"}}
		composer.gotoScene("HomePlace", options)

		elseif(params.PlaceName == "Karon Beach") then
			system.openURL( "https://www.google.com/maps/place/%E0%B8%AB%E0%B8%B2%E0%B8%94%E0%B8%81%E0%B8%B0%E0%B8%A3%E0%B8%99/@7.844051,98.2745201,14z/data=!3m1!4b1!4m5!3m4!1s0x305025721ca627d5:0xe46801b37ca8651f!8m2!3d7.8438991!4d98.2936186" )
			local options = {params = {PlaceName = "Karon Beach"}}
		composer.gotoScene("HomePlace", options)

		elseif(params.PlaceName == "Patong Beach") then
			system.openURL( "https://www.google.com/maps/place/%E0%B8%AB%E0%B8%B2%E0%B8%94%E0%B8%9B%E0%B9%88%E0%B8%B2%E0%B8%95%E0%B8%AD%E0%B8%87/@7.8961775,98.2837028,15z/data=!3m1!4b1!4m5!3m4!1s0x30503abdc80bb167:0xf80d3749eb23176d!8m2!3d7.8961957!4d98.2954147" )
			local options = {params = {PlaceName = "Patong Beach"}}
		composer.gotoScene("HomePlace", options)

		end
		print("Scene #Map : show (will)")
	
	elseif (phase == "did") then
		print("Scene #Map : show (did)")
		
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		return
		print("Scene #Map : hide (will)")
	elseif (phase == "did") then
		return
		print("Scene #Map : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #Map : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene