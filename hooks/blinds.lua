RE.Blinds = {}
RE.Blinds.Protocol = {}

local function calculate_chip_requirement(blind_id)
    local blind = G.P_BLINDS[blind_id]
    return get_blind_amount(G.GAME.round_resets.ante) * blind.mult * G.GAME.starting_params.ante_scaling
end

function RE.Blinds.current()
    local current_blind_choice = G.GAME.blind_on_deck
    local blind_id = G.GAME.round_resets.blind_choices[current_blind_choice]
    if current_blind_choice == "Boss" then
        return { Boss = { chips = calculate_chip_requirement(blind_id), kind = blind_id } }
    else
        local ret = {}
        ret[current_blind_choice] = { chips = calculate_chip_requirement(blind_id) }
        return ret
    end
end

function RE.Blinds.choice(id)
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

function RE.Blinds.choices()
    return {
        small = RE.Blinds.choice("Small"),
        big = RE.Blinds.choice("Big"),
        boss = RE.Blinds.choice("Boss"),
    }
end

local function get_blind_choice_widget()
	selected_blind = G.GAME.blind_on_deck
	selected = selected_blind == "Small" and 1 or selected_blind == "Big" and 2 or 3
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
	elseif G.GAME.blind_on_deck == "Boss" then
		err("Cannot skip Boss Blind")
		return
	end
	G.FUNCS.skip_blind(get_blind_choice_widget())
    RE.Screen.await(G.STATES.BLIND_SELECT, function()
        ok(RE.Blinds.choices())
    end)
end
