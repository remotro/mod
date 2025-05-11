RE.Shop = {}
RE.Shop.Protocol = {}

function RE.Shop.info()
	return { jokers = G.shop_jokers.cards, vouchers = G.shop_vouchers.cards, boosters = G.Shop_booster.cards }
end

function RE.Shop.Protocol.buy_main(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	if not G.FUNCS.check_for_buy_space(c) then
		err("Cannot do this action, No space")
	end
	if (e.config.ref_table.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (e.config.ref_table.cost > 0) then
		Err("Not enough money")
		return
	end
end

function RE.Shop.Protocol.buy_voucher(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
end

function RE.Shop.Protocol.buy_booster(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
end

function RE.Shop.Protocol.buy_and_use(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " ..G.STATE)
		return
	end
	if e.config.id ~= 'buy_and_use' then
		err("Cannot do this action, card cannot be used right now")
		return
	end
end


function RE.Shop.Protocol.reroll(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	if ((G.GAME.dollars-G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost < 0) and G.GAME.current_round.reroll_cost ~= 0 then
		err("Cannot afford to reroll shop")
		return
	end
	G.FUNCS.reroll_shop()
end

function RE.Shop.Protocol.continue(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end


