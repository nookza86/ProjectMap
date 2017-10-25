local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local toast = require('plugin.toast')
require("FitImage")
require("createAcc")
require("get-data")
require ("Network-Check")
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local params, cx, cy, cw, ch
local Bg, BgText, BackBtn, SaveBtn
local ImageUser1, ImageUser2, ImageUser3, ImageUser4
local ImpressionRadioGroup, BeautyRadioGroup, CleanRadioGroup
local ImpressionRadioButton
local BeautyRadioButton
local CleanRadioButton
local PhotoPickerCheck1, PhotoPickerCheck2, PhotoPickerCheck3, PhotoPickerCheck4
local TextDesField
local AddImgListener
local NoMember, NoAtt
local CheckIsHaveDiary
local DB_diary_pic1, DB_diary_pic2, DB_diary_pic3, DB_diary_pic4
local DiaryGroup = display.newGroup()
local myText ,scrollView, Text
local LOADING_IMG_1, LOADING_IMG_2, LOADING_IMG_3,LOADING_IMG_4
local FitFrameImage
local FrameUserImage1, FrameUserImage2, FrameUserImage3, FrameUserImage4

local IsImg1Landscape = false
local IsImg2Landscape = false
local IsImg3Landscape = false
local IsImg3Landscape = false

-----------------PPhoto Picker----------------------------------------
--https://forums.coronalabs.com/topic/50270-photo-editing-and-corona-how-can-i-save-a-photo-at-full-resolution/
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

display.setStatusBar( display.HiddenStatusBar ) 

local photo		-- holds the photo object
local PhotoName
local PHOTO_FUNCTION = media.PhotoLibrary 		-- or media.SavedPhotosAlbum
-----------------------------------------------------------------------------
cx = display.contentCenterX
cy = display.contentCenterY
cw = display.contentWidth
ch = display.contentHeight
----------------------
local ImagePosition_X_1 = cx - 190
local ImagePosition_Y_1 = cy - 40

local ImagePosition_X_2 = cx - 70
local ImagePosition_Y_2 = cy - 40

local ImagePosition_X_3 = cx - 190
local ImagePosition_Y_3 = cy + 70

local ImagePosition_X_4 = cx - 70
local ImagePosition_Y_4 = cy + 70
----------------------

local function RemoveAll( event )
	if(event) then
		--print( "deletePic in scene #Diary " .. params.PlaceName  )
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
	print("Scene #Diary : create")
end

local function uploadListener( event )
   if ( event.isError ) then
      print( "Network Error." )
      print( "Status:", event.status )
      print( "Response:", event.response )

   else
      if ( event.phase == "began" ) then
         print( "Upload started" )
      elseif ( event.phase == "progress" ) then
         print( "Uploading... bytes transferred ", event.bytesTransferred )
      elseif ( event.phase == "ended" ) then
         print( "Upload ended..." )
         print( "Status:", event.status )
         print( "Response:", event.response )

      end
   end
end

local function UploadUserImage( fileName )

    local url = "http://mapofmem.esy.es/admin/api/android_upload_api/diary_upload.php"
  
    local method = "PUT"
     
    local params = {
       timeout = 60,
       progress = true,
       bodyType = "binary"
    }

    local filename = fileName .. ".jpg"
    local baseDirectory = system.DocumentsDirectory
   -- local baseDirectory = system.DocumentsDirectory 
   -- local baseDirectory = system.TemporaryDirectory
    local contentType = "image/jpge" 

    local headers = {}
    headers.filename = filename
    params.headers = headers
     
    network.upload( url , method, uploadListener, params, filename, baseDirectory, contentType )
end

local function GoS(  )

	local options = {params = {PlaceName = params.PlaceName}}
			composer.gotoScene("HomePlace", options)
			native.setActivityIndicator( false )
end

local function CallDrop(  )
	DropTableData( 2 )
end

