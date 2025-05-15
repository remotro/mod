RE.Consumables = {}

function RE.Consumables.Tarot(card)
	return { card.name }
end

function RE.Consumables.Planet(card)
	local hand_type = card.hand_type
	return { name = card.name, hand = hand_type }
end

function RE.Consumables.Spectral(card)
	return { card.name }
end

