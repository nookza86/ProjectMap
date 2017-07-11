local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local toast = require('plugin.toast')
require("createAcc")
require("get-data")
require ("Network-Check")
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local params, cx, cy, cw, ch
local Bg, BgText, BackBtn, SaveBtn
local ImageUser1, ImageUser2, ImageUser3, ImageUser4, ImageUser5
local TitleImage, TitleBookImage, ScoreImage
local ImpressionImage, BeautyImage, CleanImage
local ImpressionRadioGroup, BeautyRadioGroup, CleanRadioGroup
local ImpressionRadioButton
local BeautyRadioButton
local CleanRadioButton
local ImpressionScore, BeautyScore, CleanScore
local PhotoPickerCheck1, PhotoPickerCheck2, PhotoPickerCheck3, PhotoPickerCheck4
local TextDesField
local AddImgListener
local NoMember, NoAtt
local myText = display.newText( "5555555555", 100, 200, native.systemFont, 16 )
			myText:setFillColor( 1, 0, 0 ) 
local DiaryGroup = display.newGroup()

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
local function RemoveAll( event )
	if(event) then
		print( "deletePic in scene #Diary " .. params.PlaceName  )
		event:removeSelf( )
		event = nil
		
	end
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
        print( "TextDesField null" )
        native.showAlert( "Fill","Add some note.", { "OK" } )
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

        local diary = {}

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

			if (PhotoPickerCheck1 == false or PhotoPickerCheck2 == false or PhotoPickerCheck3 == false or PhotoPickerCheck4 == false ) then
				native.showAlert( "No photo select","Add least 1 photo.", { "OK" } )
				return
			end

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
    		ImpressionScore = 1
    	elseif (switch.id == "ImpressionRadioButton2") then
    		ImpressionScore = 2
    	elseif (switch.id == "ImpressionRadioButton3") then
    		ImpressionScore = 3
    	elseif (switch.id == "ImpressionRadioButton4") then
    		ImpressionScore = 4
    	else
    		ImpressionScore = 5
    	end

    elseif (switch == "BeautyRadioButton1" or switch.id == "BeautyRadioButton2" or switch.id == "BeautyRadioButton3" or switch.id == "BeautyRadioButton4" or switch.id == "BeautyRadioButton5") then
    	print( "2" )
    	if (switch.id == "BeautyRadioButton1") then
    		BeautyScore = 1
    	elseif (switch.id == "BeautyRadioButton2") then
    		BeautyScore = 2
    	elseif (switch.id == "BeautyRadioButton3") then
    		BeautyScore = 3
    	elseif (switch.id == "BeautyRadioButton4") then
    		BeautyScore = 4
    	else
    		BeautyScore = 5
    	end

    else
    	print( "3" )
    	if (switch.id == "CleanRadioButton1") then
    		CleanScore = 1
    	elseif (switch.id == "CleanRadioButton2") then
    		CleanScore = 2
    	elseif (switch.id == "CleanRadioButton3") then
    		CleanScore = 3
    	elseif (switch.id == "CleanRadioButton4") then
    		CleanScore = 4
    	else
    		CleanScore = 5
    	end
    end

    print( ImpressionScore, BeautyScore, CleanScore )

end



-- Media listener
-- Executes after the user picks a photo (or cancels)
--
local sessionComplete = function(event)
	photo = event.target
	
	if photo then

		if photo.width > photo.height then
			photo:rotate( -90 )			-- rotate for landscape
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
   		if (PhotoName == NoAtt .. "_" .. NoMember .. "_1") then
   			PhotoPickerCheck1 = true
   			ImageUser1:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser1)
   			ImageUser1 = display.newImage( PhotoName..".jpg", system.DocumentsDirectory, cx - 170, cy - 100, true )
   			ImageUser1:scale(scale , scale )
   			ImageUser1.name = NoAtt .. "_" .. NoMember .. "_1"
   			ImageUser1:addEventListener( "touch", AddImgListener )
   			DiaryGroup:insert( ImageUser1 )

   		elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_2") then
   			PhotoPickerCheck2 = true
   			ImageUser2:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser2)
   			ImageUser2 = display.newImage( PhotoName..".jpg", system.DocumentsDirectory, cx - 220, cy - 20, true )
   			ImageUser2:scale(scale / 2, scale / 2 )
   			ImageUser2.name = NoAtt .. "_" .. NoMember .. "_2"
   			ImageUser2:addEventListener( "touch", AddImgListener )
   			DiaryGroup:insert( ImageUser2 )

   		elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_3") then
   			PhotoPickerCheck3 = true
   			ImageUser3:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser3)
   			ImageUser3 = display.newImage( PhotoName..".jpg", system.DocumentsDirectory, ImageUser2.x + 50, ImageUser2.y, true )
   			ImageUser3:scale(scale / 2, scale / 2 )
   			ImageUser3.name = NoAtt .. "_" .. NoMember .. "_3"
   			ImageUser3:addEventListener( "touch", AddImgListener )
   			DiaryGroup:insert( ImageUser3 )

   		else
   			PhotoPickerCheck4 = true
   			ImageUser4:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser4)
   			ImageUser4 = display.newImage( PhotoName..".jpg", system.DocumentsDirectory, ImageUser3.x + 50, ImageUser3.y, true )
   			ImageUser4:scale(scale / 2, scale / 2 )
   			ImageUser4.name = NoAtt .. "_" .. NoMember .. "_4"
   			ImageUser4:addEventListener( "touch", AddImgListener )
   			DiaryGroup:insert( ImageUser4 )

   		end

   		
   		myText.text = PhotoName..".jpg".. photo.width .. " " .. photo.height
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
		myText.text = "No Image Selected"

	end
end

function AddImgListener( event )
	PhotoName = event.target.name
	print( PhotoName )
	media.selectPhoto( { listener = sessionComplete, baseDir = system.TemporaryDirectory, filename = PhotoName .. "jpg",mediaSource = PHOTO_FUNCTION })
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
		print( params.PlaceName )
		--DropTableData(  )
		Bg = display.newImageRect("Phuket/Diary/bg.png", cw, ch )
		Bg.x = cx 
		Bg.y = cy

		BgText = display.newImageRect( "Phuket/Diary/bgtext.png", 1000/3, 525/3)
		BgText.x = cx + 100
		BgText.y = cy - 70

		TextDesField = native.newTextBox( BgText.x , BgText.y, BgText.width - 30, BgText.height - 30, 100 )
	    TextDesField.text = ""
	    TextDesField.hasBackground = false
	    TextDesField.isEditable = true
	    TextDesField.font = native.newFont( "Cloud-Light", 16 )

		ScoreImage = display.newImageRect( "Phuket/Diary/score.png", 300/2, 80/2 )
		ScoreImage.x = cx 
		ScoreImage.y = cy + 70

		local sql = "SELECT id FROM personel;"
		NoMember = ""
		for row in db:nrows(sql) do
			NoMember = row.id
		end

		local sql = "SELECT att_no FROM attractions WHERE att_name = '".. params.PlaceName .."';"
		NoAtt = 0
		for row in db:nrows(sql) do
			NoAtt = row.att_no
		end

		ImageUser1 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/12, 1280/12 )
		ImageUser1.x = cx - 170
		ImageUser1.y = cy - 100
		ImageUser1.name = NoAtt .. "_" .. NoMember .. "_1"
		ImageUser1:addEventListener( "touch", AddImgListener )
		PhotoPickerCheck1 = false

		ImageUser2 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/30, 1280/30 )
		ImageUser2.x = cx - 220
		ImageUser2.y = cy - 20
		ImageUser2.name = NoAtt .. "_" .. NoMember .. "_2"
		ImageUser2:addEventListener( "touch", AddImgListener )
		PhotoPickerCheck2 = false

		ImageUser3 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/30, 1280/30 )
		ImageUser3.x = ImageUser2.x + 50
		ImageUser3.y = ImageUser2.y 
		ImageUser3.name = NoAtt .. "_" .. NoMember .. "_3"
		ImageUser3:addEventListener( "touch", AddImgListener )
		PhotoPickerCheck3 = false

		ImageUser4 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/30, 1280/30 )
		ImageUser4.x = ImageUser3.x + 50
		ImageUser4.y = ImageUser3.y 
		ImageUser4.name = NoAtt .. "_" .. NoMember .. "_4"
		ImageUser4:addEventListener( "touch", AddImgListener )
		PhotoPickerCheck4 = false

		ImpressionImage = display.newImageRect( "Phuket/Diary/impression.png", 450/2.5, 80/2.5 )
		ImpressionImage.x = ImageUser4.x - 20
		ImpressionImage.y = cy + 130

		BeautyImage = display.newImageRect( "Phuket/Diary/beauty.png", 300/3, 80/3 )
		BeautyImage.x = ImpressionImage.x 
		BeautyImage.y = ImpressionImage.y + 50

		CleanImage = display.newImageRect( "Phuket/Diary/clean.png", 300/3, 80/3 )
		CleanImage.x = BeautyImage.x
		CleanImage.y = BeautyImage.y + 50
	
		-- Create a group for the radio button set
 	ImpressionRadioGroup = display.newGroup()
 	BeautyRadioGroup = display.newGroup()
 	CleanRadioGroup = display.newGroup()
 
