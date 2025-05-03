RE.Deck = {}

function RE.Deck.playing_cards(cards)
    local json_cards = {};
    for i, card in ipairs(cards) do
        local edition = nil;
        if card.edition then
            edition = "e_" .. string.lower(card.edition.type);
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
        local json = {
            edition = edition,
            enhancement = enhancement,
            rank = rank,
            suit = suit,
            seal = seal
        }
        table.insert(json_cards, json);
    end
    return json_cards
end