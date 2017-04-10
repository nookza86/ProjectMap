local composer = require("composer")
local widget = require("widget" )
local json = require ("json")
local facebook = require( "plugin.facebook.v4" )
local scene = composer.newScene()
local LoginWithFaceBookBtn, LoginBtn, register, myText
local DontHaveImage, SignUpImage, EmailImage, PasswordImage, TextFieldImage
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
        local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
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
        	print( "Welcome " .. decodedData["user"]["first_name"] )
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


		elseif (event.target.id == "SignUp") then
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

		EmailTxf = native.newTextField( cx , cy + 30, 200, 30 )
	    EmailTxf.inputType = "default"
	    EmailTxf.text = ""
	    EmailTxf.hasBackground = false
	    EmailTxf.placeholder = "E-mail"

	    EmailImage = display.newImageRect("Phuket/menu/box.png", 210, 35 )
		EmailImage.x = EmailTxf.x
		EmailImage.y = EmailTxf.y

	    PasswordTxf = native.newTextField( cx , cy + 70, 200, 30 )
	    PasswordTxf.inputType = "default"
	    PasswordTxf.isSecure = true
	    PasswordTxf.text = ""
	    PasswordTxf.hasBackground = false
	    PasswordTxf.placeholder = "Password"

	    PasswordImage = display.newImageRect("Phuket/menu/box.png", 210, 35 )
		PasswordImage.x = PasswordTxf.x
		PasswordImage.y = PasswordTxf.y

		TextFieldImage = display.newImageRect("Phuket/menu/wbg.png", 500/2, 380/2.5 )
		TextFieldImage.x = cx
		TextFieldImage.y = cy + 40


	 LoginBtn = widget.newButton(
    	{
	        width = 150/1.5,
	        height = 45/1.5,
	        defaultFile = "Phuket/Button/Button/login.png",
	        overFile = "Phuket/Button/ButtonPress/login.png",
	        id = "login",
	        onEvent = Check
    	}
			)
		
		LoginBtn.x = cx 
		LoginBtn.y = cy + 110

	 LoginWithFaceBookBtn = widget.newButton(
    	{
	        width = 250 / 2,
	        height = 60/ 2,
	        defaultFile = "Phuket/Button/Button/login_w_fb.png",
	        overFile = "Phuket/Button/ButtonPress/login_w_fb.png",
	        id = "LoginWithFaceBookBtn",
	        onEvent = Check
    	}
			)
		
		LoginWithFaceBookBtn.x = cx
		LoginWithFaceBookBtn.y = cy - 10 

	DontHaveImage = display.newImageRect("Phuket/menu/donthave.png", 400/2.5, 50/2.5 )
	DontHaveImage.x = display.contentCenterX - 50
	DontHaveImage.y = display.contentCenterY + 140

	SignUpImage = display.newImageRect("Phuket/menu/signup.png", 200/2.5, 60/2.5 )
	SignUpImage.x = DontHaveImage.x + 130
	SignUpImage.y = DontHaveImage.y 
	SignUpImage.id = "SignUp"

	SignUpImage:addEventListener( "touch", Check )

		
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
		RemoveAll(DontHaveImage)
		RemoveAll(EmailTxf)
		RemoveAll(SignUpImage)
		RemoveAll(EmailImage)
		RemoveAll(PasswordImage)
		RemoveAll(PasswordTxf)
		RemoveAll(TextFieldImage)

		
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