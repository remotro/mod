RE.Jokers = {}

function RE.Jokers.joker(card)
	local edition = nil
	if card.edition then
		edition = card.edition.key
	end
	
	local result = { kind = card.config.center.key, price = card.cost, edition = edition }
	local key = card.config.center.key
	
	-- Add additional fields based on joker type
	if key == "j_stencil" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_ceremonial" then
		result.mult = card.config.extra.mult
	elseif key == "j_loyalty_card" then
		-- Sadly the remaining field is a string value formatted as
		-- "N remaining" so we need to parse it
		local remaining = card.config.extra.remaining
		local num_remaining = tonumber(string.match(remaining, "%d+"))
		result.left = num_remaining
	elseif key == "j_steel_joker" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_abstract" then
		result.mult = card.config.extra.mult
	elseif key == "j_ride_the_bus" then
		result.mult = card.config.extra.mult
	elseif key == "j_ice_cream" then
		result.chips = card.config.extra.chips
	elseif key == "j_blue_joker" then
		result.chips = card.config.extra.chips
	elseif key == "j_constellation" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_green_joker" then
		result.mult = card.config.extra.mult
	elseif key == "j_todo_list" then
		result.poker_hand = card.config.extra.poker_hand
	elseif key == "j_red_card" then
		result.mult = card.config.extra.mult
	elseif key == "j_madness" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_square" then
		result.chips = card.config.extra.chips
	elseif key == "j_vampire" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_hologram" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_cloud_9" then
		result.earnings = card.config.extra
	elseif key == "j_rocket" then
		if card.config.extra then
			result.earnings = card.config.extra.dollars
		else
			-- Starting value before joker is bought
			result.earnings = 1
		end
	elseif key == "j_obelisk" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_turtle_bean" then
		result.hand_size = card.config.extra.h_size
	elseif key == "j_erosion" then
		result.mult = card.config.extra.mult
	elseif key == "j_mail" then
		result.rank = G.GAME.current_round.mail_card.rank
	elseif key == "j_fortune_teller" then
		result.mult = card.config.extra.mult
	elseif key == "j_stone" then
		result.chips = card.config.extra.chips
	elseif key == "j_lucky_cat" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_flash" then
		result.mult = card.config.extra.mult
	elseif key == "j_popcorn" then
		result.mult = card.config.extra.mult
	elseif key == "j_trousers" then
		result.mult = card.config.extra.mult
	elseif key == "j_ancient" then
		result.suit =  G.GAME.ancient_round.castle_card.suit
	elseif key == "j_ramen" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_selzer" then
		result.hands_left = card.config.extra
	elseif key == "j_castle" then
		result.chips = card.config.extra.chips
		result.suit =  G.GAME.current_round.castle_card.suit
	elseif key == "j_campfire" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_swashbuckler" then
		result.mult = card.config.extra.mult
	elseif key == "j_throwback" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_glass" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_wee" then
		result.chips = card.config.extra.chips
	elseif key == "j_hit_the_road" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_invisible" then
		result.rounds = card.ability.invis_rounds
	elseif key == "j_satellite" then
		result.earnings = card.config.extra
	elseif key == "j_drivers_license" then
		result.cards = card.ability.driver_tally 
	elseif key == "j_astronomer" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_bootstraps" then
		result.mult = card.config.extra.mult
	elseif key == "j_caino" then
		result.xmult = card.config.extra.Xmult
	elseif key == "j_yorick" then
		result.xmult = card.config.extra.Xmult
	end

	if card.ability.perishable then
		result.lifespan = { Perishable = { rounds_left = card.ability.perish_tally } }
	elseif card.ability.eternal then
		result.lifespan = "Eternal"
	else
		result.lifespan = "Normal"
	end

	result.rental = card.ability.rental ~= nil
	
	return result
end
