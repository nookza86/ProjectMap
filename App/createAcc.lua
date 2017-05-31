local json = require ("json")

local function showAlertListener( event )
    print( event.action )
    if (event.action == "clicked") then
        return true
    end
end

local function networkListener( event )
    if ( event.isError ) then
        print( "Network error!" )

    else
        print( "RESPONSE: " .. event.response )
        native.setActivityIndicator( false )

        if (event.response == "finish") then
            print( "..." )
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

local function DiarySendListener( event )
    if ( event.isError ) then
        print( "Network error!" )
        local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
    else

        local GetDatabase = event.response
        print( "RESPONSE: " .. event.response )
       local decodedDatabase = (json.decode( GetDatabase ))
       
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
