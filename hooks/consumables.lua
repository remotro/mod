RE.Consumables = {}

function RE.Consumables.tarot(card)
	local edition = "e_base"
	if card.edition then
		edition = card.edition.key
	end
	return { item = { Tarot = card.config.center.key }, price = card.cost, edition = edition }
end

function RE.Consumables.planet(card)
	local edition = "e_base"
	if card.edition then
		edition = card.edition.key
	end
	return { item = { Planet = card.config.center.key }, price = card.cost, edition = edition }
end

function RE.Consumables.spectral(card)
	local edition = "e_base"
	if card.edition then
		edition = card.edition.key
	end
	return { item = { Spectral = card.config.center.key }, price = card.cost, edition = edition}
end

