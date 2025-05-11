RE.Shop = {}
RE.Shop.Protocol = {}

function RE.Shop.info()
	return { jokers = G.shop_jokers.cards, vouchers = G.shop_vouchers.cards, boosters = G.Shop_booster.cards }
end

function RE.Shop.Protocol.buy(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("cannot do this action, must be in shop but in " .. G.STATE)
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


