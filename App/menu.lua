local composer = require("composer")
local widget = require("widget" )
local json = require ("json")
local facebook = require( "plugin.facebook.v4" )
local scene = composer.newScene()
local LoginWithFaceBookBtn, LoginBtn, register, myText
local ForgotImage, SignUpImage, EmailImage, PasswordImage, TextFieldImage
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
       -- ActiveCheck = decodedData["user"]["active"]

    	if( ErrorCheck == true) then
    		local alert = native.showAlert( "Error", "Try again.", { "OK" })
        	print( "Try again." )

        elseif ( decodedData["user"]["active"] == 'no') then
        	local alert = native.showAlert( "Error", "Please Activate.", { "OK" })
        	print( "Need Activate." )

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

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/login.php"
    --local url = "https://mapofmem.000webhostapp.com/android_login_api/login.php"

    print( "Login Data Sending To ".. url .." Web Server : " .. LoginSend )

    network.request( url, "POST", networkListener, params )
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Menu : create")
end

local function Check( event )
	print( event.target.id )

	if(event.target.id == "LoginWithFaceBookBtn") then
		composer.gotoScene( "overview" )
	end

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

		--[[
		print( display.pixelWidth  )
		print( display.pixelHeight  )
		print(display.contentWidth)
		print(display.contentHeight)
		print(display.actualContentWidth)
		print(display.actualContentHeight)
		print( display.imageSuffix )
		print( display.pixelWidth / display.actualContentWidth )
		print( display.pixelHeight / display.actualContentHeight )
		]]

		myText = display.newImageRect("Phuket/menu/bglogin.png", cw, ch )
		myText.x = display.contentCenterX 
		myText.y = display.contentCenterY

		EmailTxf = native.newTextField( cx , cy + 40, 200, 25 )
	    EmailTxf.inputType = "default"
	    EmailTxf.text = ""
	    EmailTxf.hasBackground = false
	    EmailTxf.placeholder = "E-mail"

	    EmailImage = display.newImageRect("Phuket/menu/box.png", 210, 35 )
		EmailImage.x = EmailTxf.x
		EmailImage.y = EmailTxf.y

	    PasswordTxf = native.newTextField( cx , cy + 80, 200, 25 )
	    PasswordTxf.inputType = "default"
	    PasswordTxf.isSecure = true
	    PasswordTxf.text = ""
	    PasswordTxf.hasBackground = false
	    PasswordTxf.placeholder = "Password"

	    PasswordImage = display.newImageRect("Phuket/menu/box.png", 210, 35 )
		PasswordImage.x = PasswordTxf.x
		PasswordImage.y = PasswordTxf.y
--[[
		ForgotImage = display.newImageRect("Phuket/menu/forgotpass.png", 270/2.5, 50/2.5)
		ForgotImage.x = PasswordTxf.x - 50
		ForgotImage.y = PasswordTxf.y + 25
]]
		TextFieldImage = display.newImageRect("Phuket/menu/wbg.png", 480/2, 360/2.5 )
		TextFieldImage.x = cx
		TextFieldImage.y = cy + 75


	 LoginBtn = widget.newButton(
    	{
	        width = 150/2,
	        height = 45/2,
	        defaultFile = "Phuket/Button/Button/login.png",
	        overFile = "Phuket/Button/ButtonPress/login.png",
	        id = "login",
	        onEvent = Check
    	}
			)
		
		LoginBtn.x = cx - 55
		LoginBtn.y = cy + 115

	 LoginWithFaceBookBtn = widget.newButton(
    	{
	        width = 250 / 2.5,
	        height = 60/ 2.5,
	        defaultFile = "Phuket/Button/Button/login_w_fb.png",
	        overFile = "Phuket/Button/ButtonPress/login_w_fb.png",
	        id = "LoginWithFaceBookBtn",
	        onEvent = Check
    	}
			)
		
		LoginWithFaceBookBtn.x = LoginBtn.x + 95
		LoginWithFaceBookBtn.y = LoginBtn.y  

	ForgotImage = display.newImageRect("Phuket/menu/forgotpass.png", 270/2.5, 50/2.5 )
	ForgotImage.x = display.contentCenterX - 40
	ForgotImage.y = display.contentCenterY + 145

	SignUpImage = display.newImageRect("Phuket/menu/signup.png", 200/3.5, 60/3.5 )
	SignUpImage.x = ForgotImage.x + 90
	SignUpImage.y = ForgotImage.y 
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
		RemoveAll(ForgotImage)
		RemoveAll(EmailTxf)
		RemoveAll(SignUpImage)
		RemoveAll(EmailImage)
		RemoveAll(PasswordImage)
		RemoveAll(PasswordTxf)
		RemoveAll(TextFieldImage)
		SignUpImage:removeEventListener( "touch", Check )

		
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