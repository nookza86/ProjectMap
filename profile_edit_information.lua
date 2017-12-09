local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local json = require ("json")
local mime = require( "mime" )
local lfs = require( "lfs" )
local toast = require('plugin.toast')
local imgOper = require('image')
require("createAcc")
require ("Network-Check")
require ("get-data")
require("FitImage")
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)

local txfFirstName, txfLastName, txfPassword, txfConfirmPassword, txfEmail, BirthDay, BirthMonth, BirthYear, Gender, Country
local PicUser, PicTitle, PicFirstName, PicLastName, PicPassword, PicConfirmPassword, PicEmail, PicBirthDay, PicGender, PicCountry
local PictxfFirstName, PictxfLastName, PictxfPassword, PictxfConfirmPassword, PictxfEmail
local Bg, CreateBtn, BackBtn
local cx, cy
local ImageGroup, txfGroup
local ImageGroup = display.newGroup()
local GenderPickerWheel, BirthPickerWheel, CountryPickerWheel
local FrameGender, FrameBirth, FrameCountry
local BoxGender, BoxBirth, BoxCountry
local GenderTitle, BirthTitle, CountryTitle
local CheckPasswordMatch, CheckEmail
local myNewData, decodedData
local PhotoName, PhotoPickerCheck
local SelectImg, mask, ProfileFrame
local myText, scrollView
local CountImg = 100000

-----------------PPhoto Picker----------------------------------------
--https://forums.coronalabs.com/topic/50270-photo-editing-and-corona-how-can-i-save-a-photo-at-full-resolution/
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

display.setStatusBar( display.HiddenStatusBar ) 

local photo     -- holds the photo object
local PhotoName
local PHOTO_FUNCTION = media.PhotoLibrary       -- or media.SavedPhotosAlbum
-----------------------------------------------------------------------------            
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function RemoveAll( event )
    if(event) then
        --print( "deletePic in scene #Register " )
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

    if(event.phase == "ended") then
        if (event.target.id == "BackBtn") then
            composer.gotoScene( "profile" )
        elseif(event.target.id == "UpdateBtn") then
            print( "update" )
        end
    end
    
end

local function textFieldHandler( event )

    if (event.target.name == "txfEmail" and string.len( txfEmail.text ) > 0) then
        CheckEmail = false
        if (txfEmail.text:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")) then
            CheckEmail = true
            print("VALID EMAIL")
        else
            CheckEmail = false
             print("INVALID EMAIL")                
        end
    end

end

local function GoS(  )
  composer.gotoScene( "profile" )
  
end

local function loadProfileImageListener( event )

	if ( event.isError ) then
        print( "Network error: ", event.response )
 
    elseif ( event.phase == "began" ) then
        if ( event.bytesEstimated <= 0 ) then
            print( "Download starting, size unknown" )
        else
            print( "Download starting, estimated size: " .. event.bytesEstimated )
        end
 
    elseif ( event.phase == "progress" ) then
        if ( event.bytesEstimated <= 0 ) then
            print( "Download progress: " .. event.bytesTransferred )
        else
            print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )

        end
         
    elseif ( event.phase == "ended" ) then
        print( "Download complete, total bytes transferred: " .. event.bytesTransferred )
        composer.gotoScene( "profile" )
        native.setActivityIndicator( false )
		
    end

end

local function LoadUserImg( NOOOO )
	local url = "http://mapofmem.esy.es/admin/api/android_upload_api/upload/profile/" .. NOOOO ..".jpg"
	print( url )
network.download( url , 
	"GET", 
	loadProfileImageListener,
	{},
	NOOOO..".jpg",
	system.DocumentsDirectory
	)

end

local function uploadListener( event )
    --toast.show("uploadListener")
   if ( event.isError ) then
      print( "Network Error." )
      print( "Status:", event.status )
      print( "Response:", event.response )
       --myText.text = "Status:" .. event.status .. " Response: " .. event.response
    --toast.show("Network Error, Try again.")

   else
      if ( event.phase == "began" ) then
         print( "Upload started" )
      elseif ( event.phase == "progress" ) then
         print( "Uploading... bytes transferred ", event.bytesTransferred )
      elseif ( event.phase == "ended" ) then
         print( "Upload ended..." )
         print( "Status:", event.status )
         print( "Response:", event.response )
      local id = 0   
        for row in db:nrows("SELECT id FROM personel;") do
        	id = row.id
            imgOper.Remove( row.id .. ".jpg", system.DocumentsDirectory  )
        end

         --imgOper.Remove( PhotoName .. ".jpg", system.DocumentsDirectory  )

         imgOper.CleanDir(system.TemporaryDirectory)
         LoadUserImg( id )
         --timer.performWithDelay( 5000, GoS )

      end
   end
end

local function UploadUserImage( MemberNo )
    --[[
    local MemNo = 0

    for row in db:nrows("SELECT id FROM personel;") do
        MemNo = row.id
    end
]]
    local url = "http://mapofmem.esy.es/admin/api/android_upload_api/register_upload.php"
  
    local method = "PUT"
     
    local params = {
       timeout = 60,
       progress = true,
       bodyType = "binary"
    }

    local filename = "".. MemberNo ..".jpg"
    --toast.show("Upload img name : " .. filename)
    --local baseDirectory = system.ResourceDirectory
    --local baseDirectory = system.DocumentsDirectory 
    local baseDirectory = system.TemporaryDirectory
    local contentType = "image/jpge" 

    local headers = {}
    headers.filename = filename
    params.headers = headers
     --myText.text = "with file name " .. filename
     print( "Upload User Image To " .. url .." with file name " .. filename )
    network.upload( url , method, uploadListener, params, filename, baseDirectory, contentType )
end

local function networkListener( event )
    
    if ( event.isError ) then
        print( "Network error!" )

    else
        print( "RESPONSE: " .. event.response )
        --native.setActivityIndicator( false )

        myNewData = event.response
        decodedData = (json.decode( myNewData ))

        if (decodedData["error"] == false) then

            local MemberNo 
            for row in db:nrows("SELECT id FROM personel;") do
                MemberNo = row.id
            end
            DropTableData( 4 )
            local Result_Rename = imgOper.reName( PhotoName, MemberNo  )

            if ( Result_Rename == true ) then
                UploadUserImage( MemberNo )
                native.setActivityIndicator( true )
                --toast.show("true " .. MemberNo)
            else
                native.setActivityIndicator( false )
                toast.show("Try again")
            end

        else
            native.setActivityIndicator( false )
            ---native.showAlert( "Error","Try again.", { "OK" } )
            toast.show("Error. Try again")
        end
    end
end

function CreateAccountSendListener( EditProfileSend )
    local headers = {}

    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "EditProfileSend=" .. EditProfileSend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/profile_edit.php"
    
    print( "Register Data Sending To ".. url .." Web Server : " .. EditProfileSend )
    network.request( url, "POST", networkListener, params )
end

local function CreateAccountListener( event )

    if isRechable() == false then 
        --native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
        toast.show("It seems internet is not Available. Please connect to internet.")
        return
    end

    if(event.phase == "began") then
        native.setActivityIndicator( true )
        local GenderPickerValues = GenderPickerWheel:getValues()
        local BirthPickerValues = BirthPickerWheel:getValues()
        local CountryPickerValues = CountryPickerWheel:getValues()

        local GenderValue = GenderPickerValues[1].value
        local BirthMonthValue = BirthPickerValues[1].index
        local BirthDayValue = BirthPickerValues[2].value
        local BirthYearValue = BirthPickerValues[3].value
        local CountryValue = CountryPickerValues[1].value

        for row in db:nrows("SELECT id FROM personel;") do
                ID_USER = row.id
        end

        local EditProfile = {}
        EditProfile["member_no"] = ID_USER
        EditProfile["fname"] = txfFirstName.text
        EditProfile["lname"] = txfLastName.text
        EditProfile["email"] = txfEmail.text
       -- EditProfile["password"] = txfPassword.text
        EditProfile["gender"] = GenderValue
        EditProfile["BirthMonth"] = BirthMonthValue
        EditProfile["BirthDay"] = BirthDayValue
        EditProfile["BirthYear"] = BirthYearValue
        EditProfile["Country"] = CountryValue
        --EditProfile["UserFrom"] = "0"
        --EditProfile["UserImage"] = "/img_path/user.jpg"

        local EditProfileSend = json.encode( EditProfile )
        
        CreateAccountSendListener(EditProfileSend)

    end
end

