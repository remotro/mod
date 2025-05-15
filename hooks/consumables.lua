RE.Consumables = {}

function RE.Consumables.tarot(card)
	return { card.name }
end

function RE.Consumables.planet(card)
	local hand_type = card.hand_type
	return { name = card.name, hand = hand_type }
end

function RE.Consumables.spectral(card)
	return { card.name }
end

