RE.Jokers = {}

function RE.Jokers.joker(card)
	local edition = nil
	if card.edition then
		edition = card.edition.key
	end
	return { kind = card.config.center.key, price = card.cost, edition = edition }
end
