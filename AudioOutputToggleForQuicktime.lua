local recordingMode = false
local menubar = hs.menubar.new(true)

local function updateMenubar()
    if recordingMode then
        menubar:setTitle("⏺")
        menubar:setTooltip("Switch back to normal audio output")
    else
        menubar:setTitle("🔊")
        menubar:setTooltip("Switch to internal sound for QuickTime Recording")
    end
end

local function toggleAudioMode()
    recordingMode = not recordingMode
    if recordingMode then
        hs.audiodevice.findOutputByName("QUICKTIME DESKTOP AUDIO"):setDefaultOutputDevice()
    else
        local screens = hs.screen.allScreens()
        if #screens > 1 then
            hs.audiodevice.findOutputByName("LG ULTRAGEAR"):setDefaultOutputDevice()
        else
            hs.audiodevice.findOutputByName("MacBook Pro Speakers"):setDefaultOutputDevice()
        end
    end
    updateMenubar()
end

menubar:setClickCallback(toggleAudioMode)
updateMenubar()