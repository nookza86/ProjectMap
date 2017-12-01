local composer = require("composer")
local widget = require("widget" )
local json = require ("json")
--https://forums.coronalabs.com/topic/66630-how-can-i-encrypt-my-saved-data/
local openssl = require( "plugin.openssl" )
local cipher = openssl.get_cipher ( "aes-256-cbc" )
local myPassword = "5]:-a9Ya5H(;"
local sqlite = require("sqlite3")
local facebook = require( "plugin.facebook.v4" )
local toast = require('plugin.toast')
local imgOper = require('image')
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
local INSERT_DATA_1, INSERT_DATA_2, INSERT_DATA_3, INSERT_DATA_4, INSERT_DATA_5
local saveEncryptedData, loadEncryptedData
local RememberCheckBox, RememberCheckBoxImage,isRememberCheckBox

local function RemoveAll( event )
	if(event) then
		--print( "deletePic in scene #Menu " )
		event:removeSelf( )
		event = nil
		
	end
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
	INSERT_DATA_4 = true

	if (isRememberCheckBox == true) then
		local myTable = {
			email = decodedData["user"]["email"],
			password = PasswordTxf.text,
			remember = "true",
		}
		saveEncryptedData(myTable, "user.json")
	else
		imgOper.Remove( "user.json", system.DocumentsDirectory )
		INSERT_DATA_5 = true
	end
	

 end

local function GoS(  )
			composer.gotoScene("overview")
			--native.setActivityIndicator( false )
end

local function listener( event )
    if (INSERT_DATA_4 == true and INSERT_DATA_5 == true) then
    	native.setActivityIndicator( false )
    	 timer.cancel( event.source )
    	 composer.gotoScene("loading")
    	 print( "LOADING DONE" )
    	else
    		print( "4 : " .. tostring( INSERT_DATA_4 ) .. " 5 : " .. tostring( INSERT_DATA_5 ) )
    end
end

local function networkListener( event )
    if ( event.isError ) then
        print( "Network error!" )
        --local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
        toast.show("Try again")
        native.setActivityIndicator( false )
    else
    	myNewData = event.response
        print( "RESPONSE: " .. event.response )
        decodedData = (json.decode( myNewData ))

        ErrorCheck = decodedData["error"]
       -- ActiveCheck = decodedData["user"]["active"]

    	if( ErrorCheck == true) then
    		--local alert = native.showAlert( "Error", "Try again.", { "OK" })
    		toast.show(decodedData["error_msg"])
        	print( "Try again." )
        	native.setActivityIndicator( false )
        else
        	--local alert = native.showAlert( "Welcome", decodedData["user"]["first_name"], { "OK" })
        	--print( "Welcome " .. decodedData["user"]["first_name"] )

	    INSERT_DATA_4 = false
	    INSERT_DATA_5 = false

	    

		--native.setActivityIndicator( true )
		timer.performWithDelay( 1000, listener, 0 )
		InsertData(  )

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
  		--native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
  		toast.show("It seems internet is not Available. Please connect to internet.")
  		return
	end
]]
	if(event.phase == "ended") then
		if(event.target.id == "login") then
			if(EmailTxf.text == "" or PasswordTxf.text == "") then
				--print( "NULL" )
				toast.show("Please fill all fields.")
				return
			else
				native.setActivityIndicator( true )
				LoginListener()
				print( "NOT NULL" )

			end


		elseif (event.target.id == "SignUp") then
			composer.gotoScene("register")
		elseif (event.target.id == "Forgot") then
			composer.gotoScene("forgot")
		end
	end

end

function saveEncryptedData(tableName, fileName)
	
	--turn table into json string
	local myJsonString = json.encode(tableName)

	--encrypt that json string
	local encryptedData = cipher:encrypt ( myJsonString, myPassword )

	--save to a file
	local path = system.pathForFile(fileName, system.DocumentsDirectory )
	local file = io.open(path, "w")
	file:write(encryptedData)	
	io.close(file)
	INSERT_DATA_5 = true

end

function loadEncryptedData(filename)

	local path = system.pathForFile( filename, system.DocumentsDirectory )

	-- will hold contents of file
	local contents

	--predeclare file variable
	local file

	-- io.open opens a file at path. returns nil if no file found
	if path then
		file = io.open( path, "r" )
	end

	--if file could be opened then proceed
	if file then
	    -- read all contents of file into a string
	   	contents = file:read( "*a" )
	    io.close( file )	-- close the file after using it
	else
		--if file could not be opened, then set contents to be an empty table json string
		contents = "[]"
	end

	--decrypt the string that we have retrieved
	local decryptedData = cipher:decrypt ( contents, myPassword )

	--then turn json string back into a lua table
	local newTable = json.decode(decryptedData)

	--and return the table
	return newTable

end

local function onSwitchPress( event )
    local switch = event.target
    isRememberCheckBox = switch.isOn
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
end

