local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local params, cx, cy, cw, ch
local Bg, UserImage1, UserImage2, UserImage3, UserImage4
local BackBtn, ShareBtn

local function RemoveAll( event )
	if(event) then
		print( "deletePic "  )
		event:removeSelf( )
		event = nil
		
	end
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #share : create")
end

local function Check( event )
	print( event.target.id, params.PlaceName)
	local options = {params = {PlaceName = params.PlaceName}}
	if(event.phase == "ended") then
		if(event.target.id == "BackBtn") then
			print( "Go to scene #HomePlace " .. params.PlaceName )
			composer.gotoScene("HomePlace",options)
		elseif (event.target.id == "ShareBtn") then
			print( "Share with facebook button" )
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

	    Bg = display.newImage("Phuket/share/" .. params.PlaceName .. "/bg.png", cx, cy )
		Bg:scale( 0.3, 0.3 ) 

		UserImage1 = display.newImageRect( "Phuket/share/" .. params.PlaceName .. "/addpicture.png", 999/9, 929/9 )
		UserImage1.x = cx - 200
		UserImage1.y = cy + 40

		UserImage2 = display.newImageRect( "Phuket/share/" .. params.PlaceName .. "/addpicture.png", 999/9, 929/9 )
		UserImage2.x = UserImage1.x + 130
		UserImage2.y = UserImage1.y

		UserImage3 = display.newImageRect( "Phuket/share/" .. params.PlaceName .. "/addpicture.png", 999/9, 929/9 )
		UserImage3.x = UserImage2.x + 130 
		UserImage3.y = UserImage2.y

		UserImage4 = display.newImageRect( "Phuket/share/" .. params.PlaceName .. "/addpicture.png", 999/9, 929/9 )
		UserImage4.x = UserImage3.x + 130
		UserImage4.y = UserImage3.y

		BackBtn = widget.newButton(
    	{
	        width = 43,
	        height = 43,
	        defaultFile = "Phuket/Button/back.png",
	        overFile = "Phuket/Button/back.png",
	        id = "BackBtn",
	        onEvent = Check
    	}
			)
		
		BackBtn.x = cx - 240
		BackBtn.y = cy + 130
		
		ShareBtn = widget.newButton(
    	{
	        width = 3500/30,
	        height = 1280/30,
	        defaultFile = "Phuket/Button/share_w_fb.png",
	        overFile = "Phuket/Button/share_w_fb.png",
	        id = "ShareBtn",
	        onEvent = Check
    	}
			)
		
		ShareBtn.x = cx + 200
		ShareBtn.y = cy + 130

	elseif (phase == "did") then
		print("Scene #share : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(Bg)
		RemoveAll(UserImage1)
		RemoveAll(UserImage2)
		RemoveAll(UserImage3)
		RemoveAll(UserImage4)
		RemoveAll(BackBtn)
		RemoveAll(ShareBtn)
		print("Scene #share : hide (will)")
	elseif (phase == "did") then
		print("Scene #share : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #share : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene