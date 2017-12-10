local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local toast = require('plugin.toast')
local imgOper = require('image')
require("FitImage")
--require("createAcc")
--require("get-data")
require ("Network-Check")
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local params, cx, cy, cw, ch
local Bg, BgText, BackBtn, SaveBtn
local ImageUser1, ImageUser2, ImageUser3, ImageUser4
local CheckImg1, CheckImg2, CheckImg3, CheckImg4
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
local UPLOADING_IMG_1, UPLOADING_IMG_2, UPLOADING_IMG_3,UPLOADING_IMG_4, UPLOADING_IMG_5
local FitFrameImage
local FrameUserImage1, FrameUserImage2, FrameUserImage3, FrameUserImage4
local NowUploadFilename = ""
local IsImg1Landscape = false
local IsImg2Landscape = false
local IsImg3Landscape = false
local IsImg3Landscape = false
local CountImg = {}
CountImg[1] = 100
CountImg[2] = 200
CountImg[3] = 300
CountImg[4] = 400
local PhotoNo = 0
local PhotoArray = {}
--local myText1 = display.newText( "1", display.contentCenterX + 50, 260, native.systemFont, 16 )

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


local function GoS(  )

  local options = {params = {PlaceName = params.PlaceName}}
      composer.gotoScene("HomePlace", options)

      native.setActivityIndicator( false )
end

local function CallDrop(  )
  DropTableData( 2 )
  imgOper.CleanDir(system.TemporaryDirectory)

end

local function UploadPhotoDiarylistener( event )

    if (UPLOADING_IMG_1 == true and UPLOADING_IMG_2 == true and UPLOADING_IMG_3 == true and UPLOADING_IMG_4 == true and UPLOADING_IMG_5 == true) then
        timer.cancel( event.source )
        print( "UPLOADING DONE" )
        imgOper.CleanDir(system.TemporaryDirectory)
        imgOper.Remove( NoAtt .. "_" .. NoMember .. "_1.jpg", system.DocumentsDirectory )
        imgOper.Remove( NoAtt .. "_" .. NoMember .. "_2.jpg", system.DocumentsDirectory )
        imgOper.Remove( NoAtt .. "_" .. NoMember .. "_3.jpg", system.DocumentsDirectory )
        imgOper.Remove( NoAtt .. "_" .. NoMember .. "_4.jpg", system.DocumentsDirectory )
        timer.performWithDelay( 8000, GoS )
    else
        print( "UPLOADING IMG" )
    end

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
         --toast.show(event.bytesTransferred)
      elseif ( event.phase == "ended" ) then
         print( "Upload ended..." )
         print( "Status:", event.status )
         print( "Response:", event.response )

         --toast.show("Status : " .. event.status .. " Response : " ..  event.response)

        if (event.status == 201 or event.status == "201") then
            if (PhotoPickerCheck1 == true and event.response == NoAtt .. "_" .. NoMember .. "_1.jpg") then
                 UPLOADING_IMG_1 = true
            end

             if (PhotoPickerCheck2 == true and event.response == NoAtt .. "_" .. NoMember .. "_2.jpg") then
                 UPLOADING_IMG_2 = true
            end

             if (PhotoPickerCheck3 == true and event.response == NoAtt .. "_" .. NoMember .. "_3.jpg") then
                 UPLOADING_IMG_3 = true
            end

             if (PhotoPickerCheck4 == true and event.response == NoAtt .. "_" .. NoMember .. "_4.jpg") then
                 UPLOADING_IMG_4 = true
            end
        end

      end
   end
end

local function UploadUserImage( fileName_Upload )
  NowUploadFilename = fileName_Upload
  --toast.show(NowUploadFilename)
    local url = "http://mapofmem.esy.es/admin/api/android_upload_api/diary_upload.php"
  
    local method = "PUT"
     
    local params = {
       timeout = 60,
       progress = true,
       bodyType = "binary"
    }

    local filename = fileName_Upload .. ".jpg"
    --local baseDirectory = system.DocumentsDirectory
    local baseDirectory = system.TemporaryDirectory
    local contentType = "image/jpge" 

    local headers = {}
    headers.filename = filename
    params.headers = headers
    --myText1.text = filename
    network.upload( url , method, uploadListener, params, filename, baseDirectory, contentType )
