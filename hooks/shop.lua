RE.Shop = {}
RE.Shop.Protocol = {}

function RE.Shop.info()
	sendTraceMessage("state: " .. G.STATE)
	if G.RE.shop then
		sendTraceMessage("shop: true")
	else
		sendTraceMessage("shop: false")
	end
	if G.STATE ~= G.STATES.SHOP or not G.RE.shop then
		sendTraceMessage("returning nil")
		return nil
	end
	local main = G.shop_jokers.cards
	local vouchers = G.shop_vouchers.cards
	local boosters = G.shop_booster.cards

	local main_row = {}
	local vouchers_row = {}
	local boosters_row = {}
	for k, card in ipairs(main) do
		local json = {"Failed"}
		if card.ability.set == "Joker" then
			json = { Joker = RE.Jokers.joker(card) }
		elseif card.ability.set == "Tarot" then
			json = { Tarot = RE.Consumables.tarot(card) }
		elseif card.ability.set == "Planet" then
			json = { Planet = RE.Consumables.planet(card) }
		elseif card.ability.set == "Spectral" then
			json = { Spectral = RE.Consumables.spectral(card) }
		elseif card.ability.set == "Default" then
			json = { Playing = RE.Card.shop(card) }
		end
		table.insert(main_row, json)
	end
	for k, voucher in ipairs(vouchers) do
		local json = { kind = voucher.config.center.key, price = voucher.cost }
		table.insert(vouchers_row, json)
	end
	for k, booster in ipairs(boosters) do
		local json = RE.Boosters.booster(booster)
		table.insert(boosters_row, json)
	end
	return { hud = RE.Hud.info(), main = main_row , vouchers = vouchers_row, boosters = boosters_row }
end

function RE.Shop.Protocol.buy_main(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	local card = G.shop_jokers.cards[request.index + 1]
	if not G.FUNCS.check_for_buy_space(card) then
		err("Cannot do this action, No space")
	end
	if (card.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (card.cost > 0) then
		err("Cannot do this action, Not enough money")
		return
	end
	G.FUNCS.buy_from_shop({config={ref_table=card}})
	RE.Util.enqueue(function()
		ok(RE.Shop.info())
	end)
end


function RE.Shop.Protocol.buy_and_use(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " ..G.STATE)
		return
	end
	local card = G.shop_jokers.cards[request.index + 1]
	card.config.id = 'buy_and_use'
	if (card.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (card.cost > 0) then
		err("Cannot do this action, Not enough money")
		return
	end
	G.FUNCS.buy_from_shop({config={ref_table=card}})
	RE.Util.enqueue(function()
		ok(RE.Shop.info())
	end)
end

function RE.Shop.Protocol.buy_voucher(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	local voucher = G.shop_vouchers.cards[request.index + 1]
	if (voucher.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (voucher.cost > 0) then
		err("Cannot do this action, Not enough money")
		return
	end
	G.FUNCS.use_card({config={ref_table=voucher}})
	RE.Util.enqueue(function()
		ok(RE.Shop.info())
	end)
end

function RE.Shop.Protocol.buy_booster(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	local pack = G.shop_booster.cards[request.index + 1]
	if (pack.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (pack.cost > 0) then
		err("Cannot do this action, Not enough money")
		return
	end
	G.FUNCS.use_card({config={ref_table=pack}})
	RE.Util.await(
	function()
		return RE.Boosters.info() ~= nil
	end,
	function()
		ok(RE.Boosters.info())
	end)
end

function RE.Shop.Protocol.reroll(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	if ((G.GAME.dollars-G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost < 0) and G.GAME.current_round.reroll_cost ~= 0 then
		err("Cannot do this action, Not enough money")
		return
	end
	G.FUNCS.reroll_shop()
	RE.Util.enqueue(function()
		ok(RE.Shop.info())
	end)
end

function RE.Shop.Protocol.continue(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	G.FUNCS.toggle_shop()
	RE.Screen.await(G.STATES.BLIND_SELECT, function()
		ok(RE.Blinds.info())
	end)
end
