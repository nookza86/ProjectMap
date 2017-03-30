local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
 
local txfUsername, txfPassword, txfConfirmPassword, txfEmail, BirthDay, BirthMonth, BirthYear, Gender, Country
local PicUser, PicTitle, PicUsername, PicPassword, PicConfirmPassword, PicEmail, PicBirthDay, PicGender, PicCountry
local Bg, CreateBtn
local cx, cy
local ImageGroup, txfGroup
local ImageGroup = display.newGroup()
local pickerWheel
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
local function networkListener( event )
    if ( event.isError ) then
        print( "Network error!" )
    else
        print( "RESPONSE: "..event.response )
    end
end

local function CreateAccountListener( event )
    print( event.phase )
    if(event.phase == "began") then
        local values = pickerWheel:getValues()
 
    -- Get the value for each column in the wheel, by column index
    local GenderValue = values[1].value
    local BirthMonthValue = values[2].value
    local BirthDayValue = values[3].value
    local BirthYearValue = values[4].value
    local CountryValue = values[5].value
     
    print( GenderValue, BirthMonthValue, BirthDayValue, BirthYearValue, CountryValue )
    print( txfUsername.text, txfPassword.text, txfEmail.text )
    local headers = {}

    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "username=".. txfUsername.text .."&password=".. txfPassword.text .."&email=" .. txfEmail.text

    local params = {}
    params.headers = headers
    params.body = body

    network.request( "https://mapofmem.000webhostapp.com/string_get.php", "POST", networkListener, params )
    

    --[[
    local json = require( "json" )
 
    local t = {
        ["username"] = "admin",
        ["password"] = "1234",
    }
     
    local encoded = json.encode( t )
    print( encoded )  --> {"name1":"value1","name3":null,"name2":[1,false,true,23.54,"a \u0015 string"]}
     
    --local encoded = json.encode( t, { indent=true } )
    --print( encoded )

    local headers = {}
        headers["Content-Tpe"] = "application/json"
        headers["Accept-Language"] = "en-US"
    
    local params = {}
    params.headers = headers
    params.body = encoded

    network.request( "https://mapofmem.000webhostapp.com/jsontest.php", "POST", networkListener, params)
    ]]
 

    end
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

    Bg = display.newImage( "Phuket/CreateAccount/BG.png", cx , cy )
    Bg:scale( 0.3, 0.3 )

    PicUser = display.newImageRect( "Phuket/CreateAccount/Addpic.png", 386/3, 388/3 )
    PicUser.x = cx - 200
    PicUser.y = cy - 20

    PicTitle = display.newImageRect( "Phuket/CreateAccount/Title.png", 991/3.5, 83/3.5 )
    PicTitle.x = cx + 20
    PicTitle.y = cy - 140

    PicUsername = display.newImageRect( "Phuket/CreateAccount/username.png", 331/2.8, 80/2.8 )
    PicUsername.x = cx - 70
    PicUsername.y = cy - 80

    PicPassword = display.newImageRect( "Phuket/CreateAccount/pass.png", 279/2.8, 55/2.8 )
    PicPassword.x = cx - 80
    PicPassword.y = cy - 40

    PicConfirmPassword = display.newImageRect( "Phuket/CreateAccount/confirm.png", 279/2.8, 112/2.8 )
    PicConfirmPassword.x = cx - 80
    PicConfirmPassword.y = cy

    PicEmail = display.newImageRect( "Phuket/CreateAccount/email.png", 210/2.8, 55/2.8 )
    PicEmail.x = cx - 90
    PicEmail.y = cy + 40

    PicBirthDay = display.newImageRect( "Phuket/CreateAccount/birth.png", 314/2.8, 55/2.8 )
    PicBirthDay.x = cx - 60
    PicBirthDay.y = cy + 100

    PicGender = display.newImageRect( "Phuket/CreateAccount/gender.png", 211/2.8, 55/2.8 )
    PicGender.x = cx - 210
    PicGender.y = cy + 100

    PicCountry = display.newImageRect( "Phuket/CreateAccount/country.png", 245/2.8, 55/2.8 )
    PicCountry.x = cx + 120
    PicCountry.y = cy + 100

    txfUsername = native.newTextField( PicUsername.x + 180, PicUsername.y, 250, 30 )
    txfUsername.inputType = "default"
    txfUsername.text = ""
    txfUsername.hasBackground = false

    txfPassword = native.newTextField( PicPassword.x + 190, PicPassword.y, 250, 30 )
    txfPassword.inputType = "default"
    txfPassword.isSecure = true
    txfPassword.text = ""
    txfPassword.hasBackground = false

    txfConfirmPassword = native.newTextField( PicConfirmPassword.x + 190, PicConfirmPassword.y, 250, 30 )
    txfConfirmPassword.inputType = "default"
    txfConfirmPassword.text = ""
    txfConfirmPassword.isSecure = true
    txfConfirmPassword.hasBackground = false

    txfEmail = native.newTextField( PicEmail.x + 200, PicEmail.y, 250, 30 )
    txfEmail.inputType = "email"
    txfEmail.text = ""
    txfEmail.hasBackground = false

    CreateBtn = display.newImageRect("Phuket/Button/create.png",3000/30, 1280/30)
    CreateBtn.x = cx 
    CreateBtn.y = cy + 320
    CreateBtn:addEventListener( "touch", CreateAccountListener )


    --ImageGroup = display.newGroup()
    ---------------------------------- Group Place -----------------------------------------
    --ImageGroup:insert(Bg)
    ImageGroup:insert(PicUser)
    ImageGroup:insert(PicTitle)
    ImageGroup:insert(PicUsername)
    ImageGroup:insert(PicPassword)
    ImageGroup:insert(PicConfirmPassword)
    ImageGroup:insert(PicEmail)
    ImageGroup:insert(PicBirthDay)
    ImageGroup:insert(PicGender)
    ImageGroup:insert(PicCountry)
    ImageGroup:insert(CreateBtn)

    txfGroup = display.newGroup()
    ----------------------------------- Group Button -----------------------------------------
    ImageGroup:insert(txfUsername)
    ImageGroup:insert(txfPassword)
    ImageGroup:insert(txfConfirmPassword)
    ImageGroup:insert(txfEmail)

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
            width = 215,
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
        y = display.contentCenterY + 200,
        top = display.contentHeight - 228,
        columns = columnData,
        style = "resizable",
        width = 500,
        rowHeight = 32,
        --onValueSelected = s,
        fontSize = 14
    })  

 
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
        --hideBackground = true,
       -- hideScrollBar = true,
       -- isBounceEnabled = false,
        horizontalScrollDisabled = true
        }
    )
    scrollView:insert( ImageGroup )
    scrollView:insert( pickerWheel )
    
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
        --[[
        ImageGroup:remove(PicUser)
        ImageGroup:remove(PicTitle)
        ImageGroup:remove(PicUsername)
        ImageGroup:remove(PicPassword)
        ImageGroup:remove(PicConfirmPassword)
        ImageGroup:remove(PicEmail)
        ImageGroup:remove(PicBirthDay)
        ImageGroup:remove(PicGender)
        ImageGroup:remove(PicCountry)

        ImageGroup:remove(txfUsername)
        ImageGroup:remove(txfPassword)
        ImageGroup:remove(txfConfirmPassword)
        ImageGroup:remove(txfEmail)
        ImageGroup:removeSelf( )
        ImageGroup = nil

        txfUsername = nil
        txfPassword = nil
        txfConfirmPassword = nil
        txfEmail = nil
        BirthDay = nil
        BirthMonth = nil
        BirthYear = nil
        Gender = nil
        Country = nil
        Bg = nil
        PicUser = nil
        PicTitle = nil
        PicUsername = nil
        PicPassword = nil
        PicConfirmPassword = nil
        PicEmail = nil
        PicBirthDay = nil
        PicGender = nil
        PicCountry = nil
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

return scene