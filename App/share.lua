local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local toast = require('plugin.toast')
local image = require('image')
require("FitImage")
require("createAcc")
require("get-data")
require ("Network-Check")
require ("facebook.face")
--local facebook = require( "plugin.facebook.v4" )
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local params, cx, cy, cw, ch
local Bg, UserImage1, UserImage2, UserImage3, UserImage4
local BackBtn, ShareBtn, ReloadBtn
local member_no, NoAtt, DiaryNote, SelecFileImg
local CheckImg1, CheckImg2, CheckImg3, CheckImg4
local backgroundALpha
local CheckSelectImg = false
local myText
local LOADING_IMG_1, LOADING_IMG_2, LOADING_IMG_3,LOADING_IMG_4
local FrameUserImage1, FrameUserImage2, FrameUserImage3, FrameUserImage4
local FitFrameImage
local IMG_SCALE = 1.2
local Check, SelectImg
--local mask = graphics.newMask( "rr-512.png" )
local mask = graphics.newMask( "Phuket/share/addpicture.png" )
local PopupImg, PopupClose, backgroundALpha, PopupText
local ShareGroup = display.newGroup()

cx = display.contentCenterX
cy = display.contentCenterY
cw = display.contentWidth
ch = display.contentHeight
----------------------
local ImagePosition_X_1 = cx - 200
local ImagePosition_Y_1 = cy + 20

local ImagePosition_X_2 = cx - 70
local ImagePosition_Y_2 = cy + 20

local ImagePosition_X_3 = cx + 60
local ImagePosition_Y_3 = cy + 20

local ImagePosition_X_4 = cx + 190
local ImagePosition_Y_4 = cy + 20
----------------------


local function RemoveAll( event )
	if(event) then
		--print( "deletePic "  )
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

local function DisableBTN(  )
	
	UserImage1:removeEventListener( "touch", SelectImg )
	UserImage2:removeEventListener( "touch", SelectImg )
	UserImage3:removeEventListener( "touch", SelectImg )
	UserImage4:removeEventListener( "touch", SelectImg )
	ShareBtn:setEnabled( false )
	BackBtn:setEnabled( false )

end

local function EnableBTN(  )
	
	UserImage1:addEventListener( "touch", SelectImg )
	UserImage2:addEventListener( "touch", SelectImg )
	UserImage3:addEventListener( "touch", SelectImg )
	UserImage4:addEventListener( "touch", SelectImg )
	ShareBtn:setEnabled( true )
	BackBtn:setEnabled( true )

end

local function ShowPopUp( TextAlert )

	backgroundALpha = display.newRect(0,0,570,360)
	backgroundALpha.x = display.contentWidth / 2
	backgroundALpha.y = display.contentHeight / 2
	backgroundALpha:setFillColor( black )
	backgroundALpha.alpha = 0.5

	PopupImg = display.newImageRect( "Phuket/Home/popup.png", 779 / 3, 450 / 3 )
	PopupImg.x = display.contentCenterX
	PopupImg.y = display.contentCenterY

	local options = {
	   text = TextAlert,
	   x = PopupImg.x,
	   y = PopupImg.y,
	   fontSize = 16,
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
	        defaultFile = "Phuket/Button/Button/close.png",
	        overFile = "Phuket/Button/ButtonPress/close.png",
	        id = "CloseBtn",
	        onEvent = Check
    	}
			)
	CloseBtn.name = "CloseBtn"
	CloseBtn.x = PopupImg.x + 90
	CloseBtn.y = PopupImg.y - 50

	DisableBTN(  )

	ShareGroup:insert( backgroundALpha )
	ShareGroup:insert( PopupImg )
	ShareGroup:insert( PopupText )
	ShareGroup:insert( CloseBtn )
end