local SelectImageListener = function(event)
    photo = event.target
    
    if photo then
        imgOper.Remove( (PhotoName - 1) ..".jpg", system.TemporaryDirectory)
        if photo.width > photo.height then
           -- photo:rotate( -90 )         -- rotate for landscape
            print( "Rotated" )
        end
        
        -- Scale image to fit content scaled screen
        local xScale = _W / photo.contentWidth
        local yScale = _H / photo.contentHeight
        local scale = math.max( xScale, yScale ) * .75
        
        local maxWidth = imgOper.getWidth(  )
        local maxHeight = imgOper.getHeight(  )
        --local ScaleProFile = 0

        --photo:scale( scale, scale )
        photo.x = centerX
        photo.y = centerY
        --myText.text =  "photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale
        print( "photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale )

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

        
            PhotoPickerCheck1 = true
            PicUser:removeEventListener( "touch", SelectImg )
            --RemoveAll(PicUser)

            if (mask) then
                PicUser:setMask( nil )
                mask = nil
                --RemoveAll(ProfileFrame)
                ProfileFrame:removeSelf( )
                ProfileFrame = nil
            end
            PicUser:removeSelf( )
            PicUser = nil

            local ID_USER = 0

            for row in db:nrows("SELECT id FROM personel;") do
                ID_USER = row.id
            end
            
            display.save( photo, { filename=PhotoName..".jpg", baseDir=system.TemporaryDirectory, isFullResolution=true } )
            display.remove( photo )

            PicUser = display.newImage( PhotoName..".jpg", system.TemporaryDirectory, cx - 165, cy - 80, true )
            PicUser:scale(0.2  , 0.2  )
            PicUser.name = ID_USER
            PicUser:addEventListener( "touch", SelectImg )
            local markX = 1.5
                local markY = 1.5
                print( PicUser.height, PicUser.width )
                if ( PicUser.height < 512 and PicUser.width < 512) then
                    local Fit = fitImage( PicUser, 512, 512, true )
                    PicUser:scale(Fit, Fit)
                    markX = 0.28
                    markY = 0.28
                    print( markX, markY )
                    else
                    markX = 2
                    markY = 2
                end

            mask = graphics.newMask( "cc.png" )
             
            PicUser:setMask( mask )
            
            PicUser.maskX = 1
            --PicUser.maskY = 1
            --PicUser.maskRotation = 20
            PicUser.maskScaleX = markX
            PicUser.maskScaleY = markY

            ProfileFrame = display.newImageRect( "Phuket/Overview/profilebut.png", 190*0.7, 187*0.7 )
            ProfileFrame.x = PicUser.x 
            ProfileFrame.y = PicUser.y + 6
            ImageGroup:insert( PicUser )
            ImageGroup:insert( ProfileFrame )

    else
        PhotoPickerCheck = false
        --myText.text = "No Image Selected"
        --toast.show("else")
    end
end

function SelectImg( event )
     --PhotoName = event.target.name
     CountImg = CountImg + 1
     PhotoName = CountImg

     media.selectPhoto( { listener = SelectImageListener, baseDir = system.TemporaryDirectory, filename = PhotoName .. ".jpg",mediaSource = PHOTO_FUNCTION })   
end

local function loadImageListener( event )
    if(not event.isError) then
        native.setActivityIndicator( true )
        print( event.response.filename, event.response.baseDirectory )
            PicUser = display.newImage( 
                            event.response.filename, 
                            event.response.baseDirectory,
                            cx - 180,
                            cy - 75 
                            )
                PicUser:scale( 0.2, 0.2 )
                PicUser.name = "profile"

                local markX = 1.5
                local markY = 1.5
                print( PicUser.height, PicUser.width )
                if ( PicUser.height < 512 and PicUser.width < 512) then
                    local Fit = fitImage( PicUser, 425, 425, true )
                    PicUser:scale(Fit, Fit)
                    markX = 0.28
                    markY = 0.28
                    print( markX, markY )
                end
                

           if PicUser.width > PicUser.height then
            --PicUser:rotate( -90 )           -- rotate for landscape
            print( "Rotated" )
        end
        
        -- Scale image to fit content scaled screen
        local xScale = cw / PicUser.contentWidth
        local yScale = ch / PicUser.contentHeight
        local scale = math.max( xScale, yScale ) * .75
        
        local maxWidth = 512
        local maxHeight = 512
        local ScaleProFile = 0

        --rescale width
        if ( PicUser.width > maxWidth ) then
           local ratio = maxWidth / PicUser.width
           PicUser.width = maxWidth
           PicUser.height = PicUser.height * ratio
           ScaleProFile = scale / 2.5
        end
         
        --rescale height
        if ( PicUser.height > maxHeight ) then
           local ratio = maxHeight / PicUser.height
           PicUser.height = maxHeight
           PicUser.width = PicUser.width * ratio
           ScaleProFile = scale
        end

        --PicUser:scale( ScaleProFile, ScaleProFile )
         mask = graphics.newMask( "cc.png" )
         --local mask = graphics.newMask( "Phuket/Overview/profilebut.png" )
             
            PicUser:setMask( mask )
            
            PicUser.maskX = 1
            --PicUser.maskY = 1
            --PicUser.maskRotation = 20
            PicUser.maskScaleX = markX
            PicUser.maskScaleY = markY

            print( PicUser.width, PicUser.height )

    ProfileFrame = display.newImageRect( "Phuket/Overview/profilebut.png", 190*0.7, 187*0.7 )
    ProfileFrame.x = PicUser.x 
    ProfileFrame.y = PicUser.y + 6
    ProfileFrame.name = "profile"
    PicUser:addEventListener( "touch", SelectImg )
    ImageGroup:insert( PicUser )
    ImageGroup:insert( ProfileFrame )
    
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
    print("Scene #Overview : create")
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    if (phase == "will") then
    cx = display.contentCenterX
    cy = display.contentCenterY
    cw = display.contentWidth
    ch = display.contentHeight
    imgOper.CleanDir(system.TemporaryDirectory)
    local prevScene = composer.getSceneName( "previous" )

        if (prevScene ~= nil) then
            composer.removeScene( prevScene )
        end

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
    ImageGroup:insert( scrollView )

    Bg = display.newImageRect( "Phuket/Profile/bg.jpg", cw , ch  )
    Bg.x = cx
    Bg.y = cy 

    PicFirstName = display.newImageRect( "Phuket/CreateAccount/box.png", 120, 25 )
    PicFirstName.x = cx 
    PicFirstName.y = cy - 90

    PicLastName = display.newImageRect( "Phuket/CreateAccount/box.png", 120, 25 )
    PicLastName.x = PicFirstName.x + 130
    PicLastName.y = PicFirstName.y

    PicEmail = display.newImageRect( "Phuket/CreateAccount/box.png", 250, 25 )
    PicEmail.x = PicFirstName.x + 65
    PicEmail.y = PicFirstName.y + 50

    txfFirstName = native.newTextField( PicFirstName.x  , PicFirstName.y, PicFirstName.width - 10, PicFirstName.height - 10 )
    txfFirstName.inputType = "default"
    txfFirstName.text = ""
    txfFirstName.hasBackground = false
    txfFirstName.placeholder = "Firstname"

    txfLastName = native.newTextField( PicLastName.x  , PicLastName.y, PicLastName.width - 10, PicLastName.height - 10 )
    txfLastName.inputType = "default"
    txfLastName.text = ""
    txfLastName.hasBackground = false
    txfLastName.placeholder = "Lastname"

    txfEmail = native.newTextBox( PicEmail.x  , PicEmail.y, PicEmail.width - 10, PicEmail.height - 10 )
    txfEmail.inputType = "email"
    txfEmail.text = ""
    txfEmail.hasBackground = false
    txfEmail.name = "txfEmail"
    txfEmail.placeholder = "Email"
    txfEmail.isEditable = false
    txfEmail.size = 12

    txfEmail:addEventListener("userInput", textFieldHandler)
    local gender = ""
    local dob = ""
    local country = ""
    local id = 0
     for row in db:nrows("SELECT id, img, fname, lname, email, gender, dob, country FROM personel;") do
            id = row.id
            txfFirstName.text = row.fname   
            txfLastName.text = row.lname
            txfEmail.text = row.email
            gender = row.gender
            dob = row.dob
            country = row.country
            Filename = row.img

            if (row.img == "") then
                PicUser = display.newImageRect( "Phuket/CreateAccount/Addpic.png", 386/3, 388/3 )
                PicUser.x = cx - 195
                PicUser.y = cy - 80
                PicUser:addEventListener( "touch", SelectImg )
                PicUser.name = "PIC"
     
            elseif (FindImg( Filename ) == true) then  
                PicUser = display.newImage( 
                            row.img, 
                            system.DocumentsDirectory,
                            cx - 165,
                            cy - 75 
                            )
                PicUser:scale( 0.2, 0.2 )
                PicUser.name = id
                PicUser:addEventListener( "touch", SelectImg )

                local markX = 1.5
                local markY = 1.5
                print( PicUser.height, PicUser.width )
                if ( PicUser.height < 512 and PicUser.width < 512) then
                    local Fit = fitImage( PicUser, 512, 512, true )
                    PicUser:scale(Fit, Fit)
                    markX = 0.28
                    markY = 0.28
                    print( markX, markY )
                    else
                    markX = 1.5
                    markY = 1.5
                end
            end
        end

        -- Scale image to fit content scaled screen
        local xScale = cw / PicUser.contentWidth
        local yScale = ch / PicUser.contentHeight
        local scale = math.max( xScale, yScale ) * .75
        
        local maxWidth = 512
        local maxHeight = 512
        local ScaleProFile = 0
        
        --rescale width
        if ( PicUser.width > maxWidth ) then
           local ratio = maxWidth / PicUser.width
           PicUser.width = maxWidth
           PicUser.height = PicUser.height * ratio
           ScaleProFile = scale 
        end
         
        --rescale height
        if ( PicUser.height > maxHeight ) then
           local ratio = maxHeight / PicUser.height
           PicUser.height = maxHeight
           PicUser.width = PicUser.width * ratio
           ScaleProFile = scale / 1.7
        end
        if ( PicUser.height < 512 and PicUser.width < 512) then
                    
                    markX = 0.28
                    markY = 0.28
                    print( markX, markY )
                else
                    markX = 1.5
                    markY = 1.5
        end
        --PicUser:scale( ScaleProFile, ScaleProFile )
         local mask = graphics.newMask( "cc.png" )
         --local mask = graphics.newMask( "Phuket/Overview/profilebut.png" )
             
            PicUser:setMask( mask )
            
            PicUser.maskX = 1
            --PicUser.maskY = 1
            --PicUser.maskRotation = 20
            PicUser.maskScaleX = markX
            PicUser.maskScaleY = markY

            print( markX, markY )

            ProfileFrame = display.newImageRect( "Phuket/Overview/profilebut.png", 190*0.6, 187*0.6 )
    ProfileFrame.x = PicUser.x 
    ProfileFrame.y = PicUser.y + 5 
    ProfileFrame.name = "profile"

    --scrollView:insert( PicUser )


    CreateBtn = widget.newButton(
        {
            width = 457/4,
            height = 121/4,
            defaultFile = "Phuket/Button/Button/update.png",
            overFile = "Phuket/Button/ButtonPress/update.png",
            id = "CreateBtn",
            onEvent = CreateAccountListener
        }
            )
        
    CreateBtn.x = cx 
    CreateBtn.y = cy + 138

    BackBtn = widget.newButton(
        {
            width = 130/3.5,
            height = 101/3.5,
            defaultFile = "Phuket/Button/Button/close.png",
            overFile = "Phuket/Button/ButtonPress/close.png",
            id = "BackBtn",
            onEvent = Check
        }
            )
        
        BackBtn.x = cx + 240
        BackBtn.y = cy - 138
   
------------------------------- Gender ------------------------------------------------
    local GenderStartIndex = 1
    if (gender == "Female") then
        GenderStartIndex = 2
    end
    local columnGenderData = { 
        {
            align = "center",
            width = 50,
            startIndex = GenderStartIndex,
            labels = {"Male", "Female"},
        }
    }
 
    -- Create the widget
    GenderPickerWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX - 210,
        y = display.contentCenterY + 50,
        --top = display.contentHeight - 120,
        columns = columnGenderData,
        style = "resizable",
        width = 50,
        rowHeight = 20,
        --onValueSelected = s,
        fontSize = 12
    })  

    FrameGender = display.newImageRect( "Phuket/CreateAccount/FrameGender.png", GenderPickerWheel.width + 15, GenderPickerWheel.height + 20 )
    FrameGender.x = GenderPickerWheel.x
    FrameGender.y = GenderPickerWheel.y

    BoxGender = display.newImageRect( "Phuket/CreateAccount/t1.png", 70, 25 )
    BoxGender.x = GenderPickerWheel.x
    BoxGender.y = GenderPickerWheel.y - 40

    GenderTitle = display.newImageRect( "Phuket/CreateAccount/gender.png", 168/3, 47/3)
    GenderTitle.x = BoxGender.x + 2
    GenderTitle.y = BoxGender.y - 2