local function DiaryListener(  )
 
    if(TextDesField.text == "" ) then
        print( "Please fill some note." )
        native.showAlert( "Fill","Please fill some note.", { "OK" } )
        return
    end
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
--[[
	local DB_DIARY_ID = 0	
	local sql3 = "SELECT diary_id FROM diary WHERE att_name = '".. params.PlaceName .."';"
		for row in db:nrows(sql2) do
			DB_DIARY_ID = row.diary_id
		end
]]
        local diary = {}

        if (CheckIsHaveDiary == true) then
        	diary["command"] = "update"
        	--diary["diary_id"] = member_no
        else
        	diary["command"] = "insert"
        end

        
        diary["member_no"] = member_no
        diary["att_no"] = NoAtt
        diary["diary_note"] = TextDesField.text
        diary["impression"] = ImpressionScore
        diary["beauty"] = BeautyScore
        diary["clean"] = CleanScore

        if (PhotoPickerCheck1 )then
			 diary["diary_pic1"] = NoAtt .. "_" .. NoMember .. "_1.jpg"
		else
			diary["diary_pic1"] = ""
		end

		if (PhotoPickerCheck2 )then
			diary["diary_pic2"] = NoAtt .. "_" .. NoMember .. "_2.jpg"
			else
			diary["diary_pic2"] = ""
		end

		if (PhotoPickerCheck3 )then
			diary["diary_pic3"] = NoAtt .. "_" .. NoMember .. "_3.jpg"
		else
			diary["diary_pic3"] = ""
		end

		if (PhotoPickerCheck4 )then
			 diary["diary_pic4"] = NoAtt .. "_" .. NoMember .. "_4.jpg"
		else
			diary["diary_pic4"] = ""
		end



        local DiarySendData = json.encode( diary )

       --myText.text = DiarySendData
        DiarySend(DiarySendData)
		native.setActivityIndicator( true )
		timer.performWithDelay( 5000, CallDrop )
        timer.performWithDelay( 5000, GoS )

        
        
end


local function Check( event )

	local options = {params = {PlaceName = params.PlaceName}}

	if(event.phase == "ended") then
		if (event.target.name == "BackBtn") then
			composer.gotoScene("HomePlace", options)
		else
			if isRechable() == false then 
 				native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
 				return
			end
--[[
			if (PhotoPickerCheck1 == false or PhotoPickerCheck2 == false or PhotoPickerCheck3 == false or PhotoPickerCheck4 == false ) then
				native.showAlert( "No photo select","Add least 1 photo.", { "OK" } )
				return
			end
]]
			if (PhotoPickerCheck1 )then
				UploadUserImage(NoAtt .. "_" .. NoMember .. "_1")
			end

			if (PhotoPickerCheck2 )then
				UploadUserImage(NoAtt .. "_" .. NoMember .. "_2")
			end

			if (PhotoPickerCheck3 )then
				UploadUserImage(NoAtt .. "_" .. NoMember .. "_3")
			end

			if (PhotoPickerCheck4 )then
				UploadUserImage(NoAtt .. "_" .. NoMember .. "_4")
			end
			
			DiaryListener(  )
		end
		
		
	end

end

local function onSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )

    if (switch.id == "ImpressionRadioButton1" or switch.id == "ImpressionRadioButton2" or switch.id == "ImpressionRadioButton3" or switch.id == "ImpressionRadioButton4" or switch.id == "ImpressionRadioButton5") then
    	print( "1" )
    	if (switch.id == "ImpressionRadioButton1") then
    		ImpressionScore = 5
    	elseif (switch.id == "ImpressionRadioButton2") then
    		ImpressionScore = 4
    	elseif (switch.id == "ImpressionRadioButton3") then
    		ImpressionScore = 3
    	elseif (switch.id == "ImpressionRadioButton4") then
    		ImpressionScore = 2
    	else
    		ImpressionScore = 1
    	end

    elseif (switch == "BeautyRadioButton1" or switch.id == "BeautyRadioButton2" or switch.id == "BeautyRadioButton3" or switch.id == "BeautyRadioButton4" or switch.id == "BeautyRadioButton5") then
    	print( "2" )
    	if (switch.id == "BeautyRadioButton1") then
    		BeautyScore = 5
    	elseif (switch.id == "BeautyRadioButton2") then
    		BeautyScore = 4
    	elseif (switch.id == "BeautyRadioButton3") then
    		BeautyScore = 3
    	elseif (switch.id == "BeautyRadioButton4") then
    		BeautyScore = 2
    	else
    		BeautyScore = 1
    	end

    else
    	print( "3" )
    	if (switch.id == "CleanRadioButton1") then
    		CleanScore = 5
    	elseif (switch.id == "CleanRadioButton2") then
    		CleanScore = 4
    	elseif (switch.id == "CleanRadioButton3") then
    		CleanScore = 3
    	elseif (switch.id == "CleanRadioButton4") then
    		CleanScore = 2
    	else
    		CleanScore = 1
    	end
    end

    print( ImpressionScore, BeautyScore, CleanScore )

end



