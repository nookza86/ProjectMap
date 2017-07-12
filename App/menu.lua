local composer = require("composer")
local widget = require("widget" )
local json = require ("json")
local sqlite = require("sqlite3")
local facebook = require( "plugin.facebook.v4" )
local toast = require('plugin.toast')
require ("Network-Check")
local scene = composer.newScene()
local LoginWithFaceBookBtn, LoginBtn, register, myText
local ForgotImage, SignUpImage, EmailImage, PasswordImage, TextFieldImage
local EmailTxf, PasswordTxf
local myNewData 
local decodedData 
local cx, cy, cw, ch
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local CountGetDatabase = 0
local GetData
local function RemoveAll( event )
	if(event) then
		print( "deletePic in scene #Menu " )
		event:removeSelf( )
		event = nil
		
	end
end

local function GetDataListener( event )
    if ( event.isError ) then
        print( "Network error!" )
        local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
    else

    	local GetDatabase = event.response
        print( "RESPONSE: " .. event.response )
       local decodedDatabase = (json.decode( GetDatabase ))

       if(CountGetDatabase == 1) then
	       for idx1, val1 in ipairs(decodedDatabase) do
	       		local insertQuery = "INSERT INTO attractions VALUES (" ..
				val1.att_no .. ",'" ..
				val1.att_name .. "','" ..
				val1.descriptions.. "','" .. 
				val1.att_img .. "');"

				db:exec( insertQuery )
				--print(insertQuery)
				
	       end
	       GetData(2)
        	
	    elseif(CountGetDatabase == 2) then
	       for idx2, val2 in ipairs(decodedDatabase) do
	       		local insertQuery = "INSERT INTO diary VALUES (" ..
				val2.diary_id .. "," ..
				val2.member_no .. "," ..
				val2.att_no .. ",'" ..
				val2.diary_note.. "'," .. 
				val2.impression.. "," .. 
				val2.beauty.. "," ..
				val2.clean.. ",'" ..
				val2.diary_pic1.. "','" ..
				val2.diary_pic2.. "','" ..
				val2.diary_pic3.. "','" ..
				val2.diary_pic4 .. "');"

				db:exec( insertQuery )
				--print(insertQuery)
				
	       end
	       GetData(3)
	    elseif(CountGetDatabase == 3) then
	       for idx3, val3 in ipairs(decodedDatabase) do
	       	--print("GetData 3",idx3, val3)
	       		local insertQuery = "INSERT INTO unattractions VALUES (" ..
				val3.un_id .. ",'" ..
				val3.member_no .. "','" ..
				val3.att_no .. "');"

				db:exec( insertQuery )
				--print(insertQuery)
				
	       end
	   end
       
    end
end

function GetData( i )
	CountGetDatabase = i
	local GetDatabase = {}

	local NOOOO = 0	
	local sql2 = "SELECT id FROM personel;"
		for row in db:nrows(sql2) do
			NOOOO = row.id
		end
		
    GetDatabase["no"] = i
    GetDatabase["mem_no"] = NOOOO

    local GetDatabaseSend = json.encode( GetDatabase )

    local headers = {}
   
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "Number=" .. GetDatabaseSend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/retivedata.php"
     print( CountGetDatabase.." : Login Data Sending To ".. url .." : " .. GetDatabaseSend )
    network.request( url, "POST", GetDataListener, params )
end

local function InsertData(  )
	local TRU = "DROP TABLE IF EXISTS `personel`;"
	db:exec(TRU)
	TRU = "DROP TABLE IF EXISTS `diary`;"
	db:exec(TRU)
	TRU = "DROP TABLE IF EXISTS `attractions`;"
	db:exec(TRU)
	TRU = "DROP TABLE IF EXISTS `unattractions`;"
	db:exec(TRU)

	local tablesetup = [[CREATE TABLE IF NOT EXISTS personel (
							`id`	INTEGER,
							`fname`	TEXT,
							`lname`	TEXT,
							`email`	TEXT,
							`gender`	TEXT,
							`dob`	TEXT,
							`country`	TEXT,
							`userfrom`	TEXT,
							`img`	TEXT,
							PRIMARY KEY(`id`));

						CREATE TABLE IF NOT EXISTS `attractions` (
							`att_no`	INTEGER,
							`att_name`	TEXT,
							`descriptions`	TEXT,
							`att_img`	TEXT,
							PRIMARY KEY(`att_no`));

							CREATE TABLE IF NOT EXISTS `diary` (
								`diary_id`	INTEGER,
								`member_no`	INTEGER,
								`att_no`	INTEGER,
								`diary_note`	TEXT,
								`impression`	INTEGER,
								`beauty`	INTEGER,
								`clean`	INTEGER,
								`diary_pic1`	TEXT,
								`diary_pic2`	TEXT,
								`diary_pic3`	TEXT,
								`diary_pic4`	TEXT,
								PRIMARY KEY(`diary_id`));

							CREATE TABLE IF NOT EXISTS `unattractions` (
								`un_id`	INTEGER,
								`member_no`	INTEGER,
								`att_no`	INTEGER,
								PRIMARY KEY(`un_id`));
						]]

	db:exec(tablesetup)
	

	local insertQuery = "INSERT INTO personel VALUES (" ..
			decodedData["member_no"] .. ",'" ..
			decodedData["user"]["first_name"] .. "','" ..
			decodedData["user"]["last_name"].. "','" .. 
			decodedData["user"]["email"].. "','" ..
			decodedData["user"]["gender"].. "','" ..
			decodedData["user"]["dob"].. "','" ..
			decodedData["user"]["Country"].. "','" ..
			decodedData["user"]["UserFrom"].. "','" ..
			decodedData["user"]["UserImage"] .. "');"

	db:exec( insertQuery )
	--print(insertQuery)

 end

local function GoS(  )
			composer.gotoScene("overview")
			native.setActivityIndicator( false )
end

local function networkListener( event )
    if ( event.isError ) then
        print( "Network error!" )
        local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
    else
    	myNewData = event.response
        print( "RESPONSE: " .. event.response )
        decodedData = (json.decode( myNewData ))

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

        	InsertData(  )     	
        	GetData(1)
        	timer.performWithDelay( 5000, GoS ) 
        	

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

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Menu : create")
end

local function Check( event )
	print( event.target.id )
--[[
	if isRechable() == true then 
		print( "Internet access" )
	else 
  		native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
  		return
	end
]]
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
	    EmailTxf.text = "nook_we@hotmail.com"
	    EmailTxf.hasBackground = false
	    EmailTxf.placeholder = "E-mail"

	    EmailImage = display.newImageRect("Phuket/menu/box.png", 210, 35 )
		EmailImage.x = EmailTxf.x
		EmailImage.y = EmailTxf.y

	    PasswordTxf = native.newTextField( cx , cy + 80, 200, 25 )
	    PasswordTxf.inputType = "default"
	    PasswordTxf.isSecure = true
	    PasswordTxf.text = "123456789"
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