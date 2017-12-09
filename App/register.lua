local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local json = require ("json")
local mime = require( "mime" )
local lfs = require( "lfs" )
local toast = require('plugin.toast')
local imgOper = require('image')
require("FitImage")
require("createAcc")
require ("Network-Check")
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
local Member_NO_RE_UPLOAD
local CountImg = 0
local UploadUserImage

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
    print( event.phase )
    if(event.phase == "ended") then
        composer.gotoScene( "menu" )

    end
end

local function textFieldHandler( event )
    --print( event.target.name )
    if(event.target.name == "txfConfirmPassword") then
        CheckPasswordMatch = false
        if(txfPassword.text ~= txfConfirmPassword.text ) then
            CheckPasswordMatch = false
            print( "Password doesn't match" )

        elseif(txfPassword.text == txfConfirmPassword.text) then
            CheckPasswordMatch = true
            print( "Password match" )
        end

    elseif (event.target.name == "txfEmail" and string.len( txfEmail.text ) > 0) then
        CheckEmail = false
        if (txfEmail.text:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")) then
            CheckEmail = true
            print("VALID EMAIL")
        else
            CheckEmail = false
             print("INVALID EMAIL")                
        end
        --CheckEmail = validemail(txfEmail.text)
        --print( string.len( txfEmail.text ), CheckEmail )
    end
end

local function GoS(  )
  native.setActivityIndicator( false )  
  composer.gotoScene( "menu" )
end

local function uploadListener( event )
   
   if ( event.isError ) then
      print( "Network Error." )
      print( "Status:", event.status )
      print( "Response:", event.response )
      --toast.show("Network Error.")
      UploadUserImage( Member_NO_RE_UPLOAD )
      --native.showAlert( event.status, event.response, { "OK", "Learn More" } )
    native.setActivityIndicator( false )
   else
      if ( event.phase == "began" ) then
         print( "Upload started" )
      elseif ( event.phase == "progress" ) then
         print( "Uploading... bytes transferred ", event.bytesTransferred )
      elseif ( event.phase == "ended" ) then
         print( "Upload ended..." )
         print( "Status:", event.status )
         print( "Response:", event.response )

         imgOper.CleanDir(system.TemporaryDirectory)
         timer.performWithDelay( 5000, GoS )

      end
   end
end

function UploadUserImage( MemNo )
   
    local url = "http://mapofmem.esy.es/admin/api/android_upload_api/register_upload.php"
  
    local method = "PUT"
     
    local params = {
       timeout = 60,
       progress = true,
       bodyType = "binary"
    }

    local filename = "".. MemNo ..".jpg"
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

local function reNameImg( member_no )
    -- Get raw path to the app documents directory
    local doc_path = system.pathForFile( "", system.TemporaryDirectory )
    local destDir = system.TemporaryDirectory
    --myText.text = "reNameImg"

    for file in lfs.dir( doc_path ) do
        -- "file" is the current file or directory name
        print( "Found file: " .. file )

        if (file == PhotoName .. ".jpg") then
            local result, reason = os.rename(
                system.pathForFile( PhotoName .. ".jpg", destDir ),
                system.pathForFile( "" .. member_no .. ".jpg", destDir )
            )

            if result then
                --myText.text = "File renamed"
                print( "File renamed" )
                UploadUserImage( member_no )
            else
                --myText.text = "File not renamed re: " .. reason 
                print( "File not renamed", reason )  --> File not renamed    orange.txt: No such file or directory
            end
            break
        end
    end
end

local function networkListener( event )
    
    if ( event.isError ) then
        print( "Network error!" )
        toast.show("Network error!, Try again.")
        native.setActivityIndicator( false )
    else
        print( "RESPONSE: " .. event.response )

        myNewData = event.response
        decodedData = (json.decode( myNewData ))

        if (decodedData["error"] == false) then
            --myText.text = decodedData["member_no"] 
             print( decodedData["member_no"] )
             Member_NO_RE_UPLOAD = decodedData["member_no"]
             reNameImg( decodedData["member_no"] )
         else
            native.setActivityIndicator( false )
            toast.show(decodedData["error_msg"])
        end
    end
end

function CreateAccountSendListener( RegisterSend )
    local headers = {}

    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "RegisterSend=" .. RegisterSend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/register.php"
    
    print( "Register Data Sending To ".. url .." Web Server : " .. RegisterSend )
    network.request( url, "POST", networkListener, params )
end


local function CreateAccountListener( event )

    if(txfFirstName.text == "" or txfLastName.text == "" or txfPassword.text == "" or txfConfirmPassword.text == "" or txfEmail.text == "") then
        --native.showAlert( "Please fill all information in the form.", { "OK" } )
        toast.show("Please fill all information in the form.")
        return
    end

    if (CheckPasswordMatch == false) then
        --native.showAlert( "The password does not match", { "OK" } )
        toast.show("The password does not match.")
        return
    end

    if (CheckEmail == false) then
        --native.showAlert( "Email Address in invalid format", { "OK" } )
        toast.show("Email Address in invalid format.")
        return
    end

    if isRechable() == false then 
        --native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
        toast.show("It seems internet is not Available. Please connect to internet.")
        return
    end

    if (PhotoName == nil or PhotoName == "" or PhotoName == 0) then
        toast.show("Please select profile image.")
        return
    end

    if(event.phase == "began" and CheckPasswordMatch == true and CheckEmail == true) then
        native.setActivityIndicator( true )
        local GenderPickerValues = GenderPickerWheel:getValues()
        local BirthPickerValues = BirthPickerWheel:getValues()
        local CountryPickerValues = CountryPickerWheel:getValues()

        local GenderValue = GenderPickerValues[1].value
        local BirthMonthValue = BirthPickerValues[1].index
        local BirthDayValue = BirthPickerValues[2].value
        local BirthYearValue = BirthPickerValues[3].value
        local CountryValue = CountryPickerValues[1].value

        local register = {}
        register["fname"] = txfFirstName.text
        register["lname"] = txfLastName.text
        register["email"] = txfEmail.text
        register["password"] = txfPassword.text
        register["gender"] = GenderValue
        register["BirthMonth"] = BirthMonthValue
        register["BirthDay"] = BirthDayValue
        register["BirthYear"] = BirthYearValue
        register["Country"] = CountryValue
        register["UserFrom"] = "0"
        register["UserImage"] = "/img_path/user.jpg"

        local RegisterSend = json.encode( register )
        
        CreateAccountSendListener(RegisterSend)

    end
end

local sessionComplete = function(event)
    photo = event.target
    --myText.text = "ses"
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
        --local maxWidth = 256
        --local maxHeight = 256

        --photo:scale( scale, scale )
        photo.x = centerX
        photo.y = centerY
        --myText.text =  "photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale
        print( "photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale )
        --toast.show("photo w,h = " .. photo.width .. "," .. photo.height)
        --local alert = native.showAlert( "Error", "photo w,h = " .. photo.width .. "," .. photo.height .." ".. xScale .." ".. yScale .." ".. scale, { "OK" })
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
        --toast.show("photo w,h = " .. photo.width .. "," .. photo.height)
        --local alert = native.showAlert( "Error", "photo w,h = " .. photo.width .. "," .. photo.height .." ".. xScale .." ".. yScale .." ".. scale, { "OK" })

        
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

            display.save( photo, { filename=PhotoName..".jpg", baseDir=system.TemporaryDirectory, isFullResolution=true } )
        
            
            PicUser = display.newImage( PhotoName..".jpg", system.TemporaryDirectory, cx - 195, cy - 85, true )
            PicUser:scale(0.2  , 0.2  )
            PicUser.name = "PIC"
            PicUser:addEventListener( "touch", SelectImg )
            local markX
            local markY
             if ( PicUser.height < 512 and PicUser.width < 512) then
                local Fit = fitImage( PicUser, 512, 512, true )
                PicUser:scale(Fit, Fit)
                markX = 0.28
                markY = 0.28
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
            --toast.show("photo w,h = " .. PicUser.width .. "," .. PicUser.height)
            display.remove( photo )
    else
        PhotoPickerCheck = false
        --myText.text = "No Image Selected"

    end
end

function SelectImg( event )
     --PhotoName = event.target.name
     CountImg = CountImg + 1
     PhotoName = CountImg
     
     media.selectPhoto( { listener = sessionComplete, baseDir = system.TemporaryDirectory, filename = PhotoName .. "jpg",mediaSource = PHOTO_FUNCTION })   
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

    Bg = display.newImageRect( "Phuket/CreateAccount/bg.jpg", cw , ch  )
    Bg.x = cx
    Bg.y = cy 
    
    PicUser = display.newImageRect( "Phuket/CreateAccount/Addpic.png", 386/3, 388/3 )
    PicUser.x = cx - 195
    PicUser.y = cy - 80
    PicUser:addEventListener( "touch", SelectImg )
    PicUser.name = "PIC"
    PhotoPickerCheck = false

    PicFirstName = display.newImageRect( "Phuket/CreateAccount/box.png", 120, 25 )
    PicFirstName.x = cx - 70
    PicFirstName.y = cy - 90

    PicLastName = display.newImageRect( "Phuket/CreateAccount/box.png", 120, 25 )
    PicLastName.x = PicFirstName.x + 130
    PicLastName.y = PicFirstName.y

    PicPassword = display.newImageRect( "Phuket/CreateAccount/box.png", 120, 25 )
    PicPassword.x = PicLastName.x + 130
    PicPassword.y = PicLastName.y

    PicEmail = display.newImageRect( "Phuket/CreateAccount/box.png", 250, 25 )
    PicEmail.x = PicFirstName.x + 65
    PicEmail.y = PicFirstName.y + 50

    PicConfirmPassword = display.newImageRect( "Phuket/CreateAccount/box.png", 120, 25 )
    PicConfirmPassword.x = PicEmail.x + 195
    PicConfirmPassword.y = PicEmail.y

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

    txfPassword = native.newTextField( PicPassword.x  , PicPassword.y, PicPassword.width - 10, PicPassword.height - 10 )
    txfPassword.inputType = "default"
    txfPassword.isSecure = true
    txfPassword.text = ""
    txfPassword.hasBackground = false
    txfPassword.placeholder = "Password"

    txfConfirmPassword = native.newTextField( PicConfirmPassword.x  , PicConfirmPassword.y, PicConfirmPassword.width - 10, PicConfirmPassword.height - 10 )
    txfConfirmPassword.inputType = "default"
    txfConfirmPassword.text = ""
    txfConfirmPassword.isSecure = true
    txfConfirmPassword.hasBackground = false
    txfConfirmPassword.name = "txfConfirmPassword"
    txfConfirmPassword.placeholder = "Confirm Password"

    txfConfirmPassword:addEventListener("userInput", textFieldHandler)

    txfEmail = native.newTextField( PicEmail.x  , PicEmail.y, PicEmail.width - 10, PicEmail.height - 10 )
    txfEmail.inputType = "email"
    txfEmail.text = ""
    txfEmail.hasBackground = false
    txfEmail.name = "txfEmail"
    txfEmail.placeholder = "Email"

    txfEmail:addEventListener("userInput", textFieldHandler)

    CreateBtn = widget.newButton(
        {
            width = 291/3.5,
            height = 108/3.5,
            defaultFile = "Phuket/Button/Button/create.png",
            overFile = "Phuket/Button/ButtonPress/create.png",
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
    local columnGenderData = { 
        {
            align = "center",
            width = 50,
            startIndex = 1,
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
    local days = {}
    local years = {}
    for i = 1,31 do days[i] = i end
    for j = 1,47 do years[j] = 1970+j end

    local columnBirthData = { 
        {
            align = "right",
            width = 70,
            startIndex = 5,
            labels = {
                "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" 
            },
        },
        {
            align = "right",
            width = 30,
            startIndex = 18,
            labels = days,
        },
        {
            align = "right",
            width = 50,
            startIndex = 21,
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
   local columnCountryData = { 
        {
            align = "center",
            width = 200,
            startIndex = 21,
            labels = {"Afghanistan","Albania","Algeria","Andorra","Angola","Antigua and Barbuda","Argentina","Armenia","Australia",
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
                "Vietnam","Yemen","Zambia","Zimbabwe"},
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
        ImageGroup:insert(PicFirstName)
        ImageGroup:insert(PicLastName)
        ImageGroup:insert(PicPassword)
        ImageGroup:insert(PicConfirmPassword)
        ImageGroup:insert(PicEmail)
        
        
        ImageGroup:insert(CreateBtn)
        ImageGroup:insert(BackBtn)

        ImageGroup:insert(txfFirstName)
        ImageGroup:insert(txfLastName)
        ImageGroup:insert(txfPassword)
        ImageGroup:insert(txfConfirmPassword)
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
        RemoveAll(PicPassword)
        RemoveAll(PicConfirmPassword)
        RemoveAll(PicEmail)
        RemoveAll(PicBirthDay)
        RemoveAll(PicGender)
        RemoveAll(PicCountry)
        RemoveAll(CreateBtn)
        RemoveAll(BackBtn)

        RemoveAll(txfFirstName)
        RemoveAll(txfLastName)
        RemoveAll(txfPassword)
        RemoveAll(txfConfirmPassword)
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
]]      PicUser:removeEventListener( "touch", SelectImg )

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