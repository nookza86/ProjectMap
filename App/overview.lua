local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local scrollView, island
local screenW, screenH
local PlaceGroup, ButtonGroup, TextGroup
local cx, cy
local currentLocation, currentLatitude, currentLongitude,YourLocation
local watchalong, bangpae, bigbuddha, kata, karon, kamala1, kamala2, kamala3, patong
local cocoKataImage, cocokaronImage
local ChairPatong, TreeImage, LagoonImage, cocoLagoonImage, TribeBangpareImage
local CloudBigBudda, CloudTree, CloudWatChalong, CloudRight, CloudCenter, CloudCenterRight
local ProfileImage
local BangPaeLabel, BigBuddhaLabel, ChalongLabel, KamalaLabel, KaronLabel, KataLabel, PatongLabel
local RecButton, RecBg, CloseBtn, backgroundALpha
local CheckInList, IsClick
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local myMap = native.newMapView( 20, 20, 1, 1 )

-------- ----
local filename = system.pathForFile( "Rule.json", system.ResourceDirectory )
local decoded, pos, msg = json.decodeFile( filename )
local RuleOtherNo = 0
local RuleOtherAttractionNo = 0
local nationality = "Other"
local CountRec = 0

local RecNational = {}
--------------

local function RemoveAll( event )
	if(event) then
		print( "deletePic "  )
		event:removeSelf( )
		event = nil
		
	end
end

