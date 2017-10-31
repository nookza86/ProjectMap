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
local SettingBtn, OkBtn
local NewPassTxf, ConfirmTxf, NewPassImage, ConfirmImage
local CheckPasswordMatch


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

local function networkListener( event )
    
    if ( event.isError ) then
        print( "Network error!" )

    else
        print( "RESPONSE: " .. event.response )
        native.setActivityIndicator( false )

        myNewData = event.response
        decodedData = (json.decode( myNewData ))

        if (decodedData["error"] == false) then
            composer.gotoScene("profile")

        end
    end
end

function UpdatePassword(  )

    local EditPassSend = {}
    EditPassSend["member_no"] = ID_USER
    EditPassSend["password"] = NewPassTxf.text

    local headers = {}

    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "EditPassSend=" .. EditPassSend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/password_edit.php"
    
    print( "Register Data Sending To ".. url .." Web Server : " .. EditPassSend )
    network.request( url, "POST", networkListener, params )
end

local function Check( event )
    local obj = event.target.id

    print( obj )
    if(event.phase == "ended") then

        if(obj == "ok") then
            if (CheckPasswordMatch == true) then
                native.setActivityIndicator( true )
                 UpdatePassword(  )
            else
                print( "Password doesn't match" )
            end

        elseif(obj == "BackBtn") then
            composer.gotoScene("profile")
        end
    end
end

local function textFieldHandler( event )
    --print( event.target.name )
    if(event.target.name == "ConfirmPass") then
        CheckPasswordMatch = false
        if(NewPassTxf.text ~= ConfirmTxf.text ) then
            CheckPasswordMatch = false
            print( "Password doesn't match" )

        elseif(NewPassTxf.text == ConfirmTxf.text) then
            CheckPasswordMatch = true
            print( "Password match" )
        end

    end
end

function scene:create(event)
    local sceneGroup = self.view
    print("Scene #Profile : create")
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    cx = display.contentCenterX
    cy = display.contentCenterY
    cw = display.contentWidth
    ch = display.contentHeight

    if (phase == "will") then
        local prevScene = composer.getSceneName( "previous" )

        if (prevScene ~= nil) then
            composer.removeScene( prevScene )
        end

        Bg = display.newImageRect("Phuket/Profile/bg.jpg", cw, ch )
        Bg.x = cx 
        Bg.y = cy 
        
        NewPassTxf = native.newTextField( cx , cy - 40, 200, 25 )
        NewPassTxf.inputType = "default"
        NewPassTxf.hasBackground = false
        NewPassTxf.placeholder = "New Password"
        NewPassTxf.isSecure = true

        NewPassImage = display.newImageRect("Phuket/menu/box.png", 210, 35 )
        NewPassImage.x = NewPassTxf.x
        NewPassImage.y = NewPassTxf.y

        ConfirmTxf = native.newTextField( cx , cy + 40, 200, 25 )
        ConfirmTxf.inputType = "default"
        ConfirmTxf.hasBackground = false
        ConfirmTxf.placeholder = "Confirm New Password"
        ConfirmTxf.isSecure = true
        ConfirmTxf.name = "ConfirmPass"

        ConfirmImage = display.newImageRect("Phuket/menu/box.png", 210, 35 )
        ConfirmImage.x = ConfirmTxf.x
        ConfirmImage.y = ConfirmTxf.y

        ConfirmTxf:addEventListener("userInput", textFieldHandler)

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
        OkBtn.x = cx 
        OkBtn.y = cy + 100

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
        
        BackBtn.x = cx - 240
        BackBtn.y = cy - 110

        sceneGroup:insert(Bg)
        sceneGroup:insert(NewPassTxf)
        sceneGroup:insert(NewPassImage)
        sceneGroup:insert(ConfirmTxf)
        sceneGroup:insert(ConfirmImage)
        sceneGroup:insert(OkBtn)
        sceneGroup:insert(BackBtn)

        print("Scene #Profile : show (will)")
    
    elseif (phase == "did") then
        print("Scene #Profile : show (did)")
        
        
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
    if (phase == "will") then
        ConfirmTxf:removeEventListener("userInput", textFieldHandler)

        --[[
        RemoveAll(Bg)
        RemoveAll(NewPassTxf)
        RemoveAll(NewPassImage)
        RemoveAll(ConfirmTxf)
        RemoveAll(ConfirmImage)
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