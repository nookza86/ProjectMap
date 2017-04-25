local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local Bg, cx, cy, cw, ch
local SettingBtn, OkBtn, SoundBtn, SoundMute
local myRoundedRect, MenuHide

TestGroup = display.newGroup()

--local params

local function RemoveAll( event )
	if(event) then
		print( "deletePic in setting"  )
		event:removeSelf( )
		event = nil
		
	end
end

local function Check( event )
	local obj = event.target.id

	if(event.phase == "ended") then
		if(obj == "sound" ) then
			SoundMute = not SoundMute
			RemoveAll(SoundBtn)
			print( SoundMute )

			if(SoundMute == true) then
				SoundBtn = display.newImageRect("Phuket/Button/Button/Csound.png", 70/1.5, 70/1.5)
				SoundBtn.id = "sound"
				SoundBtn.x = cx 
				SoundBtn.y = cy 
				SoundBtn:addEventListener( "touch", Check )

			else
				SoundBtn = display.newImageRect("Phuket/Button/Button/Osound.png", 70/1.5, 70/1.5)
				SoundBtn.id = "sound"
				SoundBtn.x = cx 
				SoundBtn.y = cy 
				SoundBtn:addEventListener( "touch", Check )
			end
		else
			MenuHide = not MenuHide
			if(MenuHide == true) then
				transition.to( myRoundedRect, { time=150, x=(cw), y=(myRoundedRect.y)} )
				transition.to( SSSoundBtn, { time=150, x=(cw), y=(SSSoundBtn.y)} )
				transition.to( SSoundBtn, { time=150, x=(cw), y=(SSoundBtn.y)} )
				transition.to( SoundBtn, { time=150, x=(cw), y=(SoundBtn.y)} )
			else	
				transition.to( myRoundedRect, { time=150, x=(cx), y=(myRoundedRect.y)} )
				transition.to( SSSoundBtn, { time=150, x=(cx), y=(SSSoundBtn.y)} )
				transition.to( SSoundBtn, { time=150, x=(cx), y=(SSoundBtn.y)} )
				transition.to( SoundBtn, { time=150, x=(cx), y=(SoundBtn.y)} )
			end
		end
	end
end
function scene:create(event)
	local sceneGroup = self.view
	print("Scene #setting : create")
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	cx = display.contentCenterX
    cy = display.contentCenterY
    cw = display.contentWidth
    ch = display.contentHeight
	--params = event.params
	if (phase == "will") then

		Bg = display.newImageRect("Phuket/setting/bg.png", cw, ch )
		Bg.x = cx 
		Bg.y = cy 

		myRoundedRect = display.newRoundedRect( cw, ch , 50, 300, 1 )
		myRoundedRect:setFillColor( 1,0,1 )
		myRoundedRect.alpha = 0.1


		SoundBtn = display.newImageRect("Phuket/Button/Button/Osound.png", 70/1.5, 70/1.5)
		SoundBtn.id = "sound"
		SoundBtn.x = myRoundedRect.x 
		SoundBtn.y = cy 
		SoundBtn:addEventListener( "touch", Check )

		SSoundBtn = display.newImageRect("Phuket/Button/Button/Osound.png", 70/1.5, 70/1.5)
		SSoundBtn.id = "sound"
		SSoundBtn.x = SoundBtn.x 
		SSoundBtn.y = cy + 50
		SSoundBtn:addEventListener( "touch", Check )

		SSSoundBtn = display.newImageRect("Phuket/Button/Button/Osound.png", 70/1.5, 70/1.5)
		SSSoundBtn.id = "sound"
		SSSoundBtn.x = SSoundBtn.x 
		SSSoundBtn.y = cy + 100
		SSSoundBtn:addEventListener( "touch", Check )

		SoundMute = false
		MenuHide = true


		OkBtn = widget.newButton(
    	{
	        width = 100,
	        height = 50,
	        defaultFile = "Phuket/Button/Button/ok.png",
	        overFile = "Phuket/Button/ButtonPress/ok.png",
	        id = "ok",
	        onEvent = Check
    	}
			)
		OkBtn.x = cx 
		OkBtn.y = cy + 80

		print("Scene #setting : show (will)")
	
	elseif (phase == "did") then
		print("Scene #setting : show (did)")
		
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(Bg)
		RemoveAll(SoundBtn)
		RemoveAll(Ok)
		print("Scene #setting : hide (will)")
	elseif (phase == "did") then
		
		print("Scene #setting : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #setting : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene