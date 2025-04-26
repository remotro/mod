RE.InHooks = {}

local function calculate_chip_requirement(blind_id)
    local blind = G.P_BLINDS[blind_id]
    return get_blind_amount(G.GAME.round_resets.ante) * blind.mult * G.GAME.starting_params.ante_scaling
end

local function get_blind_info(id)
    local blind_id = G.GAME.round_resets.blind_choices[id]
    local chips = calculate_chip_requirement(blind_id)
    local blind_state = G.GAME.round_resets.blind_states[id]
    if id == "Boss" then
        local kind = blind_id
        return {
            kind = kind,
            chips = chips,
            state = blind_state
        }
    else
        local tag = G.GAME.round_resets.blind_tags[id]
        return {
            chips = chips,
            state = blind_state,
            tag = tag
        }
    end
end

local function calculate_blinds()
    return {
        small = get_blind_info("Small"),
        big = get_blind_info("Big"),
        boss = get_blind_info("Boss"),
    }
end

function RE.InHooks.start_run(bundle, cb)
    if G.STATE ~= G.STATES.MENU then
        cb({
            Err = "cannot do this action, must be in menu (" .. G.STATES.MENU .. ") but in " .. G.STATE
        })
        return
    end

    back_obj = G.P_CENTERS[bundle["back"]]
    if not back_obj then
        cb({
            Err = "could not find back " .. bundle["back"]
        })
        return
    end

    if not back_obj.unlocked then
        cb({
            Err = "back " .. bundle["back"] .. " is not unlocked"
        })
        return
    end

    -- Balatro assumes that run start will occur in run setup,
    -- which will populate the viewed deck (back). We must "pretend"
    -- this is the case as well. 
    G.GAME.viewed_back = back_obj
    G.FUNCS.start_run(e, {stake = bundle["stake"], seed = bundle["seed"], challenge = nil});

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        no_delete = true,
        func = function()
            cb({
                Ok = calculate_blinds()
            })
            return true
        end
    }))
end

local function get_e()
    return G.blind_select.UIRoot.children[1].children[1].config.object:get_UIE_by_ID('select_blind_button')
end

function RE.InHooks.select_blind(bundle, cb)
    if G.STATE ~= G.STATES.BLIND_SELECT then
        cb({
            Err = "cannot do this action, must be in blind_select but in " .. G.STATE
        })
        return
    end

    G.FUNCS.select_blind(get_e())
    cb({
        Ok = calculate_blinds()
    })
end

function RE.InHooks.skip_blind(bundle, cb)
    if G.STATE ~= G.STATES.BLIND_SELECT then
        cb({
            Err = "cannot do this action, must be in blind_select but in " .. G.STATE
        })
        return
    end

    G.FUNCS.skip_blind(get_e())
    cb({
        Ok = calculate_blinds()
    })
end
