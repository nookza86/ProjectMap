local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local toast = require('plugin.toast')
require ("cal")
require("createAcc")
require("get-data")
require ("Network-Check")
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local params, cx, cy, cw, ch
local Bg, BgBtn, BackBtn, TitleImage, OkBtn
local EmailImage
local EmailTxf

local function RemoveAll( event )
	if(event) then
		--print( "deletePic in scene #Forgot " .. params.PlaceName  )
		event:removeSelf( )
		event = nil
		
	end
end

local function onKeyEvent( event )
    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
   -- native.showAlert( "Error", message, { "OK" } )
 
    -- If the "back" key was pressed on Android or Windows Phone, prevent it from backing out of the app
    if ( event.keyName == "back" ) then
        local platformName = system.getInfo( "platformName" )
        if ( platformName == "Android" ) or ( platformName == "WinPhone" ) then
        	
            return true
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Forgot : create")
end

local function networkListener( event )
	native.setActivityIndicator( false )
    if ( event.isError ) then
        print( "Network error!" )
        local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
    else
    	myNewData = event.response
        print( "RESPONSE: " .. event.response )
        decodedData = (json.decode( myNewData ))

        ErrorCheck = decodedData["error"]

    	if( ErrorCheck == true) then
    		local alert = native.showAlert( "Error", decodedData["error_msg"], { "OK" })
        	print( "Try again." )

        else
        	local alert = native.showAlert( "", "Check your email", { "OK" })
        	composer.gotoScene("menu")

    	end

        
    end
end

local function ForGotListener(  )

    local forgot = {}
    forgot["email"] = EmailTxf.text

    local ForgotSend = json.encode( forgot )

    print( "Forgot Data Sending To Web Server : " .. ForgotSend )

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "ForgotSend=" .. ForgotSend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/forgot.php"

    print( "Login Data Sending To ".. url .." Web Server : " .. ForgotSend )

    network.request( url, "POST", networkListener, params )
end

local function Check( event )
	print( event.target.id )
	--local options = {params = {PlaceName = params.PlaceName}}
	
	if(event.phase == "ended") then
		if (event.target.id == "ok") then

			if (EmailTxf.text == "" or EmailTxf.text == nil) then
				native.showAlert( "Error", "Please fill your email.", { "OK" } )
				return
			else
				native.setActivityIndicator( true )
				ForGotListener(  )
			end

		elseif (event.target.id == "BackBtn") then
			composer.gotoScene("menu")
			
		end

	end
end


function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	cx = display.contentCenterX
    cy = display.contentCenterY
    cw = display.contentWidth
    ch = display.contentHeight

	if (phase == "will") then
		--composer.removeScene( "menu" )
		local prevScene = composer.getSceneName( "previous" )

		if (prevScene ~= nil) then
			composer.removeScene( prevScene )
		end

		Bg = display.newImageRect("Phuket/menu/bglogin.png", cw, ch )
		Bg.x = display.contentCenterX 
		Bg.y = display.contentCenterY

		EmailTxf = native.newTextField( cx , cy + 40, 200, 25 )
	    EmailTxf.inputType = "default"
	    EmailTxf.text = "nook_we@hotmail.com"
	    EmailTxf.hasBackground = false
	    EmailTxf.placeholder = "E-mail"

	    EmailImage = display.newImageRect("Phuket/menu/box.png", 210, 35 )
		EmailImage.x = EmailTxf.x
		EmailImage.y = EmailTxf.y

		OkBtn = widget.newButton(
    	{
	        width = 130/2.5,
	        height = 101/2.5,
	        defaultFile = "Phuket/Button/Button/ok.png",
	        overFile = "Phuket/Button/ButtonPress/ok.png",
	        id = "ok",
	        onEvent = Check
    	}
			)
		OkBtn.x = cx 
		OkBtn.y = cy + 100

		BackBtn = widget.newButton(
    	{
	        width = 130/2.5,
	        height = 101/2.5,
	        defaultFile = "Phuket/Button/Button/back.png",
	        overFile = "Phuket/Button/ButtonPress/back.png",
	        id = "BackBtn",
	        onEvent = Check
    	}
			)
		
		BackBtn.x = cx - 240
		BackBtn.y = cy - 110

		sceneGroup:insert(Bg)
		sceneGroup:insert(EmailTxf)
		sceneGroup:insert(EmailImage)
		sceneGroup:insert(OkBtn)

	elseif (phase == "did") then
		print("Scene #Forgot : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(Bg)
		RemoveAll(EmailTxf)
		RemoveAll(EmailImage)
		RemoveAll(OkBtn)
		print("Scene #Forgot : hide (will)")
	elseif (phase == "did") then
		print("Scene #Forgot : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #Forgot : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Runtime:addEventListener( "key", onKeyEvent )

return scene