end

local function GetDataListener( event )
  --toast.show("GetDataListener")
    if ( event.isError ) then
        print( "Network error!" )
        local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
    else

      local GetDatabase = event.response
        print( "RESPONSE: " .. event.response )
       local decodedDatabase = (json.decode( GetDatabase ))

         for idx2, val2 in ipairs(decodedDatabase) do
            local insertQuery = "INSERT INTO diary VALUES (" ..
                  val2.diary_id .. "," ..
                  val2.member_no .. "," ..
                  val2.att_no .. ",'" ..
                  val2.diary_note.. "'," .. 
                  val2.impression.. "," .. 
                  val2.beauty.. "," ..
                  val2.clean.. ",'" ..
                  val2.diary_pic1.. "','" ..
                  val2.diary_pic2.. "','" ..
                  val2.diary_pic3.. "','" ..
                  val2.diary_pic4 .. "');"

        db:exec( insertQuery )

         end
         UPLOADING_IMG_5 = true

  end
end

local function GetData( i , member_no)
  --toast.show("GetData")
  --CountGetDatabase = i
  local GetDatabase = {}
    GetDatabase["no"] = i
    GetDatabase["mem_no"] = member_no

    local GetDatabaseSend = json.encode( GetDatabase )

    local headers = {}
   
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "Number=" .. GetDatabaseSend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/retivedata.php"
     --print( CountGetDatabase.." : Login Data Sending To ".. url .." : " .. GetDatabaseSend )
    network.request( url, "POST", GetDataListener, params )
end

local function DropTableData( Table )
  --toast.show("DropTableData")
  local NOOOO = 0 
  local tablesetup = ""
  local sql2 = "SELECT id FROM personel;"
    for row in db:nrows(sql2) do
      NOOOO = row.id
    end

  tablesetup = "DELETE FROM `diary`;"

  db:exec(tablesetup)
  GetData(Table , NOOOO)

 end

local function DiarySendListener( event )
    if ( event.isError ) then
        print( "Network error!" )
        local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
    else

         myNewData = event.response
        print( "RESPONSE: " .. event.response )
        decodedData = (json.decode( myNewData ))

        ErrorCheck = decodedData["error"]
        --toast.show(ErrorCheck)
        if (ErrorCheck == true) then
            return
        else
            DropTableData( 2 )
        end
       
    end
end

local function DiarySend( DiarySend )

    local headers = {}

    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "DiarySend=" .. DiarySend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/diary.php"

    print( "Diary Data Sending To ".. url .." Web Server : " .. DiarySend )
    network.request( url, "POST", DiarySendListener, params )
end

