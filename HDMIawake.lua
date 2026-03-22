local caffeineActive = false

local function circleIcon(filled)
    local canvas = hs.canvas.new({x = 0, y = 0, w = 18, h = 18})
    canvas[1] = {
        type = "circle",
        action = filled and "fill" or "stroke",
        fillColor = { white = 1, alpha = 1 },
        strokeColor = { white = 1, alpha = 1 },
        strokeWidth = 0.6,
        frame = { x = 7.5, y = 7.5, w = 3, h = 3 }
    }
    local img = canvas:imageFromCanvas()
    img:setSize({w = 7, h = 7})
    return img
end

local iconOn  = circleIcon(true)
local iconOff = circleIcon(false)

local caffeineMenu = hs.menubar.new(true)

local function enableAwake()
    hs.caffeinate.set("displayIdle", true, true)
    hs.caffeinate.set("systemIdle", true, true)
    hs.caffeinate.set("screensaverIdle", true, true)
    caffeineActive = true
    caffeineMenu:setIcon(iconOn)
    caffeineMenu:setTooltip("Display and System Awake")
end

local function disableAwake()
    hs.caffeinate.set("displayIdle", false, true)
    hs.caffeinate.set("systemIdle", false, true)
    hs.caffeinate.set("screensaverIdle", false, true)
    caffeineActive = false
    caffeineMenu:setIcon(iconOff)
    caffeineMenu:setTooltip("Display and System Sleep Allowed")
end

local function toggleAwake()
    if caffeineActive then
        disableAwake()
    else
        enableAwake()
    end
end

caffeineMenu:setClickCallback(toggleAwake)
disableAwake()

local function isExternalDisplayConnected()
    for _, screen in ipairs(hs.screen.allScreens()) do
        local name = screen:name()
        if name and not string.find(name, "Built") then
            return true
        end
    end
    return false
end

local function evaluateState()
    if isExternalDisplayConnected() then
        enableAwake()
    else
        disableAwake()
    end
end

local screenWatcher = hs.screen.watcher.new(function()
    evaluateState()
end)

screenWatcher:start()

hs.timer.doAfter(3, function()
    evaluateState()
end)