function SelectImg( event )
	SelecFileImg = event.target.id

	if (composer.getSceneName( "current" ) ~= "share") then

		return
	end
	print( SelecFileImg .. "DD " .. composer.getSceneName( "current" ) )
	
	--local RecWidth = 0
	--local RecHeight = 0
	local PositionX = 0
	local PositionY = 0
	if (event.phase == "ended") then
		
	

	if (CheckSelectImg == true) then
		--RemoveAll(backgroundALpha)
		backgroundALpha:removeSelf( )
		backgroundALpha = nil
	end

	if (SelecFileImg == NoAtt .. "_" .. member_no .. "_1.jpg") then
		--RecWidth = UserImage1.width
		--RecHeight = UserImage1.height
		PositionX = UserImage1.x
		PositionY = UserImage1.y
		CheckSelectImg = true

	elseif (SelecFileImg == NoAtt .. "_" .. member_no .. "_2.jpg") then
		--RecWidth = UserImage2.width
		--RecHeight = UserImage2.height
		PositionX = UserImage2.x
		PositionY = UserImage2.y
		CheckSelectImg = true

	elseif (SelecFileImg == NoAtt .. "_" .. member_no .. "_3.jpg") then
		--RecWidth = UserImage3.width
		--RecHeight = UserImage3.height
		PositionX = UserImage3.x
		PositionY = UserImage3.y
		CheckSelectImg = true

	elseif (SelecFileImg == NoAtt .. "_" .. member_no .. "_4.jpg") then
		--RecWidth = UserImage4.width
		--RecHeight = UserImage4.height
		PositionX = UserImage4.x
		PositionY = UserImage4.y
		CheckSelectImg = true
	end	

	backgroundALpha = display.newImageRect( "check.png", 395, 512)
	backgroundALpha.x = PositionX
	backgroundALpha.y = PositionY
	backgroundALpha:scale(0.2, 0.2 )
	ShareGroup:insert(backgroundALpha)
	
	end

end

local function loadImageListener( event )

	if(not event.isError) then
		--print( event.response.target.width )
		print( event.response.filename, event.response.baseDirectory )
		if (event.response.filename == NoAtt .. "_" .. member_no .. "_1.jpg") then
			
			UserImage1 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							ImagePosition_X_1,
							ImagePosition_Y_1 
							)
			--UserImage1:scale( 0.15, 0.15 )
			UserImage1.id = event.response.filename
			UserImage1:addEventListener( "touch", SelectImg )
			UserImage1.alpha = 0
       		LOADING_IMG_1 = true

			ShareGroup:insert( UserImage1 )
		end

		if (event.response.filename == NoAtt .. "_" .. member_no .. "_2.jpg") then

			UserImage2 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							ImagePosition_X_2,
							ImagePosition_Y_2 
							)
			--UserImage2:scale( 0.15, 0.15 )
			UserImage2.id = event.response.filename
			UserImage2:addEventListener( "touch", SelectImg )
			UserImage2.alpha = 0
       		LOADING_IMG_2 = true
			ShareGroup:insert( UserImage2 )
		end

		if (event.response.filename == NoAtt .. "_" .. member_no .. "_3.jpg") then

			UserImage3 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							ImagePosition_X_3,
							ImagePosition_Y_3 
							)
			--UserImage3:scale( 0.15, 0.15 )
			UserImage3.id = event.response.filename
			UserImage3:addEventListener( "touch", SelectImg )
			UserImage3.alpha = 0
       		LOADING_IMG_3 = true
			ShareGroup:insert( UserImage3 )
		end

		if (event.response.filename == NoAtt .. "_" .. member_no .. "_4.jpg") then

			UserImage4 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							ImagePosition_X_4,
							ImagePosition_Y_4 
							)
			--UserImage4:scale( 0.15, 0.15 )
			UserImage4.id = event.response.filename
			UserImage4:addEventListener( "touch", SelectImg )
			UserImage4.alpha = 0
       		--transition.to( UserImage4, { alpha=1.0 } )
       		LOADING_IMG_4 = true
			ShareGroup:insert( UserImage4 )
		end
		
	end

