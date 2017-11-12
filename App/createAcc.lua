local json = require ("json")
require ("get-data")
local myNewData, decodedData

local function showAlertListener( event )
    print( event.action )
    if (event.action == "clicked") then
        return true
    end
end
--[[
local function networkListener( event )
    
    if ( event.isError ) then
        print( "Network error!" )

    else
        print( "RESPONSE: " .. event.response )
        native.setActivityIndicator( false )

        myNewData = event.response
        decodedData = (json.decode( myNewData ))
     --   print( decodedData["error"] )
        if (decodedData["error"] == false) then

            return decodedData["member_no"]

        end
    end
end

function CreateAccountSendListener( RegisterSend )
   -- print( RegisterSend )

    local headers = {}

    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    --local body = "fname=".. txfFirstName.text .."&lname=we" .. "&password=".. txfPassword.text .."&email=" .. txfEmail.text .. "&gender=".. GenderValue .. "&BirthMonth=".. BirthMonthValue .. "&BirthDay=".. BirthDayValue .. "&BirthYear=".. BirthYearValue .. "&Country=".. CountryValue .. "&UserFrom=0"

    local body = "RegisterSend=" .. RegisterSend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/register.php"
    
    print( "Register Data Sending To ".. url .." Web Server : " .. RegisterSend )
    network.request( url, "POST", networkListener, params )
end
]]
local function DiarySendListener( event )
    if ( event.isError ) then
        print( "Network error!" )
        local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
    else

        local GetDatabase = event.response
        print( "RESPONSE: " .. event.response )
       local decodedDatabase = (json.decode( GetDatabase ))
       DropTableData( 2 )
       
    end
end

function DiarySend( DiarySend )

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

local function UnlockSendListener( event )
    if ( event.isError ) then
        print( "Network error!" )
        local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
    else

        --local GetDatabase = event.response
        print( "RESPONSE: " .. event.response )
       --local decodedDatabase = (json.decode( GetDatabase ))
        if (event.response == "finish") then
            DropTableData( 3 )
        else
            return
        end
       
    end
end

function UnAttSend( unattractionsSendData )

    local headers = {}

    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "unattractionsSendData=" .. unattractionsSendData

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/unattractions.php"

    print( "Diary Data Sending To ".. url .." Web Server : " .. unattractionsSendData )
    network.request( url, "POST", UnlockSendListener, params )
end