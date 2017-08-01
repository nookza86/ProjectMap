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
local TitleImage, UsernameImage, CountryImage, UserImage
local KataImage, KamalaImage, ChalongImage, KaronImage, PatongImage, BigbuddhaImage, BangpaeImage
local SettingBtn, OkBtn
local TextName, TextCountry

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
--[[
			local myRoundedRect = display.newRoundedRect( cx, cy, cw, ch, 1 )
			myRoundedRect:setFillColor( 1,0,1 )
			myRoundedRect.alpha = 0.1

			local options = {
			    isModal = true,
			    effect = "fade",
			    time = 400,
			}
 			composer.showOverlay( "setting", options )
			]]
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
		print( event.response.filename, event.response.baseDirectory )
			RemoveAll(UserImage)
			UserImage1 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							cx - 200,
							cy + 40 
							)
			UserImage1:scale( 0.2, 0.2 )


        local mask = graphics.newMask( "cccccc.png" )
		 
		UserImage1:setMask( mask )
		 
		UserImage1.maskX = -10
		--UserImage1.maskRotation = 20
		UserImage1.maskScaleX = 1
		UserImage1.maskScaleY = 1
	
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
		native.setActivityIndicator( true )
		Bg = display.newImageRect("Phuket/Profile/bg1.png", cw, ch )
		Bg.x = cx 
		Bg.y = cy 
		--Bg:scale( 0.3, 0.3 ) 

		TitleImage = display.newImageRect( "Phuket/Profile/profile.png", 369/2.5, 83/2.5 )
		TitleImage.x = cx 
		TitleImage.y = cy - 135
--[[
		UserImage = display.newImageRect( "Phuket/Profile/picpro.png", 387/3.5, 388/3.5 )
		UserImage.x = cx - 180
		UserImage.y = cy - 55
]]
		UsernameImage = display.newImageRect( "Phuket/Profile/user.png", 400/3, 80/3 )
		UsernameImage.x = cx
		UsernameImage.y = cy - 80

		CountryImage = display.newImageRect( "Phuket/Profile/country.png", 486/3, 55/3 )
		CountryImage.x = UsernameImage.x
		CountryImage.y = UsernameImage.y + 40

		TextName = display.newText( "", cx + 180 , cy - 80, native.systemFont, 16 )
		TextName:setFillColor( 1, 0, 0 )

		TextCountry = display.newText( "dd", CountryImage.x + 150 , CountryImage.y, native.systemFont, 16 )
		TextCountry:setFillColor( 1, 0, 0 )

		for row in db:nrows("SELECT img, fname, lname, country FROM personel;") do
			TextName.text = row.fname .. " " .. row.lname  
			TextCountry.text = row.country   
			Filename = row.img
			if (row.img == "") then
			    UserImage = display.newImageRect( "Phuket/Profile/picpro.png", 387/3.5, 388/3.5 )
				UserImage.x = cx - 180
				UserImage.y = cy - 55           
			elseif (FindImg( Filename ) == true) then  
				UserImage1 = display.newImage( 
							Filename, 
							system.DocumentsDirectory,
							cx - 200,
							cy + 40 
							)
			UserImage1:scale( 0.2, 0.2 )


		        local mask = graphics.newMask( "cccccc.png" )
				 
				UserImage1:setMask( mask )
				 
				UserImage1.maskX = -10
				--UserImage1.maskRotation = 20
				UserImage1.maskScaleX = 1
				UserImage1.maskScaleY = 1
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
	        width = 532/3.5,
	        height = 126/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/kata_".. CheckTrophyKata ..".png",
	        overFile = "Phuket/Profile/NameActractionPress/kata_".. CheckTrophyKata ..".png",
	        id = "kata",
	        onEvent = Check
    	}
			)
		KataImage.x = cx - 180 
		KataImage.y = cy + 40

		KamalaImage = widget.newButton(
    	{
	        width = 564/3.5,
	        height = 126/3.5,
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
	        width = 621/3.5,
	        height = 126/3.5,
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
	        width = 532/3.5,
	        height = 127/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/karon_".. CheckTrophyKaron ..".png",
	        overFile = "Phuket/Profile/NameActractionPress/karon_".. CheckTrophyKaron ..".png",
	        id = "karon",
	        onEvent = Check
    	}
			)
		KaronImage.x = KataImage.x 
		KaronImage.y = KataImage.y + 40

		PatongImage = widget.newButton(
    	{
	        width = 565/3.5,
	        height = 127/3.5,
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
	        width = 556/3.5,
	        height = 127/3.5,
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
	        width = 767/3.5,
	        height = 126/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/bangpae_".. CheckTrophyBangpae ..".png",
	        overFile = "Phuket/Profile/NameActractionPress/bangpae_".. CheckTrophyBangpae ..".png",
	        id = "bangpae",
	        onEvent = Check
    	}
			)
		BangpaeImage.x = PatongImage.x
		BangpaeImage.y = PatongImage.y + 40

		SettingBtn = widget.newButton(
    	{
	        width = 70/1.5,
	        height = 70/1.5,
	        defaultFile = "Phuket/Button/Button/setting.png",
	        overFile = "Phuket/Button/ButtonPress/setting.png",
	        id = "setting",
	        onEvent = Check
    	}
			)
		SettingBtn.x = cx - 230
		SettingBtn.y = cy + 130

		OkBtn = widget.newButton(
    	{
	        width = 130/2.5,
	        height = 101/2.5,
	        defaultFile = "Phuket/Button/Button/ok.png",
	        overFile = "Phuket/Button/ButtonPress/ok.png",
	        id = "ok",
	        onEvent = Check
    	}
			)
		OkBtn.x = cx + 230
		OkBtn.y = cy + 130

		print("Scene #Profile : show (will)")
	
	elseif (phase == "did") then
		print("Scene #Profile : show (did)")
		
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(Bg)
		RemoveAll(TitleImage)
		RemoveAll(UsernameImage)
		RemoveAll(CountryImage)
		--[[
		if (UserImage ~= nil or UserImage ~= "") then
			RemoveAll(UserImage)
		end
		]]
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
		RemoveAll(UserImage1)
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