-- Create two associated radio buttons (inserted into the same display group)
	ImpressionRadioButton = {}
	local position = ImpressionImage.x + 130
	local initialSwitch = true
	for i=1,5 do
		ImpressionRadioButton[i] = widget.newSwitch(
    {
        left = 150,
        top = 200,
        x = position,
        y = cy + 130,
        style = "radio",
        id = "ImpressionRadioButton".. i,
        initialSwitchState = initialSwitch,
        onPress = onSwitchPress
    }
	)
		initialSwitch = false
		position = position + 50
	end

	BeautyRadioButton = {}
	position = BeautyImage.x + 130
	initialSwitch = true
	for i=1,5 do
		BeautyRadioButton[i] = widget.newSwitch(
    {
        left = 150,
        top = 200,
        x = position,
        y = cy + 180,
        style = "radio",
        id = "BeautyRadioButton".. i,
        initialSwitchState = initialSwitch,
        onPress = onSwitchPress
    }
	)
		initialSwitch = false
		position = position + 50
	end

	CleanRadioButton = {}
	position = CleanImage.x + 130
	initialSwitch = true
	for i=1,5 do
		CleanRadioButton[i] = widget.newSwitch(
    {
        left = 150,
        top = 200,
        x = position,
        y = cy + 230,
        style = "radio",
        id = "CleanRadioButton".. i,
        initialSwitchState = initialSwitch,
        onPress = onSwitchPress
    }
	)
		initialSwitch = false
		position = position + 50
	end

	for i=1,5 do
	ImpressionRadioGroup:insert( ImpressionRadioButton[i] )	
	BeautyRadioGroup:insert( BeautyRadioButton[i] )	
	CleanRadioGroup:insert( CleanRadioButton[i] )
end

 ImpressionScore = 1
    BeautyScore = 1
    CleanScore = 1
	

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
		
		BackBtn.x = cx - 240
		BackBtn.y = cy - 130
		BackBtn.name = "BackBtn"

		SaveBtn = widget.newButton(
    	{
	        width = 150/1.5,
	        height = 45/1.5,
	        defaultFile = "Phuket/Button/Button/save.png",
	        overFile = "Phuket/Button/ButtonPress/save.png",
	        id = "SaveBtn",
	        onEvent = Check
    	}
			)
		
		SaveBtn.x = cx 
		SaveBtn.y = cy + 280
		SaveBtn.name = "SaveBtn"

		
		ImageUser1:addEventListener( "touch", Check )
		ImageUser2:addEventListener( "touch", Check )
		ImageUser3:addEventListener( "touch", Check )
		ImageUser4:addEventListener( "touch", Check )
		


		scrollView = widget.newScrollView(
    {
        top = 70,
        left = 0,
        width = display.contentWidth,
        height = display.contentHeight,
        scrollWidth = cw,
        scrollHeight = ch,
        --topPadding = 20,
        bottomPadding = 200,
        hideBackground = true,
       -- hideScrollBar = true,
       -- isBounceEnabled = false,
        horizontalScrollDisabled = true
        }
    )

		
		local DiaryGroup = display.newGroup()
		DiaryGroup:insert( BgText )
		DiaryGroup:insert( ImageUser1 )
		DiaryGroup:insert( ImageUser2 )
		DiaryGroup:insert( ImageUser3 )
		DiaryGroup:insert( ImageUser4 )
		--DiaryGroup:insert(myText)

		DiaryGroup:insert( ScoreImage )
		DiaryGroup:insert( ImpressionImage )
		DiaryGroup:insert( BeautyImage )
		DiaryGroup:insert( CleanImage )
		DiaryGroup:insert( SaveBtn )
		DiaryGroup:insert(TextDesField)

    scrollView:insert( DiaryGroup )
    scrollView:insert( ImpressionRadioGroup )
    scrollView:insert( BeautyRadioGroup )
    scrollView:insert( CleanRadioGroup )

	elseif (phase == "did") then
		print("Scene #Diary : show (did)")

		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		scrollView:remove( DiaryGroup )
	    scrollView:remove( ImpressionRadioGroup )
	    scrollView:remove( BeautyRadioGroup )
	    scrollView:remove( CleanRadioGroup )

	    DiaryGroup:remove( BgText )
		DiaryGroup:remove( ImageUser1 )
		DiaryGroup:remove( ImageUser2 )
		DiaryGroup:remove( ImageUser3 )
		DiaryGroup:remove( ImageUser4 )
		--DiaryGroup:remove( myText )

		DiaryGroup:remove( ScoreImage )
		DiaryGroup:remove( ImpressionImage )
		DiaryGroup:remove( BeautyImage )
		DiaryGroup:remove( CleanImage )
		DiaryGroup:remove( SaveBtn )

		RemoveAll( Bg )
		RemoveAll( BgText )
		RemoveAll( ImageUser1 )
		RemoveAll( ImageUser2 )
		RemoveAll( ImageUser3 )
		RemoveAll( ImageUser4 )
		RemoveAll( ImageUser5)
		RemoveAll( ScoreImage )
		RemoveAll( ImpressionImage )
		RemoveAll( BeautyImage )
		RemoveAll( CleanImage )
		RemoveAll( SaveBtn )
		RemoveAll( BackBtn )
		
		
		RemoveAll(myText)
		RemoveAll( DiaryGroup )
		RemoveAll( scrollView )

	for i=1,5 do
		ImpressionRadioGroup:remove( ImpressionRadioButton[i] )	
		BeautyRadioGroup:remove( BeautyRadioButton[i] )	
		CleanRadioGroup:remove( CleanRadioButton[i] )
	end


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

return scene