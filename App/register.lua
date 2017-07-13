local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local json = require ("json")
local mime = require( "mime" )
local lfs = require( "lfs" )
local toast = require('plugin.toast')
require("createAcc")
require ("Network-Check")
local txfFirstName, txfLastName, txfPassword, txfConfirmPassword, txfEmail, BirthDay, BirthMonth, BirthYear, Gender, Country
local PicUser, PicTitle, PicFirstName, PicLastName, PicPassword, PicConfirmPassword, PicEmail, PicBirthDay, PicGender, PicCountry
local PictxfFirstName, PictxfLastName, PictxfPassword, PictxfConfirmPassword, PictxfEmail
local Bg, CreateBtn, BackBtn, BgPickerWheels
local cx, cy
local ImageGroup, txfGroup
local ImageGroup = display.newGroup()
local pickerWheel
local CheckPasswordMatch, CheckEmail
local myNewData, decodedData
local PhotoName, PhotoPickerCheck
local SelectImg
local myText = display.newText( "5555555555", display.contentCenterY, display.contentCenterY + 330, native.systemFont, 16 )
            myText:setFillColor( 1, 0, 0 ) 

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

local function uploadListener( event )
    print( "uploaddddL:is" )
   if ( event.isError ) then
      print( "Network Error." )
      print( "Status:", event.status )
      print( "Response:", event.response )
       myText.text = "Status:" .. event.status .. " Response: " .. event.response

   else
      if ( event.phase == "began" ) then
         print( "Upload started" )
      elseif ( event.phase == "progress" ) then
         print( "Uploading... bytes transferred ", event.bytesTransferred )
      elseif ( event.phase == "ended" ) then
         print( "Upload ended..." )
         print( "Status:", event.status )
         print( "Response:", event.response )
         myText.text = event.status .. " " .. event.response
--[[
         if (event.status == "201") then
            local UpImg = {}

            UpImg["member_no"] = member_no
            UpImg["att_no"] = NoAtt

             UpdateImg
         end
         ]]
      end
   end
end

local function UploadUserImage( MemNo )
   
    local url = "http://mapofmem.esy.es/admin/api/android_upload_api/register_upload.php"
  
    local method = "PUT"
     
    local params = {
       timeout = 60,
       progress = true,
       bodyType = "binary"
    }

    local filename = "".. MemNo ..".jpg"
    --local baseDirectory = system.ResourceDirectory
    local baseDirectory = system.DocumentsDirectory 
   -- local baseDirectory = system.TemporaryDirectory
    local contentType = "image/jpge" 

    local headers = {}
    headers.filename = filename
    params.headers = headers
     myText.text = "with file name " .. filename
     print( "Upload User Image To " .. url .." with file name " .. filename )
    network.upload( url , method, uploadListener, params, filename, baseDirectory, contentType )
end

local function reNameImg( member_no )
    -- Get raw path to the app documents directory
    local doc_path = system.pathForFile( "", system.DocumentsDirectory )
    local destDir = system.DocumentsDirectory
    myText.text = "reNameImg"
    for file in lfs.dir( doc_path ) do
        -- "file" is the current file or directory name
        print( "Found file: " .. file )

        if (file == "PIC.jpg") then
            local result, reason = os.rename(
                system.pathForFile( "PIC.jpg", destDir ),
                system.pathForFile( "" .. member_no .. ".jpg", destDir )
            )

            if result then
                myText.text = "File renamed"
                print( "File renamed" )
                UploadUserImage( member_no )
            else
                myText.text = "File not renamed re: " .. reason 
                print( "File not renamed", reason )  --> File not renamed    orange.txt: No such file or directory
            end
            break
        end
    end


end

local function networkListener( event )
    
    if ( event.isError ) then
        print( "Network error!" )

    else
        print( "RESPONSE: " .. event.response )
        native.setActivityIndicator( false )

        myNewData = event.response
        decodedData = (json.decode( myNewData ))

        if (decodedData["error"] == false) then
            myText.text = decodedData["member_no"] 
             print( decodedData["member_no"] )
             reNameImg( decodedData["member_no"] )
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
    print( event.phase )

    if(txfFirstName.text == "" or txfLastName.text == "" or txfPassword.text == "" or txfConfirmPassword.text == "" or txfEmail.text == "") then
        print( "some Field null" )
        return
    end

    if isRechable() == false then 
        native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
        return
    end

    if(event.phase == "began" and CheckPasswordMatch == true and CheckEmail == true) then
        local values = pickerWheel:getValues()
 
        local GenderValue = values[1].value
        local BirthMonthValue = values[2].index
        local BirthDayValue = values[3].value
        local BirthYearValue = values[4].value
        local CountryValue = values[5].value

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
    
    if photo then

        if photo.width > photo.height then
            photo:rotate( -90 )         -- rotate for landscape
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
       -- myText.text =  "photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale
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
           
            PhotoPickerCheck1 = true
            PicUser:removeEventListener( "touch", SelectImg )
            ImageGroup:remove( PicUser )
            RemoveAll(PicUser)

            PicUser = display.newImage( PhotoName..".jpg", system.DocumentsDirectory, centerX - 190, centerY - 20, true )
            PicUser:scale(scale , scale )
            PicUser.name = "PIC"
            PicUser:addEventListener( "touch", SelectImg )

            ImageGroup:insert(PicUser)

        myText.text = PhotoName..".jpg".. photo.width .. " " .. photo.height
        display.remove( photo )
        
    else
        PhotoPickerCheck = false
        myText.text = "No Image Selected"

    end
end

function SelectImg( event )
     PhotoName = event.target.name
     media.selectPhoto( { listener = sessionComplete, baseDir = system.DocumentsDirectory, filename = PhotoName .. "jpg",mediaSource = PHOTO_FUNCTION })   
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

    Bg = display.newImageRect( "Phuket/CreateAccount/bg.png", cw , ch  )
    Bg.x = cx
    Bg.y = cy 
    --Bg:scale( 0.3, 0.3 )

    PicUser = display.newImageRect( "Phuket/CreateAccount/Addpic.png", 386/3, 388/3 )
    PicUser.x = cx - 190
    PicUser.y = cy - 20
    PicUser:addEventListener( "touch", SelectImg )
    PicUser.name = "PIC"
    PhotoPickerCheck = false

    PicTitle = display.newImageRect( "Phuket/CreateAccount/title.png", 801/3.5, 120/3.5 )
    PicTitle.x = cx + 20
    PicTitle.y = cy - 140

    PicFirstName = display.newImageRect( "Phuket/CreateAccount/firstname.png", 366/2.8, 95/2.8 )
    PicFirstName.x = cx - 50
    PicFirstName.y = cy - 80

    PicLastName = display.newImageRect( "Phuket/CreateAccount/lastname.png", 359/2.8, 96/2.8 )
    PicLastName.x = cx - 50
    PicLastName.y = cy - 40

    PicPassword = display.newImageRect( "Phuket/CreateAccount/pass.png", 296/2.8, 94/2.8 )
    PicPassword.x = cx - 60
    PicPassword.y = cy

    PicConfirmPassword = display.newImageRect( "Phuket/CreateAccount/confirm.png", 247/2.8, 152/2.8 )
    PicConfirmPassword.x = cx - 70
    PicConfirmPassword.y = cy + 45

    PicEmail = display.newImageRect( "Phuket/CreateAccount/email.png", 209/2.8, 95/2.8 )
    PicEmail.x = cx - 80
    PicEmail.y = cy + 90

    PicBirthDay = display.newImageRect( "Phuket/CreateAccount/birth.png", 298/2.8, 94/2.8 )
    PicBirthDay.x = cx - 60
    PicBirthDay.y = cy + 140

    PicGender = display.newImageRect( "Phuket/CreateAccount/gender.png", 229/2.8, 94/2.8 )
    PicGender.x = cx - 210
    PicGender.y = cy + 140

    PicCountry = display.newImageRect( "Phuket/CreateAccount/country.png", 255/2.8, 94/2.8 )
    PicCountry.x = cx + 120
    PicCountry.y = cy + 140

    txfFirstName = native.newTextField( PicFirstName.x + 180, PicFirstName.y, 250, 30 )
    txfFirstName.inputType = "default"
    txfFirstName.text = ""
    --txfFirstName.hasBackground = false

    txfLastName = native.newTextField( PicLastName.x + 180, PicLastName.y, 250, 30 )
    txfLastName.inputType = "default"
    txfLastName.text = ""
    --txfLastName.hasBackground = false

    txfPassword = native.newTextField( PicPassword.x + 190, PicPassword.y, 250, 30 )
    txfPassword.inputType = "default"
    txfPassword.isSecure = true
    txfPassword.text = ""
    --txfPassword.hasBackground = false

    txfConfirmPassword = native.newTextField( PicConfirmPassword.x + 200, PicConfirmPassword.y, 250, 30 )
    txfConfirmPassword.inputType = "default"
    txfConfirmPassword.text = ""
    txfConfirmPassword.isSecure = true
   -- txfConfirmPassword.hasBackground = false
    txfConfirmPassword.name = "txfConfirmPassword"

    txfConfirmPassword:addEventListener("userInput", textFieldHandler)

    txfEmail = native.newTextField( PicEmail.x + 210, PicEmail.y, 250, 30 )
    txfEmail.inputType = "email"
    txfEmail.text = ""
    --txfEmail.hasBackground = false
    txfEmail.name = "txfEmail"

    txfEmail:addEventListener("userInput", textFieldHandler)

    CreateBtn = widget.newButton(
        {
            width = 150/1.5,
            height = 45/1.5,
            defaultFile = "Phuket/Button/Button/create.png",
            overFile = "Phuket/Button/ButtonPress/create.png",
            id = "CreateBtn",
            onEvent = CreateAccountListener
        }
            )
        
    CreateBtn.x = cx 
    CreateBtn.y = cy + 360

    BackBtn = widget.newButton(
        {
            width = 70/2,
            height = 70/2,
            defaultFile = "Phuket/Button/Button/back.png",
            overFile = "Phuket/Button/ButtonPress/back.png",
            id = "BackBtn",
            onEvent = Check
        }
            )
        
        BackBtn.x = cx - 240
        BackBtn.y = cy + 360


    --ImageGroup = display.newGroup()
    ---------------------------------- Group Place -----------------------------------------
    --ImageGroup:insert(Bg)
    ImageGroup:insert(PicUser)
    ImageGroup:insert(PicTitle)
    ImageGroup:insert(PicFirstName)
    ImageGroup:insert(PicLastName)
    ImageGroup:insert(PicPassword)
    ImageGroup:insert(PicConfirmPassword)
    ImageGroup:insert(PicEmail)
    ImageGroup:insert(PicBirthDay)
    ImageGroup:insert(PicGender)
    ImageGroup:insert(PicCountry)
    ImageGroup:insert(CreateBtn)
    ImageGroup:insert(BackBtn)
    

    txfGroup = display.newGroup()
    ----------------------------------- Group Button -----------------------------------------
    ImageGroup:insert(txfFirstName)
    ImageGroup:insert(txfLastName)
    ImageGroup:insert(txfPassword)
    ImageGroup:insert(txfConfirmPassword)
    ImageGroup:insert(txfEmail)
    ImageGroup:insert(myText)

    local days = {}
    local years = {}
    for i = 1,31 do days[i] = i end
    for j = 1,47 do years[j] = 1970+j end

    local columnData = { 
        {
            align = "center",
            width = 70,
            startIndex = 1,
            labels = {"Male", "Female"},
        },
        {
            align = "right",
            width = 80,
            startIndex = 5,
            labels = {
                "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" 
            },
        },
        {
            align = "center",
            width = 70,
            startIndex = 18,
            labels = days,
        },
        {
            align = "center",
            width = 40,
            startIndex = 21,
            labels = years,
        },
        {
            align = "center",
            width = 240,
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
        },
    }
 
    -- Create the widget
    pickerWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX ,
        y = display.contentCenterY + 240,
        top = display.contentHeight - 228,
        columns = columnData,
        style = "resizable",
        width = 500,
        rowHeight = 32,
        --onValueSelected = s,
        fontSize = 14
    })  

    BgPickerWheels = display.newImageRect( "Phuket/CreateAccount/select.png", 500 , 160 )
    BgPickerWheels.x = pickerWheel.x
    BgPickerWheels.y = pickerWheel.y

    print( pickerWheel.x , pickerWheel.y, pickerWheel.height, pickerWheel.width )

 
-- Get the table of current values for all columns
-- This can be performed on a button tap, timer execution, or other event

    
    scrollView = widget.newScrollView(
    {
        top = 0,
        left = 0,
        width = screenW,
        height = screenH,
        scrollWidth = cw,
        scrollHeight = ch,
        topPadding = 20,
        bottomPadding = 30,
        hideBackground = true,
       -- hideScrollBar = true,
       -- isBounceEnabled = false,
        horizontalScrollDisabled = true
        }
    )
    ImageGroup:insert(pickerWheel)
    ImageGroup:insert(BgPickerWheels)
    scrollView:insert( ImageGroup )
    --scrollView:insert( pickerWheel )
    
    
    --textField:setTextColor( 0.8, 0.8, 0.8 )
    --textField.hasBackground = false

    
    elseif (phase == "did") then
        print("Scene Overview : show (did)")
    
        
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
    if (phase == "will") then
        
        ImageGroup:remove(PicUser)
        ImageGroup:remove(PicTitle)
        ImageGroup:remove(PicFirstName)
        ImageGroup:remove(PicLastName)
        ImageGroup:remove(PicPassword)
        ImageGroup:remove(PicConfirmPassword)
        ImageGroup:remove(PicEmail)
        ImageGroup:remove(PicBirthDay)
        ImageGroup:remove(PicGender)
        ImageGroup:remove(PicCountry)
        ImageGroup:remove(CreateBtn)
        ImageGroup:remove(BackBtn)

        ImageGroup:remove(txfFirstName)
        ImageGroup:remove(txfLastName)
        ImageGroup:remove(txfPassword)
        ImageGroup:remove(txfConfirmPassword)
        ImageGroup:remove(txfEmail)
        ImageGroup:removeSelf( )
        ImageGroup = nil

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