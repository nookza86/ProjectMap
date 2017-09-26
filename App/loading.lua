local composer = require("composer")
local widget = require("widget" )
local toast = require('plugin.toast')
local json = require ("json")
local sqlite = require("sqlite3")
require ("Network-Check")
local scene = composer.newScene()
local Bg, Title
local params
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local CountGetDatabase = 0
local GetData
local INSERT_DATA_1, INSERT_DATA_2, INSERT_DATA_3, INSERT_DATA_4
local progressView
local Result_1, Result_2, Result_3
local NOOOO = 0	

local function RemoveAll( event )
	if(event) then
		--print( "deletePic in scene #Menu " )
		event:removeSelf( )
		event = nil
		
	end
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Loading : create")
end

local function loadImageListener( event )
	--[[
	if(not event.isError) then
		print( event.bytesTransferred, event.bytesEstimated  )
		print( event.response.filename, event.response.baseDirectory )
		INSERT_DATA_4 = true
		progressView:setProgress( 1 )
	end
	]]

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
        progressView:setProgress( 1 )
        INSERT_DATA_4 = true
		
    end

end

local function LoadUserImg(  )
	local url = "http://mapofmem.esy.es/admin/api/android_upload_api/upload/profile/" .. NOOOO ..".jpg"
	print( url )
network.download( url , 
	"GET", 
	loadImageListener,
	{},
	NOOOO..".jpg",
	system.DocumentsDirectory
	)

end

local function USERIMG_FINING( Filename )
	local lfs = require( "lfs" )
 	--print( "FINDING : " ..Filename )
	-- Get raw path to the app documents directory
	local doc_path = system.pathForFile( "", system.DocumentsDirectory )
	 
	for file in lfs.dir( doc_path ) do
	    -- "file" is the current file or directory name
	    
	    if (file == Filename) then
	    	print( "Found file: " .. file )
	    	--native.showAlert( "No Internet","Found file: " .. file, { "OK" } )
	    	return true
	    end
	end
end

local function GetDataListener( event )
    if ( event.isError ) then
        print( "Network error!" )
       -- local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
       if(CountGetDatabase == 1) then
       		GetData( 1 )

       elseif(CountGetDatabase == 2) then
       		GetData( 2 )

       else
       		GetData( 3 )
       	end
    else

    	local GetDatabase = event.response
       -- print( "RESPONSE: " .. event.response )
       local decodedDatabase = (json.decode( GetDatabase ))

       if(CountGetDatabase == 1) then
	       for idx1, val1 in ipairs(decodedDatabase) do
	       		local insertQuery = "INSERT INTO attractions VALUES (" ..
				val1.att_no .. ",'" ..
				val1.att_name .. "','" ..
				val1.descriptions.. "','" .. 
				val1.att_img .. "');"

				 Result_1 = db:exec( insertQuery )
				--print(insertQuery)
				
				INSERT_DATA_1 = true
				progressView:setProgress( 0.25 )
	       end
	       if (Result_1 ~= 1) then
	       		GetData(2)
	       		print( "1 Exec Result " .. Result_1)
	       else
	       		GetData(1)
	       		print( "1 Error " .. Result_1)
	       end
	       
        	
	    elseif(CountGetDatabase == 2) then
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

				Result_2 = db:exec( insertQuery )
				--print(insertQuery)
				INSERT_DATA_2 = true
				progressView:setProgress( 0.5 )
				
	       end
	       if (Result_2 ~= 1) then
	       		GetData(3)
	       		print( "2 Exec Result " .. Result_2)
	       else
	       		GetData(2)
	       		print( "2 Error " .. Result_2)
	       end

	    elseif(CountGetDatabase == 3) then
	       for idx3, val3 in ipairs(decodedDatabase) do
	       	--print("GetData 3",idx3, val3)
	       		local insertQuery = "INSERT INTO unattractions VALUES (" ..
				val3.un_id .. ",'" ..
				val3.member_no .. "','" ..
				val3.att_no .. "');"

				Result_3 = db:exec( insertQuery )
				--print(insertQuery)
				INSERT_DATA_3 = true
				progressView:setProgress( 0.75 )
				
	       end
	       if (Result_3 ~= 1) then

	       		if (USERIMG_FINING( NOOOO..".jpg" )) then
	       			progressView:setProgress( 1 )
	       			INSERT_DATA_4 = true
	       			print( "Find " .. NOOOO .. ".jpg" )
	       		else
	       			LoadUserImg(  )
	       		end
	       		
	       		print( "3 Exec Result " .. Result_3)
	       else
	       		GetData(3)
	       		print( "3 Error " .. Result_1)
	       end
	   end
       
    end
