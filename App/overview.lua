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
	cw = display.contentWidth
    ch = display.contentHeight

print( display.pixelWidth  )
print( display.pixelHeight  )
print(display.contentWidth)
print(display.contentHeight)
print(display.actualContentWidth)
print(display.actualContentHeight)
print( display.imageSuffix )
print( display.pixelWidth / display.actualContentWidth )
print( display.pixelHeight / display.actualContentHeight )

	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		print("Scene #Overview : show (will)")
	--system.openURL( "https://www.google.com/maps/place/%E0%B8%A7%E0%B8%B1%E0%B8%94%E0%B9%84%E0%B8%8A%E0%B8%A2%E0%B8%98%E0%B8%B2%E0%B8%A3%E0%B8%B2%E0%B8%A3%E0%B8%B2%E0%B8%A1/@7.8426086,98.3334015,14.75z/data=!4m5!3m4!1s0x30502fbb832d2361:0x8f6bd319c24a4986!8m2!3d7.8467839!4d98.3369041" )
	
	YourLocation = display.newText( "YourLocation", cx + 100, cy + 120, "Cloud-Bold", 14 )

	island = display.newImageRect("Phuket/Overview/island.png", cw, ch)
	island.x = cx
	island.y = cy

	ProfileImage = display.newImageRect( "Phuket/Profile/picpro.png", 387/7, 388/7 )
	ProfileImage.x = cx - 200
	ProfileImage.y = cy - 130
	ProfileImage.name = "profile"

	watchalong = display.newImageRect( "Phuket/Overview/watchalong.png", 334/5, 202/5 )
	watchalong.x = island.x - 10
	watchalong.y = island.y
	watchalong.name = "watchalong"

	ChalongLabel = display.newImageRect( "Phuket/label/chalong.png", 734/8, 137/8 )
	ChalongLabel.x = watchalong.x 
	ChalongLabel.y = watchalong.y + 30
	ChalongLabel.name = "watchalong"

	--CloudWatChalong = display.newImageRect( "Phuket/Overview/cloud.png", 338/10, 135/10 )
	--CloudWatChalong.x = watchalong.x - 35
	--CloudWatChalong.y = watchalong.y - 10

	print(cx)
	print( cy )  
	bangpae = display.newImageRect( "Phuket/Overview/bangpae.png", 596/6, 531/6)
	bangpae.x = island.x + 80
	bangpae.y = island.y + 10
	bangpae.name = "bangpae"

	BangPaeLabel = display.newImageRect( "Phuket/label/bangpae.png", 588/5, 83/5)
	BangPaeLabel.x = bangpae.x
	BangPaeLabel.y = bangpae.y + 55
	BangPaeLabel.name = "bangpae"

	TribeBangpareImage = display.newImageRect( "Phuket/Overview/tribe.png", 302/8, 228/8)
	TribeBangpareImage.x = bangpae.x + 50
	TribeBangpareImage.y = bangpae.y + 30
	
	bigbuddha = display.newImageRect( "Phuket/Overview/bigbuddha.png", 365/4, 227/4 )
	bigbuddha.x = island.x - 120
	bigbuddha.y = island.y + 10
	bigbuddha.name = "bigbuddha"

	BigBuddhaLabel = display.newImageRect( "Phuket/label/bigbuddha.png", 393/5, 82/5 )
	BigBuddhaLabel.x = bigbuddha.x 
	BigBuddhaLabel.y = bigbuddha.y + 30
	BigBuddhaLabel.name = "bigbuddha"

	CloudBigBudda = display.newImageRect( "Phuket/Overview/cloud.png", 338/12, 135/12 )
	CloudBigBudda.x = bigbuddha.x - 20
	CloudBigBudda.y = bigbuddha.y - 10

	kata = display.newImageRect( "Phuket/Overview/kata.png", 466/7, 214/7 )
	kata.x = island.x - 220
	kata.y = island.y - 10
	kata.name = "kata"

	KataLabel = display.newImageRect( "Phuket/label/kata.png", 393/5, 82/5 )
	KataLabel.x = kata.x 
	KataLabel.y = kata.y + 20
	KataLabel.name = "kata"

	cocoKataImage = display.newImageRect( "Phuket/Overview/coco.png", 340/9, 622/9 )
	cocoKataImage.x = kata.x - 25
	cocoKataImage.y = kata.y - 20
	cocoKataImage.rotation = -15

	kamala1 = display.newImageRect( "Phuket/Overview/kamala_1.png", 356/17, 236/17 )
	kamala1.x = island.x + 40
	kamala1.y = island.y - 130
	kamala1.name = "kamala"

	KamalaLabel = display.newImageRect( "Phuket/label/kamala.png", 414/6, 82/6 )
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

	karon = display.newImageRect( "Phuket/Overview/karon.png", 472/9, 385/9 )
	karon.x = island.x - 110
	karon.y = island.y - 50
	karon.name = "karon"
	karon.xScale = -1
	cocoKataImage.rotation = -5

	KaronLabel = display.newImageRect( "Phuket/label/karon.png", 393/5.5, 82/5.5 )
	KaronLabel.x = karon.x 
	KaronLabel.y = karon.y + 20
	KaronLabel.name = "karon"

	patong = display.newImageRect( "Phuket/Overview/patong.png", 638/10, 258/10 )
	patong.x = island.x - 50
	patong.y = island.y - 80
	patong.name = "patong"

	PatongLabel = display.newImageRect( "Phuket/label/patong.png", 418/5.5, 86/5.5 )
	PatongLabel.x = patong.x + 10
	PatongLabel.y = patong.y + 30
	PatongLabel.name = "patong"

	cocokaronImage = display.newImageRect( "Phuket/Overview/coco.png", 340/9, 622/9 )
	cocokaronImage.x = karon.x + 5
	cocokaronImage.y = karon.y - 20

	ChairPatong = display.newImageRect( "Phuket/Overview/chair.png", 323/13, 548/13 )
	ChairPatong.x = island.x - 75
	ChairPatong.y = island.y - 60
	ChairPatong.xScale = -1

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
	left = cx + 150,
	top = 55,
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