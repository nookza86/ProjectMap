local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local toast = require('plugin.toast')
require("createAcc")
require("get-data")
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local Bg, cx, cy, cw, ch
local SettingBtn, OkBtn
local PasswordImage, PasswordTxf

local function RemoveAll( event )
	if(event) then
		--print( "deletePic in profile"  )
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

local function networkListener( event )
    if ( event.isError ) then
        print( "Network error!" )
        local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
    else
        native.setActivityIndicator( false )
    	myNewData = event.response
        print( "RESPONSE: " .. event.response )
        decodedData = (json.decode( myNewData ))

        ErrorCheck = decodedData["error"]

    	if( ErrorCheck == true) then
    		--local alert = native.showAlert( "Error", "Try again.", { "OK" })
            toast.show("Try again")
        	print( "Try again." )
        	
        else
	   		composer.gotoScene( "profile_select_2" )

    	end

        
    end
end

local function LoginListener(  )

	local Email = ""
	for row in db:nrows("SELECT email FROM personel;") do
            Email = row.email
    end
    local login = {}
    login["email"] = Email
    login["password"] = PasswordTxf.text

    local LoginSend = json.encode( login )

    print( "Login Data Sending To Web Server : " .. LoginSend )

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "LoginSend=" .. LoginSend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/login.php"

    print( "Login Data Sending To ".. url .." Web Server : " .. LoginSend )

    network.request( url, "POST", networkListener, params )
end

local function Check( event )
	local obj = event.target.id

	print( obj )
	if(event.phase == "ended") then

		if(obj == "ok") then
			if (PasswordTxf.text ~= nil) then
                native.setActivityIndicator( true )
				LoginListener(  )
			else
				print( "Try Again" )
			end

		elseif(obj == "BackBtn") then
			composer.gotoScene("profile")
		end
	end
end


function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Profile : create")
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	cx = display.contentCenterX
    cy = display.contentCenterY
    cw = display.contentWidth
    ch = display.contentHeight

	if (phase == "will") then
        local prevScene = composer.getSceneName( "previous" )

        if (prevScene ~= nil) then
            composer.removeScene( prevScene )
        end
		Bg = display.newImageRect("Phuket/Profile/bg.jpg", cw, ch )
		Bg.x = cx 
		Bg.y = cy 
		
		PasswordTxf = native.newTextField( cx , cy, 200, 25 )
        PasswordTxf.inputType = "default"
        PasswordTxf.text = ""
        PasswordTxf.isSecure = true
        PasswordTxf.hasBackground = false
        PasswordTxf.placeholder = "Password"

        PasswordImage = display.newImageRect("Phuket/menu/box.png", 210, 35 )
        PasswordImage.x = PasswordTxf.x
        PasswordImage.y = PasswordTxf.y

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

        BackBtn.x = cx - 230
        BackBtn.y = cy - 110

        sceneGroup:insert(Bg)
        sceneGroup:insert(PasswordTxf)
        sceneGroup:insert(PasswordImage)
        sceneGroup:insert(OkBtn)
        sceneGroup:insert(BackBtn)
		
		print("Scene #Profile : show (will)")
	
	elseif (phase == "did") then
		print("Scene #Profile : show (did)")
		
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		--[[
		RemoveAll(Bg)
		RemoveAll(PasswordTxf)
		RemoveAll(PasswordImage)
		RemoveAll(BackBtn)
]]
		print("Scene #Profile : hide (will)")
	elseif (phase == "did") then
		
		print("Scene #Profile : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #Profile : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Runtime:addEventListener( "key", onKeyEvent )

return scene