local function DiaryListener(  )
 
    if(TextDesField.text == "" ) then
        print( "Please fill some note." )
        --native.showAlert( "Fill","Please fill some note.", { "OK" } )
        toast.show("Please fill some note.")
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

        local sql3 = "SELECT diary_pic1, diary_pic2, diary_pic3, diary_pic4 FROM diary WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"
          for row in db:nrows(sql3) do

              diary["diary_pic1"] = row.diary_pic1
              diary["diary_pic2"] = row.diary_pic2
              diary["diary_pic3"] = row.diary_pic3
              diary["diary_pic4"] = row.diary_pic4
          end

          UPLOADING_IMG_1 = false
          UPLOADING_IMG_2 = false
          UPLOADING_IMG_3 = false
          UPLOADING_IMG_4 = false
          UPLOADING_IMG_5 = false

              if (PhotoPickerCheck1 == true) then
      			     diary["diary_pic1"] = NoAtt .. "_" .. NoMember .. "_1.jpg"
              else
                  UPLOADING_IMG_1 = true
      		    end

      		    if (PhotoPickerCheck2 == true) then
      			     diary["diary_pic2"] = NoAtt .. "_" .. NoMember .. "_2.jpg"
              else
                  UPLOADING_IMG_2 = true
      		    end

          		if (PhotoPickerCheck3 == true) then
          			diary["diary_pic3"] = NoAtt .. "_" .. NoMember .. "_3.jpg"
              else
                  UPLOADING_IMG_3 = true
          		end

          		if (PhotoPickerCheck4 == true) then
          			 diary["diary_pic4"] = NoAtt .. "_" .. NoMember .. "_4.jpg"
              else
                  UPLOADING_IMG_4 = true
          		end

    --myText1.text = " " .. tostring( PhotoPickerCheck1 ) .. " " .. tostring( PhotoPickerCheck2 ) .. " " .. tostring( PhotoPickerCheck3 ) .. " " .. tostring( PhotoPickerCheck4 )
    local DiarySendData = json.encode( diary )
    DiarySend(DiarySendData)
    
		native.setActivityIndicator( true )
    timer.performWithDelay( 1000, UploadPhotoDiarylistener, 0 )
		--timer.performWithDelay( 2000, CallDrop )
    --timer.performWithDelay( 15000, GoS )

end