local function FIND_FILE( Filename )
	local lfs = require( "lfs" )
 	--print( "FINDING : " ..Filename )
	-- Get raw path to the app documents directory
	local doc_path = system.pathForFile( "", system.DocumentsDirectory )
	 
	for file in lfs.dir( doc_path ) do
	    -- "file" is the current file or directory name
	    
	    if (file == Filename) then
	    	print( "Found file: " .. file )
	    	--native.showAlert( "No Internet","Found file: " .. file, { "OK" } )
	    	return true
	    end
	end
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		local prevScene = composer.getSceneName( "previous" )

		if (prevScene ~= nil) then
			composer.removeScene( prevScene )
		end
		
		
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

		myText = display.newImageRect("Phuket/menu/bglogin.jpg", cw, ch )
		myText.x = display.contentCenterX 
		myText.y = display.contentCenterY

		TextFieldImage = display.newImageRect("Phuket/menu/wbg.png", 480/2, 360/2 )
		TextFieldImage.x = cx
		TextFieldImage.y = cy + 65

		EmailTxf = native.newTextField( TextFieldImage.x , TextFieldImage.y - 50, 200, 25 )
	    EmailTxf.inputType = "default"
	    --EmailTxf.text = ""
	    --EmailTxf.text = "nook_we@hotmail.com"
	    EmailTxf.text = ""
	    EmailTxf.hasBackground = false
	    EmailTxf.placeholder = "Your E-mail"

	    EmailImage = display.newImageRect("Phuket/menu/box.png", 210, 35 )
		EmailImage.x = EmailTxf.x
		EmailImage.y = EmailTxf.y

	    PasswordTxf = native.newTextField( EmailTxf.x , EmailTxf.y + 40, 200, 25 )
	    PasswordTxf.inputType = "default"
	    PasswordTxf.isSecure = true
	    --PasswordTxf.text = "1234"
	    PasswordTxf.text = ""
	    PasswordTxf.hasBackground = false
	    PasswordTxf.placeholder = "Password"

	    PasswordImage = display.newImageRect("Phuket/menu/box.png", 210, 35 )
		PasswordImage.x = PasswordTxf.x
		PasswordImage.y = PasswordTxf.y

		local DB_Email = ""
		local initRemember = false

		if (FIND_FILE( "user.json" ) == true) then

			local UserDataJson = loadEncryptedData("user.json")
			EmailTxf.text = UserDataJson.email
			PasswordTxf.text = UserDataJson.password
			if (UserDataJson.remember == "true") then
				initRemember = true
			end

		end

	local RememberCheckBox = widget.newSwitch(
    	{
	        left = PasswordImage.x - 100,
	        top = PasswordImage.y + 20,
	        style = "checkbox",
	        id = "Checkbox",
	        initialSwitchState = initRemember,
	        width = 20,
    		height = 20,
	        onPress = onSwitchPress
    	}
	)

	RememberCheckBoxImage = display.newImageRect("Phuket/menu/rememberme.png", 234 / 2.5, 40 / 2.5 )
	RememberCheckBoxImage.x = RememberCheckBox.x + 60
	RememberCheckBoxImage.y = RememberCheckBox.y
	isRememberCheckBox = false

	 LoginBtn = widget.newButton(
    	{
	        width = 291/4,
	        height = 108/4,
	        defaultFile = "Phuket/Button/Button/login.png",
	        overFile = "Phuket/Button/ButtonPress/login.png",
	        id = "login",
	        onEvent = Check
    	}
			)
		
		LoginBtn.x = cx 
		LoginBtn.y = cy + 115

	ForgotImage = display.newImageRect("Phuket/menu/forgotpass.png", 270/2.5, 50/2.5 )
	ForgotImage.x = display.contentCenterX - 40
	ForgotImage.y = display.contentCenterY + 145
	ForgotImage.id = "Forgot"
	ForgotImage:addEventListener( "touch", Check )

	SignUpImage = display.newImageRect("Phuket/menu/signup.png", 200/3.5, 60/3.5 )
	SignUpImage.x = ForgotImage.x + 90
	SignUpImage.y = ForgotImage.y 
	SignUpImage.id = "SignUp"

	SignUpImage:addEventListener( "touch", Check )
	
	sceneGroup:insert(myText)
	sceneGroup:insert(LoginBtn)
	sceneGroup:insert(ForgotImage)
	sceneGroup:insert(EmailTxf)
	sceneGroup:insert(RememberCheckBox)
	sceneGroup:insert(RememberCheckBoxImage)
	sceneGroup:insert(SignUpImage)
	sceneGroup:insert(EmailImage)
	sceneGroup:insert(PasswordImage)
	sceneGroup:insert(PasswordTxf)
	sceneGroup:insert(TextFieldImage)	

	elseif (phase == "did") then
		print("Scene #Menu : show (did)")

		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		--[[
		RemoveAll(myText)
		RemoveAll(LoginBtn)
		RemoveAll(ForgotImage)
		RemoveAll(EmailTxf)
		RemoveAll(SignUpImage)
		RemoveAll(EmailImage)
		RemoveAll(PasswordImage)
		RemoveAll(PasswordTxf)
		RemoveAll(TextFieldImage)
		]]
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

--Runtime:addEventListener( "orientation", yourFunctionWhenOrientationChanges )

return scene