end

local function LoadDirayImage( event )
	--[[
	if isRechable() == false then 
 		--native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
 		toast.show("It seems internet is not Available.\n Please connect to internet.")
 		return
	end
]]
	local url = "http://mapofmem.esy.es/admin/api/android_upload_api/upload/diary/" ..NoAtt .."/" .. event 
	--print( url )
network.download( url , 
	"GET", 
	loadImageListener,
	{},
	event,
	system.DocumentsDirectory
	)

end

function Check( event )
	print( event.target.id, params.PlaceName)
	local options = {params = {PlaceName = params.PlaceName}}
	if(event.phase == "ended") then
		if(event.target.id == "BackBtn") then
		--	composer.removeScene( "share" )
			print( "Go to scene #HomePlace " .. params.PlaceName )
			composer.gotoScene("HomePlace",options)
		elseif (event.target.id == "ShareBtn") then
			print( "Share with facebook button" )
			--buttonOnRelease("sharePhotoDialog")
			--local command = "postPhoto"
			local command = "sharePhotoDialog"
			--local command = "postLink"
			--local command = "postMessage"
			local caption = DiaryNote
			local AttNo = NoAtt
			local memNo = member_no
			local filename = SelecFileImg

			--myText.text = "n : " .. filename

			if (filename == nil or filename == "") then
				--toast.show('Please select at least one photo.') 
				ShowPopUp( 'Please select at least one photo.' )
				return
			else

			if isRechable() == false then 
 				--native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
 				--toast.show('It seems internet is not Available. Please connect to internet.') 
 				ShowPopUp( 'It seems internet is not Available. Please connect to internet.' )
 				return
			end

				buttonOnRelease(command, caption, AttNo, memNo, filename)
			end
		elseif (event.target.id == "CloseBtn") then
			RemoveAll( backgroundALpha )
			RemoveAll( PopupImg )
			RemoveAll( PopupText )
			RemoveAll( CloseBtn )
			EnableBTN()

		elseif (event.target.id == "ReloadBtn") then
			local sql = "SELECT member_no, diary_pic1, diary_pic2, diary_pic3, diary_pic4 FROM diary WHERE att_no IN (SELECT att_no FROM attractions WHERE att_name = '" .. params.PlaceName .. "' );"

			for row in db:nrows(sql) do	
				image.Delete(member_no, row.diary_pic1)
				image.Delete(member_no, row.diary_pic2)
				image.Delete(member_no, row.diary_pic3)
				image.Delete(member_no, row.diary_pic4)
			end

			--composer.gotoScene("share",options)

		else
			composer.gotoScene("share",options)
		end
	end
end

local function DropTableData(  )
	local NOOOO = 0	
	local sql2 = "SELECT id FROM personel;"
		for row in db:nrows(sql2) do
			NOOOO = row.id
		end
		
	local tablesetup = "DELETE FROM `diary`;"
	db:exec(tablesetup)

	 GetData(2 , NOOOO)

 end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #share : create")
end

local function listener( event )
    if (LOADING_IMG_1 == true and LOADING_IMG_2 == true and LOADING_IMG_3 == true and LOADING_IMG_4 == true) then
    	 timer.cancel( event.source )
    	 if (CheckImg1) then
    	 	FitFrameImage( UserImage1 )
    	 	transition.to( UserImage1, { alpha=1.0 } )
    	 end

    	  if (CheckImg2) then
    	 	FitFrameImage( UserImage2 )
    	 	transition.to( UserImage2, { alpha=1.0 } )
    	 end

    	  if (CheckImg3) then
    	 	FitFrameImage( UserImage3 )
    	 	transition.to( UserImage3, { alpha=1.0 } )
    	 end

    	  if (CheckImg4) then
    	 	FitFrameImage( UserImage4 )
    	 	transition.to( UserImage4, { alpha=1.0 } )	
    	 end
    	
    	 native.setActivityIndicator( false )
    	 print( "LOADING DONE" )

    	else
    		print( tostring( CheckImg1 ) .. " " ..tostring( CheckImg2 ) .. " " .. tostring( CheckImg3 ) .. " " ..tostring( CheckImg4 ))
    end
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