------------------------------- Birth ------------------------------------------------
    local MonthsStartIndex = tonumber( dob:sub( 7, -4 ) )
    local DaysStartIndex = tonumber( dob:sub( 10 ) )
    local YearsSubStartIndex = tonumber( dob:sub( 1, -7 ) )
    local YearsStartIndex = 1

    local days = {}
    local years = {}
    for i = 1,31 do days[i] = i end
    for j = 1,47 do years[j] = 1970+j end

    for i=1, #years do
        if (years[i] == YearsSubStartIndex) then
            YearsStartIndex = i
        end
    end

    local columnBirthData = { 
        {
            align = "right",
            width = 70,
            startIndex = MonthsStartIndex,
            labels = {
                "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" 
            },
        },
        {
            align = "right",
            width = 30,
            startIndex = DaysStartIndex,
            labels = days,
        },
        {
            align = "right",
            width = 50,
            startIndex = YearsStartIndex,
            labels = years,
        }
    }


 
    -- Create the widget
    BirthPickerWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX - 70,
        y = display.contentCenterY + 50,
        --top = display.contentHeight - 120,
        columns = columnBirthData,
        style = "resizable",
        width = 160,
        rowHeight = 20,
        --onValueSelected = s,
        fontSize = 12
    })  

    FrameBirth = display.newImageRect( "Phuket/CreateAccount/FrameBirth.png", BirthPickerWheel.width + 15, BirthPickerWheel.height + 20 )
    FrameBirth.x = BirthPickerWheel.x
    FrameBirth.y = BirthPickerWheel.y

    BoxBirth = display.newImageRect( "Phuket/CreateAccount/t2.png", 160, 25 )
    BoxBirth.x = BirthPickerWheel.x
    BoxBirth.y = BirthPickerWheel.y - 45

    BirthTitle = display.newImageRect( "Phuket/CreateAccount/birth.png", 228/3, 37/3)
    BirthTitle.x = BoxBirth.x
    BirthTitle.y = BoxBirth.y 