local function Check( event )

	local options = {params = {PlaceName = params.PlaceName}}

	if(event.phase == "ended") then
		if (event.target.name == "BackBtn") then
			composer.gotoScene("HomePlace", options)
		else
			if isRechable() == false then 
 				--native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
 				toast.show("It seems internet is not Available. Please connect to internet.")
 				return
			end
      if (CheckIsHaveDiary == false) then
  			if (PhotoPickerCheck1 == false ) then
  				if (PhotoPickerCheck2 == false ) then
  					if (PhotoPickerCheck3 == false ) then
  						if (PhotoPickerCheck4 == false ) then
  							toast.show("Please add photo at least 1.")
  							return
  						end
  					end
  				end
  			end
      end

			if (PhotoPickerCheck1 == true ) then
          local result = imgOper.reName( PhotoArray[1].."a", NoAtt .. "_" .. NoMember .. "_1"  )

          if (result == true) then
            UploadUserImage(NoAtt .. "_" .. NoMember .. "_1")
            --toast.show( "Old : " .. NoAtt .. "_" .. NoMember .. "_1 , New : " .. PhotoArray[1] .. " Result : " .. tostring( result ) )
          else
              return
          end
			end

			if (PhotoPickerCheck2 == true) then
          local result = imgOper.reName( PhotoArray[2].."b", NoAtt .. "_" .. NoMember .. "_2"  )

          if (result == true) then
            UploadUserImage(NoAtt .. "_" .. NoMember .. "_2")
            --toast.show( "Old : " .. NoAtt .. "_" .. NoMember .. "_2 , New : " .. PhotoArray[2] .. " Result : " .. tostring( result ) )
          else
              return
          end
			end

			if (PhotoPickerCheck3 == true) then
          local result = imgOper.reName( PhotoArray[3].."c", NoAtt .. "_" .. NoMember .. "_3"  )

          if (result == true) then
            UploadUserImage(NoAtt .. "_" .. NoMember .. "_3")
            --toast.show( "Old : " .. NoAtt .. "_" .. NoMember .. "_3 , New : " .. PhotoArray[3] .. " Result : " .. tostring( result ) )
          else
              return
          end
			end

			if (PhotoPickerCheck4 == true) then
         local result = imgOper.reName( PhotoArray[4].."d", NoAtt .. "_" .. NoMember .. "_4"  )

          if (result == true) then
            UploadUserImage(NoAtt .. "_" .. NoMember .. "_4")
            --toast.show( "Old : " .. NoAtt .. "_" .. NoMember .. "_4 , New : " .. PhotoArray[4] .. " Result : " .. tostring( result ) )
          else
              return
          end
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

    elseif (switch.id == "BeautyRadioButton1" or switch.id == "BeautyRadioButton2" or switch.id == "BeautyRadioButton3" or switch.id == "BeautyRadioButton4" or switch.id == "BeautyRadioButton5") then
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
    imgOper.Remove( (CountImg[PhotoNo] - 1) .. ".jpg", system.TemporaryDirectory )
		if photo.width > photo.height then
			--photo:rotate( -90 )			-- rotate for landscape
			print( "Rotated" )
		end
		
		-- Scale image to fit content scaled screen
		local xScale = _W / photo.contentWidth
		local yScale = _H / photo.contentHeight
		local scale = math.max( xScale, yScale ) * .75
		
		local maxWidth = 1500
		local maxHeight = 1500

		photo:scale( scale, scale )
		photo.x = centerX
		photo.y = centerY
		
		print( "Before photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale )
		 --native.showAlert( "You Are Here", "photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale, { "OK" } )
   --toast.show("photo w,h = " .. photo.width .. "," .. photo.height)

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
    --toast.show("After photo w,h = " .. photo.width .. "," .. photo.height)
		display.save( photo, { filename=CountImg[PhotoNo]..".jpg", baseDir=system.TemporaryDirectory, isFullResolution=true } )
    
   		if (PhotoName == NoAtt .. "_" .. NoMember .. "_1" or PhotoName == NoAtt .. "_" .. NoMember .. "_1.jpg") then
   			display.save( photo, { filename=(CountImg[PhotoNo].."a")..".jpg", baseDir=system.TemporaryDirectory, isFullResolution=true } )
        DiaryGroup:remove( FrameUserImage1 )        
   			RemoveAll(FrameUserImage1)
   			ImageUser1:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser1)
        --imgOper.Remove(NoAtt .. "_" .. NoMember .. "_1.jpg", system.TemporaryDirectory)
   			ImageUser1 = display.newImage( CountImg[PhotoNo]..".jpg", system.TemporaryDirectory, ImagePosition_X_1, ImagePosition_Y_1, true )
   			--ImageUser1:scale(scale / 2, scale / 2 )
   			ImageUser1.name = NoAtt .. "_" .. NoMember .. "_1"
   			ImageUser1:addEventListener( "touch", AddImgListener )
   			DiaryGroup:insert( ImageUser1 )
        FitFrameImage( ImageUser1 )
   			
      	--TextDesField.text = "1"
        PhotoPickerCheck1 = true
        PhotoArray[1] = CountImg[PhotoNo]
        --toast.show(PhotoArray[1])

   		elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_2" or PhotoName == NoAtt .. "_" .. NoMember .. "_2.jpg") then
   			display.save( photo, { filename=(CountImg[PhotoNo].."b")..".jpg", baseDir=system.TemporaryDirectory, isFullResolution=true } )
        DiaryGroup:remove( FrameUserImage2 )        
   			RemoveAll(FrameUserImage2)
   			ImageUser2:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser2)
        --imgOper.Remove(NoAtt .. "_" .. NoMember .. "_2.jpg", system.TemporaryDirectory )
   			ImageUser2 = display.newImage( CountImg[PhotoNo]..".jpg", system.TemporaryDirectory, ImagePosition_X_2, ImagePosition_Y_2, true )
   			--ImageUser2:scale(scale / 2, scale / 2 )
   			ImageUser2.name = NoAtt .. "_" .. NoMember .. "_2"
   			ImageUser2:addEventListener( "touch", AddImgListener )
   			DiaryGroup:insert( ImageUser2 )
        FitFrameImage( ImageUser2 )
   			
   			--TextDesField.text = "2"
        PhotoPickerCheck2 = true
        PhotoArray[2] = CountImg[PhotoNo]
        --toast.show(PhotoArray[2])

   		elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_3" or PhotoName == NoAtt .. "_" .. NoMember .. "_3.jpg") then
   			display.save( photo, { filename=(CountImg[PhotoNo].."c")..".jpg", baseDir=system.TemporaryDirectory, isFullResolution=true } )
        DiaryGroup:remove( FrameUserImage3 )
   			RemoveAll(FrameUserImage3)
   			ImageUser3:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser3)
        --imgOper.Remove(NoAtt .. "_" .. NoMember .. "_3.jpg", system.TemporaryDirectory)
   			ImageUser3 = display.newImage( CountImg[PhotoNo]..".jpg", system.TemporaryDirectory, ImagePosition_X_3, ImagePosition_Y_3, true )
   			--ImageUser3:scale(scale / 2, scale / 2 )
   			ImageUser3.name = NoAtt .. "_" .. NoMember .. "_3"
   			ImageUser3:addEventListener( "touch", AddImgListener )
   			DiaryGroup:insert( ImageUser3 )
        FitFrameImage( ImageUser3 )
   			
   			--TextDesField.text = "3"
        PhotoPickerCheck3 = true
        PhotoArray[3] = CountImg[PhotoNo]
        --toast.show(PhotoArray[3])

   		else
        display.save( photo, { filename=(CountImg[PhotoNo].."d")..".jpg", baseDir=system.TemporaryDirectory, isFullResolution=true } )
        DiaryGroup:remove( FrameUserImage4 )   			
   			RemoveAll(FrameUserImage4)
   			ImageUser4:removeEventListener( "touch", AddImgListener )
   			RemoveAll(ImageUser4)
        --imgOper.Remove(NoAtt .. "_" .. NoMember .. "_4.jpg", system.TemporaryDirectory)
   			ImageUser4 = display.newImage( CountImg[PhotoNo]..".jpg", system.TemporaryDirectory, ImagePosition_X_4, ImagePosition_Y_4, true )
   			--ImageUser4:scale(scale / 2, scale / 2 )
   			ImageUser4.name = NoAtt .. "_" .. NoMember .. "_4"
   			ImageUser4:addEventListener( "touch", AddImgListener )
        DiaryGroup:insert( ImageUser4 )
   			FitFrameImage( ImageUser4 )
   			
   			--TextDesField.text = "4"
        PhotoPickerCheck4 = true
        PhotoArray[4] = CountImg[PhotoNo]
        --toast.show(PhotoArray[4])
   		end

      --toast.show(PhotoArray[1] .. " " .. PhotoArray[2] .. " " ..  PhotoArray[3] .. " " .. PhotoArray[4])

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
      --toast.show("No Image Selected")
		--myText.text = "No Image Selected"

	end