function FitFrameImage( ImageObj )
	local maxWidth = 331
	local maxHeight = 441
	local Fit_X_MAX = 125
	local Fit_Y_MAX = 125

	--rescale width
	if ( ImageObj.width > maxWidth ) then
		 local ratio = maxWidth / ImageObj.width
		 ImageObj.width = maxWidth
		 ImageObj.height = ImageObj.height * ratio
		-- Fit_X_MAX = 150
		 --Fit_Y_MAX = 150
	end
		 
		--rescale height
	if ( ImageObj.height > maxHeight ) then
	     local ratio = maxHeight / ImageObj.height
	     ImageObj.height = maxHeight
	     ImageObj.width = ImageObj.width * ratio
	     --Fit_X_MAX = 150
		-- Fit_Y_MAX = 150
	end	

	local Frame = ""
	local Fit_Y = 0
	local Fit_X = fitImage( ImageObj, Fit_X_MAX, Fit_Y_MAX, true )

	ImageObj:scale( Fit_X, Fit_X )
	print( "In FitFrameImage Filename: " .. ImageObj.id )
	Fit_Y = Fit_X
	if (ImageObj.width > ImageObj.height) then
		Frame = "Phuket/Frame/frame_1.png"
		Fit_X = Fit_X + 0.04
		Fit_Y = Fit_Y + 0.05
	else
		Frame = "Phuket/Frame/frame_2.png"
		Fit_X = Fit_X + 0.05
		Fit_Y = Fit_Y + 0.05
	end

	if (ImageObj.id == NoAtt .. "_" .. member_no .. "_1.jpg") then
		FrameUserImage1 = display.newImageRect( Frame, UserImage1.width, UserImage1.height )
		FrameUserImage1.x = UserImage1.x
		FrameUserImage1.y = UserImage1.y
		FrameUserImage1:scale( Fit_X , Fit_Y )
		ShareGroup:insert( FrameUserImage1 )

	elseif (ImageObj.id == NoAtt .. "_" .. member_no .. "_2.jpg") then
		FrameUserImage2 = display.newImageRect( Frame, UserImage2.width, UserImage2.height )
		FrameUserImage2.x = UserImage2.x
		FrameUserImage2.y = UserImage2.y
		FrameUserImage2:scale( Fit_X, Fit_Y )
		ShareGroup:insert( FrameUserImage2 )

	elseif (ImageObj.id == NoAtt .. "_" .. member_no .. "_3.jpg") then
		FrameUserImage3 = display.newImageRect( Frame, UserImage3.width, UserImage3.height )
		FrameUserImage3.x = UserImage3.x
		FrameUserImage3.y = UserImage3.y
		FrameUserImage3:scale( Fit_X, Fit_Y )
		ShareGroup:insert( FrameUserImage3 )


	elseif (ImageObj.id == NoAtt .. "_" .. member_no .. "_4.jpg") then
		FrameUserImage4 = display.newImageRect( Frame, UserImage4.width, UserImage4.height )
		FrameUserImage4.x = UserImage4.x
		FrameUserImage4.y = UserImage4.y
		FrameUserImage4:scale( Fit_X, Fit_Y )
		ShareGroup:insert( FrameUserImage4 )

	end
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	params = event.params
	if (phase == "will") then
		--composer.removeScene( "HomePlace" )
		local prevScene = composer.getSceneName( "previous" )
		composer.removeScene( prevScene )
		--[[
		LOADING_IMG_1 = false
	    LOADING_IMG_2 = false
	    LOADING_IMG_3 = false
	    LOADING_IMG_4 = false
	    ]]
		native.setActivityIndicator( true )
		timer.performWithDelay( 1000, listener, 0 )
		--[[
	    CheckImg1 = false
	    CheckImg2 = false
	    CheckImg3 = false
	    CheckImg4 = false
	    ]]
	 -- toast.show('Loading Image!')  

		Bg = display.newImageRect("Phuket/share/bg.jpg", cw, ch )
	    Bg.x = cx 
		Bg.y = cy 
		ShareGroup:insert( Bg )

		Tett = display.newImageRect("Phuket/share/text.png", 764/2, 94/2 )
	    Tett.x = cx 
		Tett.y = cy  - 80
		ShareGroup:insert( Tett )

		local sql = "SELECT att_no FROM attractions WHERE att_name = '".. params.PlaceName .."';"
		NoAtt = 0
		for row in db:nrows(sql) do
			NoAtt = row.att_no
		end

		local sql3 = "SELECT diary_note FROM diary WHERE att_no IN(SELECT att_no FROM attractions WHERE att_name = '".. params.PlaceName .."');"

		for row in db:nrows(sql3) do
			DiaryNote = row.diary_note
		end

		local sql = "SELECT member_no, diary_pic1, diary_pic2, diary_pic3, diary_pic4 FROM diary WHERE att_no IN (SELECT att_no FROM attractions WHERE att_name = '" .. params.PlaceName .. "' );"
		--print( "SQL is : " .. sql )
		for row in db:nrows(sql) do
			--print( row.member_no , row.diary_pic1, row.diary_pic2, row.diary_pic3, row.diary_pic4 )
			member_no = row.member_no
