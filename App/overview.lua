local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
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

local myMap = native.newMapView( 20, 20, 1, 1 )

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
	
	if(obj == "watchalong") then
		
		local options = {params = {PlaceName = "Chalong Temple"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "bangpae") then
	
		local options = {params = {PlaceName = "BangPae"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "bigbuddha") then
		
		local options = {params = {PlaceName = "Big buddha"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "kata") then
		
		local options = {params = {PlaceName = "Kata Beach"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "karon") then
		
		local options = {params = {PlaceName = "Karon Beach"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "kamala") then
		
		local options = {params = {PlaceName = "Kamala Beach"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "patong") then
		
		local options = {params = {PlaceName = "Patong Beach"}}
		composer.gotoScene("HomePlace", options)

	elseif(obj == "profile") then
		
		local options = {params = {PlaceName = "Patong Beach"}}
		composer.gotoScene("profile")
	end
		
	local options = {
    effect = "fade",
    time = 500,
    isModal = true
	}

	--composer.gotoScene("menu", options)
	--composer.showOverlay( "menu", options )
	
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
	composer.gotoScene("overview", {effect = "fade", time = 500})
end

function scene:show(event
)	cx = display.contentCenterX
	cy = display.contentCenterY

	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		print("Scene #Overview : show (will)")
	--system.openURL( "https://www.google.com/maps/place/%E0%B8%A7%E0%B8%B1%E0%B8%94%E0%B9%84%E0%B8%8A%E0%B8%A2%E0%B8%98%E0%B8%B2%E0%B8%A3%E0%B8%B2%E0%B8%A3%E0%B8%B2%E0%B8%A1/@7.8426086,98.3334015,14.75z/data=!4m5!3m4!1s0x30502fbb832d2361:0x8f6bd319c24a4986!8m2!3d7.8467839!4d98.3369041" )
	
	YourLocation = display.newText( "YourLocation", cx + 200, cy + 150, "Cloud-Bold", 14 )

	island = display.newImageRect("Phuket/Overview/island2.png", 810, 377)
	island.x = island.width / 2
	island.y = island.height / 2

	ProfileImage = display.newImageRect( "Phuket/Profile/picpro.png", 387/7, 388/7 )
	ProfileImage.x = cx - 200
	ProfileImage.y = cy - 130
	ProfileImage.name = "profile"

	watchalong = display.newImageRect( "Phuket/Overview/watchalong.png", 334/3.5, 202/3.5 )
	watchalong.x = cx + 105
	watchalong.y = cy + 30
	watchalong.name = "watchalong"

	ChalongLabel = display.newImageRect( "Phuket/label/chalong.png", 734/7, 137/7 )
	ChalongLabel.x = watchalong.x 
	ChalongLabel.y = watchalong.y + 40
	ChalongLabel.name = "watchalong"

	--CloudWatChalong = display.newImageRect( "Phuket/Overview/cloud.png", 338/10, 135/10 )
	--CloudWatChalong.x = watchalong.x - 35
	--CloudWatChalong.y = watchalong.y - 10

	print(cx)
	print( cy )  
	bangpae = display.newImageRect( "Phuket/Overview/bangpae.png", 596/5.5, 531/5.5)
	bangpae.x = cx + 210
	bangpae.y = cy + 40
	bangpae.name = "bangpae"

	BangPaeLabel = display.newImageRect( "Phuket/label/bangpae.png", 899/7, 138/7)
	BangPaeLabel.x = bangpae.x
	BangPaeLabel.y = bangpae.y + 60
	BangPaeLabel.name = "bangpae"

	TribeBangpareImage = display.newImageRect( "Phuket/Overview/tribe.png", 302/7, 228/7)
	TribeBangpareImage.x = bangpae.x + 80
	TribeBangpareImage.y = bangpae.y + 30
	
	bigbuddha = display.newImageRect( "Phuket/Overview/bigbuddha.png", 365/3, 227/3 )
	bigbuddha.x = cx - 15
	bigbuddha.y = cy + 25
	bigbuddha.name = "bigbuddha"

	BigBuddhaLabel = display.newImageRect( "Phuket/label/bigbuddha.png", 533/6, 99/6 )
	BigBuddhaLabel.x = cx - 10
	BigBuddhaLabel.y = cy + 50
	BigBuddhaLabel.name = "bigbuddha"

	CloudBigBudda = display.newImageRect( "Phuket/Overview/cloud.png", 338/10, 135/10 )
	CloudBigBudda.x = bigbuddha.x 
	CloudBigBudda.y = bigbuddha.y 

	kata = display.newImageRect( "Phuket/Overview/kata.png", 466/5, 214/5 )
	kata.x = cx - 180
	kata.y = cy + 10
	kata.name = "kata"

	KataLabel = display.newImageRect( "Phuket/label/kata.png", 515/7, 135/7 )
	KataLabel.x = kata.x + 10
	KataLabel.y = kata.y + 30
	KataLabel.name = "kata"

	cocoKataImage = display.newImageRect( "Phuket/Overview/coco.png", 340/9, 622/9 )
	cocoKataImage.x = kata.x - 25
	cocoKataImage.y = kata.y - 20
	cocoKataImage.rotation = -15

	kamala1 = display.newImageRect( "Phuket/Overview/kamala_1.png", 356/17, 236/17 )
	kamala1.x = cx + 190
	kamala1.y = cy - 115
	kamala1.name = "kamala"

	KamalaLabel = display.newImageRect( "Phuket/label/kamala.png", 638/9, 135/9 )
	KamalaLabel.x = kamala1.x
	KamalaLabel.y = kamala1.y + 20
	KamalaLabel.name = "kamala"

	kamala2 = display.newImageRect( "Phuket/Overview/kamala_2.png", 213/17, 89/17 )
	kamala2.x = kamala1.x - 20
	kamala2.y = kamala1.y 
	kamala2.name = "kamala"

	kamala3 = display.newImageRect( "Phuket/Overview/kamala_3.png", 111/10, 113/10 )
	kamala3.x = kamala2.x + 40
	kamala3.y = kamala2.y
	kamala3.name = "kamala"

	karon = display.newImageRect( "Phuket/Overview/karon.png", 472/7, 385/7 )
	karon.x = cx - 60
	karon.y = cy - 40
	karon.name = "karon"
	karon.xScale = -1
	cocoKataImage.rotation = -5

	KaronLabel = display.newImageRect( "Phuket/label/karon.png", 581/7, 135/7 )
	KaronLabel.x = karon.x - 5
	KaronLabel.y = karon.y + 35
	KaronLabel.name = "karon"

	patong = display.newImageRect( "Phuket/Overview/patong.png", 638/9, 258/9 )
	patong.x = cx + 30
	patong.y = cy - 80
	patong.name = "patong"

	PatongLabel = display.newImageRect( "Phuket/label/patong.png", 613/8, 135/8 )
	PatongLabel.x = patong.x - 10
	PatongLabel.y = patong.y + 30
	PatongLabel.name = "patong"

	cocokaronImage = display.newImageRect( "Phuket/Overview/coco.png", 340/9, 622/9 )
	cocokaronImage.x = karon.x + 5
	cocokaronImage.y = karon.y - 20

	ChairPatong = display.newImageRect( "Phuket/Overview/chair.png", 323/13, 548/13 )
	ChairPatong.x = cx + 75
	ChairPatong.y = cy - 60
	ChairPatong.xScale = -1

	TreeImage = display.newImageRect( "Phuket/Overview/tree.png", 291/5, 161/5 )
	TreeImage.x = cx  + 100
	TreeImage.y = cy - 120

	CloudTree = display.newImageRect( "Phuket/Overview/cloud.png", 338/7, 135/7 )
	CloudTree.x = TreeImage.x - 20
	CloudTree.y = TreeImage.y + 20

	LagoonImage = display.newImageRect( "Phuket/Overview/lagoon.png", 1116/13, 763/13 )
	LagoonImage.x = cx + 245
	LagoonImage.y = cy - 70

	cocoLagoonImage = display.newImageRect( "Phuket/Overview/coco.png", 340/10, 622/10 )
	cocoLagoonImage.x = LagoonImage.x + 35
	cocoLagoonImage.y = LagoonImage.y - 60

	CloudRight = display.newImageRect( "Phuket/Overview/cloud.png", 338/2, 135/2 )
	CloudRight.x = cx + 365
	CloudRight.y = cy + 50

	CloudCenter = display.newImageRect( "Phuket/Overview/cloud.png", 338/3, 135/3 )
	CloudCenter.x = cx + 200
	CloudCenter.y = cy

	CloudCenterRight = display.newImageRect( "Phuket/Overview/cloud.png", 338/4, 135/4 )
	CloudCenterRight.x = cx + 350
	CloudCenterRight.y = cy - 30

	--object.xScale = -1  to flip right,left or
	--object.yScale = -1 to flip up,down
--[[
	local button2 = widget.newButton
	{
	defaultFile = "buttonOrange.png",
	overFile = "buttonOrangeOver.png",
	label = "Current Location",
	emboss = true,
	onRelease = button2Release,
	}
]]

	LocationBtn = widget.newButton(
		{
	left = cx + 200,
	top = 105,
	width = 150,
	height = 40,
	label = "Current Location",
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
	PlaceGroup:insert(ChairPatong)
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

	TextGroup = display.newGroup()
	----------------------------------- Group Text -----------------------------------------

	TextGroup:insert(YourLocation)

	----------------------------------- scrollView -----------------------------------------
	scrollView:insert(PlaceGroup)
	scrollView:insert(ButtonGroup)
	scrollView:insert(TextGroup)

	scrollView:scrollToPosition{
	x = -(island.width / 2) + (screenW / 2),
	y = -((island.height / 2) - (screenH/ 2)),
	time = 500
	}
		
	elseif (phase == "did") then
		print("Scene Overview : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then

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
	PlaceGroup:remove(ChairPatong)
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
	RemoveAll(ChairPatong)
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


	scrollView:remove(PlaceGroup)
	scrollView:remove(ButtonGroup)
	scrollView:remove(TextGroup)
		ButtonGroup = nil
		PlaceGroup = nil
		TextGroup = nil
		scrollView = nil

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