end

function AddImgListener( event )
	PhotoName = event.target.name

  if (PhotoName == NoAtt .. "_" .. NoMember .. "_1" or PhotoName == NoAtt .. "_" .. NoMember .. "_1.jpg") then
      PhotoNo = 1
  elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_2" or PhotoName == NoAtt .. "_" .. NoMember .. "_2.jpg") then  
      PhotoNo = 2
  elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_3" or PhotoName == NoAtt .. "_" .. NoMember .. "_3.jpg") then
      PhotoNo = 3
  elseif (PhotoName == NoAtt .. "_" .. NoMember .. "_4" or PhotoName == NoAtt .. "_" .. NoMember .. "_4.jpg") then 
      PhotoNo = 4
  end 

	--print( PhotoName )
	CountImg[PhotoNo] = CountImg[PhotoNo] + 1
  --PhotoName = CountImg
	media.selectPhoto( { listener = sessionComplete, baseDir = system.TemporaryDirectory, filename = CountImg[PhotoNo] .. ".jpg",mediaSource = PHOTO_FUNCTION })

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
			ImageUser1.name = NoAtt .. "_" .. NoMember .. "_1"
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
			ImageUser2.name = NoAtt .. "_" .. NoMember .. "_2"
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
			ImageUser3.name = NoAtt .. "_" .. NoMember .. "_3"
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
			ImageUser4.name = NoAtt .. "_" .. NoMember .. "_4"
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
 		--native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
 		toast.show("It seems internet is not Available. Please connect to internet.")
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
	    	 if (CheckImg1) then
	    	 	FitFrameImage( ImageUser1 )
	    	 	transition.to( ImageUser1, { alpha=1.0 } )
	    	 end

	    	  if (CheckImg2) then
	    	 	FitFrameImage( ImageUser2 )
	    	 	transition.to( ImageUser2, { alpha=1.0 } )
	    	 end

	    	  if (CheckImg3) then
	    	 	FitFrameImage( ImageUser3 )
	    	 	transition.to( ImageUser3, { alpha=1.0 } )
	    	 end

	    	  if (CheckImg4) then
	    	 	FitFrameImage( ImageUser4 )
	    	 	transition.to( ImageUser4, { alpha=1.0 } )	
	    	 end	
	    	 print( "LOADING DONE" )
	    	 IsDone = true
    	 end
      elseif (CheckIsHaveDiary == false) then
        native.setActivityIndicator( false )
    	else
    		print("loading")
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
	--toast.show("photo w,h = " .. ImageObj.width .. "," .. ImageObj.height)
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
--[[
  LOADING_IMG_1 = false
	LOADING_IMG_2 = false
	LOADING_IMG_3 = false
	LOADING_IMG_4 = false
	]]
	native.setActivityIndicator( true )
	timer.performWithDelay( 1000, listener, 0 )

	if (phase == "will") then
    imgOper.CleanDir(system.TemporaryDirectory)
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

    PhotoPickerCheck1 = false
    PhotoPickerCheck2 = false
    PhotoPickerCheck3 = false
    PhotoPickerCheck4 = false
		
		local sqlCheck = "SELECT count(diary_id) as tt FROM diary WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"
		CheckIsHaveDiary = false
		for row in db:nrows(sqlCheck) do
			if (row.tt > 0) then
				CheckIsHaveDiary = true
			end
		end


		Bg = display.newImageRect("Phuket/Diary/bg.jpg", cw, ch )
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
	    DB_diary_pic1 = nil
	    DB_diary_pic2 = nil
	    DB_diary_pic3 = nil
	    DB_diary_pic4 = nil
		for row in db:nrows(sqlDes) do
			TextDesField.text = row.diary_note
			DB_diary_pic1 = row.diary_pic1
			DB_diary_pic2 = row.diary_pic2
			DB_diary_pic3 = row.diary_pic3
			DB_diary_pic4 = row.diary_pic4
			
		end
		print( DB_diary_pic1,DB_diary_pic2,DB_diary_pic3,DB_diary_pic4 )

		--toast.show(DB_diary_pic1 .. " " ..DB_diary_pic2 .. " " ..DB_diary_pic3 .. " " ..DB_diary_pic4)
		
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

		CheckImg1 = false
	    CheckImg2 = false
	    CheckImg3 = false
	    CheckImg4 = false
		if (DB_diary_pic1 == nil or DB_diary_pic1 == "") then
			ImageUser1 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/15, 1280/15 )
			ImageUser1.x = ImagePosition_X_1
			ImageUser1.y = ImagePosition_Y_1
			ImageUser1.name = NoAtt .. "_" .. NoMember .. "_1"
			ImageUser1:addEventListener( "touch", AddImgListener )
			DiaryGroup:insert( ImageUser1 )
      LOADING_IMG_1 = true
      CheckImg1 = false
      
			--PhotoPickerCheck1 = false

		else
			randomFlag(NoAtt .. "_" .. NoMember .. "_1.jpg")
			CheckImg1 = true
			--PhotoPickerCheck1 = true
		end
		
		if (DB_diary_pic2 == nil or DB_diary_pic2 == "") then

			ImageUser2 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/15 ,1280/15 )
			ImageUser2.x = cx - 80
			ImageUser2.y = ImagePosition_Y_2
			ImageUser2.name = NoAtt .. "_" .. NoMember .. "_2"
			ImageUser2:addEventListener( "touch", AddImgListener )
			DiaryGroup:insert( ImageUser2 )
      LOADING_IMG_2 = true
      CheckImg2 = false
      print( "2 " .. tostring( LOADING_IMG_2 ) )

			--PhotoPickerCheck2 = false

		else

			randomFlag(NoAtt .. "_" .. NoMember .. "_2.jpg")
			CheckImg2 = true
			--PhotoPickerCheck2 = true
		end

		if (DB_diary_pic3 == nil or DB_diary_pic3 == "") then
			ImageUser3 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/15, 1280/15 )
			ImageUser3.x = ImagePosition_X_3
			ImageUser3.y = ImagePosition_Y_3
			ImageUser3.name = NoAtt .. "_" .. NoMember .. "_3"
			ImageUser3:addEventListener( "touch", AddImgListener )
			DiaryGroup:insert( ImageUser3 )
      LOADING_IMG_3 = true
      CheckImg3 = false
			--PhotoPickerCheck3 = false

		else
			randomFlag(NoAtt .. "_" .. NoMember .. "_3.jpg")
			CheckImg3 = true
			--PhotoPickerCheck3 = true
		end

		if (DB_diary_pic4 == nil or DB_diary_pic4 == "") then
			ImageUser4 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/15, 1280/15 )
			ImageUser4.x = cx - 80
			ImageUser4.y = ImagePosition_Y_4
			ImageUser4.name = NoAtt .. "_" .. NoMember .. "_4"
			ImageUser4:addEventListener( "touch", AddImgListener )
			DiaryGroup:insert( ImageUser4 )
      LOADING_IMG_4 = true
      CheckImg4 = false
			--PhotoPickerCheck4 = false

		else
			randomFlag(NoAtt .. "_" .. NoMember .. "_4.jpg")
			CheckImg4 = true
			--PhotoPickerCheck4 = true
		end

		local DB_impression = 1
		local DB_beauty = 1
		local DB_clean = 1
	    local sqlRadio = "SELECT impression, beauty, clean FROM diary WHERE `att_no` IN (SELECT `att_no` FROM `attractions` WHERE `att_name` = '" .. params.PlaceName .. "');"

		for row in db:nrows(sqlRadio) do
			DB_impression = row.impression
			DB_beauty = row.beauty
			DB_clean = row.clean

      ImpressionScore = row.impression
      BeautyScore = row.beauty
      CleanScore = row.clean

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
 	

  local j = 5
