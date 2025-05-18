RE.Hud = {}
RE.Hud.Protocol = {}

function RE.Hud.get(ok, err)
	local hands = G.GAME.current_round.hands_left
	local discards = G.GAME.current_round.discards_left
	local money = G.GAME.dollars
    return {
        hands = hands,
		discards = discards,
		money = money,
        round = 0,
        ante = 0,
        jokers = {},
        consumables = {}
    }
end