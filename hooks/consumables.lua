RE.Consumables = {}

function RE.Consumables.consumable(card)
	if card.ability.set == "Tarot" then
		return { Tarot = RE.Consumables.tarot(card) }
	elseif card.ability.set == "Planet" then
		return { Planet = RE.Consumables.planet(card) }
	elseif card.ability.set == "Spectral" then
		return { Spectral = RE.Consumables.spectral(card) }
	end
end

function RE.Consumables.tarot(card)
	local edition = "e_base"
	if card.edition then
		edition = card.edition.key
	end
	local kind_data = {}
	if card.config.center.key == "c_wheel_of_fortune" then
		kind_data = { probability = G.GAME.probability }
	elseif card.config.center.key == "c_temperance" then
        local money = 0
        if G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then
                    money = money + G.jokers.cards[i].sell_cost
                end
            end
        end
		kind_data = { earnings = money }
	end
	return { kind = { [card.config.center.key] = kind_data }, price = card.cost, negative = edition == "e_negative" }
end

function RE.Consumables.planet(card)
	local edition = "e_base"
	if card.edition then
		edition = card.edition.key
	endh
	return { 
		kind = { 
			[card.config.center.key] = { 
				current_level = G.GAME.hands[self.ability.consumeable.hand_type].level -- TODO: Drive this from the real planet progression; the placeholder still references 'self'.
			} 
		},
		price = card.cost,
		negative = edition == "e_negative"
	}
end

function RE.Consumables.spectral(card)
	local edition = "e_base"
	if card.edition then
		edition = card.edition.key
	end
	-- TODO: Provide extra fields for spectral cards that require them (e.g. Ectoplasm hand size penalty).
	return { kind = card.config.center.key, price = card.cost, negative = edition == "e_negative" }
end