-- Create two associated radio buttons (inserted into the same display group)
	ImpressionRadioButton = {}
	local position = cx + 120
	local initialSwitch = false
	for i=1,5 do
		if (j == DB_impression) then
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
    j = j - 1
	end

  j = 5
	BeautyRadioButton = {}
	position = cx + 120
	initialSwitch = false
	for i=1,5 do
		if (j == DB_beauty) then
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
    j = j - 1
	end

  j = 5
	CleanRadioButton = {}
	position = cx + 120
	initialSwitch = false
	for i=1,5 do
		if (j == DB_clean) then
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
    j = j - 1
	end

	for i=1,5 do
		ImpressionRadioGroup:insert( ImpressionRadioButton[i] )	
		BeautyRadioGroup:insert( BeautyRadioButton[i] )	
		CleanRadioGroup:insert( CleanRadioButton[i] )
	end

	DiaryGroup:insert( ImpressionRadioGroup )
	DiaryGroup:insert( BeautyRadioGroup )
	DiaryGroup:insert( CleanRadioGroup )

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
    --DiaryGroup:insert( myText1 )

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
    PhotoPickerCheck1 = false
    PhotoPickerCheck2 = false
    PhotoPickerCheck3 = false
    PhotoPickerCheck4 = false
    LOADING_IMG_1 = false
    LOADING_IMG_2 = false
    LOADING_IMG_3 = false
    LOADING_IMG_4 = false
    CheckImg1 = false
    CheckImg2 = false
    CheckImg3 = false
    CheckImg4 = false
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