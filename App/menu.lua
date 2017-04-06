local composer = require("composer")
local widget = require("widget" )
local json = require ("json")
local facebook = require( "plugin.facebook.v4" )
local scene = composer.newScene()
local LoginWithFaceBookBtn, LoginBtn, register, myText
local EmailTxf, PasswordTxf
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
        	--local alert = native.showAlert( "Welcome", decodedData["user"]["fname"], { "OK" })
        	print( "Welcome " .. decodedData["user"]["fname"] )
        	composer.gotoScene("overview")

    	end

        
    end
end

local function LoginListener(  )

    print( EmailTxf.text, PasswordTxf.text)

    local login = {}
    login["email"] = EmailTxf.text
    login["password"] = PasswordTxf.text

    local LoginSend = json.encode( login )

    print( "Login Data Sending To Web Server : " .. LoginSend )

    local headers = {}
    --headers["Content-Type"] = "application/json"
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    --local body = "email=".. EmailTxf.text .."&password=".. PasswordTxf.text 

    local body = "LoginSend=" .. LoginSend

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
			if(EmailTxf.text == "" or PasswordTxf.text == "") then
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

		print( display.pixelWidth  )
		print( display.pixelHeight  )
		print(display.contentWidth)
		print(display.contentHeight)
		print(display.actualContentWidth)
		print(display.actualContentHeight)
		print( display.imageSuffix )
		print( display.pixelWidth / display.actualContentWidth )
		print( display.pixelHeight / display.actualContentHeight )

		myText = display.newImageRect("Phuket/menu/bglogin.png", cw, ch )
		myText.x = display.contentCenterX 
		myText.y = display.contentCenterY

		EmailTxf = native.newTextField( cx , cy, 250, 30 )
	    EmailTxf.inputType = "default"
	    EmailTxf.text = ""
	    EmailTxf.hasBackground = false
	    EmailTxf.placeholder = "E-mail"

	    PasswordTxf = native.newTextField( cx , cy + 50, 250, 30 )
	    PasswordTxf.inputType = "default"
	    PasswordTxf.isSecure = true
	    PasswordTxf.text = ""
	    PasswordTxf.hasBackground = false
	    PasswordTxf.placeholder = "Password"

	 LoginBtn = widget.newButton(
    	{
	        width = 100,
	        height = 42,
	        defaultFile = "Phuket/Button/login.png",
	        overFile = "Phuket/Button/map.png",
	        id = "login",
	        onEvent = Check
    	}
			)
		
		LoginBtn.x = cx 
		LoginBtn.y = cy + 100

	 LoginWithFaceBookBtn = widget.newButton(
    	{
	        width = 250 / 2,
	        height = 52/ 2,
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
		RemoveAll(EmailTxf)
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