RE.Play = {}
RE.Play.Protocol = {}

function RE.Play.info()
    local blind_status = G.GAME.current_round
	local hands = blind_status.hands_left
	local discards = blind_status.discards_left
	local money = G.GAME.dollars
	local score = G.GAME.chips

    local hand = G.hand.cards
    local json_hand = {}
    for i, card in ipairs(hand) do
        local base_json = RE.Deck.playing_card(card)
        local json;
        if card.facing == 'front' then
            json = { card = base_json, selected = card.highlighted }
        else
            json = { card = nil, selected = card.highlighted }
        end
        table.insert(json_hand, json)
    end
    return { 
		hand = json_hand,
		current_blind = RE.Blinds.current(),
		score = score,
		hands = hands,
		discards = discards,
		money = money
	}
end

function RE.Play.Protocol.click(request, ok, err)
    if G.STATE ~= G.STATES.SELECTING_HAND then
        err("cannot do this action, must be in selecting_hand but in " .. G.STATE)
        return
    end

    local hand = G.hand.cards
    local indices = request.indices
    local invalid_indices = {}
    for _, index in ipairs(indices) do
        if index < 0 or index >= #hand then
            table.insert(invalid_indices, index)
        end
    end
    if #invalid_indices > 0 then
        err("invalid card indices: " .. table.concat(invalid_indices, ", "))
        return
    end

    for _, index in ipairs(indices) do
        hand[index + 1]:click()
    end
    ok(RE.Play.info())
end

function RE.Play.Protocol.play(request, ok, err)
    if G.STATE ~= G.STATES.SELECTING_HAND then
        err("cannot do this action, must be in selecting_hand but in " .. G.STATE)
        return
    end

    -- Needs to be some highlighted cards
    if #G.hand.highlighted <= 0 then
        err("no cards highlighted")
        return
    end

    G.GAME.chips = G.GAME.blind.chips
    G.STATE = G.STATES.HAND_PLAYED
    G.STATE_COMPLETE = true
    end_round()

    RE.Screen.await({G.STATES.SELECTING_HAND, G.STATES.ROUND_EVAL, G.STATES.GAME_OVER}, function(new_state)
        if new_state == G.STATES.SELECTING_HAND then
            ok({Again = RE.Play.info()})
        elseif new_state == G.STATES.ROUND_EVAL then
            RE.Overview.round(function(res)
                ok({RoundOver = res})
            end)
        elseif new_state == G.STATES.GAME_OVER then
            ok({GameOver = {}})
        end
    end)
end

function RE.Play.Protocol.discard(request, ok, err)
    if G.STATE ~= G.STATES.SELECTING_HAND then
        err("cannot do this action, must be in selecting_hand but in " .. G.STATE)
        return
    end

    -- Needs to be some highlighted cards
    if #G.hand.highlighted <= 0 then
        err("no cards highlighted")
        return
    end

	-- Needs to have discards remaining
	if G.GAME.current_round.discards_left <= 0 then
		err("No Discards left")
		return
	end

    -- Can get away with not including a UI element here since its not used
    G.FUNCS.discard_cards_from_highlighted(nil)
    RE.Screen.await({G.STATES.SELECTING_HAND, G.STATES.GAME_OVER}, function(new_state)
        if new_state == G.STATES.SELECTING_HAND then
            ok({Again = RE.Play.info()})
        elseif new_state == G.STATES.GAME_OVER then
            ok({GameOver = {}})
        end
    end)
end
