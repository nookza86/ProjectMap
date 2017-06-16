--https://medium.com/hackthecode/check-for-internet-in-corona-sdk-800647f4a4f1

local iosNetworkAvailable = true -- 1

function networkListener( event )
    iosNetworkAvailable = event.isReachable
end

if ( network.canDetectNetworkStatusChanges ) then
    network.setStatusListener( "www.apple.com",networkListener ) -- 2
end

function isRechable()
  local os = system.getInfo("platformName")
  if ( os == "iPhone OS") then
      return iosNetworkAvailable -- 3
  elseif ( os == "Android" ) then
    local socket = require("socket") -- 4
    local test = socket.tcp()
    local isNetworkAvailable = false
    test:settimeout(3000) -- Set timeout to 3 seconds
    local testResult = test:connect("www.google.com",80) -- Note that the test does not work if we put http:// in front 
    if not(testResult == nil) then -- 5
      print("Internet access is available")
      isNetworkAvailable = true 
    else
      print("Internet access is not available")
      isNetworkAvailable = false
    end
    test:close() -- 6
    test = nil
    return isNetworkAvailable -- 7
  end
end