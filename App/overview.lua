local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local toast = require('plugin.toast')
require ("cal")
require ("Network-Check")
require ("image_proportion")
local island
local PlaceGroup, ButtonGroup
local cx, cy, cw, ch
local watchalong, bangpae, bigbuddha, kata, karon, kamala1, kamala2, kamala3, patong
local cocoKataImage, cocokaronImage
local TreeImage, LagoonImage, cocoLagoonImage, TribeBangpareImage
local CloudBigBudda, CloudTree, CloudWatChalong, CloudRight, CloudCenter, CloudCenterRight
local ProfileImage
local BangPaeLabel, BigBuddhaLabel, ChalongLabel, KamalaLabel, KaronLabel, KataLabel, PatongLabel
local RecButton, RecBg, CloseBtn, backgroundALpha
local Bird1, Bird2
local CheckInList, IsClick
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local DisableBTN, EnableBTN
local LOAD_IMG
local screen_w,screen_h
local image_w,image_h
local speed


local imageBangPaeSheet, imageBangPaeSprite
local BangPaesheetData, BangPaespriteData
------------------------------------------
local UnlockBangPaeLabel, UnlockBigBuddhaLabel, UnlockChalongLabel, UnlockKamalaLabel, UnlockKaronLabel, UnlockKataLabel, UnlockPatongLabel
local CheckUnlockBangPaeLabel, CheckUnlockBigBuddhaLabel, CheckUnlockChalongLabel, CheckUnlockKamalaLabel, CheckUnlockKaronLabel, CheckUnlockKataLabel, CheckUnlockPatongLabel

PlaceGroup = display.newGroup()
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
		--print( "deletePic "  )
		event:removeSelf( )
		event = nil
		
	end
end

local function showAlertListener( event )
	print( event.action )
	if (event.action == "clicked") then
		print( event.index )
		--native.showAlert( "Error", event.index, { "OK" } )
 	if (event.index == 1) then
 			os.exit( )
 		end
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
        	native.showAlert( "Do you want to exit?", "" ,{ "OK" , "Cancel"} , showAlertListener )
            --return true
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false
end



local function check( event )
	local obj = event.target.name
	print( obj )
	
	if (event.phase == "ended") then
		
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
			--RecButton:setEnabled( true )
			EnableBTN(  )
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
end


local function loadImageListener( event )
	if(not event.isError) then
		native.setActivityIndicator( true )
		print( event.response.filename, event.response.baseDirectory )
			--RemoveAll(UserImage)
			ProfileImage = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							cx - 250,
							cy - 130 
							)
			
			ProfileImage.name = "profile"
			ProfileImage:addEventListener( "touch", check )

        if ProfileImage.width > ProfileImage.height then
			--ProfileImage:rotate( -90 )			-- rotate for landscape
			print( "Rotated" )
		end
		
		-- Scale image to fit content scaled screen
		local xScale = cw / ProfileImage.contentWidth
		local yScale = ch / ProfileImage.contentHeight
		local scale = math.max( xScale, yScale ) * .75
		
		local maxWidth = 512
		local maxHeight = 512
		local ScaleProFile = 0
		
		--ProfileImage.x = cx
		--ProfileImage.y = cy + 100
		
		--rescale width
		if ( ProfileImage.width > maxWidth ) then
		   local ratio = maxWidth / ProfileImage.width
		   ProfileImage.width = maxWidth
		   ProfileImage.height = ProfileImage.height * ratio
		   ScaleProFile = scale 
		end
		 
		--rescale height
		if ( ProfileImage.height > maxHeight ) then
		   local ratio = maxHeight / ProfileImage.height
		   ProfileImage.height = maxHeight
		   ProfileImage.width = ProfileImage.width * ratio
		   ScaleProFile = scale / 1.7
		end
		--ProfileImage:scale( ScaleProFile, ScaleProFile )
		ProfileImage:scale( 0.2, 0.2 )
		 local mask = graphics.newMask( "cc.png" )
		 --local mask = graphics.newMask( "Phuket/Overview/profilebut.png" )
			 
			ProfileImage:setMask( mask )
			
			ProfileImage.maskX = 1
			--ProfileImage.maskY = 1
			--ProfileImage.maskRotation = 20
			ProfileImage.maskScaleX = 1
			ProfileImage.maskScaleY = 1.1

			print( ProfileImage.width, ProfileImage.height )

			ProfileFrame = display.newImageRect( "Phuket/Overview/profilebut.png", 190/3, 187/3 )
	ProfileFrame.x = ProfileImage.x 
	ProfileFrame.y = ProfileImage.y + 3
	ProfileFrame.name = "profile"
	PlaceGroup:insert(ProfileImage)
	PlaceGroup:insert(ProfileFrame)
	LOAD_IMG = true
	
	end
	native.setActivityIndicator( false )

end

local function LoadUserImg( no )
	local url = "http://mapofmem.esy.es/admin/api/android_upload_api/upload/profile/" .. no 
	print( url )
network.download( url , 
	"GET", 
	loadImageListener,
	{},
	no,
	system.DocumentsDirectory
	)

end


local function WaitForTran(  )
	CloseBtn = widget.newButton(
    	{
	        width = 130/2.5,
	        height = 101/2.5,
	        defaultFile = "Phuket/Button/Button/ok.png",
	        overFile = "Phuket/Button/ButtonPress/ok.png",
	        id = "CloseBtn",
	        onEvent = check
    	}
			)
		CloseBtn.name = "CloseBtn"
		CloseBtn.x = RecBg.x 
		CloseBtn.y = RecBg.y + 90
		CloseBtn.alpha = 0
       	transition.to( CloseBtn, { alpha=1.0 } )
       	PlaceGroup:insert(CloseBtn)

		local PositionX = 0
		local PositionY = 0

		if (CountRec > 3) then
			 PositionX = display.contentCenterX - 90
			 PositionY = display.contentCenterY - 60
		elseif (CountRec == 1) then
			 PositionX = display.contentCenterX 
			 PositionY = display.contentCenterY 
		else
			 PositionX = display.contentCenterX 
			 PositionY = display.contentCenterY - 60
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
			RecNational[idx]:scale(0.45,0.45)
			PositionY = PositionY + 50

			if (idx == 3) then
				PositionX = cx + 90
				PositionY = display.contentCenterY - 60
				print( "if > 3" )
			end
			PlaceGroup:insert(RecNational[idx])

		end	
end

local function Check( event )
	IsClick = true
	if (event.phase == "ended") then
	DisableBTN()
		backgroundALpha = display.newRect(0,0,cw,ch)
		backgroundALpha.x = display.contentWidth / 2
		backgroundALpha.y = display.contentHeight / 2
		backgroundALpha:setFillColor( black )
		backgroundALpha.alpha = 0.5

		RecBg = display.newImageRect( "Phuket/Overview/rec.png", cw, ch )
		RecBg.x = display.contentCenterX
		RecBg.y = -100
		PlaceGroup:insert(backgroundALpha)
		PlaceGroup:insert(RecBg)
		transition.moveTo( RecBg, {  y=display.contentCenterY, time=500} )

		timer.performWithDelay( 600, WaitForTran, 1 )
		

	end
end

local function RecommendPlace(  )
		IsClick = false
		CheckInList = false
		local sql = "SELECT country FROM personel;"
		for row in db:nrows(sql) do
			nationality = row.country
		end
		--nationality = "Australia"
		--nationality = "Canada"
		--nationality = "India"
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
	        width = 268 / 4,
	        height = 228 / 4,
	        defaultFile = "Phuket/Overview/Rec_button1.png",
	        overFile = "Phuket/Overview/Rec_button2.png",
	        id = "RecButton",
	        onEvent = Check
    	}
			)
		
		RecButton.x = cx + 230
		RecButton.y = cy + 110
		PlaceGroup:insert(RecButton)
		for idx, val in ipairs(decoded["rule"][RuleOtherNo]["recommend"]) do
			CountRec = CountRec + 1
		end
		print( "CountRec " .. CountRec  )
		

	else
		print( "Not in list" )

	end

	end -- decode
	
end

function EnableBTN(  )
	RecButton:setEnabled( true )
	ChalongLabel:addEventListener( "touch", check )
	BangPaeLabel:addEventListener( "touch", check )
	BigBuddhaLabel:addEventListener( "touch", check )
	KataLabel:addEventListener( "touch", check )
	KaronLabel:addEventListener( "touch", check )
	ProfileImage:addEventListener( "touch", check )
	PatongLabel:addEventListener( "touch", check )
	KamalaLabel:addEventListener( "touch", check )

	watchalong:addEventListener( "touch", check )
	bangpae:addEventListener( "touch", check )
	bigbuddha:addEventListener( "touch", check )
	kata:addEventListener( "touch", check )
	karon:addEventListener( "touch", check )
	patong:addEventListener( "touch", check )
	kamala1:addEventListener( "touch", check )
	--kamala2:addEventListener( "touch", check )
	--kamala3:addEventListener( "touch", check )
	
end

function DisableBTN(  )
	RecButton:setEnabled( false )
	ChalongLabel:removeEventListener( "touch", check )
	BangPaeLabel:removeEventListener( "touch", check )
	BigBuddhaLabel:removeEventListener( "touch", check )
	KataLabel:removeEventListener( "touch", check )
	KaronLabel:removeEventListener( "touch", check )
	ProfileImage:removeEventListener( "touch", check )
	PatongLabel:removeEventListener( "touch", check )
	KamalaLabel:removeEventListener( "touch", check )

	watchalong:removeEventListener( "touch", check )
	bangpae:removeEventListener( "touch", check )
	bigbuddha:removeEventListener( "touch", check )
	kata:removeEventListener( "touch", check )
	karon:removeEventListener( "touch", check )
	patong:removeEventListener( "touch", check )
	kamala1:removeEventListener( "touch", check )
	--kamala2:removeEventListener( "touch", check )
	--kamala3:removeEventListener( "touch", check )
	
end

local function listener( event )
    if (LOAD_IMG == true ) then
    	 timer.cancel( event.source )
    	 native.setActivityIndicator( false )
    	 print( "LOADING DONE" )
    	else
    		print( "LOADING IMG" )
    end
end

local function USERIMG_FINING( Filename )
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

local function scrollBackground(event)
	background1.x = background1.x - speed
	background2.x = background2.x - speed
	if(background1.x) < -609 then
		background1.x = 890
	end
	if(background2.x) < -609 then
		background2.x = 890
	end
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Overview : create")

end

function scene:show(event)	
	cx = display.contentCenterX
	cy = display.contentCenterY
	cw = display.contentWidth
    ch = display.contentHeight
    local Lock = 514/12
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
		local prevScene = composer.getSceneName( "previous" )

		if (prevScene ~= nil) then
			composer.removeScene( prevScene )
		end

		LOAD_IMG = false
		
		timer.performWithDelay( 1000, listener, 0 )

	island = display.newImageRect("Phuket/Overview/island.jpg", cw, ch)
	island.x = cx
	island.y = cy

	watchalong = display.newImageRect( "Phuket/Overview/press.png", 334/5, 202/5 )
	watchalong.x = island.x + 35
	watchalong.y = island.y - 5
	watchalong.name = "Chalong Temple"

	ChalongLabel = display.newImageRect( "Phuket/label/chalong.png", 734/8, 137/8 )
	ChalongLabel.x = watchalong.x 
	ChalongLabel.y = watchalong.y + 30
	ChalongLabel.name = "Chalong Temple"

	UnlockChalongLabel = display.newImageRect( "Phuket/Overview/lock.png", Lock, Lock)
	UnlockChalongLabel.x = watchalong.x
	UnlockChalongLabel.y = watchalong.y - 5

	bangpae = display.newImageRect( "Phuket/Overview/press.png", 596/6, 531/6)
	bangpae.x = island.x + 180
	bangpae.y = island.y - 15
	bangpae.name = "Bang Pae Waterfall"
