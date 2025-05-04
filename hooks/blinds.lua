RE.Blinds = {}
RE.Blinds.Protocol = {}

local function calculate_chip_requirement(blind_id)
    local blind = G.P_BLINDS[blind_id]
    return get_blind_amount(G.GAME.round_resets.ante) * blind.mult * G.GAME.starting_params.ante_scaling
end

function RE.Blinds.get(id)
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

function RE.Blinds.info()
    return {
        small = RE.Blinds.get("Small"),
        big = RE.Blinds.get("Big"),
        boss = RE.Blinds.get("Boss"),
    }
end

local function get_blind_choice_widget()
	selected = G.GAME.round_resets.blind_states["Small"] == "Select" and 1 or 2
	return G.blind_select.UIRoot.children[1].children[selected].config.object:get_UIE_by_ID('select_blind_button')
end

function RE.Blinds.Protocol.select_blind(request, ok, err)
    if G.STATE ~= G.STATES.BLIND_SELECT then
        err("cannot do this action, must be in blind_select but in " .. G.STATE)
        return
    end

    G.FUNCS.select_blind(get_blind_choice_widget())
    RE.Screen.await(G.STATES.SELECTING_HAND, function()
        ok(RE.Play.info())
    end)
end

function RE.Blinds.Protocol.skip_blind(request, ok, err)
    if G.STATE ~= G.STATES.BLIND_SELECT then
        err("cannot do this action, must be in blind_select but in " .. G.STATE)
        return
	elseif G.GAME.round_resets.blind_states["Boss"] == "Select" then
		err("Cannot skip Boss Blind")
		return
	end
	G.FUNCS.skip_blind(get_blind_choice_widget())
    RE.Screen.await(G.STATES.BLIND_SELECT, function()
        ok(RE.Blinds.info())
    end)
end
