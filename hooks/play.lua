RE.Play = {}
RE.Play.Protocol = {}

function RE.Play.get_hand()
    return { hand = RE.Deck.playing_cards(G.hand.cards) }
end

function RE.Play.Protocol.click(request, ok, err)
    if G.STATE ~= G.STATES.SELECTING_HAND then
        err("cannot do this action, must be in selecting_hand but in " .. G.STATE)
        return
    end

    local hand = G.hand.cards;
    local indices = request.indices;
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
    ok(RE.Play.get_hand())
end