--[[
		BangPaesheetData = {
	 	width = 277,
	 	height = 336,
	 	numFrames = 4
	}

	BangPaespriteData = {
		name = "BangPaeWater",
		start = 1,
		count = 2,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	}

	BangPaeSheet = graphics.newImageSheet("Phuket/Overview/water.png", BangPaesheetData)
	BangPaeSprite = display.newSprite(BangPaeSheet, BangPaespriteData)
	BangPaeSprite.x = bangpae.x + 20
	BangPaeSprite.y = bangpae.y + 30
	BangPaeSprite:scale( 0.2, 0.2 )
	BangPaeSprite:play()
]]
	BangPaeLabel = display.newImageRect( "Phuket/label/bangpae.png", 588/5, 83/5)
	BangPaeLabel.x = bangpae.x
	BangPaeLabel.y = bangpae.y + 55
	BangPaeLabel.name = "Bang Pae Waterfall"

	UnlockBangPaeLabel = display.newImageRect( "Phuket/Overview/lock.png", Lock, Lock)
	UnlockBangPaeLabel.x = bangpae.x
	UnlockBangPaeLabel.y = bangpae.y + 15

	bigbuddha = display.newImageRect( "Phuket/Overview/press.png", 365/4, 227/4 )
	bigbuddha.x = island.x - 40
	bigbuddha.y = island.y - 20
	bigbuddha.name = "Big Buddha"

	BigBuddhaLabel = display.newImageRect( "Phuket/label/bigbuddha.png", 393/5, 82/5 )
	BigBuddhaLabel.x = bigbuddha.x 
	BigBuddhaLabel.y = bigbuddha.y + 30
	BigBuddhaLabel.name = "Big Buddha"

	UnlockBigBuddhaLabel = display.newImageRect( "Phuket/Overview/lock.png", Lock, Lock)
	UnlockBigBuddhaLabel.x = bigbuddha.x
	UnlockBigBuddhaLabel.y = bigbuddha.y - 5

	kata = display.newImageRect( "Phuket/Overview/press.png", 466/7, 214/7 )
	kata.x = island.x - 180
	kata.y = island.y - 15
	kata.name = "Kata Beach"

	KataLabel = display.newImageRect( "Phuket/label/kata.png", 393/5, 82/5 )
	KataLabel.x = kata.x 
	KataLabel.y = kata.y + 20
	KataLabel.name = "Kata Beach"

	UnlockKataLabel = display.newImageRect( "Phuket/Overview/lock.png", Lock, Lock)
	UnlockKataLabel.x = kata.x
	UnlockKataLabel.y = kata.y - 15

	kamala1 = display.newImageRect( "Phuket/Overview/press.png", 356/17, 236/17 )
	kamala1.x = island.x + 50
	kamala1.y = island.y - 130
	kamala1.name = "Kamala Beach"

	KamalaLabel = display.newImageRect( "Phuket/label/kamala.png", 414/6, 82/6 )
	KamalaLabel.x = kamala1.x
	KamalaLabel.y = kamala1.y + 30
	KamalaLabel.name = "Kamala Beach"

	UnlockKamalaLabel = display.newImageRect( "Phuket/Overview/lock.png", Lock, Lock)
	UnlockKamalaLabel.x = kamala1.x
	UnlockKamalaLabel.y = kamala1.y - 5

	karon = display.newImageRect( "Phuket/Overview/press.png", 472/9, 385/9 )
	karon.x = island.x - 100
	karon.y = island.y - 40
	karon.name = "Karon Beach"
	karon.xScale = -1
	--cocoKataImage.rotation = -5

	KaronLabel = display.newImageRect( "Phuket/label/karon.png", 393/5.5, 82/5.5 )
	KaronLabel.x = karon.x 
	KaronLabel.y = karon.y + 20
	KaronLabel.name = "Karon Beach"

	UnlockKaronLabel = display.newImageRect( "Phuket/Overview/lock.png", Lock, Lock)
	UnlockKaronLabel.x = karon.x
	UnlockKaronLabel.y = karon.y - 15

	patong = display.newImageRect( "Phuket/Overview/press.png", 638/11, 258/11 )
	patong.x = island.x - 40
	patong.y = island.y - 80
	patong.name = "Patong Beach"

	PatongLabel = display.newImageRect( "Phuket/label/patong.png", 418/5.5, 86/5.5 )
	PatongLabel.x = patong.x + 10
	PatongLabel.y = patong.y + 27
	PatongLabel.name = "Patong Beach"

	UnlockPatongLabel = display.newImageRect( "Phuket/Overview/lock.png", Lock, Lock)
	UnlockPatongLabel.x = patong.x
	UnlockPatongLabel.y = patong.y - 5

	--object.xScale = -1  to flip right,left or
	--object.yScale = -1 to flip up,down
	--IsClick = false
	--RecommendPlace(  )

	ChalongLabel:addEventListener( "touch", check )
	BangPaeLabel:addEventListener( "touch", check )
	BigBuddhaLabel:addEventListener( "touch", check )
	KataLabel:addEventListener( "touch", check )
	KaronLabel:addEventListener( "touch", check )
	PatongLabel:addEventListener( "touch", check )
	KamalaLabel:addEventListener( "touch", check )

	watchalong:addEventListener( "touch", check )
	bangpae:addEventListener( "touch", check )
	bigbuddha:addEventListener( "touch", check )
	kata:addEventListener( "touch", check )
	karon:addEventListener( "touch", check )
	patong:addEventListener( "touch", check )
	kamala1:addEventListener( "touch", check )
	--kamala2:addEventListener( "touch", check )
	--kamala3:addEventListener( "touch", check )
	

	screen_w = 480
	screen_h = 320
	image_w = 1920	/ 3
	image_h = 1080 / 3
	speed =	0.05

	background1 = display.newImageRect("Phuket/Overview/sky.png",image_w,image_h)
	background1.x = screen_w / 2
	background1.y = screen_h / 2
	background2 = display.newImageRect("Phuket/Overview/sky.png",image_w,image_h)
	background2.x = 890
	background2.y = screen_h / 2

	Runtime:addEventListener("enterFrame",scrollBackground)


	Frame = display.newImageRect("Phuket/Overview/frame.png", cw, ch)
	Frame.x = cx
	Frame.y = cy

	---------------------------------- Group Place -----------------------------------------
	PlaceGroup:insert(island)
	PlaceGroup:insert(watchalong)
	PlaceGroup:insert(ChalongLabel)
	PlaceGroup:insert(bangpae)
	PlaceGroup:insert(BangPaeLabel)
	PlaceGroup:insert(bigbuddha)
	PlaceGroup:insert(BigBuddhaLabel)
	PlaceGroup:insert(kata)
	PlaceGroup:insert(KataLabel)
	PlaceGroup:insert(karon)
	PlaceGroup:insert(KaronLabel)
	PlaceGroup:insert(patong)
	PlaceGroup:insert(PatongLabel)
	PlaceGroup:insert(kamala1)
	PlaceGroup:insert(KamalaLabel)
	PlaceGroup:insert(KataLabel)
	PlaceGroup:insert(background1)
	PlaceGroup:insert(background2)
	PlaceGroup:insert(Frame)
	PlaceGroup:insert(UnlockBangPaeLabel)
	PlaceGroup:insert(UnlockBigBuddhaLabel)
	PlaceGroup:insert(UnlockChalongLabel)
	PlaceGroup:insert(UnlockKamalaLabel)
	PlaceGroup:insert(UnlockKaronLabel)
	PlaceGroup:insert(UnlockKataLabel)
	PlaceGroup:insert(UnlockPatongLabel)
	
	for row in db:nrows("SELECT img FROM personel;") do
		local Check = USERIMG_FINING( row.img )

		--native.showAlert( "No Internet",tostring( Check ), { "OK" } )
			if (row.img == "") then
			    ProfileImage = display.newImageRect( "Phuket/Overview/profilebut.png", 424/10, 430/10 )
				ProfileImage.x = cx - 250
				ProfileImage.y = cy - 130
				ProfileImage.name = "profile"  
				LOAD_IMG = true      
				--native.showAlert( "No Internet","1", { "OK" } )
			elseif (Check == true) then  
				--native.showAlert( "No Internet","2", { "OK" } )
				ProfileImage = display.newImage( 
							row.img, 
							system.DocumentsDirectory,
							cx - 250,
							cy - 130 
							)
				--ProfileImage:scale( 0.2, 0.2 )
				ProfileImage.name = "profile"
				ProfileImage:addEventListener( "touch", check )

	       if ProfileImage.width > ProfileImage.height then
			--ProfileImage:rotate( -90 )			-- rotate for landscape
			print( "Rotated" )
		end
		
		-- Scale image to fit content scaled screen
		local xScale = cw / ProfileImage.contentWidth
		local yScale = ch / ProfileImage.contentHeight
		local scale = math.max( xScale, yScale ) * .75
		
		local maxWidth = 512
		local maxHeight = 512
		local ScaleProFile = 0
		
		--ProfileImage.x = cx
		--ProfileImage.y = cy + 100
		
		--rescale width
		if ( ProfileImage.width > maxWidth ) then
		   local ratio = maxWidth / ProfileImage.width
		   ProfileImage.width = maxWidth
		   ProfileImage.height = ProfileImage.height * ratio
		   ScaleProFile = scale 
		end
		 
		--rescale height
		if ( ProfileImage.height > maxHeight ) then
		   local ratio = maxHeight / ProfileImage.height
		   ProfileImage.height = maxHeight
		   ProfileImage.width = ProfileImage.width * ratio
		   ScaleProFile = scale / 1.7
		end

		--ProfileImage:scale( ScaleProFile, ScaleProFile )
		ProfileImage:scale( 0.2, 0.2 )

		 local mask = graphics.newMask( "cc.png" )
		 --local mask = graphics.newMask( "Phuket/Overview/profilebut.png" )
			 
			ProfileImage:setMask( mask )
			
			ProfileImage.maskX = 1
			--ProfileImage.maskY = 1
			--ProfileImage.maskRotation = 20
			ProfileImage.maskScaleX = 0.75
			ProfileImage.maskScaleY = 0.75

			print( ProfileImage.width, ProfileImage.height )

			ProfileFrame = display.newImageRect( "Phuket/Overview/profilebut.png", 190/3.5, 187/3.5 )
			ProfileFrame.x = ProfileImage.x 
			ProfileFrame.y = ProfileImage.y + 3
			ProfileFrame.name = "profile"
	      	LOAD_IMG = true

			PlaceGroup:insert(ProfileImage)
			PlaceGroup:insert(ProfileFrame)
		else
			--native.showAlert( "No Internet","3", { "OK" } )
				LoadUserImg(row.img)
			end                       
		end

	ButtonGroup = display.newGroup()
	----------------------------------- Group Button -----------------------------------------
