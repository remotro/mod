RE.Jokers = {}

function RE.Jokers.joker(card)
	local edition = "e_base"
	if card.edition then
		edition = card.edition.key
	end
	return { item = {Joker = card.config.center.key }, price = card.cost, edition = edition }
end
