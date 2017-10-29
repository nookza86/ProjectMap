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
local NameImage, CountryImage, UserImage
local KataImage, KamalaImage, ChalongImage, KaronImage, PatongImage, BigbuddhaImage, BangpaeImage
local SettingBtn, OkBtn
local TextName, TextCountry, ProfileFrame, mask
local ProfileGroup = display.newGroup( )

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

local function Check( event )
	local obj = event.target.id

	print( obj )
	if(event.phase == "ended") then
		if(obj == "ok") then
			composer.gotoScene("overview")

		elseif(obj == "setting") then
			composer.gotoScene("profile_select")

		elseif(obj == "watchalong") then
			
			local options = {params = {PlaceName = "Chalong Temple"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "bangpae") then
		
			local options = {params = {PlaceName = "Bang Pae Waterfall"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "bigbuddha") then
			
			local options = {params = {PlaceName = "Big Buddha"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "kata") then
			
			local options = {params = {PlaceName = "Kata Beach"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "serpent") then
			
			local options = {params = {PlaceName = "Serpent"}}
			--composer.gotoScene("HomePlace", options)

		elseif(obj == "kamala") then
			
			local options = {params = {PlaceName = "Kamala Beach"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "karon") then
			
			local options = {params = {PlaceName = "Karon Beach"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "patong") then
			
			local options = {params = {PlaceName = "Patong Beach"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "profile") then
			
			local options = {params = {PlaceName = "Patong Beach"}}
			composer.gotoScene("profile", options)
		end
	end
end

local function loadImageListener( event )
	if(not event.isError) then
		native.setActivityIndicator( true )
		print( event.response.filename, event.response.baseDirectory )
        	UserImage = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							cx - 180,
							cy - 75 
							)
				--UserImage:scale( 0.2, 0.2 )
				UserImage.name = "profile"
				

	       if UserImage.width > UserImage.height then
			--UserImage:rotate( -90 )			-- rotate for landscape
			print( "Rotated" )
		end
		
		-- Scale image to fit content scaled screen
		local xScale = cw / UserImage.contentWidth
		local yScale = ch / UserImage.contentHeight
		local scale = math.max( xScale, yScale ) * .75
		
		local maxWidth = 512
		local maxHeight = 512

		UserImage:scale( scale, scale )
		--UserImage.x = cx
		--UserImage.y = cy + 100
		
		--rescale width
		if ( UserImage.width > maxWidth ) then
		   local ratio = maxWidth / UserImage.width
		   UserImage.width = maxWidth
		   UserImage.height = UserImage.height * ratio
		end
		 
		--rescale height
		if ( UserImage.height > maxHeight ) then
		   local ratio = maxHeight / UserImage.height
		   UserImage.height = maxHeight
		   UserImage.width = UserImage.width * ratio
		end

		 mask = graphics.newMask( "cc.png" )
		 --local mask = graphics.newMask( "Phuket/Overview/profilebut.png" )
			 
			UserImage:setMask( mask )
			
			UserImage.maskX = 1
			--UserImage.maskY = 1
			--UserImage.maskRotation = 20
			UserImage.maskScaleX = 2
			UserImage.maskScaleY = 2

			print( UserImage.width, UserImage.height )

	ProfileFrame = display.newImageRect( "Phuket/Overview/profilebut.png", 190*0.7, 187*0.7 )
	ProfileFrame.x = UserImage.x 
	ProfileFrame.y = UserImage.y + 6
	ProfileFrame.name = "profile"

	ProfileGroup:insert( UserImage )
	ProfileGroup:insert( ProfileFrame )
	
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
	system.ApplicationSupportDirectory
	)

end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Profile : create")
end

local function FindImg( Filename )
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
	cx = display.contentCenterX
    cy = display.contentCenterY
    cw = display.contentWidth
    ch = display.contentHeight
	--params = event.params
	if (phase == "will") then
		local prevScene = composer.getSceneName( "previous" )

		if (prevScene ~= nil) then
			composer.removeScene( prevScene )
		end

		--native.setActivityIndicator( true )
		Bg = display.newImageRect("Phuket/Profile/bg.png", cw, ch )
		Bg.x = cx 
		Bg.y = cy 
		--Bg:scale( 0.3, 0.3 ) 
		ProfileGroup:insert( Bg )

--[[
		UserImage = display.newImageRect( "Phuket/Profile/picpro.png", 387/3.5, 388/3.5 )
		UserImage.x = cx - 180
		UserImage.y = cy - 55
]]
		NameImage = display.newImageRect( "Phuket/Profile/name.png", 226/3, 77/3 )
		NameImage.x = cx + 40
		NameImage.y = cy - 80
		ProfileGroup:insert( NameImage )

		CountryImage = display.newImageRect( "Phuket/Profile/country.png", 449/3, 92/3 )
		CountryImage.x = NameImage.x - 40
		CountryImage.y = NameImage.y + 40
		ProfileGroup:insert( CountryImage )

		TextName = display.newText( "", cx + 160 , cy - 80, "Cloud-Bold", 16 )
		--TextName:setFillColor( 1, 0, 0 )
		ProfileGroup:insert( TextName )


		TextCountry = display.newText( "dd", CountryImage.x + 150 , CountryImage.y, "Cloud-Bold", 16 )
		--TextCountry:setFillColor( 1, 0, 0 )
		ProfileGroup:insert( TextCountry )

		for row in db:nrows("SELECT img, fname, lname, country FROM personel;") do
			TextName.text = row.fname .. " " .. row.lname  
			TextCountry.text = row.country   
			Filename = row.img
			if (row.img == "") then
			    UserImage = display.newImageRect( "Phuket/Profile/picpro.png", 387/3.5, 388/3.5 )
				UserImage.x = cx - 180
				UserImage.y = cy - 55          
				ProfileGroup:insert( UserImage ) 
			elseif (FindImg( Filename ) == true) then  
				UserImage = display.newImage( 
							row.img, 
							system.DocumentsDirectory,
							cx - 180,
							cy - 75 
							)
				--UserImage:scale( 0.2, 0.2 )
				UserImage.name = "profile"
				

	       if UserImage.width > UserImage.height then
			--UserImage:rotate( -90 )			-- rotate for landscape
			print( "Rotated" )
		end
		
		-- Scale image to fit content scaled screen
		local xScale = cw / UserImage.contentWidth
		local yScale = ch / UserImage.contentHeight
		local scale = math.max( xScale, yScale ) * .75
		
		local maxWidth = 512
		local maxHeight = 512

		UserImage:scale( scale, scale )
		--UserImage.x = cx
		--UserImage.y = cy + 100
		
		--rescale width
		if ( UserImage.width > maxWidth ) then
		   local ratio = maxWidth / UserImage.width
		   UserImage.width = maxWidth
		   UserImage.height = UserImage.height * ratio
		end
		 
		--rescale height
		if ( UserImage.height > maxHeight ) then
		   local ratio = maxHeight / UserImage.height
		   UserImage.height = maxHeight
		   UserImage.width = UserImage.width * ratio
		end

		 local mask = graphics.newMask( "cc.png" )
		 --local mask = graphics.newMask( "Phuket/Overview/profilebut.png" )
			 
			UserImage:setMask( mask )
			
			UserImage.maskX = 1
			--UserImage.maskY = 1
			--UserImage.maskRotation = 20
			UserImage.maskScaleX = 1.5
			UserImage.maskScaleY = 1.5

			print( UserImage.width, UserImage.height )

	ProfileFrame = display.newImageRect( "Phuket/Overview/profilebut.png", 190*0.6, 187*0.6 )
	ProfileFrame.x = UserImage.x 
	ProfileFrame.y = UserImage.y + 6
	ProfileFrame.name = "profile"
	ProfileGroup:insert( UserImage )
	ProfileGroup:insert( ProfileFrame )
native.setActivityIndicator( false )
			else
				LoadUserImg(row.img)
			end                       
		end

		local sqlUnlock = "SELECT att_no FROM unattractions;"
		local CheckTrophyKata = 0
		local CheckTrophyKamala = 0
		local CheckTrophyChalong = 0
		local CheckTrophyKaron = 0
		local CheckTrophyPatong = 0
		local CheckTrophyBigbuddha = 0
		local CheckTrophyBangpae = 0

		for row in db:nrows(sqlUnlock) do
			if (row.att_no == 1) then
				CheckTrophyBangpae = 1

			elseif (row.att_no == 2) then
				CheckTrophyBigbuddha = 1

			elseif (row.att_no == 3) then
				CheckTrophyChalong = 1

			elseif (row.att_no == 4) then
				CheckTrophyKamala = 1

			elseif (row.att_no == 5) then
				CheckTrophyKaron = 1

			elseif (row.att_no == 6) then
				CheckTrophyKata = 1

			elseif (row.att_no == 7) then
				CheckTrophyPatong = 1

			end
		end

		

		KataImage = widget.newButton(
    	{
	        width = 463/3.5,
	        height = 117/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/kata_".. CheckTrophyKata ..".png",
	        overFile = "Phuket/Profile/NameActractionPress/kata_".. CheckTrophyKata ..".png",
	        id = "kata",
	        onEvent = Check
    	}
			)
		KataImage.x = cx - 180 
		KataImage.y = cy + 15

		KamalaImage = widget.newButton(
    	{
	        width = 522/3.5,
	        height = 118/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/kamala_".. CheckTrophyKamala ..".png",
	        overFile = "Phuket/Profile/NameActractionPress/kamala_".. CheckTrophyKamala ..".png",
	        id = "kamala",
	        onEvent = Check
    	}
			)
		KamalaImage.x = KataImage.x + 170
		KamalaImage.y = KataImage.y

		ChalongImage = widget.newButton(
    	{
	        width = 522/3.5,
	        height = 117/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/chalong_".. CheckTrophyChalong ..".png",
	        overFile = "Phuket/Profile/NameActractionPress/chalong_".. CheckTrophyChalong ..".png",
	        id = "watchalong",
	        onEvent = Check
    	}
			)
		ChalongImage.x = KamalaImage.x + 180
		ChalongImage.y = KamalaImage.y

		KaronImage = widget.newButton(
    	{
	        width = 453/3.5,
	        height = 117/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/karon_".. CheckTrophyKaron ..".png",
	        overFile = "Phuket/Profile/NameActractionPress/karon_".. CheckTrophyKaron ..".png",
	        id = "karon",
	        onEvent = Check
    	}
			)
		KaronImage.x = KataImage.x 
		KaronImage.y = KataImage.y + 45

		PatongImage = widget.newButton(
    	{
	        width = 476/3.5,
	        height = 118/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/patong_".. CheckTrophyPatong ..".png",
	        overFile = "Phuket/Profile/NameActractionPress/patong_".. CheckTrophyPatong ..".png",
	        id = "patong",
	        onEvent = Check
    	}
			)
		PatongImage.x = KaronImage.x + 170
		PatongImage.y = KaronImage.y 

		BigbuddhaImage = widget.newButton(
    	{
	        width = 465/3.5,
	        height = 119/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/bigbuddha_".. CheckTrophyBigbuddha ..".png",
	        overFile = "Phuket/Profile/NameActractionPress/bigbuddha_".. CheckTrophyBigbuddha ..".png",
	        id = "bigbuddha",
	        onEvent = Check
    	}
			)
		BigbuddhaImage.x = PatongImage.x + 170
		BigbuddhaImage.y = PatongImage.y 

		BangpaeImage = widget.newButton(
    	{
	        width = 684/3.5,
	        height = 114/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/bangpae_".. CheckTrophyBangpae ..".png",
	        overFile = "Phuket/Profile/NameActractionPress/bangpae_".. CheckTrophyBangpae ..".png",
	        id = "bangpae",
	        onEvent = Check
    	}
			)
		BangpaeImage.x = PatongImage.x
		BangpaeImage.y = PatongImage.y + 45

		SettingBtn = widget.newButton(
    	{
	        width = 130/3,
	        height = 101/3,
	        defaultFile = "Phuket/Button/Button/setting.png",
	        overFile = "Phuket/Button/ButtonPress/setting.png",
	        id = "setting",
	        onEvent = Check
    	}
			)
		SettingBtn.x = cx - 230
		SettingBtn.y = cy + 115

		OkBtn = widget.newButton(
    	{
	        width = 130/3,
	        height = 101/3,
	        defaultFile = "Phuket/Button/Button/ok.png",
	        overFile = "Phuket/Button/ButtonPress/ok.png",
	        id = "ok",
	        onEvent = Check
    	}
			)
		OkBtn.x = cx + 225
		OkBtn.y = cy + 115
	
		ProfileGroup:insert(KataImage)
		ProfileGroup:insert(KamalaImage)
		ProfileGroup:insert(ChalongImage)
		ProfileGroup:insert(KaronImage)
		ProfileGroup:insert(PatongImage)
		ProfileGroup:insert(BigbuddhaImage)
		ProfileGroup:insert(BangpaeImage)

		ProfileGroup:insert(SettingBtn)
		ProfileGroup:insert(OkBtn)

		sceneGroup:insert( ProfileGroup )

		print("Scene #Profile : show (will)")
	
	elseif (phase == "did") then
		print("Scene #Profile : show (did)")
		
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then

		UserImage:setMask( nil )
		mask = nil
		--[[
		RemoveAll(Bg)
		RemoveAll(NameImage)
		RemoveAll(CountryImage)
		RemoveAll(UserImage)

		RemoveAll(KataImage)
		RemoveAll(KamalaImage)
		RemoveAll(ChalongImage)
		RemoveAll(KaronImage)
		RemoveAll(PatongImage)
		RemoveAll(BigbuddhaImage)
		RemoveAll(BangpaeImage)

		RemoveAll(SettingBtn)
		RemoveAll(OkBtn)
		RemoveAll(TextName)
		RemoveAll(TextCountry)
		RemoveAll(ProfileFrame)
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