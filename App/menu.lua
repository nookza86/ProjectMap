local composer = require("composer")
local widget = require("widget" )
local json = require ("json")
local scene = composer.newScene()
local LoginWithFaceBookBtn, LoginBtn, register, myText
local UsernameTxf, PasswordTxf
local myNewData 
local decodedData 
local cx, cy, cw, ch

local function RemoveAll( event )
	if(event) then
		print( "deletePic in scene #Menu " )
		event:removeSelf( )
		event = nil
		
	end
end

local function networkListener( event )
    if ( event.isError ) then
        print( "Network error!" )
    else
    	myNewData = event.response
        print( "RESPONSE: " .. event.response )
        decodedData = (json.decode( myNewData ))

        native.setActivityIndicator( false )

        ErrorCheck = decodedData["error"]

    	if( ErrorCheck == true) then
    		local alert = native.showAlert( "Error", "Try again.", { "OK" })
        	print( "Try again." )
        else
        	local alert = native.showAlert( "Welcome", decodedData["user"]["fname"], { "OK" })
        	print( "Welcome " .. decodedData["user"]["fname"] )
    	end

        
    end
end

local function LoginListener(  )

    print( UsernameTxf.text, PasswordTxf.text)

    local headers = {}

    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "email=".. UsernameTxf.text .."&password=".. PasswordTxf.text 

    local params = {}
    params.headers = headers
    params.body = body

    local url = "https://mapofmem.000webhostapp.com/android_login_api/login.php"

    network.request( url, "POST", networkListener, params )
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Menu : create")
end

local function Check( event )
	print( event.target.id )

	if(event.phase == "ended") then
		if(event.target.id == "login") then
			if(UsernameTxf.text == "" or PasswordTxf.text == "") then
				print( "NULL" )

				return
			else
				native.setActivityIndicator( true )
				LoginListener()
				print( "NOT NULL" )

			end


		elseif (event.target.id == "register") then
			composer.gotoScene("register")
		end
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

		UsernameTxf = native.newTextField( cx , cy, 250, 30 )
	    UsernameTxf.inputType = "default"
	    UsernameTxf.text = ""
	    UsernameTxf.hasBackground = false

	    PasswordTxf = native.newTextField( cx , cy + 50, 250, 30 )
	    PasswordTxf.inputType = "default"
	    PasswordTxf.isSecure = true
	    PasswordTxf.text = ""
	    PasswordTxf.hasBackground = false

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
		LoginBtn.y = cy + 100

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
		
		LoginWithFaceBookBtn.x = cx - 100
		LoginWithFaceBookBtn.y = cy + 100

	 register = widget.newButton(
			{
				left = display.contentCenterX + 60,
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
		RemoveAll(UsernameTxf)
		RemoveAll(PasswordTxf)
		
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