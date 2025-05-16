RE.Jokers = {}

function RE.Jokers.joker(card)
	local edition = nil
	if card.edition then
		edition = "e_" .. string.lower(card.edition.type)
	end
	return { item = {Joker = card.config.center.key, edition = edition }, price = card.cost }
end
