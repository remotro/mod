RE.Hud = {}
RE.Hud.Protocol = {}

local function screen_info(screen)
    if screen == "blind_select" then
        return RE.Blinds.info()
    elseif screen == "play" then
        return RE.Play.info()
    elseif screen == "shop" then
        return RE.Shop.info()
    elseif string.match(screen, ".*/open/.*") then
        return RE.Boosters.info(true)
    end
end

function RE.Hud.info()
    local jokers = {}
    for _, card in pairs(G.jokers.cards) do
        table.insert(jokers, RE.Jokers.joker(card))
    end
	local json_deck = {}
	for _, card in ipairs(G.deck.cards) do
		table.insert(json_deck, RE.Deck.playing_card(card))
	end
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
            played_round = poker_hand.played_this_round,
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
    local tags = {}
    for _, tag in pairs(G.GAME.tags) do
        table.insert(tags, tag.key)
    end
    return {
        hands = G.GAME.current_round.hands_left,
		discards = G.GAME.current_round.discards_left,
		money = G.GAME.dollars,
        round = G.GAME.round,
        ante = G.GAME.round_resets.ante,
        jokers = jokers,
		joker_slots = G.jokers.config.card_limit,
        consumables = consumables,
		consumable_slots = G.consumeables.config.card_limit,
        tags = tags,
		deck = json_deck,
        run_info = {
            poker_hands = poker_hands,
            blinds = {
                small = RE.Blinds.choice("Small"),
                big = RE.Blinds.choice("Big"),
                boss = RE.Blinds.choice("Boss"),
            },
            vouchers_redeemed = vouchers_redeemed,
            stake = G.GAME.stake,
			deck = G.GAME.selected_back.effect.center.key,
        }
    }
end

function RE.Hud.Protocol.sell_joker(request, screen, ok, err)
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
                ok(screen_info(screen))
            end)
        end)
    end)
end

function RE.Hud.Protocol.move_joker(request, screen, ok, err)
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
    table.insert(G.jokers.cards, to + 1 , table.remove(G.jokers.cards, from + 1))
    RE.Util.enqueue(function()
        ok(screen_info(screen))
    end)
end

function RE.Hud.Protocol.sell_consumable(request, screen, ok, err)
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
                ok(screen_info(screen))
            end)
        end)
    end)
end

function RE.Hud.Protocol.move_consumable(request, screen, ok, err)
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
    table.insert(G.consumeables.cards, to + 1, table.remove(G.consumeables.cards, from + 1))
	RE.Util.enqueue(function()
        ok(screen_info(screen))
    end)
end

function RE.Hud.Protocol.use_consumable(request, screen, ok, err)
    local card = G.consumeables.cards[request.index + 1]
    if not card then
        err("invalid use index")
        return
    end
    if card.ability.max_highlighted then
        if not G.hand.highlighted then
            err("no cards highlighted")
            return
        elseif card.ability.max_highlighted > #G.hand.highlighted then
            err("too many cards highlighted")
            return
        end
    end
    G.FUNCS.use_card({config={ref_table=card}})
    RE.Util.enqueue(function()
        ok(screen_info(screen))
    end)
end
