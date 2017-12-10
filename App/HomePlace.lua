local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local toast = require('plugin.toast')
require ("cal")
--require("createAcc")
--require("get-data")
require ("Network-Check")
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local myMap = native.newMapView( 20, 20, 1, 1 )
local params, cx, cy, cw, ch
local Bg, BgBtn, BackBtn, TitleImage
local InformationBtn, MapBtn, ShareBtn, DiaryBtn
local PopupImg, PopupClose, backgroundALpha, PopupText
local IsUnlock = false
local IsDiary = false
local Check
local HomeGroup = display.newGroup( )
------
local filename = system.pathForFile( "distance.json", system.ResourceDirectory )
local decoded, pos, msg = json.decodeFile( filename )
local LocationBtn

-------

local function RemoveAll( event )
	if(event) then
		--print( "deletePic in scene #HomePlace " .. params.PlaceName  )
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
	print("Scene #HomePlace : create")
end

local function DisableBTN(  )
	
	InformationBtn:setEnabled( false )
	MapBtn:setEnabled( false )
	ShareBtn:setEnabled( false )
	DiaryBtn:setEnabled( false )
	BackBtn:setEnabled( false )

	if (LocationBtn) then
		LocationBtn:setEnabled( false )
	end
end

local function EnableBTN(  )
	
	InformationBtn:setEnabled( true )
	MapBtn:setEnabled( true )
	ShareBtn:setEnabled( true )
	DiaryBtn:setEnabled( true )
	BackBtn:setEnabled( true )

	if (LocationBtn) then
		LocationBtn:setEnabled( true )
	end
end

local function ShowPopUp( TextAlert, IsAlert )
	native.setActivityIndicator( false )
	backgroundALpha = display.newRect(0,0,cw,ch)
	backgroundALpha.x = display.contentWidth / 2
	backgroundALpha.y = display.contentHeight / 2
	backgroundALpha:setFillColor( black )
	backgroundALpha.alpha = 0.5

	PopupImg = display.newImageRect( "Phuket/Home/popup.png", 779 / 3, 450 / 3 )
	PopupImg.x = display.contentCenterX
	PopupImg.y = display.contentCenterY

	local BtnType = {}

	if (IsAlert == true) then
		BtnType.File = "close"
		BtnType.name = "CloseBtn"
		BtnType.x = PopupImg.x + 90
		BtnType.y = PopupImg.y - 50
		BtnType.fontSize = 16
		BtnType.TextPositionX = PopupImg.x - 5
		BtnType.TextPositionY = PopupImg.y
	else
		BtnType.File = "ok"
		BtnType.name = "OkBtn"
		BtnType.x = PopupImg.x + 90
		BtnType.y = PopupImg.y + 40
		BtnType.fontSize = 20
		BtnType.TextPositionX = PopupImg.x - 5
		BtnType.TextPositionY = PopupImg.y - 10
	end

	local options = {
	   text = TextAlert,
	   x = BtnType.TextPositionX,
	   y = BtnType.TextPositionY ,
	   fontSize = BtnType.fontSize,
	   font = "Cloud-Light",
	   --width = 200,
	   --height = 0,
	   align = "center"
	}

	PopupText = display.newText( options )

	CloseBtn = widget.newButton(
    	{
	        width = 130/3,
	        height = 101/3,
	        defaultFile = "Phuket/Button/Button/".. BtnType.File ..".png",
	        overFile = "Phuket/Button/ButtonPress/".. BtnType.File ..".png",
	        id = BtnType.name,
	        onEvent = Check
    	}
			)
	CloseBtn.name = BtnType.name
	CloseBtn.x = BtnType.x
	CloseBtn.y = BtnType.y

	DisableBTN(  )

	HomeGroup:insert( backgroundALpha )
	HomeGroup:insert( PopupImg )
	HomeGroup:insert( PopupText )
	HomeGroup:insert( CloseBtn )
end

function Check( event )
	print( event.target.id )
	local options = {params = {PlaceName = params.PlaceName}}
	
	if(event.phase == "ended") then
		if(event.target.id == "InformationBtn") then
			print( "Go to scene #Information " .. params.PlaceName )
			composer.gotoScene("information", options)

		elseif (event.target.id == "MapBtn") then
			print( "Go to scene #Map " .. params.PlaceName )
			composer.gotoScene("map", options)

		elseif (event.target.id == "ShareBtn") then

			if (IsDiary) then
				print( "Go to scene #Share " .. params.PlaceName )
				composer.gotoScene("share", options)
			else
				--native.showAlert( "Not Diary","Add some diary and some photo", { "OK" } )
				--toast.show("Please add a photo in the diary to share your photo on facebook.")
				ShowPopUp( "Not available \n\n Please add a photo in the diary.", true)
				return
			end

			

		elseif (event.target.id == "DiaryBtn") then
			--IsUnlock=true
			if (IsUnlock) then
				print( "Go to scene #Diary " .. params.PlaceName )
				composer.gotoScene("Diary", options)
			else
				--native.showAlert( "Not Unlock","Unlock Please", { "OK" } )
				--toast.show("Not available because ".. params.PlaceName .." has been locked.")
				ShowPopUp( "Not available \n\n ".. params.PlaceName .." is locked.", true )
				return
			end
			

		elseif (event.target.id == "BackBtn" or event.target.id == "OkBtn") then
			EnableBTN()
			composer.gotoScene("overview")

		elseif (event.target.id == "CloseBtn") then
			RemoveAll( backgroundALpha )
			RemoveAll( PopupImg )
			RemoveAll( PopupText )
			RemoveAll( CloseBtn )
			EnableBTN()
		end
	end
end

local function GoS(  )
	--toast.show("Now " .. params.PlaceName .." has Unlocked.")
	ShowPopUp("Now " .. params.PlaceName .." has Unlocked.", false)
	--[[
	local options = {params = {PlaceName = params.PlaceName}}
			composer.gotoScene("overview", options)
			native.setActivityIndicator( false )
			]]
end

local function GetDataListener( event )
	--toast.show("GetDataListener")
    if ( event.isError ) then
        print( "Network error!" )
        --local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
        ShowPopUp("Network error!, Try again.", true)
    else

    	local GetDatabase = event.response
        print( "RESPONSE: " .. event.response )
       local decodedDatabase = (json.decode( GetDatabase ))

	       for idx3, val3 in ipairs(decodedDatabase) do
	       	--print("GetData 3",idx3, val3)
	       		local insertQuery = "INSERT INTO unattractions VALUES (" ..
				val3.un_id .. ",'" ..
				val3.member_no .. "','" ..
				val3.att_no .. "');"

				db:exec( insertQuery )
				--print(insertQuery)
	       end 
	    native.setActivityIndicator( false )
	    ShowPopUp("Unlocked\n\n" .. params.PlaceName, false)
	    --ShowPopUp(params.PlaceName .." has Unlocked.", false)
	    --GoS()
	end
end

local function GetData( i , member_no)
	--toast.show("GetData")
	--CountGetDatabase = i
	local GetDatabase = {}
    GetDatabase["no"] = i
    GetDatabase["mem_no"] = member_no

    local GetDatabaseSend = json.encode( GetDatabase )

    local headers = {}
   
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "Number=" .. GetDatabaseSend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/retivedata.php"
     --print( CountGetDatabase.." : Login Data Sending To ".. url .." : " .. GetDatabaseSend )
    network.request( url, "POST", GetDataListener, params )
end

local function DropTableData( Table )
	--toast.show("DropTableData")
	local NOOOO = 0	
	local tablesetup = ""
	local sql2 = "SELECT id FROM personel;"
		for row in db:nrows(sql2) do
			NOOOO = row.id
		end

	tablesetup = "DELETE FROM `unattractions`;"

	db:exec(tablesetup)
	GetData(Table , NOOOO)

 end

local function UnlockSendListener( event )
--toast.show("UnlockSendListener")
    if ( event.isError ) then
        print( "Network error!" )
        --local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
        ShowPopUp("Network error!, Try again.", false)
        native.setActivityIndicator( false )

    else

        myNewData = event.response
        print( "RESPONSE: " .. event.response )
        decodedData = (json.decode( myNewData ))

        ErrorCheck = decodedData["error"]
        --toast.show(ErrorCheck)
        if (ErrorCheck == true) then
            return
        else
            DropTableData( 3 )
        end
       
    end
end

function UnAttSend( unattractionsSendData )
	--toast.show("UnAttSend")
    local headers = {}

    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "unattractionsSendData=" .. unattractionsSendData

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/unattractions.php"

    print( "Diary Data Sending To ".. url .." Web Server : " .. unattractionsSendData )
    network.request( url, "POST", UnlockSendListener, params )
end

local function UnlockListener( user )
 --toast.show("UnlockListener")
    local sql = "SELECT att_no FROM attractions WHERE att_name = '".. params.PlaceName .."';"
	local att_no = 0
		for row in db:nrows(sql) do
			att_no = row.att_no
		end

	local member_no = 0	
	local sql2 = "SELECT id FROM personel;"
		for row in db:nrows(sql2) do
			member_no = row.id
		end

        local unattractions = {}

        unattractions["member_no"] = member_no
        unattractions["att_no"] = att_no
        unattractions["latitude"] = user.latitude
        unattractions["longitude"] = user.longitude

        local unattractionsSendData = json.encode( unattractions )
        
        UnAttSend(unattractionsSendData)

		native.setActivityIndicator( true )
		--timer.performWithDelay( 1000, CallDrop )

        --timer.performWithDelay( 5000, GoS )     
            
end

local function CalDis( currentLatitude, currentLongitude )

	if not decoded then
		    print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
		else
		    print( "File successfully decoded!" )

		    for idx, val in ipairs(decoded.rule) do
		    	if (params.PlaceName == val.name) then
		    		CheckInList = true
		    		RuleNo = val.no
		    		print( "Place No. " .. RuleNo )
		    		print( "Attraction name is " .. val.name)	 
		    		break
		    	end-- if name
			end--for 1
			
			local point1 = {}
			local point2 = {}
			local user = {}
			user.latitude = currentLatitude
			user.longitude = currentLongitude
			--user.latitude = 7.827689
			--user.longitude = 98.312640
		   	for idx, val in ipairs(decoded.rule[RuleNo]["information"]) do
				
				point1.latitude = val.latitude1
			    point1.longitude = val.longitude1
			    point2.latitude = val.latitude2
			    point2.longitude = val.longitude2
			    --point 1 จุดศูนกลาง
			    d = sphericalDistanceBetween( point1, point2 )
			    Userd = sphericalDistanceBetween( point1, user )
			    ---- Check distance User and Attraction -----

			    if(Userd <= d) then
			    	InArea = true
			    	break
			    else
			    	InArea = false
			    end
			    text = "Rule No : " .. idx .. " Distance : " .. d .. " User distance : " .. Userd .. " In Area : " .. tostring(InArea)
			    --native.showAlert( "You Are Here", text, { "OK" } )
			end
			
				--InArea = true
			if (InArea == true) then
				--toast.show(user.latitude .. " " .. user.longitude)
				UnlockListener( user )
			else

				--toast.show("You are not in the area. Please try again.")
				
				ShowPopUp("You are not in the area.\n\n Please try again.", true)
			end
			
		
	end -- decode
end

-- A function to handle the "mapAddress" event (also known as "reverse geocoding", ie: coordinates -> string).
local mapAddressHandler = function( event )
	if event.isError then
		-- Failed to receive location information.
		native.showAlert( "Error", event.errorMessage, { "OK" } )
	else
		-- Location information received. Display it.
		local locationText =
				"Latitude: " .. currentLatitude .. 
				", Longitude: " .. currentLongitude ..
				", Address: " .. ( event.streetDetail or "" ) ..
				" " .. ( event.street or "" ) ..
				", " .. ( event.city or "" ) ..
				", " .. ( event.region or "" ) ..
				", " .. ( event.country or "" ) ..
				", " .. ( event.postalCode or "" )
		native.showAlert( "You Are Here", locationText, { "OK" } )
		YourLocation.text = locationText
		
	end
end

local function CheckLocation( event )
 	-- Do not continue if a MapView has not been created.
if(event.phase == "ended") then
 	if isRechable() == false then 
 		--native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
 		--toast.show("It seems internet is not Available. Please connect to internet.")
 		ShowPopUp("It seems internet is not Available.\n\n Please connect to internet.", true)
 		return
	end

 	if myMap == nil then
		return
	end
	native.setActivityIndicator( true )
    -- Fetch the user's current location
	-- Note: in Xcode Simulator, the current location defaults to Apple headquarters in Cupertino, CA
	currentLocation = myMap:getUserLocation()
	if currentLocation.errorCode then
		if currentLocation.errorCode ~= 0 then -- errorCode 0 is: Pending User Authorization!
			currentLatitude = 0
			currentLongitude = 0
			--native.showAlert( "Error", currentLocation.errorMessage, { "OK" } )
			--toast.show(currentLocation.errorMessage)
			ShowPopUp(currentLocation.errorMessage, true)
			native.setActivityIndicator( false )
		end
	else
		-- Current location data was received.
		-- Move map so that current location is at the center.
		currentLatitude = currentLocation.latitude
		currentLongitude = currentLocation.longitude
		CalDis(currentLatitude, currentLongitude)
		myMap:setRegion( currentLatitude, currentLongitude, 0.01, 0.01, true )
		
		-- Look up nearest address to this location (this is returned as a "mapAddress" event, handled above)
		--myMap:nearestAddress( currentLatitude, currentLongitude, mapAddressHandler )
	end
end
end
--
local function locationHandler( event )
 
    if ( event.isError ) then
        print( "Map Error: " .. event.errorMessage )
        native.showAlert( "Error", event.errorMessage, { "OK" } )
    else
        print( "The specified string is at: " .. event.latitude .. "," .. event.longitude )
        --native.showAlert( "Error", event.latitude .." long :" .. event.longitude, { "OK" } )
        --myMap:setCenter( event.latitude, event.longitude )
        myMap:nearestAddress( event.latitude, event.longitude, mapAddressHandler )
    end
 
end

local function CheckLocation2( event )
 	
 	local point1 = {}
 	local point2 = {}
 	point1.latitude = 7.827657
 	point1.longitude = 98.312738

	point2.latitude = 7.827357
 	point2.longitude = 98.312627

 	local d = sphericalDistanceBetween( point1, point2 )
 	print( d )
  -- myMap:requestLocation( "วัดไชยธาราราม", locationHandler )

end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	params = event.params
	cx = display.contentCenterX
    cy = display.contentCenterY
    cw = display.contentWidth
    ch = display.contentHeight

	if (phase == "will") then
		--[[
		composer.removeScene( "overview" )
		composer.removeScene( "information" )
		composer.removeScene( "map" )
		composer.removeScene( "Diary" )
		composer.removeScene( "share" )
		]]
		local prevScene = composer.getSceneName( "previous" )

		if (prevScene ~= nil) then
			composer.removeScene( prevScene )
		end

		print( "User Click " .. params.PlaceName .. " From Overview" )

		
		Bg = display.newImageRect("Phuket/Home/".. params.PlaceName .. "/bg.jpg", cw, ch )
		Bg.x = display.contentCenterX 
		Bg.y = display.contentCenterY
		--Bg:scale( 0.3, 0.3 ) 

		InformationBtn = widget.newButton(
    	{
	        width = 400/2.5,
	        height = 108/2.5,
	        defaultFile = "Phuket/Button/Button/information.png",
	        overFile = "Phuket/Button/ButtonPress/information.png",
	        id = "InformationBtn",
	        onEvent = Check
    	}
			)
		InformationBtn.x = cx + 170 
		InformationBtn.y = cy - 80

		MapBtn = widget.newButton(
    	{
	        width = 400/2.5,
	        height = 108/2.5,
	        defaultFile = "Phuket/Button/Button/map.png",
	        overFile = "Phuket/Button/ButtonPress/map.png",
	        id = "MapBtn",
	        onEvent = Check
    	}
			)
		MapBtn.x = InformationBtn.x
		MapBtn.y = InformationBtn.y + 60

		DiaryBtn = widget.newButton(
    	{
	        width = 400/2.5,
	        height = 108/2.5,
	        defaultFile = "Phuket/Button/Button/diary.png",
	        overFile = "Phuket/Button/ButtonPress/diary.png",
	        id = "DiaryBtn",
	        onEvent = Check
    	}
			)
		DiaryBtn.x = MapBtn.x
		DiaryBtn.y = MapBtn.y + 60

		ShareBtn = widget.newButton(
    	{
	        width = 400/2.5,
	        height = 108/2.5,
	        defaultFile = "Phuket/Button/Button/share.png",
	        overFile = "Phuket/Button/ButtonPress/share.png",
	        id = "ShareBtn",
	        onEvent = Check
    	}
			)
		ShareBtn.x = DiaryBtn.x
		ShareBtn.y = DiaryBtn.y + 60

		

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
		--BackBtn.x = (cx + 170) - 400
		--BackBtn.y = cy + 110
		BackBtn.x = cx - 230
		BackBtn.y = cy - 110

		local sqlUnlock = "SELECT count(`att_no`) as Catt_no FROM `unattractions` WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"

		for row in db:nrows(sqlUnlock) do
			if (row.Catt_no == 0) then
				LocationBtn = widget.newButton(
			{
				left = cx - 250,
				top = cy - 70,
				--left = cx - 250,
				--top = cy + 80,
				width = 172/4,
				height = 177/4,
				defaultFile = "Phuket/Button/Button/scan.png",
	        	overFile = "Phuket/Button/ButtonPress/scan.png",
				onEvent = CheckLocation
					
			}
		)

			end
			
		
		end

		local sqlUnlock3 = "SELECT un_id FROM `unattractions` WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"
		IsUnlock = false
		for row in db:nrows(sqlUnlock3) do
			IsUnlock = true
		end

		local sqlUnlock4 = "SELECT diary_id FROM `diary` WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"
		IsDiary = false

		for row in db:nrows(sqlUnlock4) do
			IsDiary = true
		end
		if (myMap) then
			sceneGroup:insert(myMap)
		end
		sceneGroup:insert(Bg)
		sceneGroup:insert(InformationBtn)
		sceneGroup:insert(MapBtn)
		sceneGroup:insert(ShareBtn)
		sceneGroup:insert(DiaryBtn)
		sceneGroup:insert(BackBtn)

		if (LocationBtn) then
			sceneGroup:insert(LocationBtn)
		end

		sceneGroup:insert(HomeGroup)
		

	elseif (phase == "did") then
		print("Scene #HomePlace : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then

		if (myMap) then
			myMap:removeSelf( )
			myMap = nil
		end
		--[[
		RemoveAll(Bg)
		RemoveAll(InformationBtn)
		RemoveAll(MapBtn)
		RemoveAll(ShareBtn)
		RemoveAll(DiaryBtn)
		RemoveAll(BackBtn)

		if (LocationBtn) then
			RemoveAll(LocationBtn)
		end
]]
		print("Scene #HomePlace : hide (will)")
	elseif (phase == "did") then
		print("Scene #HomePlace : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #HomePlace : destroy")
	IsUnlock = false
	IsDiary = false
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Runtime:addEventListener( "key", onKeyEvent )

return scene