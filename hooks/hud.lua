RE.Hud = {}
RE.Hud.Protocol = {}

function RE.Hud.get(ok, err)
	local hands = G.GAME.current_round.hands_left
	local discards = G.GAME.current_round.discards_left
	local money = G.GAME.dollars
    local round = G.GAME.round
    local ante = G.GAME.round_resets.ante
    local jokers = {}
    for _, card in pairs(G.jokers.cards) do
        table.insert(jokers, RE.Jokers.joker(card))
    end
    return {
        hands = hands,
		discards = discards,
		money = money,
        round = round,
        ante = ante,
        jokers = jokers,
        consumables = {}
    }
end