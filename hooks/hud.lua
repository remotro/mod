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
	local joker_slots = G.jokers.config.card_limit
    local jokers = {}
    for _, card in pairs(G.jokers.cards) do
        table.insert(jokers, RE.Jokers.joker(card))
    end
	local consumable_slots = G.consumeables.config.card_limit
    local consumables = {}
    for _, card in pairs(G.consumeables.cards) do
        table.insert(consumables, RE.Consumables.consumable(card))
    end
    local poker_hands = {}
    for kind, poker_hand in pairs(G.GAME.hands) do
        -- for the field we need to lowercase and replace spaces with underscores
        local transformed_kind = kind:lower():gsub(" ", "_")
        poker_hands[transformed_kind] = {
            played = poker_hand.played,
            hand = {
                kind = kind,
                level = poker_hand.level,
                chips = poker_hand.chips,
                mult = poker_hand.mult,
            }
        }
    end
    local vouchers_redeemed = {}
    for voucher, _ in pairs(G.GAME.used_vouchers) do
        table.insert(vouchers_redeemed, voucher)
    end
    return {
        hands = hands,
		discards = discards,
		money = money,
        round = round,
        ante = ante,
		joker_slots = joker_slots,
        jokers = jokers,
        consumables = consumables,
        run_info = {
            poker_hands = poker_hands,
            blinds = {
                small = RE.Blinds.choice("Small"),
                big = RE.Blinds.choice("Big"),
                boss = RE.Blinds.choice("Boss"),
            },
            vouchers_redeemed = vouchers_redeemed,
            stake = G.GAME.stake,
        }
    }
end

function RE.Hud.Protocol.sell_joker(request, context, ok, err)
    local card = G.jokers.cards[request.index + 1]
    if not card then
        err("invalid sell index")
        return
    end
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
    if not G.jokers.cards[from + 1] then
        err("invalid move from index")
        return
    end
    local to = request.to
    if not G.jokers.cards[to + 1] then
        err("invalid move to index")
        return
    end
    local tmp = G.jokers.cards[from + 1]
    table.remove(G.jokers.cards, from + 1)
    RE.Util.enqueue(function()
        ok(context_screen(context))
    end)
end

function RE.Hud.Protocol.sell_consumable(request, context, ok, err)
    local card = G.consumeables.cards[request.index + 1]
    if not card then
        err("invalid sell index")
        return
    end
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
    if not G.consumeables.cards[from + 1] then
        err("invalid move from index")
        return
    end
    local to = request.to
    if not G.consumeables.cards[to + 1] then
        err("invalid move to index")
        return
    end
    table.remove(G.consumeables.cards, from + 1)
    table.insert(G.consumeables.cards, to + 1, tmp)
    RE.Util.enqueue(function()
        ok(context_screen(context))
    end)
end

function RE.Hud.Protocol.use_consumable(request, context, ok, err)
    local card = G.consumeables.cards[request.index + 1]
    if not card then
        err("invalid use index")
        return
    end
    G.FUNCS.use_card({config={ref_table=card}})
    RE.Util.enqueue(function()
        if G.STATE == G.STATES.GAME_OVER then
            ok({GameOver = {}})
        else
            ok({Used = context_screen(context)})
        end
    end)
end
