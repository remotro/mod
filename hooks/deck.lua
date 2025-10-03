RE.Deck = {}

function RE.Deck.playing_card(card)
    local edition = nil;
    if card.edition then
        edition = card.edition.key;
    end
    local enhancement = nil;
    if card.ability.name ~= "Default Base" then
        enhancement = "m_" .. string.lower(card.ability.name:match("%w+"));
        -- TODO: Attach enhancement metadata (e.g. Glass/Lucky probabilities) so the client can deserialize Enhancement variants with payloads.
    end
	local debuffed = card.debuff;
    local rank = card.base.value;
    local suit = card.base.suit;
    local seal = nil;
    if card.seal then
        seal = string.lower(card.seal) .. "_seal";
    end
    return {
		debuffed = debuffed,
        edition = edition,
        enhancement = enhancement,
        rank = rank,
        suit = suit,
        seal = seal,
        extra_chips = (card.ability.bonus + (card.ability.perma_bonus or 0)) > 0 and (card.ability.bonus + (card.ability.perma_bonus or 0)) or nil
    }
end