--[[
	if (CheckInList) then
		ButtonGroup:insert(RecButton)
	end
]]	
	RecommendPlace(  )
	sceneGroup:insert( PlaceGroup )
	sceneGroup:insert( ButtonGroup )

	CheckUnlockBangPaeLabel = true
	CheckUnlockBigBuddhaLabel = true
	CheckUnlockChalongLabel = true
	CheckUnlockKamalaLabel = true
	CheckUnlockKaronLabel = true
	CheckUnlockKataLabel = true
	CheckUnlockPatongLabel = true
	
	local sqlUnlock = "SELECT att_no FROM unattractions;"
	--local sqlUnlock = "SELECT count(att_no) as Catt_no FROM unattractions;"
	local CountAtt = 0
		for row in db:nrows(sqlUnlock) do
			if (row.att_no == 1) then
				RemoveAll(UnlockBangPaeLabel)
				CheckUnlockBangPaeLabel = false
			elseif (row.att_no == 2) then
				RemoveAll(UnlockBigBuddhaLabel)
				CheckUnlockBigBuddhaLabel = false
			elseif (row.att_no == 3) then
				RemoveAll(UnlockChalongLabel)
				CheckUnlockChalongLabel = false
			elseif (row.att_no == 4) then
				RemoveAll(UnlockKamalaLabel)
				CheckUnlockKamalaLabel = false
			elseif (row.att_no == 5) then
				RemoveAll(UnlockKaronLabel)
				CheckUnlockKaronLabel = false
			elseif (row.att_no == 6) then
				RemoveAll(UnlockKataLabel)
				CheckUnlockKataLabel = false
			elseif (row.att_no == 7) then
				RemoveAll(UnlockPatongLabel)
				CheckUnlockPatongLabel = false
			end
		end

	elseif (phase == "did") then
		print("Scene Overview : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then

	ChalongLabel:removeEventListener( "touch", check )
	BangPaeLabel:removeEventListener( "touch", check )
	BigBuddhaLabel:removeEventListener( "touch", check )
	KataLabel:removeEventListener( "touch", check )
	KaronLabel:removeEventListener( "touch", check )
	ProfileImage:removeEventListener( "touch", check )
	PatongLabel:removeEventListener( "touch", check )
	KamalaLabel:removeEventListener( "touch", check )
	watchalong:removeEventListener( "touch", check )
	bangpae:removeEventListener( "touch", check )
	bigbuddha:removeEventListener( "touch", check )
	kata:removeEventListener( "touch", check )
	karon:removeEventListener( "touch", check )
	patong:removeEventListener( "touch", check )
	kamala1:removeEventListener( "touch", check )
	Runtime:removeEventListener("enterFrame",scrollBackground)
--[[
	PlaceGroup:remove(island)
	PlaceGroup:remove(watchalong)
	PlaceGroup:remove(ChalongLabel)
	PlaceGroup:remove(bangpae)
	PlaceGroup:remove(BangPaeLabel)
	PlaceGroup:remove(bigbuddha)
	PlaceGroup:remove(BigBuddhaLabel)
	PlaceGroup:remove(kata)
	PlaceGroup:remove(KataLabel)
	PlaceGroup:remove(karon)
	PlaceGroup:remove(KaronLabel)
	PlaceGroup:remove(patong)
	PlaceGroup:remove(PatongLabel)
	PlaceGroup:remove(kamala1)
	PlaceGroup:remove(KamalaLabel)


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
]]
	ProfileImage:setMask( nil )
	mask = nil

--[[
	RemoveAll(island)
	RemoveAll(watchalong)
	RemoveAll(bangpae)
	RemoveAll(bigbuddha)
	RemoveAll(kata)
	RemoveAll(karon)
	RemoveAll(ProfileImage)
	RemoveAll(ProfileFrame)
	RemoveAll(kamala1)
	RemoveAll(patong)
	RemoveAll(ChalongLabel)
	RemoveAll(BigBuddhaLabel)
	RemoveAll(KataLabel)
	RemoveAll(KaronLabel)
	RemoveAll(KamalaLabel)
	RemoveAll(BangPaeLabel)
	RemoveAll(PatongLabel)


	if (CheckUnlockBangPaeLabel) then
		RemoveAll(UnlockBangPaeLabel)
	end

	if (CheckUnlockBigBuddhaLabel) then
		RemoveAll(UnlockBigBuddhaLabel)
	end

	if (CheckUnlockChalongLabel) then
		RemoveAll(UnlockChalongLabel)
	end

	if (CheckUnlockKamalaLabel) then
		RemoveAll(UnlockKamalaLabel)
	end

	if (CheckUnlockKaronLabel) then
		RemoveAll(UnlockKaronLabel)
	end

	if (CheckUnlockKataLabel) then
		RemoveAll(UnlockKataLabel)
	end

	if (CheckUnlockPatongLabel) then
		RemoveAll(UnlockPatongLabel)
	end
]]
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

Runtime:addEventListener( "key", onKeyEvent )

return scene