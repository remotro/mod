RE.Shop = {}
RE.Shop.Protocol = {}

function RE.Shop.info()
	local main = G.shop_jokers.cards
	local vouchers = G.shop_vouchers.cards
	local boosters = G.shop_booster.cards

	local main_row = {}
	local vouchers_row = {}
	local boosters_row = {}
	for k, card in ipairs(main) do
		RE.Util.inspectTable(card, "card.txt")
		local json = {"Failed"}
		if card.ability.set == "Joker" then
			json = RE.Jokers.joker(card)
		elseif card.ability.set == "Tarot" then
			json = RE.Consumables.tarot(card)
		elseif card.ability.set == "Planet" then
			json = RE.Consumables.planet(card)
		elseif card.ability.set == "Spectral" then
			json = RE.Consumables.spectral(card)
		end
		table.insert(main_row, json)
	end
	for k, voucher in ipairs(vouchers) do
		local json = { voucher = voucher.config.center.key, price = voucher.cost }
		table.insert(vouchers_row, json)
	end
	for k, booster in ipairs(boosters) do
		local json = { booster = string.sub(booster.config.center.key,1,-3), price = booster.cost }
		table.insert(boosters_row, json)
	end
	return { main = main_row , vouchers = vouchers_row, boosters = boosters_row }
end

function RE.Shop.Protocol.buy_main(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	local card = G.shop_jokers.cards[request.index]
	if not G.FUNCS.check_for_buy_space(card) then
		err("Cannot do this action, No space")
	end
	if (card.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (card.cost > 0) then
		err("Not enough money")
		return
	end
	G.FUNCS.buy_from_shop({config={ref_table=card}})
	ok(RE.Shop.info())
end


function RE.Shop.Protocol.buy_and_use(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " ..G.STATE)
		return
	end
	local card = G.shop_jokers.cards[request.index]
	card.config.id = 'buy_and_use'
	if (card.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (card.cost > 0) then
		err("Not enough money")
		return
	end
	G.FUNCS.buy_from_shop({config={ref_table=card}})
	ok(RE.Shop.info())
end

function RE.Shop.Protocol.buy_voucher(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	local voucher = G.shop_vouchers.cards[request.index]
	if (voucher.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (voucher.cost > 0) then
		err("Not enough money")
		return
	end
	G.FUNCS.use_card({config={ref_table=voucher}})
	ok(RE.Shop.info())
end

function RE.Shop.Protocol.buy_booster(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	local pack = G.shop_booster.cards[request.index]
	if (pack.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (pack.cost > 0) then
		err("Not enough money")
		return
	end
	G.FUNCS.use_card({config={ref_table=pack}})
	ok(RE.Shop.info())
end

function RE.Shop.Protocol.reroll(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	if ((G.GAME.dollars-G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost < 0) and G.GAME.current_round.reroll_cost ~= 0 then
		err("Not enough money")
		return
	end
	G.FUNCS.reroll_shop()
	ok(RE.Shop.info())
end

function RE.Shop.Protocol.continue(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	G.FUNCS.toggle_shop()
	RE.Screen.await(G.STATES.BLIND_SELECT, function()
		ok(RE.Blinds.choices())
	end)
end
