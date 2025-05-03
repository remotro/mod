RE.Play = {}
RE.Play.Protocol = {}

function RE.Play.info()
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
    return { hand = json_hand }
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
    ok(RE.Play.info())
end


function RE.Play.Protocol.play(request, ok, err)
    if G.STATE ~= G.STATES.SELECTING_HAND then
        err("cannot do this action, must be in selecting_hand but in " .. G.STATE)
        return
    end

    -- Needs to be some highlighted cards
    local highlighted_cards = false
    for _, card in ipairs(G.hand.cards) do
        if card.highlighted then
            highlighted_cards = true
        end
    end
    if not highlighted_cards then
        err("no cards highlighted")
        return
    end

    -- Can get away with not including a UI element here since its not used
    G.FUNCS.play_cards_from_highlighted(nil)
    function launch() 
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            no_delete = true,
            func = function()
                if G.STATE ~= G.STATES.SELECTING_HAND then
                    launch()
                    return true
                end
                ok(RE.Play.info())
                return true
            end
        }))
    end
    launch()
end

function RE.Play.Protocol.discard(request, ok, err)
    if G.STATE ~= G.STATES.SELECTING_HAND then
        err("cannot do this action, must be in selecting_hand but in " .. G.STATE)
        return
    end

    -- Needs to be some highlighted cards
    local highlighted_cards = false
    for _, card in ipairs(G.hand.cards) do
        if card.highlighted then
            highlighted_cards = true
        end
    end
    if not highlighted_cards then
        err("no cards highlighted")
        return
    end

    -- Can get away with not including a UI element here since its not used
    G.FUNCS.discard_cards_from_highlighted(nil)
    function launch() 
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            no_delete = true,
            func = function()
                if G.STATE ~= G.STATES.SELECTING_HAND then
                    launch()
                    return true
                end
                ok(RE.Play.info())
                return true
            end
        }))
    end
    launch()
end
