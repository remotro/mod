RE.Hand = {}
RE.Hand.Protocol = {}

function RE.Hands.get()
    local hand = G.hand;
    local json_hand = {};
    for i, v in ipairs(hand) do
        local card_info = v.base;
        local json = {
            rank = card_info.value,
            suit = card_info.suit,
        }
        table.insert(json_hand, json);
    end
    return json_hand
end