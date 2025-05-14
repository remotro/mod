RE.JOKERS = {}

function RE.Jokers.joker(card)
	local edition = nil
	if card.edition then
		edition = "e_" .. string.lower(card.edition.type)
	end
	return {edition = edition}
end
