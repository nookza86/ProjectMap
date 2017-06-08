
function deg2rad( deg )
	return deg * (math.pi/180)
end

function sphericalDistanceBetween( point1, point2 )
 
    local dLongitude = point2.longitude - point1.longitude
    local dLatitude = point2.latitude - point1.latitude
 
    local R = 6371  -- Earth radius in kilometers
 
    -- Localize some math calls
    local sin = math.sin
    local cos = math.cos
    local sqrt = math.sqrt
    local atan2 = math.atan2
 
    local a = ( sin( dLatitude/2 ) )^2 + cos( deg2rad(point1.latitude) ) * cos( deg2rad(point2.latitude) ) * ( sin( dLongitude/2 ) )^2
  --[[
    local a = sin(dLatitude/2) * sin(dLatitude/2) +
    cos(deg2rad(point1.latitude)) * cos(deg2rad( point2.latitude)) * 
    sin(dLongitude/2) * sin(dLongitude/2)
]]
    local c = 2 * atan2( sqrt( a ), sqrt( 1-a ) )
    local d = R * c
 
    return d * math.pi / 180
end

--flat
function distanceBetween( point1, point2 )
 
    local dX = point2.longitude - point1.longitude
    local dY = point2.latitude - point1.latitude
 
    local distance = math.sqrt( ( dX^2 ) + ( dY^2 ) )
    return distance
end