local json = require ("json")
local CountGetDatabase = 0
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local function GetDataListener( event )
    if ( event.isError ) then
        print( "Network error!" )
        local alert = native.showAlert( "Error", "Network error!, Try again.", { "OK" })
    else

    	local GetDatabase = event.response
        print( "RESPONSE: " .. event.response )
       local decodedDatabase = (json.decode( GetDatabase ))

       if(CountGetDatabase == 1) then
	       for idx1, val1 in ipairs(decodedDatabase) do
	       		local insertQuery = "INSERT INTO attractions VALUES (" ..
				val1.att_no .. ",'" ..
				val1.att_name .. "','" ..
				val1.descriptions.. "','" .. 
				val1.att_img .. "');"

				db:exec( insertQuery )
				--print(insertQuery)
				
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

				db:exec( insertQuery )
				--print(insertQuery)
				--print( "round : " .. idx2 )
	       end

	    elseif(CountGetDatabase == 3) then
	       for idx3, val3 in ipairs(decodedDatabase) do
	       	--print("GetData 3",idx3, val3)
	       		local insertQuery = "INSERT INTO unattractions VALUES (" ..
				val3.un_id .. ",'" ..
				val3.member_no .. "','" ..
				val3.att_no .. "');"

				db:exec( insertQuery )
				--print(insertQuery)
	       end


	    elseif(CountGetDatabase == 4) then

			for idx4, val4 in ipairs(decodedDatabase) do
	       		local insertQuery = "INSERT INTO personel VALUES (" ..
				val4.member_no .. ",'" ..
				val4.first_name .. "','" ..
				val4.last_name .. "','" ..
				val4.email.. "','" .. 
				val4.gender.. "','" .. 
				val4.dob.. "','" ..
				val4.country.. "','" ..
				val4.userfrom.. "','" ..
				val4.user_img .. "');"
				print( insertQuery )
				db:exec( insertQuery )
	       end
	       
	    end
       
    end
end

function GetData( i , member_no)
	CountGetDatabase = i
	local GetDatabase = {}
    GetDatabase["no"] = i
    GetDatabase["mem_no"] = member_no

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

function DropTableData( Table )
	local NOOOO = 0	
	local tablesetup = ""
	local sql2 = "SELECT id FROM personel;"
		for row in db:nrows(sql2) do
			NOOOO = row.id
		end
	
	if (Table == 1) then
		tablesetup = "DELETE FROM `attractions`;"

	elseif (Table == 2) then
		tablesetup = "DELETE FROM `diary`;"

	elseif (Table == 3) then
		tablesetup = "DELETE FROM `unattractions`;"

	elseif (Table == 4) then
		tablesetup = "DELETE FROM `personel`;"
		
	end
	
	db:exec(tablesetup)
	GetData(Table , NOOOO)

 end