--[[
			if (row.diary_pic1 == "" or row.diary_pic1 == nil) then
				CheckImg1 = false
			end
			if (row.diary_pic2 == "" or row.diary_pic2 == nil) then
				CheckImg2 = false
			end
			if (row.diary_pic3 == "" or row.diary_pic3 == nil) then
				CheckImg3 = false
			end
			if (row.diary_pic4 == "" or row.diary_pic4 == nil) then
				CheckImg4 = false
			end
			
			if (row.diary_pic1 ~= "") then
				
				CheckImg1 = true
				Filename = row.diary_pic1
				if (FindImg( Filename ) == true) then
					
					UserImage1 = display.newImage( 
							Filename, 
							system.DocumentsDirectory,
							ImagePosition_X_1,
							ImagePosition_Y_1 
							)
					--UserImage1:scale( 0.15, 0.15 )
					UserImage1.id = Filename
					UserImage1:addEventListener( "touch", SelectImg )
					UserImage1.alpha = 0
		       		LOADING_IMG_1 = true

					ShareGroup:insert( UserImage1 )

				else
					LoadDirayImage(row.diary_pic1)
				end
			end
			]]

			if (row.diary_pic1 == nil or row.diary_pic1 == "") then
				UserImage1 = display.newImageRect( "Phuket/share/addpicture.png", 999/9, 929/9 )
				UserImage1.x = ImagePosition_X_1
				UserImage1.y = ImagePosition_Y_1
				UserImage1.id = row.diary_pic1
				--UserImage1:addEventListener( "touch", SelectImg )
				ShareGroup:insert( UserImage1 )
	     		LOADING_IMG_1 = true
	      		CheckImg1 = false
     
			else
				LoadDirayImage(row.diary_pic1)
				CheckImg1 = true
			end
