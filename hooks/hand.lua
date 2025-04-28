RE.Hand = {}
RE.Hand.Protocol = {}

function RE.Hands.get()
    local hand = G.hand;
    local json_hand = {};
    for i, v in ipairs(hand) do
        local edition = "";
        if card.edition.foil then
            edition = "e_foil"
        elseif card.edition.holo then
            edition = "e_holo"
        elseif card.edition.polychrome then
            edition = "e_polychrome"
        elseif card.edition.negative then
            edition = "e_negative"
        else
            edition = "e_base"
        end
        local enhancement = card.ability.name;
        local card_info = v.base;
        local rank = card_info.value;
        local suit = card_info.suit;
        local seal = card.seal;
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
end