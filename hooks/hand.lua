RE.Hand = {}
RE.Hand.Protocol = {}

function RE.Hands.get()
    local hand = G.hand;
    local json_hand = {};
    for i, card in ipairs(hand) do
        local edition = "e_" .. string.lower(card.edition.type);
        local enhancement = "m_" .. string.lower(card.ability.name);
        local rank = card.base.value;
        local suit = card.base.suit;
        local seal = string.lower(card.seal) .. "_seal";
        local json = {
            edition = edition,
            enhancement = enhancement,
            value = rank,
            suit = suit,
            seal = seal
        }
        table.insert(json_hand, json);
    end
    return json_hand
end>