------------------------------- Country ------------------------------------------------
    local CountrysStartIndex = 1
    local countrys = {"Afghanistan","Albania","Algeria","Andorra","Angola","Antigua and Barbuda","Argentina","Armenia","Australia",
                "Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin",
                "Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi",
                "Cabo Verde","Cambodia","Cameroon","Canada","Central African Republic","Chad","Chile","China","Colombia",
                "Comoros","Democratic Republic of the Congo","Republic of the Congo","Costa Rica","Cote d'Ivoire","Croatia",
                "Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt",
                "El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Fiji","Finland","France","Gabon","Gambia",
                "Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras",
                "Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan",
                "Kazakhstan","Kenya","Kiribati","Kosovo","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia",
                "Libya","Liechtenstein","Lithuania","Luxembourg","Macedonia","Madagascar","Malawi","Malaysia","Maldives",
                "Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia",
                "Montenegro","Morocco","Mozambique","Myanmar","Namibia","Nauru","Nepal","Netherlands","New Zealand",
                "Nicaragua","Niger","Nigeria","North Korea","Norway","Oman","Pakistan","Palau","Palestine","Panama","Papua New Guinea",
                "Paraguay","Peru","Philippines","Poland","Portugal","Qatar","Romania","Russia","Rwanda","Saint Kitts and Nevis",
                "Saint Lucia","Saint Vincent and the Grenadines","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia",
                "Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia",
                "South Africa","South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Swaziland","Sweden",
                "Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor-Leste","Togo","Tonga","Trinidad and Tobago",
                "Tunisia","Turkey","Turkmenistan","Tuvalu","Uganda","Ukraine","United Arab Emirates","United Kingdom",
                "United States of America","Uruguay","Uzbekistan","Vanuatu","Vatican City","Venezuela",
                "Vietnam","Yemen","Zambia","Zimbabwe"}
    

    for i=1, #countrys do
        if (countrys[i] == country) then
            CountrysStartIndex = i
        end
    end
   local columnCountryData = { 
        {
            align = "center",
            width = 200,
            startIndex = CountrysStartIndex,
            labels = countrys,
        }
    }


 
    -- Create the widget
    CountryPickerWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX + 140,
        y = display.contentCenterY + 50,
        --top = display.contentHeight - 120,
        columns = columnCountryData,
        style = "resizable",
        width = 200,
        rowHeight = 20,
        --onValueSelected = s,
        fontSize = 12
    })  

    FrameCountry = display.newImageRect( "Phuket/CreateAccount/FrameCountry.png", CountryPickerWheel.width + 15, CountryPickerWheel.height + 20 )
    FrameCountry.x = CountryPickerWheel.x
    FrameCountry.y = CountryPickerWheel.y

    BoxCountry = display.newImageRect( "Phuket/CreateAccount/t3.png", 180, 25 )
    BoxCountry.x = CountryPickerWheel.x
    BoxCountry.y = CountryPickerWheel.y - 46

    CountryTitle = display.newImageRect( "Phuket/CreateAccount/country.png", 187/3, 47/3)
    CountryTitle.x = BoxCountry.x
    CountryTitle.y = BoxCountry.y 

        ImageGroup:insert(Bg)
        ImageGroup:insert(PicUser)
        ImageGroup:insert(ProfileFrame)
        ImageGroup:insert(PicFirstName)
        ImageGroup:insert(PicLastName)
        ImageGroup:insert(PicEmail)
        
        ImageGroup:insert(CreateBtn)
        ImageGroup:insert(BackBtn)

        ImageGroup:insert(txfFirstName)
        ImageGroup:insert(txfLastName)
        ImageGroup:insert(txfEmail)

        ImageGroup:insert(CountryPickerWheel)
        ImageGroup:insert(BirthPickerWheel)
        ImageGroup:insert(GenderPickerWheel)
        ImageGroup:insert(FrameGender)
        ImageGroup:insert(FrameCountry)
        ImageGroup:insert(FrameBirth)
        ImageGroup:insert(BoxBirth)
        ImageGroup:insert(BoxCountry)
        ImageGroup:insert(BoxGender)
        ImageGroup:insert(GenderTitle)
        ImageGroup:insert(CountryTitle)
        ImageGroup:insert(BirthTitle)

        sceneGroup:insert( ImageGroup )    

    elseif (phase == "did") then
        print("Scene Overview : show (did)")
    
        
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
    if (phase == "will") then
