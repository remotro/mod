RE.Consumables = {}

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

