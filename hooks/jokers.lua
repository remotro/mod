RE.Jokers = {}

function RE.Jokers.joker(card)
	local edition = nil
	if card.edition then
		edition = card.edition.key
	end

	local kind_data = nil
	local key = card.config.center.key

	sendTraceMessage(RE.JSON.encode(card.ability))
	
	-- Add additional fields based on joker type
	if key == "j_stencil" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_ceremonial" then
		kind_data = { mult = card.ability.extra }
	elseif key == "j_loyalty_card" then
		-- Sadly the remaining field is a string value formatted as
		-- "N remaining" so we need to parse it
		local remaining = card.ability.extra.remaining
		local num_remaining = tonumber(string.match(remaining, "%d+"))
		kind_data = { left = num_remaining }
	elseif key == "j_steel_joker" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_abstract" then
		kind_data = { mult = card.ability.extra }
	elseif key == "j_ride_the_bus" then
		kind_data = { mult = card.ability.extra }
	elseif key == "j_ice_cream" then
		kind_data = { chips = card.ability.extra }
	elseif key == "j_blue_joker" then
		kind_data = { chips = card.ability.extra }
	elseif key == "j_constellation" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_green_joker" then
		kind_data = { mult = card.ability.extra }
	elseif key == "j_todo_list" then
		kind_data = { poker_hand = card.ability.extra.poker_hand }
	elseif key == "j_red_card" then
		kind_data = { mult = card.ability.extra }
	elseif key == "j_madness" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_square" then
		kind_data = { chips = card.ability.extra }
	elseif key == "j_vampire" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_hologram" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_cloud_9" then
		kind_data = { earnings = card.ability.extra }
	elseif key == "j_rocket" then
		kind_data = { earnings = card.ability.extra.dollars }
	elseif key == "j_obelisk" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_turtle_bean" then
		kind_data = { hand_size = card.ability.extra.h_size }
	elseif key == "j_erosion" then
		kind_data = { mult = card.ability.extra }
	elseif key == "j_mail" then
		kind_data = { rank = G.GAME.current_round.mail_card.rank }
	elseif key == "j_fortune_teller" then
		kind_data = { mult = card.ability.extra }
	elseif key == "j_stone" then
		kind_data = { chips = card.ability.extra }
	elseif key == "j_lucky_cat" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_flash" then
		kind_data = { mult = card.ability.extra }
	elseif key == "j_popcorn" then
		kind_data = { mult = card.ability.extra }
	elseif key == "j_trousers" then
		kind_data = { mult = card.ability.extra }
	elseif key == "j_ancient" then
		kind_data = { suit =  G.GAME.ancient_round.castle_card.suit }
	elseif key == "j_ramen" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_selzer" then
		kind_data = { hands_left = card.ability.extra }
	elseif key == "j_castle" then
		kind_data = { chips = card.ability.extra, suit = G.GAME.current_round.castle_card.suit }
	elseif key == "j_campfire" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_swashbuckler" then
		kind_data = { mult = card.ability.extra or 0 }
	elseif key == "j_throwback" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_glass" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_wee" then
		kind_data = { chips = card.ability.extra }
	elseif key == "j_hit_the_road" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_invisible" then
		kind_data = { rounds = card.ability.invis_rounds }
	elseif key == "j_satellite" then
		kind_data = { earnings = card.ability.extra }
	elseif key == "j_drivers_license" then
		kind_data = { cards = card.ability.driver_tally }
	elseif key == "j_astronomer" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_bootstraps" then
		kind_data = { mult = card.ability.extra }
	elseif key == "j_caino" then
		kind_data = { xmult = card.ability.extra }
	elseif key == "j_yorick" then
		kind_data = { xmult = card.ability.extra }
	end

	local result = { kind = kind, price = card.cost, edition = edition }

	if card.ability.perishable then
		result.lifespan = { Perishable = { rounds_left = card.ability.perish_tally } }
	elseif card.ability.eternal then
		result.lifespan = "Eternal"
	else
		result.lifespan = "Normal"
	end

	result.rental = card.ability.rental ~= nil
	
	if kind_data then
		result.kind = { [card.config.center.key] = kind_data }
	else
		result.kind = card.config.center.key
	end

	return result
end
