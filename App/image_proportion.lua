--https://medium.com/hackthecode/make-the-images-right-corona-sdk-a31adbf2523c

function getNewHeight(image , newWidth) 
    local r = image.width / image.height --4
    local newHeight = newWidth / r --5
    return newHeight --6
end

--Function to get the New Width for Given Height
function getNewWidth(image , newHeight)
    local r = image.width / image.height
    local newWidth = newHeight * r
    return newWidth
end