-- Media listener
-- Executes after the user picks a photo (or cancels)
--
local sessionComplete = function(event)
	photo = event.target
	--myText.text = "sessionComplete"
	if photo then

		if photo.width > photo.height then
			--photo:rotate( -90 )			-- rotate for landscape
			print( "Rotated" )
		end
		
		-- Scale image to fit content scaled screen
		local xScale = _W / photo.contentWidth
		local yScale = _H / photo.contentHeight
		local scale = math.max( xScale, yScale ) * .75
		
		local maxWidth = 1280
		local maxHeight = 720

		photo:scale( scale, scale )
		photo.x = centerX
		photo.y = centerY
		
		print( "photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale )
		 --native.showAlert( "You Are Here", "photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale, { "OK" } )


		--rescale width
		if ( photo.width > maxWidth ) then
		   local ratio = maxWidth / photo.width
		   photo.width = maxWidth
		   photo.height = photo.height * ratio
		end
		 
		--rescale height
		if ( photo.height > maxHeight ) then
		   local ratio = maxHeight / photo.height
		   photo.height = maxHeight
		   photo.width = photo.width * ratio
		end

		display.save( photo, { filename=PhotoName..".jpg", baseDir=system.DocumentsDirectory, isFullResolution=true } )
   		if (PhotoName == NoAtt .. "_" .. NoMember .. "_1" or PhotoName == NoAtt .. "_" .. NoMember .. "_1.jpg") then
   			PhotoPickerCheck1 = true
   			RemoveAll(FrameUserImage1)
   			ImageUser1:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser1)
   			ImageUser1 = display.newImage( PhotoName..".jpg", system.DocumentsDirectory, ImagePosition_X_1, ImagePosition_Y_1, true )
   			--ImageUser1:scale(scale / 2, scale / 2 )
   			ImageUser1.name = NoAtt .. "_" .. NoMember .. "_1"
   			ImageUser1:addEventListener( "touch", AddImgListener )
   			FitFrameImage( ImageUser1 )
   			DiaryGroup:insert( ImageUser1 )
      			--TextDesField.text = "1"

   		elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_2" or PhotoName == NoAtt .. "_" .. NoMember .. "_2.jpg") then
   			PhotoPickerCheck2 = true
   			RemoveAll(FrameUserImage2)
   			ImageUser2:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser2)
   			ImageUser2 = display.newImage( PhotoName..".jpg", system.DocumentsDirectory, ImagePosition_X_2, ImagePosition_Y_2, true )
   			--ImageUser2:scale(scale / 2, scale / 2 )
   			ImageUser2.name = NoAtt .. "_" .. NoMember .. "_2"
   			ImageUser2:addEventListener( "touch", AddImgListener )
   			FitFrameImage( ImageUser2 )
   			DiaryGroup:insert( ImageUser2 )
   			--TextDesField.text = "2"

   		elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_3" or PhotoName == NoAtt .. "_" .. NoMember .. "_3.jpg") then
   			PhotoPickerCheck3 = true
   			RemoveAll(FrameUserImage3)
   			ImageUser3:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser3)
   			ImageUser3 = display.newImage( PhotoName..".jpg", system.DocumentsDirectory, ImagePosition_X_3, ImagePosition_Y_3, true )
   			--ImageUser3:scale(scale / 2, scale / 2 )
   			ImageUser3.name = NoAtt .. "_" .. NoMember .. "_3"
   			ImageUser3:addEventListener( "touch", AddImgListener )
   			FitFrameImage( ImageUser3 )
   			DiaryGroup:insert( ImageUser3 )
   			--TextDesField.text = "3"

   		else
   			PhotoPickerCheck4 = true
   			RemoveAll(FrameUserImage4)
   			ImageUser4:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser4)
   			ImageUser4 = display.newImage( PhotoName..".jpg", system.DocumentsDirectory, ImagePosition_X_4, ImagePosition_Y_4, true )
   			--ImageUser4:scale(scale / 2, scale / 2 )
   			ImageUser4.name = NoAtt .. "_" .. NoMember .. "_4"
   			ImageUser4:addEventListener( "touch", AddImgListener )
   			FitFrameImage( ImageUser4 )
   			DiaryGroup:insert( ImageUser4 )
   			--TextDesField.text = "4"

   		end

   		
   		--myText.text = PhotoName..".jpg".. photo.width .. " " .. photo.height
   		display.remove( photo )
		
	else
		if (PhotoName == NoAtt .. "_" .. NoMember .. "_1") then
   			PhotoPickerCheck1 = false
   		elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_2") then
   			PhotoPickerCheck2 = false
   		elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_3") then
   			PhotoPickerCheck3 = false
   		elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_4") then
   			PhotoPickerCheck4 = false
   		end
		--myText.text = "No Image Selected"

	end
end

function AddImgListener( event )
	PhotoName = event.target.name
	print( PhotoName )
	--TextDesField.text = PhotoName
	--myText.text = PhotoName
	media.selectPhoto( { listener = sessionComplete, baseDir = system.DocumentsDirectory, filename = PhotoName .. "jpg",mediaSource = PHOTO_FUNCTION })

end

local function loadImageListener( event )
	if(not event.isError) then
		
		print( event.response.filename, event.response.baseDirectory )
		if (event.response.filename == NoAtt .. "_" .. NoMember .. "_1.jpg") then
			
			ImageUser1 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							ImagePosition_X_1,
							ImagePosition_Y_1 
							)
			--ImageUser1:scale( 0.15, 0.15 )
			ImageUser1.name = event.response.filename
			ImageUser1:addEventListener( "touch", AddImgListener )
			ImageUser1.alpha = 0
			DiaryGroup:insert( ImageUser1 )
       		--transition.to( ImageUser1, { alpha=1.0 } )
			LOADING_IMG_1 = true
			--DiaryGroup:insert(ImageUser1)

			
		end

		if (event.response.filename == NoAtt .. "_" .. NoMember .. "_2.jpg") then

			ImageUser2 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							ImagePosition_X_2,
							ImagePosition_Y_2 
							)
			--ImageUser2:scale( 0.15, 0.15 )
			ImageUser2.name = event.response.filename
			ImageUser2:addEventListener( "touch", AddImgListener )
			ImageUser2.alpha = 0
			DiaryGroup:insert( ImageUser2 )
       		--transition.to( ImageUser2, { alpha=1.0 } )
			LOADING_IMG_2 = true
			--DiaryGroup:insert(ImageUser2)
		end

		if (event.response.filename == NoAtt .. "_" .. NoMember .. "_3.jpg") then

			ImageUser3 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							ImagePosition_X_3,
							ImagePosition_Y_3 
							)
			--ImageUser3:scale( 0.15, 0.15 )
			ImageUser3.name = event.response.filename
			ImageUser3:addEventListener( "touch", AddImgListener )
			ImageUser3.alpha = 0
			DiaryGroup:insert( ImageUser3 )
       		--transition.to( ImageUser3, { alpha=1.0 } )
			LOADING_IMG_3 = true
			--DiaryGroup:insert(ImageUser3)
			
		end

		if (event.response.filename == NoAtt .. "_" .. NoMember .. "_4.jpg") then

			ImageUser4 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							ImagePosition_X_4,
							ImagePosition_Y_4 
							)
			--ImageUser4:scale( 0.15, 0.15 )
			ImageUser4.name = event.response.filename
			ImageUser4:addEventListener( "touch", AddImgListener )
			ImageUser4.alpha = 0
			DiaryGroup:insert( ImageUser4 )
       		--transition.to( ImageUser4, { alpha=1.0 } )
			LOADING_IMG_4 = true
			--DiaryGroup:insert(ImageUser4)
		end

	end

end



local function randomFlag( event )
	if isRechable() == false then 
 		native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
 		native.setActivityIndicator( false )
 		return
	end

	local url = "http://mapofmem.esy.es/admin/api/android_upload_api/upload/diary/" ..NoAtt .."/" .. event 
	print( url )
network.download( url , 
	"GET", 
	loadImageListener,
	{},
	event,
	system.DocumentsDirectory
	)

end
local IsDone = false

local function listener( event )

    if (LOADING_IMG_1 == true and LOADING_IMG_2 == true and LOADING_IMG_3 == true and LOADING_IMG_4 == true) then
    	 if (IsDone == false) then
    	 	timer.cancel( event.source )
	    	 native.setActivityIndicator( false )
	    	 FitFrameImage( ImageUser1 )	
	    	 FitFrameImage( ImageUser2 )	
	    	 FitFrameImage( ImageUser3 )	
	    	 FitFrameImage( ImageUser4 )

--[[
	    	 if (IsImg1Landscape == true) then
	    	 	if (IsImg2Landscape == true) then
	    	 		
	    	 	end
	    	 end
]]
	    	 transition.to( ImageUser1, { alpha=1.0 } )
	    	 transition.to( ImageUser2, { alpha=1.0 } )
	    	 transition.to( ImageUser3, { alpha=1.0 } )
	    	 transition.to( ImageUser4, { alpha=1.0 } )	
	    	 print( "LOADING DONE" )
	    	 IsDone = true
    	 end

    	else
    		print( "LOADING IMG" )
    end
end

function FitFrameImage( ImageObj )
	if (ImageObj == nil or ImageObj.height == nil or ImageObj.width == nil) then
		return
	end
	local maxWidth = 340
	local maxHeight = 300

	if (ImageObj.width > ImageObj.height) then
		maxWidth = 300
		maxHeight = 260
	end

	local Fit_X_MAX = 125
	local Fit_Y_MAX = 125

	--rescale width
	if ( ImageObj.width > maxWidth ) then
		 local ratio = maxWidth / ImageObj.width
		 ImageObj.width = maxWidth
		 ImageObj.height = ImageObj.height * ratio
	end
		 
		--rescale height
	if ( ImageObj.height > maxHeight ) then
	     local ratio = maxHeight / ImageObj.height
	     ImageObj.height = maxHeight
	     ImageObj.width = ImageObj.width * ratio
	end	

	local Frame = ""
	local Fit_Y = 0
	local Fit_X = fitImage( ImageObj, Fit_X_MAX, Fit_Y_MAX, true )
	ImageObj:scale( Fit_X - 0.1, Fit_X - 0.1)
	Fit_Y = Fit_X
	
	if (ImageObj.width > ImageObj.height) then
		--Frame = "Phuket/Frame/frame_1.png"
		Fit_X = Fit_X 
		Fit_Y = Fit_Y 
	else
		--Frame = "Phuket/Frame/frame_2.png"
		Fit_X = Fit_X - 0.05
		Fit_Y = Fit_Y - 0.05
	end
	
	Frame = "Phuket/Frame/frame_1.png"

	print( "In FitFrameImage Filename: " .. ImageObj.name .. " use "..Frame )

	if (ImageObj.name == NoAtt .. "_" .. NoMember .. "_1.jpg" or ImageObj.name == NoAtt .. "_" .. NoMember .. "_1") then
		FrameUserImage1 = display.newImageRect( Frame, maxWidth, maxHeight )
		FrameUserImage1.x = ImageUser1.x
		FrameUserImage1.y = ImageUser1.y
		FrameUserImage1:scale( Fit_X, Fit_Y)
		DiaryGroup:insert( FrameUserImage1 )
		if (ImageObj.width > ImageObj.height) then
			IsImg1Landscape = true
		end

	elseif (ImageObj.name == NoAtt .. "_" .. NoMember .. "_2.jpg" or ImageObj.name == NoAtt .. "_" .. NoMember .. "_2") then
		FrameUserImage2 = display.newImageRect( Frame, maxWidth, maxHeight )
		FrameUserImage2.x = ImageUser2.x
		FrameUserImage2.y = ImageUser2.y
		FrameUserImage2:scale( Fit_X, Fit_Y )
		DiaryGroup:insert( FrameUserImage2 )
		if (ImageObj.width > ImageObj.height) then
			IsImg2Landscape = true
		end

	elseif (ImageObj.name == NoAtt .. "_" .. NoMember .. "_3.jpg" or ImageObj.name == NoAtt .. "_" .. NoMember .. "_3") then
		FrameUserImage3 = display.newImageRect( Frame, maxWidth, maxHeight )
		FrameUserImage3.x = ImageUser3.x
		FrameUserImage3.y = ImageUser3.y
		FrameUserImage3:scale( Fit_X, Fit_Y )
		DiaryGroup:insert( FrameUserImage3 )
		if (ImageObj.width > ImageObj.height) then
			IsImg3Landscape = true
		end

	elseif (ImageObj.name == NoAtt .. "_" .. NoMember .. "_4.jpg" or ImageObj.name == NoAtt .. "_" .. NoMember .. "_4") then
		FrameUserImage4 = display.newImageRect( Frame, maxWidth, maxHeight )
		FrameUserImage4.x = ImageUser4.x
		FrameUserImage4.y = ImageUser4.y
		FrameUserImage4:scale( Fit_X, Fit_Y )
		DiaryGroup:insert( FrameUserImage4 )
		if (ImageObj.width > ImageObj.height) then
			IsImg4Landscape = true
		end
	end

end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	params = event.params

    LOADING_IMG_1 = false
	LOADING_IMG_2 = false
	LOADING_IMG_3 = false
	LOADING_IMG_4 = false
	native.setActivityIndicator( true )
	timer.performWithDelay( 1000, listener, 0 )

	if (phase == "will") then
		local prevScene = composer.getSceneName( "previous" )
		composer.removeScene( prevScene )
	sceneGroup:insert( DiaryGroup )
	scrollView = widget.newScrollView(
    {
        top = 00,
        left = 0,
        width = display.contentWidth,
        height = display.contentHeight,
        scrollWidth = 0,
        scrollHeight = 0,
        --topPadding = 20,
        bottomPadding = 0,
        hideBackground = true,
       -- hideScrollBar = true,
        isBounceEnabled = false,
        verticalScrollDisabled = false,
        horizontalScrollDisabled = false
        }
    )
    scrollView:insert( sceneGroup )

		--composer.removeScene( "HomePlace" )
		
		local sqlCheck = "SELECT count(diary_id) as tt FROM diary WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"
		CheckIsHaveDiary = false
		for row in db:nrows(sqlCheck) do
			if (row.tt > 0) then
				CheckIsHaveDiary = true
			end
		end


		Bg = display.newImageRect("Phuket/Diary/bg.png", cw, ch )
		Bg.x = cx 
		Bg.y = cy
		DiaryGroup:insert( Bg )

		BgText = display.newImageRect( "Phuket/Diary/bgtext.png", 1000/4, 525/4.5)
		BgText.x = cx + 130
		BgText.y = cy - 70
		DiaryGroup:insert( BgText )

		TextDesField = native.newTextBox( BgText.x , BgText.y, BgText.width - 30, BgText.height - 30, 100 )
	    TextDesField.text = ""
	    TextDesField.hasBackground = false
	    TextDesField.isEditable = true
	    TextDesField.font = native.newFont( "Cloud-Light", 16 )
	    DiaryGroup:insert( TextDesField )

	    Text = display.newImageRect( "Phuket/Diary/text.png", 658/4, 367/4)
		Text.x = cx + 95
		Text.y = cy + 42
		DiaryGroup:insert( Text )

	    local sqlDes = "SELECT diary_note, diary_pic1, diary_pic2, diary_pic3, diary_pic4 FROM diary WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"
	    DB_diary_pic1 = ""
	    DB_diary_pic2 = ""
	    DB_diary_pic3 = ""
	    DB_diary_pic4 = ""
		for row in db:nrows(sqlDes) do
			TextDesField.text = row.diary_note
			DB_diary_pic1 = row.diary_pic1
			DB_diary_pic2 = row.diary_pic2
			DB_diary_pic3 = row.diary_pic3
			DB_diary_pic4 = row.diary_pic4
			
		end
		print( DB_diary_pic1,DB_diary_pic2,DB_diary_pic3,DB_diary_pic4 )

		local sql = "SELECT id FROM personel;"
		NoMember = ""
		for row in db:nrows(sql) do
			NoMember = row.id
		end

		local sql22 = "SELECT att_no FROM attractions WHERE att_name = '".. params.PlaceName .."';"
		print( sql22 )
		NoAtt = 0
		for row in db:nrows(sql22) do
			NoAtt = row.att_no
			print( NoAtt )
		end

		if (DB_diary_pic1 == nil or DB_diary_pic1 == "") then
			ImageUser1 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/15, 1280/15 )
			ImageUser1.x = ImagePosition_X_1
			ImageUser1.y = ImagePosition_Y_1
			ImageUser1.name = NoAtt .. "_" .. NoMember .. "_1"
			ImageUser1:addEventListener( "touch", AddImgListener )
			DiaryGroup:insert( ImageUser1 )
			PhotoPickerCheck1 = false

		else
			randomFlag(NoAtt .. "_" .. NoMember .. "_1.jpg")
			PhotoPickerCheck1 = true
		end
		
		if (DB_diary_pic2 == nil or DB_diary_pic2 == "") then
			ImageUser2 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/15 ,1280/15 )
			ImageUser2.x = cx - 80
			ImageUser2.y = ImagePosition_Y_2
			ImageUser2.name = NoAtt .. "_" .. NoMember .. "_2"
			ImageUser2:addEventListener( "touch", AddImgListener )
			DiaryGroup:insert( ImageUser2 )
			PhotoPickerCheck2 = false

		else
			randomFlag(NoAtt .. "_" .. NoMember .. "_2.jpg")
			PhotoPickerCheck2 = true
		end

		if (DB_diary_pic3 == nil or DB_diary_pic3 == "") then
			ImageUser3 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/15, 1280/15 )
			ImageUser3.x = ImagePosition_X_3
			ImageUser3.y = ImagePosition_Y_3
			ImageUser3.name = NoAtt .. "_" .. NoMember .. "_3"
			ImageUser3:addEventListener( "touch", AddImgListener )
			DiaryGroup:insert( ImageUser3 )
			PhotoPickerCheck3 = false

		else
			randomFlag(NoAtt .. "_" .. NoMember .. "_3.jpg")
			PhotoPickerCheck3 = true
		end

		if (DB_diary_pic4 == nil or DB_diary_pic4 == "") then
			ImageUser4 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/15, 1280/15 )
			ImageUser4.x = cx - 80
			ImageUser4.y = ImagePosition_Y_4
			ImageUser4.name = NoAtt .. "_" .. NoMember .. "_4"
			ImageUser4:addEventListener( "touch", AddImgListener )
			DiaryGroup:insert( ImageUser4 )
			PhotoPickerCheck4 = false

		else
			randomFlag(NoAtt .. "_" .. NoMember .. "_4.jpg")
			PhotoPickerCheck4 = true
		end

		local DB_impression = 1
		local DB_beauty = 1
		local DB_clean = 1
	    local sqlRadio = "SELECT impression, beauty, clean FROM diary WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"

		for row in db:nrows(sqlRadio) do
			DB_impression = row.impression
			DB_beauty = row.beauty
			DB_clean = row.clean

			print( DB_impression,DB_beauty,DB_clean )
		end

		local options = {
		    width = 100,
		    height = 100,
		    numFrames = 10,
		    sheetContentWidth = 400,
		    sheetContentHeight = 300
		}
		local radioButtonSheet = graphics.newImageSheet( "Phuket/Diary/sheet.png", options )

		-- Create a group for the radio button set
 	ImpressionRadioGroup = display.newGroup()
 	BeautyRadioGroup = display.newGroup()
 	CleanRadioGroup = display.newGroup()
 	
-- Create two associated radio buttons (inserted into the same display group)
	ImpressionRadioButton = {}
	local position = cx + 120
	local initialSwitch = false
	for i=1,5 do
		if (i == DB_impression) then
			initialSwitch = true
		else
			initialSwitch = false
		end
		ImpressionRadioButton[i] = widget.newSwitch(
    {
        --left = PositionLeft,
        --top = PositionTop,
        x = position,
        y = cy + 30,
        width = 25,
        height = 25,
        style = "radio",
        id = "ImpressionRadioButton".. i,
        initialSwitchState = initialSwitch,
        onPress = onSwitchPress,
        sheet = radioButtonSheet,
        frameOff = i,
        frameOn = i + 5
    }
	)
		
		position = position + 28
	end

	BeautyRadioButton = {}
	position = cx + 120
	initialSwitch = false
	for i=1,5 do
		if (i == DB_beauty) then
			initialSwitch = true
		else
			initialSwitch = false
		end
		BeautyRadioButton[i] = widget.newSwitch(
    {
        --left = 150,
        --top = 200,
        x = position ,
        y = cy + 55,
        width = 25,
        height = 25,
        style = "radio",
        id = "BeautyRadioButton".. i,
        initialSwitchState = initialSwitch,
        onPress = onSwitchPress,
        sheet = radioButtonSheet,
        frameOff = i,
        frameOn = i + 5
    }
	)
		
		position = position + 28
	end

	CleanRadioButton = {}
	position = cx + 120
	initialSwitch = false
	for i=1,5 do
		if (i == DB_clean) then
			initialSwitch = true
		else
			initialSwitch = false
		end
		CleanRadioButton[i] = widget.newSwitch(
    {
       -- left = 150,
       -- top = 200,
         x = position ,
        y = cy + 80,
        width = 25,
        height = 25,
        style = "radio",
        id = "CleanRadioButton".. i,
        initialSwitchState = initialSwitch,
        onPress = onSwitchPress,
        sheet = radioButtonSheet,
        frameOff = i,
        frameOn = i + 5
    }
	)
		
		position = position + 28
	end

	for i=1,5 do
		ImpressionRadioGroup:insert( ImpressionRadioButton[i] )	
		BeautyRadioGroup:insert( BeautyRadioButton[i] )	
		CleanRadioGroup:insert( CleanRadioButton[i] )
	end

	DiaryGroup:insert( ImpressionRadioGroup )
	DiaryGroup:insert( BeautyRadioGroup )
	DiaryGroup:insert( CleanRadioGroup )

 	ImpressionScore = 1
    BeautyScore = 1
    CleanScore = 1
	

		BackBtn = widget.newButton(
    	{
	        width = 130/3,
	        height = 101/3,
	        defaultFile = "Phuket/Button/Button/back.png",
	        overFile = "Phuket/Button/ButtonPress/back.png",
	        id = "BackBtn",
	        onEvent = Check
    	}
			)
		
		BackBtn.x = cx - 240
		BackBtn.y = cy - 130
		BackBtn.name = "BackBtn"

		SaveBtn = widget.newButton(
    	{
	        width = 291/4,
	        height = 108/4,
	        defaultFile = "Phuket/Button/Button/save.png",
	        overFile = "Phuket/Button/ButtonPress/save.png",
	        id = "SaveBtn",
	        onEvent = Check
    	}
			)
		
		SaveBtn.x = cx + 140
		SaveBtn.y = cy + 110
		SaveBtn.name = "SaveBtn"

		DiaryGroup:insert( BackBtn )
		DiaryGroup:insert( SaveBtn )

		--myText = display.newText( "Hello World!", 400, 200, native.systemFont, 36 )
		--myText:setFillColor( 1, 1, 0 )


			--[[
			scrollView:insert( ImpressionRadioGroup )
			scrollView:insert( BeautyRadioGroup )
			scrollView:insert( CleanRadioGroup )
			if (DB_diary_pic1 == nil or DB_diary_pic1 == "") then
				scrollView:insert( ImageUser1 )
			end
			if (DB_diary_pic2 == nil or DB_diary_pic2 == "") then
			scrollView:insert( ImageUser2 )
		end
		if (DB_diary_pic3 == nil or DB_diary_pic3 == "") then
			scrollView:insert( ImageUser3 )
		end
		if (DB_diary_pic4 == nil or DB_diary_pic4 == "") then
			scrollView:insert( ImageUser4 )
		end
			scrollView:insert( SaveBtn )
			scrollView:insert( BackBtn )
]]
	elseif (phase == "did") then
		print("Scene #Diary : show (did)")

		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		ImageUser1:removeEventListener( "touch", AddImgListener )
		ImageUser2:removeEventListener( "touch", AddImgListener )
		ImageUser3:removeEventListener( "touch", AddImgListener )
		ImageUser4:removeEventListener( "touch", AddImgListener )
