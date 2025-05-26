RE.Hud = {}
RE.Hud.Protocol = {}

local function context_screen(context)
    if context == "menu" then
        return {}
    elseif context == "blind_select" then
        return RE.Blinds.info()
    elseif context == "play" then
        return RE.Play.info()
    elseif context == "shop" then
        return RE.Shop.info()
    end
end

function RE.Hud.info()
	local hands = G.GAME.current_round.hands_left
	local discards = G.GAME.current_round.discards_left
	local money = G.GAME.dollars
    local round = G.GAME.round
    local ante = G.GAME.round_resets.ante
    local jokers = {}
    for _, card in pairs(G.jokers.cards) do
        table.insert(jokers, RE.Jokers.joker(card))
    end
    local consumables = {}
    for _, card in pairs(G.consumeables.cards) do
        table.insert(consumables, RE.Consumables.consumable(card))
    end
    return {
        hands = hands,
		discards = discards,
		money = money,
        round = round,
        ante = ante,
        jokers = jokers,
        consumables = consumables
    }
end

function RE.Hud.Protocol.sell_joker(request, context, ok, err)
    local card = G.jokers.cards[request.index + 1]
    G.FUNCS.sell_card({config={ref_table=card}})
    RE.Util.enqueue(function()
        RE.Util.await(function()
            return G.CONTROLLER.locks.selling_card ~= nil
        end, function()
            RE.Util.enqueue(function()
                ok(context_screen(context))
            end)
        end)
    end)
end

function RE.Hud.Protocol.move_joker(request, context, ok, err)
    local from = request.from
    local to = request.to
    local tmp = G.jokers.cards[from + 1]
    table.remove(G.jokers.cards, from + 1)
    table.insert(G.jokers.cards, to + 1, tmp)
    RE.Util.enqueue(function()
        ok(context_screen(context))
    end)
end

function RE.Hud.Protocol.sell_consumable(request, context, ok, err)
    local card = G.consumeables.cards[request.index + 1]
    G.FUNCS.sell_card({config={ref_table=card}})
    RE.Util.enqueue(function()
        RE.Util.await(function()
            return G.CONTROLLER.locks.selling_card ~= nil
        end, function()
            RE.Util.enqueue(function()
                ok(context_screen(context))
            end)
        end)
    end)
end

function RE.Hud.Protocol.move_consumable(request, context, ok, err)
    local from = request.from
    local to = request.to
    local tmp = G.consumeables.cards[from + 1]
    table.remove(G.consumeables.cards, from + 1)
    table.insert(G.consumeables.cards, to + 1, tmp)
    RE.Util.enqueue(function()
        ok(context_screen(context))
    end)
end

function RE.Hud.Protocol.use_consumable(request, context, ok, err)
    local card = G.consumeables.cards[request.index + 1]
    G.FUNCS.use_card({config={ref_table=card}})
    RE.Util.enqueue(function()
        if G.STATE == G.STATES.GAME_OVER then
            ok({GameOver = {}})
        else
            ok({Used = context_screen(context)})
        end
    end)
end
