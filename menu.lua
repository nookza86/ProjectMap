local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local LoginWithFaceBookBtn, LoginBtn, register, myText
local cx, cy, cw, ch

local function RemoveAll( event )
	if(event) then
		print( "deletePic in scene #Information " )
		event:removeSelf( )
		event = nil
		
	end
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Menu : create")
end

local function Check( event )
	print( event.target.id )
	if(event.target.id == "login") then
		composer.gotoScene("overview")
	elseif (event.target.id == "register") then
		composer.gotoScene("register")
	end

end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		
		cx = display.contentCenterX
	    cy = display.contentCenterY
	    cw = display.contentWidth
	    ch = display.contentHeight

		print("Scene #Menu : show (will)")
		display.setStatusBar( display.HiddenStatusBar )
		myText = display.newImageRect("Phuket/menu/bglogin.png", 2149/3, 1084/3 )
		myText.x = display.contentCenterX - 10
		myText.y = display.contentCenterY + 18

	 LoginBtn = widget.newButton(
    	{
	        width = 3000/30,
	        height = 1280/30,
	        defaultFile = "Phuket/Button/login.png",
	        overFile = "Phuket/Button/login.png",
	        id = "login",
	        onEvent = Check
    	}
			)
		
		LoginBtn.x = cx 
		LoginBtn.y = cy + 30

	 LoginWithFaceBookBtn = widget.newButton(
    	{
	        width = 3500/30,
	        height = 1280/30,
	        defaultFile = "Phuket/Button/login_w_fb.png",
	        overFile = "Phuket/Button/login_w_fb.png",
	        id = "LoginWithFaceBookBtn",
	        onEvent = Check
    	}
			)
		
		LoginWithFaceBookBtn.x = cx 
		LoginWithFaceBookBtn.y = cy + 70

	 register = widget.newButton(
			{
				left = display.contentCenterX,
				top = display.contentCenterY + 100,
				width = 0,
				height = 0,
				id = "register",
				label = "register",
				onEvent = Check,
				shape = "Rect",
				labelColor = {default={1,1,1}, over={0,0,0,0.5}},
				fillColor = {default={0.4,0.4,0.4}, over={0.8,0.8,0.8}},	
			}
		)
		
	elseif (phase == "did") then
		print("Scene #Menu : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(myText)
		RemoveAll(LoginBtn)
		RemoveAll(LoginWithFaceBookBtn)
		RemoveAll(register)
		
		print("Scene #Menu : hide (will)")
	elseif (phase == "did") then
		print("Scene #Menu : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #Menu : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene