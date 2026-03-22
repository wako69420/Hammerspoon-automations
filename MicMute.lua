local micMuted = false
local micMenu = hs.menubar.new(true)

local function updateMicMenu()
    if micMuted then
        micMenu:setTitle("🎙️🔴")
        micMenu:setTooltip("System Wide Mute — click to unmute")
    else
        micMenu:setTitle("🎙️")
        micMenu:setTooltip("System Wide Mute — click to mute")
    end
end

local function toggleMic()
    micMuted = not micMuted
    local device = hs.audiodevice.defaultInputDevice()
    if device then
        device:setInputMuted(micMuted)
    end
    updateMicMenu()
end

micMenu:setClickCallback(toggleMic)
updateMicMenu()