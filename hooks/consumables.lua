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
	return { kind = card.config.center.key, price = card.cost, negative = edition == "e_negative" }
end

function RE.Consumables.planet(card)
	local edition = "e_base"
	if card.edition then
		edition = card.edition.key
	end
	return { kind = card.config.center.key, price = card.cost, negative = edition == "e_negative" }
end

function RE.Consumables.spectral(card)
	local edition = "e_base"
	if card.edition then
		edition = card.edition.key
	end
	return { kind = card.config.center.key, price = card.cost, negative = edition == "e_negative" }
end