--[[
        RemoveAll(PicUser)
        RemoveAll(PicTitle)
        RemoveAll(PicFirstName)
        RemoveAll(PicLastName)
        --RemoveAll(PicPassword)
        --RemoveAll(PicConfirmPassword)
        RemoveAll(PicEmail)
        RemoveAll(PicBirthDay)
        RemoveAll(PicGender)
        RemoveAll(PicCountry)
        RemoveAll(CreateBtn)
        RemoveAll(BackBtn)

        RemoveAll(txfFirstName)
        RemoveAll(txfLastName)
        --RemoveAll(txfPassword)
       -- RemoveAll(txfConfirmPassword)
        RemoveAll(txfEmail)

        RemoveAll(BoxBirth)
        RemoveAll(BoxCountry)
        RemoveAll(BoxGender)
        RemoveAll(GenderTitle)
        RemoveAll(CountryTitle)
        RemoveAll(BirthTitle)

        RemoveAll(FrameGender)
        RemoveAll(FrameCountry)
        RemoveAll(FrameBirth)

        --RemoveAll(mask)
        --RemoveAll(ProfileFrame)

        

        RemoveAll(CountryPickerWheel)
        RemoveAll(BirthPickerWheel)
        RemoveAll(GenderPickerWheel)
]]      
        PicUser:removeEventListener( "touch", SelectImg )
        if (mask) then
                PicUser:setMask( nil )
                mask = nil
                RemoveAll(ProfileFrame)
            end
        RemoveAll(scrollView)

       -- CountryPickerWheel = nil
       -- BirthPickerWheel = nil
       -- GenderPickerWheel = nil



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