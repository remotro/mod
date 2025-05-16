RE.Consumables = {}

function RE.Consumables.tarot(card)
	return { item = { Tarot = card.config.center.key }, price = card.cost }
end

function RE.Consumables.planet(card)
	local hand_type = card.hand_type
	return { item = { Planet = card.config.center.key }, price = card.cost }
end

function RE.Consumables.spectral(card)
	return { item = { Spectral = card.config.center.key }, price = card.cost }
end