-----------------------------------------2---------------------------------------------
--[[
			if (row.diary_pic2 ~= "") then

				CheckImg2 = true
				Filename = row.diary_pic2
				if (FindImg( Filename ) == true) then
					
					UserImage2 = display.newImage( 
							Filename, 
							system.DocumentsDirectory,
							ImagePosition_X_2,
							ImagePosition_Y_2  
							)
					--UserImage2:scale( 0.15, 0.15 )
					UserImage2.id = Filename
					UserImage2:addEventListener( "touch", SelectImg )
					UserImage2.alpha = 0
		       		LOADING_IMG_2 = true

					ShareGroup:insert( UserImage2 )
				else
				LoadDirayImage(row.diary_pic2)
			end
		end
		]]

		if (row.diary_pic2 == nil or row.diary_pic2 == "") then
				UserImage2 = display.newImageRect( "Phuket/share/addpicture.png", 999/9, 929/9 )
				UserImage2.x = ImagePosition_X_2
				UserImage2.y = ImagePosition_Y_2
				UserImage2.id = row.diary_pic2
				--UserImage2:addEventListener( "touch", SelectImg )
				ShareGroup:insert( UserImage2 )
	     		LOADING_IMG_2 = true
	      		CheckImg2 = false
     
			else
				LoadDirayImage(row.diary_pic2)
				CheckImg2 = true
			end
-----------------------------------------3---------------------------------------------
--[[
			if (row.diary_pic3 ~= "") then

				CheckImg3 = true
				Filename = row.diary_pic3
				if (FindImg( Filename ) == true) then
					
					UserImage3 = display.newImage( 
							Filename, 
							system.DocumentsDirectory,
							ImagePosition_X_3,
							ImagePosition_Y_3 
							)
					--UserImage3:scale( 0.15, 0.15 )
					UserImage3.id = Filename
					UserImage3:addEventListener( "touch", SelectImg )
					UserImage3.alpha = 0
		       		LOADING_IMG_3 = true
					ShareGroup:insert( UserImage3 )
				else
				LoadDirayImage(row.diary_pic3)
			end
		end
		]]
		if (row.diary_pic3 == nil or row.diary_pic3 == "") then
				UserImage3 = display.newImageRect( "Phuket/share/addpicture.png", 999/9, 929/9 )
				UserImage3.x = ImagePosition_X_3
				UserImage3.y = ImagePosition_Y_3
				UserImage3.id = row.diary_pic3
				--UserImage3:addEventListener( "touch", SelectImg )
				ShareGroup:insert( UserImage3 )
	     		LOADING_IMG_3 = true
	      		CheckImg3 = false
     
			else
				LoadDirayImage(row.diary_pic3)
				CheckImg3 = true
			end
-----------------------------------------4---------------------------------------------
--[[
			if (row.diary_pic4 ~= "") then

				CheckImg4 = true
				Filename = row.diary_pic4
				if (FindImg( Filename ) == true) then
					
					UserImage4 = display.newImage( 
							Filename, 
							system.DocumentsDirectory,
							ImagePosition_X_4,
							ImagePosition_Y_4  
							)
					--UserImage4:scale( 0.15, 0.15 )
					UserImage4.id = Filename
					UserImage4:addEventListener( "touch", SelectImg )
					UserImage4.alpha = 0
		       		LOADING_IMG_4 = true
					ShareGroup:insert( UserImage4 )
				else
				LoadDirayImage(row.diary_pic4)
			end

		end
		]]
		if (row.diary_pic4 == nil or row.diary_pic4 == "") then
				UserImage4 = display.newImageRect( "Phuket/share/addpicture.png", 999/9, 929/9 )
				UserImage4.x = ImagePosition_X_4
				UserImage4.y = ImagePosition_Y_4
				UserImage4.id = row.diary_pic4
				--UserImage4:addEventListener( "touch", SelectImg )
				ShareGroup:insert( UserImage4 )
	     		LOADING_IMG_4 = true
	      		CheckImg4 = false
     
			else
				LoadDirayImage(row.diary_pic4)
				CheckImg4 = true
			end
end