local function check( event )
	local obj = event.target.name

	print( obj )
	
	if(obj == "Chalong Temple") then
		
		local options = {params = {PlaceName = "Chalong Temple"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "Bang Pae Waterfall") then
	
		local options = {params = {PlaceName = "Bang Pae Waterfall"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "Big Buddha") then
		
		local options = {params = {PlaceName = "Big Buddha"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "Kata Beach") then
		
		local options = {params = {PlaceName = "Kata Beach"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "Karon Beach") then
		
		local options = {params = {PlaceName = "Karon Beach"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "Kamala Beach") then
		
		local options = {params = {PlaceName = "Kamala Beach"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "Patong Beach") then
		
		local options = {params = {PlaceName = "Patong Beach"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "profile") then
		
		local options = {params = {PlaceName = "Patong Beach"}}
		composer.gotoScene("profile")

	elseif(obj == "CloseBtn") then
		IsClick = false
		RemoveAll(RecBg)
		RemoveAll(CloseBtn)
		RemoveAll(backgroundALpha)
		for i=1, CountRec do
			print( CountRec )
			RecNational[i]:removeSelf( )
			RecNational[i] = nil
		end
		

	end
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
		myMap:setRegion( currentLatitude, currentLongitude, 0.01, 0.01, true )
		
		-- Look up nearest address to this location (this is returned as a "mapAddress" event, handled above)
		myMap:nearestAddress( currentLatitude, currentLongitude, mapAddressHandler )
	end
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Overview : create")
end

local function Check( event )
	--composer.gotoScene("overview", {effect = "fade", time = 500})
	IsClick = true
	if (event.phase == "ended") then
		backgroundALpha = display.newRect(0,0,570,360)
		backgroundALpha.x = display.contentWidth / 2
		backgroundALpha.y = display.contentHeight / 2
		backgroundALpha:setFillColor( black )
		backgroundALpha.alpha = 0.5

		RecBg = display.newImageRect( "Phuket/Overview/rec.png", 1152 / 3, 787/ 3 )
		RecBg.x = display.contentCenterX
		RecBg.y = display.contentCenterY

		CloseBtn = widget.newButton(
    	{
	        width = 50,
	        height = 25,
	        defaultFile = "Phuket/Button/Button/ok.png",
	        overFile = "Phuket/Button/ButtonPress/ok.png",
	        id = "CloseBtn",
	        onEvent = check
    	}
			)
		CloseBtn.name = "CloseBtn"
		CloseBtn.x = RecBg.x 
		CloseBtn.y = RecBg.y + 100

		local PositionX = 0
		local PositionY = 0

		if (CountRec > 3) then
			 PositionX = display.contentCenterX - 100
			 PositionY = display.contentCenterY - 40
		else
			 PositionX = display.contentCenterX 
			 PositionY = display.contentCenterY - 40
		end

		for idx, val in ipairs(decoded["rule"][RuleOtherNo]["recommend"]) do
			
			print( idx, val )

			RecNational[idx] = widget.newButton(
	    	{
		       -- width = 300/2.5,
		       -- height = 60/2.5,
		        defaultFile = "Phuket/Button/RButton/".. val ..".png",
		        overFile = "Phuket/Button/RButtonPress/".. val ..".png",
		        id = val,
		        onEvent = check
	    	}
				)
			
			RecNational[idx].name = val 
			RecNational[idx].x = PositionX 
			RecNational[idx].y = PositionY 
			RecNational[idx]:scale(0.5,0.5)
			PositionY = PositionY + 50

			if (idx == 3) then
				PositionX = cx + 80
				PositionY = display.contentCenterY - 40
				print( "if > 3" )
			end

		end

	end
end

local function RecommendPlace(  )
		IsClick = false
		CheckInList = false
		local sql = "SELECT country FROM personel;"
		for row in db:nrows(sql) do
			nationality = row.country
		end
		nationality = "Australia"
		--nationality = "Canada"
		print( nationality )
		if not decoded then
		    print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
		else
		    print( "File successfully decoded!" )
--------------------check where is number of rule ------------------------------
		    for idx, val in ipairs(decoded.rule) do
		    	if (nationality == val.nationality) then
		    		CheckInList = true
		    		RuleOtherNo = val.no
		    		print( "Rule No. " .. RuleOtherNo )
		    		print( "Rule nationality is " .. val.nationality)
		    		print( "-------------------------------------------------" )
		    		break
		    	else
		    		RuleOtherNo = 5
		    		CheckInList = false
		    	end-- if nation
			end--for 1
----------------------------------check list------------------
	if (CheckInList) then
		RecButton = widget.newButton(
    	{
	        width = 295 / 4,
	        height = 211 / 4,
	        defaultFile = "Phuket/Overview/buttonrec.png",
	        overFile = "Phuket/Overview/buttonrec.png",
	        id = "RecButton",
	        onEvent = Check
    	}
			)
		
		RecButton.x = cx + 230
		RecButton.y = cy - 120
		for idx, val in ipairs(decoded["rule"][RuleOtherNo]["recommend"]) do
			CountRec = CountRec + 1
		end
		print( "CountRec " .. CountRec  )
		

	else
		print( "Not in list" )

	end

	end -- decode
	
end

function scene:show(event)	
	cx = display.contentCenterX
	cy = display.contentCenterY
	cw = display.contentWidth
    ch = display.contentHeight
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
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		print("Scene #Overview : show (will)")
		
	YourLocation = display.newText( "YourLocation", cx + 100, cy + 120, "Cloud-Bold", 14 )

	island = display.newImageRect("Phuket/Overview/island.png", cw, ch)
	island.x = cx
	island.y = cy

	ProfileImage = display.newImageRect( "Phuket/Overview/profilebut.png", 424/10, 430/10 )
	ProfileImage.x = cx - 250
	ProfileImage.y = cy - 130
	ProfileImage.name = "profile"

	watchalong = display.newImageRect( "Phuket/Overview/watchalong.png", 334/5, 202/5 )
	watchalong.x = island.x - 10
	watchalong.y = island.y
	watchalong.name = "Chalong Temple"

	ChalongLabel = display.newImageRect( "Phuket/label/chalong.png", 734/8, 137/8 )
	ChalongLabel.x = watchalong.x 
	ChalongLabel.y = watchalong.y + 30
	ChalongLabel.name = "Chalong Temple"

	--CloudWatChalong = display.newImageRect( "Phuket/Overview/cloud.png", 338/10, 135/10 )
	--CloudWatChalong.x = watchalong.x - 35
	--CloudWatChalong.y = watchalong.y - 10

	bangpae = display.newImageRect( "Phuket/Overview/bangpae.png", 596/6, 531/6)
	bangpae.x = island.x + 80
	bangpae.y = island.y + 10
	bangpae.name = "Bang Pae Waterfall"

	BangPaeLabel = display.newImageRect( "Phuket/label/bangpae.png", 588/5, 83/5)
	BangPaeLabel.x = bangpae.x
	BangPaeLabel.y = bangpae.y + 55
	BangPaeLabel.name = "Bang Pae Waterfall"

	TribeBangpareImage = display.newImageRect( "Phuket/Overview/tribe.png", 302/8, 228/8)
	TribeBangpareImage.x = bangpae.x + 50
	TribeBangpareImage.y = bangpae.y + 30
	
	bigbuddha = display.newImageRect( "Phuket/Overview/bigbuddha.png", 365/4, 227/4 )
	bigbuddha.x = island.x - 120
	bigbuddha.y = island.y + 10
	bigbuddha.name = "Big Buddha"

	BigBuddhaLabel = display.newImageRect( "Phuket/label/bigbuddha.png", 393/5, 82/5 )
	BigBuddhaLabel.x = bigbuddha.x 
	BigBuddhaLabel.y = bigbuddha.y + 30
	BigBuddhaLabel.name = "Big Buddha"

	CloudBigBudda = display.newImageRect( "Phuket/Overview/cloud.png", 338/12, 135/12 )
	CloudBigBudda.x = bigbuddha.x - 20
	CloudBigBudda.y = bigbuddha.y - 10

	kata = display.newImageRect( "Phuket/Overview/kata.png", 466/7, 214/7 )
	kata.x = island.x - 220
	kata.y = island.y - 10
	kata.name = "Kata Beach"

	KataLabel = display.newImageRect( "Phuket/label/kata.png", 393/5, 82/5 )
	KataLabel.x = kata.x 
	KataLabel.y = kata.y + 20
	KataLabel.name = "Kata Beach"

	cocoKataImage = display.newImageRect( "Phuket/Overview/coco.png", 340/9, 622/9 )
	cocoKataImage.x = kata.x - 15
	cocoKataImage.y = kata.y - 20
	cocoKataImage.rotation = -15

	kamala1 = display.newImageRect( "Phuket/Overview/kamala_1.png", 356/17, 236/17 )
	kamala1.x = island.x + 40
	kamala1.y = island.y - 130
	kamala1.name = "Kamala Beach"

	KamalaLabel = display.newImageRect( "Phuket/label/kamala.png", 414/6, 82/6 )
	KamalaLabel.x = kamala1.x
	KamalaLabel.y = kamala1.y + 20
	KamalaLabel.name = "Kamala Beach"

	kamala2 = display.newImageRect( "Phuket/Overview/kamala_2.png", 213/17, 89/17 )
	kamala2.x = kamala1.x - 20
	kamala2.y = kamala1.y 
	kamala2.name = "Kamala Beach"

	kamala3 = display.newImageRect( "Phuket/Overview/kamala_3.png", 111/10, 113/10 )
	kamala3.x = kamala2.x + 40
	kamala3.y = kamala2.y
	kamala3.name = "Kamala Beach"

	karon = display.newImageRect( "Phuket/Overview/karon.png", 472/9, 385/9 )
	karon.x = island.x - 110
	karon.y = island.y - 50
	karon.name = "Karon Beach"
	karon.xScale = -1
	cocoKataImage.rotation = -5

	KaronLabel = display.newImageRect( "Phuket/label/karon.png", 393/5.5, 82/5.5 )
	KaronLabel.x = karon.x 
	KaronLabel.y = karon.y + 20
	KaronLabel.name = "Karon Beach"

	patong = display.newImageRect( "Phuket/Overview/patong.png", 638/10, 258/10 )
	patong.x = island.x - 50
	patong.y = island.y - 80
	patong.name = "Patong Beach"

	PatongLabel = display.newImageRect( "Phuket/label/patong.png", 418/5.5, 86/5.5 )
	PatongLabel.x = patong.x + 10
	PatongLabel.y = patong.y + 30
	PatongLabel.name = "Patong Beach"

	cocokaronImage = display.newImageRect( "Phuket/Overview/coco.png", 340/9, 622/9 )
	cocokaronImage.x = karon.x + 5
	cocokaronImage.y = karon.y - 20
--[[
	ChairPatong = display.newImageRect( "Phuket/Overview/chair.png", 323/13, 548/13 )
	ChairPatong.x = island.x - 75
	ChairPatong.y = island.y - 60
	ChairPatong.xScale = -1
]]
	TreeImage = display.newImageRect( "Phuket/Overview/tree.png", 291/6, 161/6 )
	TreeImage.x = island.x - 20
	TreeImage.y = island.y - 120

	CloudTree = display.newImageRect( "Phuket/Overview/cloud.png", 338/8, 135/8 )
	CloudTree.x = TreeImage.x - 20
	CloudTree.y = TreeImage.y + 10

	LagoonImage = display.newImageRect( "Phuket/Overview/lagoon.png", 1116/14, 763/14 )
	LagoonImage.x = island.x + 80
	LagoonImage.y = island.y - 70

	cocoLagoonImage = display.newImageRect( "Phuket/Overview/coco.png", 340/10, 622/10 )
	cocoLagoonImage.x = LagoonImage.x + 35
	cocoLagoonImage.y = LagoonImage.y - 60

	CloudRight = display.newImageRect( "Phuket/Overview/cloud.png", 338/3, 135/3 )
	CloudRight.x = island.x + 200
	CloudRight.y = island.y + 10

	CloudCenter = display.newImageRect( "Phuket/Overview/cloud.png", 338/4, 135/4 )
	CloudCenter.x = island.x + 50
	CloudCenter.y = island.y - 30

	CloudCenterRight = display.newImageRect( "Phuket/Overview/cloud.png", 338/5, 135/6 )
	CloudCenterRight.x = island.x + 150
	CloudCenterRight.y = island.y - 50

	--object.xScale = -1  to flip right,left or
	--object.yScale = -1 to flip up,down
	RecommendPlace(  )

	LocationBtn = widget.newButton(
		{
	left = cx + 150,
	top = 100,
	width = 100,
	height = 40,
	label = "Location",
	onEvent = CheckLocation,
	shape = "Rect",
	labelColor = {default={1,1,1}, over={0,0,0,0.5}},
	fillColor = {default={0.4,0.4,0.4}, over={0.8,0.8,0.8}},	
		}
	)
	--[[watchalong:addEventListener( "touch", check )
	bangpae:addEventListener( "touch", check )
	bigbuddha:addEventListener( "touch", check )
	kata:addEventListener( "touch", check )
	karon:addEventListener( "touch", check )
	ProfileImage:addEventListener( "touch", check )
	patong:addEventListener( "touch", check )
	kamala1:addEventListener( "touch", check )
	kamala2:addEventListener( "touch", check )
	kamala3:addEventListener( "touch", check )
]]
	ChalongLabel:addEventListener( "touch", check )
	BangPaeLabel:addEventListener( "touch", check )
	BigBuddhaLabel:addEventListener( "touch", check )
	KataLabel:addEventListener( "touch", check )
	KaronLabel:addEventListener( "touch", check )
	ProfileImage:addEventListener( "touch", check )
	PatongLabel:addEventListener( "touch", check )
	KamalaLabel:addEventListener( "touch", check )
	

	screenW = display.contentWidth
	screenH = display.contentHeight
--[[
	scrollView = widget.newScrollView(
	{
		top = 0,
		left = 0,
		width = screenW,
		height = screenH,
		scrollWidth = island.width,
		scrollHeight = island.height,
		hideBackground = true,
		hideScrollBar = true,
		isBounceEnabled = false,
		--verticalScrollDisabled = true
		}
	)
]]
	PlaceGroup = display.newGroup()
	---------------------------------- Group Place -----------------------------------------
	PlaceGroup:insert(island)
	PlaceGroup:insert(watchalong)
	PlaceGroup:insert(ChalongLabel)
	PlaceGroup:insert(bangpae)
	PlaceGroup:insert(BangPaeLabel)
	PlaceGroup:insert(TribeBangpareImage)
	PlaceGroup:insert(bigbuddha)
	PlaceGroup:insert(BigBuddhaLabel)
	PlaceGroup:insert(CloudBigBudda)
	PlaceGroup:insert(kata)
	PlaceGroup:insert(KataLabel)
	PlaceGroup:insert(cocokaronImage)
	PlaceGroup:insert(karon)
	PlaceGroup:insert(KaronLabel)
	PlaceGroup:insert(cocoKataImage)
	--PlaceGroup:insert(ChairPatong)
	PlaceGroup:insert(patong)
	PlaceGroup:insert(PatongLabel)
	PlaceGroup:insert(kamala1)
	PlaceGroup:insert(kamala2)
	PlaceGroup:insert(kamala3)
	PlaceGroup:insert(KamalaLabel)
	PlaceGroup:insert(KataLabel)
	PlaceGroup:insert(TreeImage)
	PlaceGroup:insert(CloudTree)
	PlaceGroup:insert(LagoonImage)
	PlaceGroup:insert(cocoLagoonImage)
	PlaceGroup:insert(CloudRight)
	PlaceGroup:insert(CloudCenter)
	PlaceGroup:insert(CloudCenterRight)
	PlaceGroup:insert(ProfileImage)

	ButtonGroup = display.newGroup()
	----------------------------------- Group Button -----------------------------------------
	ButtonGroup:insert(LocationBtn)
	if (CheckInList) then
		ButtonGroup:insert(RecButton)
	end
		
	
	

	TextGroup = display.newGroup()
	----------------------------------- Group Text -----------------------------------------

	TextGroup:insert(YourLocation)

	----------------------------------- scrollView -----------------------------------------
	--scrollView:insert(PlaceGroup)
	--scrollView:insert(ButtonGroup)
	--scrollView:insert(TextGroup)

	--scrollView:scrollToPosition{
	--x = -(island.width / 2) + (screenW / 2),
	--y = -((island.height / 2) - (screenH/ 2)),
	--time = 500
	--}
		
	elseif (phase == "did") then
		print("Scene Overview : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
composer.removeScene( "overview" )
	PlaceGroup:remove(island)
	PlaceGroup:remove(watchalong)
	PlaceGroup:remove(ChalongLabel)
	PlaceGroup:remove(bangpae)
	PlaceGroup:remove(BangPaeLabel)
	PlaceGroup:remove(TribeBangpareImage)
	PlaceGroup:remove(bigbuddha)
	PlaceGroup:remove(BigBuddhaLabel)
	PlaceGroup:remove(CloudBigBudda)
	PlaceGroup:remove(kata)
	PlaceGroup:remove(KataLabel)
	PlaceGroup:remove(cocokaronImage)
	PlaceGroup:remove(karon)
	PlaceGroup:remove(KaronLabel)
	PlaceGroup:remove(cocoKataImage)
	--PlaceGroup:remove(ChairPatong)
	PlaceGroup:remove(patong)
	PlaceGroup:remove(PatongLabel)
	PlaceGroup:remove(TreeImage)
	PlaceGroup:remove(CloudTree)
	PlaceGroup:remove(LagoonImage)
	PlaceGroup:remove(cocoLagoonImage)
	PlaceGroup:remove(CloudRight)
	PlaceGroup:remove(CloudCenter)
	PlaceGroup:remove(CloudCenterRight)
	PlaceGroup:remove(ProfileImage)
	PlaceGroup:remove(kamala1)
	PlaceGroup:remove(kamala2)
	PlaceGroup:remove(kamala3)
	PlaceGroup:remove(KamalaLabel)

	ButtonGroup:remove(LocationBtn)

	if (CheckInList) then
		ButtonGroup:remove(RecButton)
		if (IsClick) then
		RemoveAll(RecButton)
		RemoveAll(RecBg)
		RemoveAll(CloseBtn)
		RemoveAll(backgroundALpha)
	end
		for i=1, CountRec do
			if (IsClick) then
				RecNational[i]:removeSelf( )
				RecNational[i] = nil
			end
			
		end
	end

	

	TextGroup:remove(YourLocation)

	RemoveAll(island)
	RemoveAll(watchalong)
	RemoveAll(bangpae)
	RemoveAll(TribeBangpareImage)
	RemoveAll(bigbuddha)
	RemoveAll(CloudBigBudda)
	RemoveAll(kata)
	RemoveAll(cocokaronImage)
	RemoveAll(karon)
	RemoveAll(cocoKataImage)
	--RemoveAll(ChairPatong)
	RemoveAll(TreeImage)
	RemoveAll(CloudTree)
	RemoveAll(LagoonImage)
	RemoveAll(cocoLagoonImage)
	RemoveAll(CloudRight)
	RemoveAll(CloudCenter)
	RemoveAll(CloudCenterRight)
	RemoveAll(LocationBtn)
	RemoveAll(YourLocation)
	RemoveAll(ProfileImage)
	RemoveAll(kamala1)
	RemoveAll(kamala2)
	RemoveAll(kamala3)
	RemoveAll(patong)
	RemoveAll(ChalongLabel)
	RemoveAll(BigBuddhaLabel)
	RemoveAll(KataLabel)
	RemoveAll(KaronLabel)
	RemoveAll(KamalaLabel)
	RemoveAll(BangPaeLabel)
	RemoveAll(PatongLabel)


	--scrollView:remove(PlaceGroup)
	--scrollView:remove(ButtonGroup)
	--scrollView:remove(TextGroup)
	--	ButtonGroup = nil
	--	PlaceGroup = nil
	--	TextGroup = nil
	--	scrollView = nil

		print("Scene #Overview : hide (will)")
	elseif (phase == "did") then
		print("Scene #Overview : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #Overview : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene