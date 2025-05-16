RE.Deck = {}

function RE.Deck.playing_card(card)
    local edition = nil;
    if card.edition then
        edition = card.edition.key;
    end
    local enhancement = nil;
    if card.ability.name ~= "Default Base" then
        enhancement = "m_" .. string.lower(card.ability.name);
    end
    local rank = card.base.value;
    local suit = card.base.suit;
    local seal = nil;
    if card.seal then
        seal = string.lower(card.seal) .. "_seal";
    end
    return {
        edition = edition,
        enhancement = enhancement,
        rank = rank,
        suit = suit,
        seal = seal
    }
end