--[[
		if (CheckImg1 == false) then
			print( "else1" )
			UserImage1 = display.newImageRect( "Phuket/share/addpicture.png", 999/9, 929/9 )
			UserImage1.x = ImagePosition_X_1
			UserImage1.y = ImagePosition_Y_1
			ShareGroup:insert( UserImage1 )
			LOADING_IMG_1 = true
		end

		if (CheckImg2 == false) then
			print( "else2" )
			UserImage2 = display.newImageRect( "Phuket/share/addpicture.png", 999/9, 929/9 )
			UserImage2.x = ImagePosition_X_1
			UserImage2.y = ImagePosition_Y_2
			ShareGroup:insert( UserImage2 )
			LOADING_IMG_2 = true
		end

		if (CheckImg3 == false) then
			print( "else3" )
			UserImage3 = display.newImageRect( "Phuket/share/addpicture.png", 999/9, 929/9 )
			UserImage3.x = ImagePosition_X_3
			UserImage3.y = ImagePosition_Y_3
			ShareGroup:insert( UserImage3 )
			LOADING_IMG_3 = true
		end

		if (CheckImg4 == false) then
			print( "else4" )
			UserImage4 = display.newImageRect( "Phuket/share/addpicture.png", 999/9, 929/9 )
			UserImage4.x = ImagePosition_X_4
			UserImage4.y = ImagePosition_Y_4
			ShareGroup:insert( UserImage4 )
			LOADING_IMG_4 = true
		end
		]]
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
		
		BackBtn.x = cx - 230
		BackBtn.y = cy - 110
		
		ShareBtn = widget.newButton(
    	{
	        width = 451/3.5,
	        height = 121/3.5,
	        defaultFile = "Phuket/Button/Button/share_on_fb.png",
	        overFile = "Phuket/Button/ButtonPress/share_on_fb.png",
	        id = "ShareBtn",
	        onEvent = Check
    	}
			)
		
		ShareBtn.x = cx 
		ShareBtn.y = cy + 120

		ShareGroup:insert( BackBtn )
		ShareGroup:insert( ShareBtn )

		sceneGroup:insert(ShareGroup)
	elseif (phase == "did") then
		print("Scene #share : show (did)")

		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		UserImage1:removeEventListener( "touch", SelectImg )
		UserImage2:removeEventListener( "touch", SelectImg )
		UserImage3:removeEventListener( "touch", SelectImg )
		UserImage4:removeEventListener( "touch", SelectImg )

		LOADING_IMG_1 = nil
		LOADING_IMG_2 = nil
		LOADING_IMG_3 = nil
		LOADING_IMG_4 = nil
		CheckImg1 = nil
		CheckImg2 = nil
		CheckImg3 = nil
		CheckImg4 = nil
--[[
		if (CheckImg1 == true) then
			UserImage1:removeEventListener( "touch", SelectImg )
		end

		if (CheckImg2 == true) then
			UserImage2:removeEventListener( "touch", SelectImg )
		end

		if (CheckImg3 == true) then
			UserImage3:removeEventListener( "touch", SelectImg )
		end

		if (CheckImg4 == true) then
			UserImage4:removeEventListener( "touch", SelectImg )
		end
		RemoveAll(FrameUserImage1)
		RemoveAll(FrameUserImage2)
		RemoveAll(FrameUserImage3)
		RemoveAll(FrameUserImage4)
		RemoveAll(Bg)
		RemoveAll(Tett)
		RemoveAll(BackBtn)
		RemoveAll(ShareBtn)
		--RemoveAll(UserImage1)
		--RemoveAll(UserImage2)
		--RemoveAll(UserImage3)
	--	RemoveAll(UserImage4)
		

		UserImage1:removeSelf( )
		UserImage1=nil

		UserImage2:removeSelf( )
		UserImage2=nil

		UserImage3:removeSelf( )
		UserImage3=nil

		UserImage4:removeSelf( )
		UserImage4=nil

		if (backgroundALpha) then
			RemoveAll(backgroundALpha)
		end

		
]]
		CheckSelectImg = false
		print("Scene #share : hide (will)")
	elseif (phase == "did") then
		print("Scene #share : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #share : destroy")

end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Runtime:addEventListener( "key", onKeyEvent )

return scene