local function moveWindowsToExternal()
    local externalScreen = nil

    for _, screen in ipairs(hs.screen.allScreens()) do
        if screen:name() and not string.find(screen:name(), "Built") then
            externalScreen = screen
            break
        end
    end

    if not externalScreen then return end

    for _, win in ipairs(hs.window.allWindows()) do
        if win:isStandard() and not win:isMinimized() then
            win:moveToScreen(externalScreen, true, true)
        end
    end
end

local screenWatcher = hs.screen.watcher.new(function()
    hs.timer.doAfter(3, function()
        if #hs.screen.allScreens() > 1 then
            moveWindowsToExternal()
        end
    end)
end)

screenWatcher:start()