--[[
HttpTest by Espen v1.4
An example code to show how to use the ComputerCraft HTTP functions.

Thanks to Advert for making me aware of the redundant call to http.get after http.request!
1.4: Changed the else-condition in getHttpBody() to explicitly check for an http_failure, instead of just assuming one if the event isn't an http_success. *derp*
--]]

--[[ Setting up variables ]]
local fileWriteOK
local url
local filename
local tArgs = { ... }


local function getHttpBody( url )
    http.request( url )
    
    while true do
        local event, url, hBody = os.pullEvent()
        if event == "http_success" then
            print( "HTTP SUCCESS\nURL = "..url )
            return hBody
        elseif event == "http_failure" then
            error( "HTTP FAILURE\nURL = "..url )    -- If the error is not catched, this will exit the program.
            return nil    -- In case this function is called via pcall.
        end
    end
end

local function processHttpBody( hBody, filename )
    local hFile
    
    if hBody then
            local body = hBody.readAll()    -- Read the whole body.
            hFile = io.open( filename, "w" )    -- Open the provided filename for writing.
            hFile:write( body )     -- Write the body to the file.
            hFile:close()   -- Save the changes and close the file.
    else
        print( "Sorry, no body to process." )
    end
    
    hBody.close()   -- Do not know for sure if this is really necessary, but just in case.
end

local function checkOverwrite( filename )
    term.setCursorBlink( false )
    print("\nWarning: File already exists. Overwrite? (Y/N)")
    
    while true do
            event, choice = os.pullEvent( "char" )  -- Only listen for "char" events.
            if string.lower( choice ) == "y" then return true end
            if string.lower( choice ) == "n" then return false end
    end
end

local function printUsage()
    print("Usage:")
    print("httptest <URL> <OUTPUT-FILENAME>")
    print("Example:")
    print("httptest http://www.google.com/ webout")
    print("\nThe response body will then be output into the file 'webout', line for line.")
end


--[[ ===== Execution Entry ===== ]]

--[[ Processing arguments ]]
if tArgs[1] then url = tArgs[1] end
if tArgs[2] then filename = tArgs[2] end

--[[ Making sure all necessary arguments were provided by the user ]]
if not url or not filename then
    printUsage()
elseif not fs.exists( filename ) or checkOverwrite( filename ) then
    processHttpBody( getHttpBody( url ), filename )    --If getHttpBody successfully returns a body, we continue with processing the body and saving it to a file.
end
