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
local NewPassTxf, ConfirmTxf


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

        if(obj == "Password") then
            composer.gotoScene("profile_edit_password")

        elseif(obj == "Information") then
            composer.gotoScene("profile_edit_information")

        elseif(obj == "BackBtn") then
            composer.gotoScene("profile")
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
        Bg = display.newImageRect("Phuket/Profile/bg.png", cw, ch )
        Bg.x = cx 
        Bg.y = cy 
        
         InformationBtn = widget.newButton(
        {
            width = 457/2.5,
            height = 121/2.5,
            defaultFile = "Phuket/Button/Button/profile.png",
            overFile = "Phuket/Button/ButtonPress/profile.png",
            id = "Information",
            onEvent = Check
        }
            )
        InformationBtn.x = cx 
        InformationBtn.y = cy 

        PasswordBtn = widget.newButton(
        {
            width = 457/2.5,
            height = 121/2.5,
            defaultFile = "Phuket/Button/Button/password.png",
            overFile = "Phuket/Button/ButtonPress/password.png",
            id = "Password",
            onEvent = Check
        }
            )
        PasswordBtn.x = InformationBtn.x
        PasswordBtn.y = InformationBtn.y + 60

       

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
        sceneGroup:insert(InformationBtn)
        sceneGroup:insert(PasswordBtn)
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
--[[
        RemoveAll(Bg)
        RemoveAll(InformationBtn)
        RemoveAll(PasswordBtn)
        RemoveAll(BackBtn)        
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