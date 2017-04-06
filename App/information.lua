local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local params, cx, cy, cw, ch
local Bg, BgText, BackBtn
local Recommend1, Recommend2

local function RemoveAll( event )
	if(event) then
		print( "deletePic in scene #Information " .. params.PlaceName  )
		event:removeSelf( )
		event = nil
		
	end
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #informatiom : create")
end

local function Check( event )
	print( event.target.id )
	local options = {params = {PlaceName = params.PlaceName}}
	if(event.phase == "ended") then
		if(event.target.id == "BackBtn") then
			print( "Go to scene #HomePlace " .. params.PlaceName )
			composer.gotoScene("HomePlace",options)
		elseif (event.target.id == "register") then
			composer.gotoScene("register")
		end
	end
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	params = event.params
	if (phase == "will") then
		cx = display.contentCenterX
	    cy = display.contentCenterY
	    cw = display.contentWidth
	    ch = display.contentHeight

	    Bg = display.newImage("Phuket/Information/bg.png", cx, cy )
		Bg:scale( 0.3, 0.3 ) 

		BgText = display.newImageRect( "Phuket/Information/text.png", 1222/3.3, 637/3.3)
		BgText.x = cx + 80
		BgText.y = cy - 30

		BackBtn = widget.newButton(
    	{
	        width = 43,
	        height = 43,
	        defaultFile = "Phuket/Button/Button/back.png",
	        overFile = "Phuket/Button/ButtonPress/back.png",
	        id = "BackBtn",
	        onEvent = Check
    	}
			)
		
		BackBtn.x = cx - 240
		BackBtn.y = cy + 130

		Recommend1 = widget.newButton(
    	{
	        width = 3500/30,
	        height = 1280/30,
	        defaultFile = "Phuket/Button/RButton/bangpae.png",
	        overFile = "Phuket/Button/RButtonPress/bangpae.png",
	        id = "Recommend1",
	        onEvent = Check
    	}
			)
		
		Recommend1.x = cx + 100
		Recommend1.y = cy + 100


	elseif (phase == "did") then
		print("Scene #informatiom : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(Bg)
		RemoveAll(BgText)
		RemoveAll(BackBtn)
		RemoveAll(Recommend1)
		print("Scene #informatiom : hide (will)")
	elseif (phase == "did") then
		print("Scene #informatiom : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #informatiom : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene