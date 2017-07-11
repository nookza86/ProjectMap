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
		--print( "deletePic in scene #HomePlace " .. params.PlaceName  )
		event:removeSelf( )
		event = nil
		
	end
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #HomePlace : create")
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

        else
        	--local alert = native.showAlert( "Welcome", decodedData["user"]["fname"], { "OK" })

        	composer.gotoScene("overview")

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

    local body = "LoginSend=" .. ForgotSend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/forgot.php"

    print( "Login Data Sending To ".. url .." Web Server : " .. ForgotSend )

    network.request( url, "POST", networkListener, params )
end

local function Check( event )
	print( event.target.id )
	local options = {params = {PlaceName = params.PlaceName}}
	
	if(event.phase == "ended") then
		if (EmailTxf.text == "" or EmailTxf.text == nil) then
			native.showAlert( "Error", "Type email", { "OK" } )
			return

		else
			native.setActivityIndicator( true )
			ForGotListener(  )
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

		
		Bg = display.newImageRect("Phuket/Home/".. params.PlaceName .. "/bg.png", cw, ch )
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
	        width = 100/1.5,
	        height = 50/1.5,
	        defaultFile = "Phuket/Button/Button/ok.png",
	        overFile = "Phuket/Button/ButtonPress/ok.png",
	        id = "ok",
	        onEvent = Check
    	}
			)
		OkBtn.x = cx + 230
		OkBtn.y = cy + 130

	elseif (phase == "did") then
		print("Scene #HomePlace : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then

		print("Scene #HomePlace : hide (will)")
	elseif (phase == "did") then
		print("Scene #HomePlace : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #HomePlace : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene