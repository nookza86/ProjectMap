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
local myMap = native.newMapView( 20, 20, 1, 1 )
local params, cx, cy, cw, ch
local Bg, BgBtn, BackBtn, TitleImage
local InformationBtn, MapBtn, ShareBtn, DiaryBtn
local IsUnlock = false
local IsDiary = false

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

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #HomePlace : create")
end

local function Check( event )
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
				native.showAlert( "Not Diary","Add some diary and some photo", { "OK" } )
				return
			end

			

		elseif (event.target.id == "DiaryBtn") then
			if (IsUnlock) then
				print( "Go to scene #Diary " .. params.PlaceName )
				composer.gotoScene("Diary", options)
			else
				native.showAlert( "Not Unlock","Unlock Please", { "OK" } )
				return
			end
			

		elseif (event.target.id == "BackBtn") then
			composer.gotoScene("overview")
		end
	end
end

local function GoS(  )

	local options = {params = {PlaceName = params.PlaceName}}
			composer.gotoScene("HomePlace", options)
			native.setActivityIndicator( false )
end

local function CallDrop(  )
	DropTableData( 3 )
end

local function UnlockListener(  )
 
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

        local unattractionsSendData = json.encode( unattractions )
        print( "BBBBBBBBBBBBBBBBBBBBBBBB" .. unattractionsSendData )
        UnAttSend(unattractionsSendData)
		native.setActivityIndicator( true )
		timer.performWithDelay( 5000, CallDrop )
        timer.performWithDelay( 5000, GoS )         
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

		   	for idx, val in ipairs(decoded.rule[RuleNo]["information"]) do
				
				point1.latitude = val.latitude1
			    point1.longitude = val.longitude1
			    point2.latitude = val.latitude2
			    point2.longitude = val.longitude2
			    d = sphericalDistanceBetween( point1, point2 )
			    Userd = sphericalDistanceBetween( point1, user )

			    ---- Check distance User and Attraction -----
			    if(Userd <= d) then
			    	InArea = true
			    	UnlockListener(  )
			    	break
			    else
			    	InArea = false
			    end
			    text = "Rule No : " .. idx .. " Distance : " .. d .. " User distance : " .. Userd .. " In Area : " .. tostring(InArea)
			    native.showAlert( "You Are Here", text, { "OK" } )
			    print( "Rule No : " .. idx .. " Distance : " .. d .. " User distance : " .. Userd .. " In Area : " .. tostring(InArea))
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
 	UnlockListener(  )

 	if isRechable() == false then 
 		native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
 		return
	end

 	if myMap == nil then
		return
	end

    -- Fetch the user's current location
	-- Note: in Xcode Simulator, the current location defaults to Apple headquarters in Cupertino, CA
	currentLocation = myMap:getUserLocation()
	if currentLocation.errorCode then
		if currentLocation.errorCode ~= 0 then -- errorCode 0 is: Pending User Authorization!
			currentLatitude = 0
			currentLongitude = 0
			native.showAlert( "Error", currentLocation.errorMessage, { "OK" } )
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
		print( "User Click " .. params.PlaceName .. " From Overview" )

		
		Bg = display.newImageRect("Phuket/Home/".. params.PlaceName .. "/bg.png", cw, ch )
		Bg.x = display.contentCenterX 
		Bg.y = display.contentCenterY
		--Bg:scale( 0.3, 0.3 ) 

		TitleImage = display.newImage("Phuket/Attraction Name/".. params.PlaceName .. ".png", cx - 80, cy - 100 )
		
		if(params.PlaceName == "Bang Pae Waterfall") then
			TitleImage:scale( 0.4, 0.4 )
		elseif(params.PlaceName == "Kata Beach" or params.PlaceName == "Big buddha") then
			TitleImage:scale( 0.6, 0.6 )
		else
			TitleImage:scale( 0.5, 0.5 )
		end

		local sqlUnlock = "SELECT count(`att_no`) as Catt_no FROM `unattractions` WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"


		for row in db:nrows(sqlUnlock) do
			if (row.Catt_no == 0) then
				LocationBtn = widget.newButton(
			{
				left = cx - 120,
				top = cy,
				width = 100,
				height = 40,
				label = "Location",
				onEvent = CheckLocation,
				shape = "Rect",
				labelColor = {default={1,1,1}, over={0,0,0,0.5}},
				fillColor = {default={0.4,0.4,0.4}, over={0.8,0.8,0.8}},	
			}
		)
			end
			
		
		end

		local sqlUnlock3 = "SELECT un_id FROM `unattractions` WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"

		for row in db:nrows(sqlUnlock3) do
			IsUnlock = true
		end

		local sqlUnlock4 = "SELECT diary_id FROM `diary` WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"

		for row in db:nrows(sqlUnlock4) do
			IsDiary = true
		end

		InformationBtn = widget.newButton(
    	{
	        width = 250/1.5,
	        height = 60/1.5,
	        defaultFile = "Phuket/Button/Button/information.png",
	        overFile = "Phuket/Button/ButtonPress/information.png",
	        id = "InformationBtn",
	        onEvent = Check
    	}
			)
		InformationBtn.x = cx + 170 
		InformationBtn.y = cy - 90

		MapBtn = widget.newButton(
    	{
	        width = 250/1.5,
	        height = 60/1.5,
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
	        width = 250/1.5,
	        height = 60/1.5,
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
	        width = 250/1.5,
	        height = 60/1.5,
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
	        width = 43,
	        height = 43,
	        defaultFile = "Phuket/Button/Button/back.png",
	        overFile = "Phuket/Button/ButtonPress/back.png",
	        id = "BackBtn",
	        onEvent = Check
    	}
			)
		BackBtn.x = (cx + 170) - 400
		BackBtn.y = cy + 110
		

	elseif (phase == "did") then
		print("Scene #HomePlace : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(Bg)
		--RemoveAll(BgBtn)
		RemoveAll(InformationBtn)
		RemoveAll(MapBtn)
		RemoveAll(ShareBtn)
		RemoveAll(DiaryBtn)
		RemoveAll(BackBtn)
		RemoveAll(TitleImage)

		if (LocationBtn) then
			RemoveAll(LocationBtn)
		end

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