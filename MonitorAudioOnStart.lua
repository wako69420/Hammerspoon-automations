local function setAudioOutput()
    local screens = hs.screen.allScreens()
    if #screens > 1 then
        local device = hs.audiodevice.findOutputByName("LG ULTRAGEAR")
        if device then device:setDefaultOutputDevice() end
    else
        local device = hs.audiodevice.findOutputByName("MacBook Pro Speakers")
        if device then device:setDefaultOutputDevice() end
    end
end

local screenWatcher = hs.screen.watcher.new(setAudioOutput)
screenWatcher:start()