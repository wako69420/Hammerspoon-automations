-- ===== CONFIG =====
local linearMouseApp = "LinearMouse"
local monitorControlApp = "MonitorControl"
local mouseUSBName = "Razer DeathAdder V2 X HyperSpeed"
local mouseBTName = "DA V2 X"
-- ===================

local lastDisplayState = nil
local lastMouseState = nil
local btCache = false
local btCheckCounter = 0

local function isExternalDisplayConnected()
    for _, screen in ipairs(hs.screen.allScreens()) do
        local name = screen:name()
        if name and not string.find(name, "Built") then
            return true
        end
    end
    return false
end

local function isUSBMouseConnected()
    for _, device in ipairs(hs.usb.attachedDevices()) do
        if device.productName == mouseUSBName then
            return true
        end
    end
    return false
end

local function checkBluetooth()
    local result = hs.execute("/usr/sbin/system_profiler SPBluetoothDataType 2>/dev/null | grep -A10 'DA V2 X' | grep 'RSSI'")
    btCache = result and result ~= ""
    return btCache
end

local function isMouseConnected()
    if isUSBMouseConnected() then return true end

    -- Poll BT every 5 calls only
    btCheckCounter = btCheckCounter + 1
    if btCheckCounter >= 5 then
        btCheckCounter = 0
        checkBluetooth()
    end

    return btCache
end

local function openApp(appName)
    local app = hs.application.get(appName)
    if not app or not app:isRunning() then
        hs.application.launchOrFocus(appName)
    end
end

local function closeApp(appName)
    local app = hs.application.get(appName)
    if app then app:kill() end
end

function evaluateMouseState()
    if isMouseConnected() then
        openApp(linearMouseApp)
    else
        closeApp(linearMouseApp)
    end
end

local function evaluateState()
    local display = isExternalDisplayConnected()
    local mouse = isMouseConnected()

    if mouse ~= lastMouseState then
        lastMouseState = mouse
        if mouse then openApp(linearMouseApp)
        else closeApp(linearMouseApp) end
    end

    if display ~= lastDisplayState then
        lastDisplayState = display
        if display then openApp(monitorControlApp)
        else closeApp(monitorControlApp) end
    end
end

-- USB watcher for instant response
local usbWatcher = hs.usb.watcher.new(function(event)
    if event.eventType == "removed" then
        -- On remove, immediately invalidate BT cache and evaluate
        btCache = false
        btCheckCounter = 0
        hs.timer.doAfter(0.5, evaluateState)
    elseif event.eventType == "added" then
        -- On add, wait a moment for device to register
        hs.timer.doAfter(1.5, evaluateState)
    end
end)
usbWatcher:start()

local poller = hs.timer.new(2, evaluateState)
poller:start()

evaluateState()