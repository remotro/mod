RE.Card = {}

function RE.Card.shop(card)
	local edition = "e_base"
	if card.edition then
		edition = card.edition.key
	end
	local cardJson = RE.Deck.playing_card(card)
	return { item = { PlayingCard = cardJson }, price = card.cost, edition = edition }
end