--[[
		scrollView:remove( ImpressionRadioGroup )
		scrollView:remove( BeautyRadioGroup )
		scrollView:remove( CleanRadioGroup )

		if (DB_diary_pic1 == nil or DB_diary_pic1 == "") then
				scrollView:remove( ImageUser1 )
		end
		if (DB_diary_pic2 == nil or DB_diary_pic2 == "") then
			scrollView:remove( ImageUser2 )
		end
		if (DB_diary_pic3 == nil or DB_diary_pic3 == "") then
			scrollView:remove( ImageUser3 )
		end
		if (DB_diary_pic4 == nil or DB_diary_pic4 == "") then
			scrollView:remove( ImageUser4 )
		end
		scrollView:remove( SaveBtn )
		scrollView:remove( BackBtn )
		RemoveAll(FrameUserImage1)
		RemoveAll(FrameUserImage2)
		RemoveAll(FrameUserImage3)
		RemoveAll(FrameUserImage4)
		RemoveAll( Bg )
		RemoveAll( BgText )
		RemoveAll(TextDesField)
		RemoveAll( ImageUser1 )
		RemoveAll( ImageUser2 )
		RemoveAll( ImageUser3 )
		RemoveAll( ImageUser4 )
		RemoveAll( SaveBtn )
		RemoveAll( BackBtn )
		RemoveAll(Text)

		

	for i=1,5 do
		ImpressionRadioGroup:remove( ImpressionRadioButton[i] )	
		BeautyRadioGroup:remove( BeautyRadioButton[i] )	
		CleanRadioGroup:remove( CleanRadioButton[i] )
	end
	]]
	RemoveAll(scrollView)
	IsDone = false


		print("Scene #Diary : hide (will)")
	elseif (phase == "did") then
		print("Scene #Diary : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #Diary : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Runtime:addEventListener( "key", onKeyEvent )

return scene