RE.Screen = {}
RE.Screen.Protocol = {}

function RE.Screen.Protocol.get(ok, err)
    if G.STATE == G.STATES.MENU then
        ok({Menu = {}})
    elseif G.STATE == G.STATES.BLIND_SELECT then
        ok({SelectBlind = RE.Blinds.choices()})
    elseif G.STATE == G.STATES.SELECTING_HAND then
        ok({Play = RE.Play.info()})
	elseif G.STATE == G.STATES.SHOP then
		ok({Shop = RE.Shop.info()})
    end
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