end

function GetData( i )
	CountGetDatabase = i
	local GetDatabase = {}

	local sql2 = "SELECT id FROM personel;"
		for row in db:nrows(sql2) do
			NOOOO = row.id
		end
		
    GetDatabase["no"] = i
    GetDatabase["mem_no"] = NOOOO

    local GetDatabaseSend = json.encode( GetDatabase )

    local headers = {}
   
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"

    local body = "Number=" .. GetDatabaseSend

    local params = {}
    params.headers = headers
    params.body = body

    local url = "http://mapofmem.esy.es/admin/api/android_login_api/retivedata.php"
     print( CountGetDatabase.." : Login Data Sending To ".. url .." : " .. GetDatabaseSend )
    network.request( url, "POST", GetDataListener, params )
end

local function GoS(  )
			composer.gotoScene("overview")
end

local function listener( event )
    if (INSERT_DATA_1 == true and INSERT_DATA_2 == true and INSERT_DATA_3 == true ) then
    	progressView:setProgress( 1 )
    	 timer.cancel( event.source )
    	 composer.gotoScene("overview")
    	 print( "LOADING DONE" )
    	else
    		print( "1 : " .. tostring( INSERT_DATA_1 ) )
    		print( "2 : " .. tostring( INSERT_DATA_2 ) )
    		print( "3 : " .. tostring( INSERT_DATA_3 ) )

    end
end
function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	params = event.params
	if (phase == "will") then
		cx = display.contentCenterX
	    cy = display.contentCenterY
	    cw = display.contentWidth
	    ch = display.contentHeight

	    Bg = display.newImageRect("Phuket/Loading/bg.png", cw, ch )
	    Bg.x = cx 
		Bg.y = cy

		Title = display.newImageRect("Phuket/Loading/title.png", 724/3, 334/3 )
	    Title.x = cx 
		Title.y = cy - 30

		Glass = display.newImageRect("Phuket/Loading/glass.png", 302/3, 301/3 )
	    Glass.x = Title.x - 60 
		Glass.y = Title.y - 20

  

		transition.to( Glass, { time=600, x=Glass.x + 150, y=Glass.y } )
		transition.to( Glass, { time=200, delay=600, x=Glass.x + 150, y=Glass.y + 20 } )
		transition.to( Glass, { time=600, delay=800, x=Glass.x - 40, y=Glass.y + 55 } )
		transition.to( Glass, { time=600, delay=1400, x=Glass.x + 150, y=Glass.y + 55 } )

		local options = {
    width = 192,
    height = 64,
    numFrames = 6,
    sheetContentWidth = 1152,
    sheetContentHeight = 64
}
local progressSheet = graphics.newImageSheet( "Phuket/Loading/widget-progress-view2.png", options )
 
-- Create the widget
 progressView = widget.newProgressView(
    {
        sheet = progressSheet,
        fillOuterLeftFrame = 1,
        fillOuterMiddleFrame = 2,
        fillOuterRightFrame = 3,
        fillOuterWidth = 64,
        fillOuterHeight = 64,
        fillInnerLeftFrame = 4,
        fillInnerMiddleFrame = 5,
        fillInnerRightFrame = 6,
        fillWidth = 64,
        fillHeight = 64,
        left = (cy / 2),
        top = (cx / 2) + 60,
        width = 400,
        isAnimated = true
    }
)
 
-- Set the progress to 50%
progressView:setProgress( 0 )

		INSERT_DATA_1 = false
	    INSERT_DATA_2 = false
	    INSERT_DATA_3 = false
	    INSERT_DATA_4 = false

		--native.setActivityIndicator( true )
		timer.performWithDelay( 1000, listener, 0 )
     	
        GetData(1)	

	

		print("Scene #Loading : show (will)")
	
	elseif (phase == "did") then
		print("Scene #Loading : show (did)")
		
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(Bg)
		RemoveAll(Glass)
		RemoveAll(Title)
		RemoveAll(progressView)

		print("Scene #Loading : hide (will)")
	elseif (phase == "did") then
		return
		print("Scene #Loading : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #Loading : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene