RE.Screen = {}
RE.Screen.Protocol = {}

function RE.Screen.Protocol.get(ok, err)
    RE.Util.await(function()
        sendTraceMessage("state checks: " .. G.STATE)
        if G.STATE == G.STATES.MENU then
            sendTraceMessage("MENU")
        elseif G.STATE == G.STATES.BLIND_SELECT then
            sendTraceMessage("BLIND_SELECT")
        elseif G.STATE == G.STATES.SELECTING_HAND then
            sendTraceMessage("SELECTING_HAND")
        elseif G.STATE == G.STATES.ROUND_EVAL then
            sendTraceMessage("ROUND_EVAL")
        elseif G.STATE == G.STATES.SHOP then
            sendTraceMessage("SHOP")
        elseif G.STATE == G.STATES.GAME_OVER then
            sendTraceMessage("GAME_OVER")
        elseif RE.Boosters.info() ~= nil then
            sendTraceMessage("BOOSTERS")
        end

        return G.STATE == G.STATES.MENU or G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.ROUND_EVAL or RE.Shop.info() ~= nil or G.STATE == G.STATES.GAME_OVER or RE.Boosters.info() ~= nil
    end, function(res)
        if G.STATE == G.STATES.MENU then
            ok({Menu = RE.Menu.info()})
        elseif G.STATE == G.STATES.BLIND_SELECT then
            ok({SelectBlind = RE.Blinds.info()})
        elseif G.STATE == G.STATES.SELECTING_HAND then
            ok({Play = RE.Play.info()})
        elseif G.STATE == G.STATES.ROUND_EVAL then
            RE.Overview.round(function (info)
                ok({RoundOverview = info})
            end)
        elseif RE.Shop.info() ~= nil then
            ok({Shop = RE.Shop.info()})
        elseif G.STATE == G.STATES.GAME_OVER then
            ok({GameOver = RE.Overview.game()})
        elseif RE.Boosters.info() ~= nil then
            if G.shop then
                ok({ShopOpen = RE.Boosters.info()})
            else
                ok({SkipOpen = RE.Boosters.info()})
            end
        end
    end)
end

function RE.Screen.await(states, cb)
    -- Convert single state to table if needed
    if type(states) ~= "table" then
        states = {states}
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        no_delete = true,
        func = function()
            -- Check if current state matches any of the target states
            local found_state = nil
            for _, state in ipairs(states) do
                if G.STATE == state then
                    found_state = state
                    break
                end
            end

            if not found_state then
                RE.Screen.await(states, cb)
                return true
            end
            cb(found_state)
            return true
        end
    }))
end
