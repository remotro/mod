RE.Boosters = {}
RE.Boosters.Protocol = {}

local function open_info(convert)
    local options = {}
    for i, card in ipairs(G.pack_cards.cards) do
        table.insert(options, convert(card))
    end
    local kind = string.sub(SMODS.OPENED_BOOSTER.config.center.key,1,-3)
    return {
        booster = kind,
        options = options,
        selections_left = G.GAME.pack_choices
    }
end

local function open_info_with_hand(convert)
    local options = open_info(convert)
    options.hand = {}
    for i, card in ipairs(G.hand) do
        table.insert(options.hand, { card = RE.Deck.playing_card(card), selected = card.highlighted })
    end
    return options
end

function RE.Boosters.arcana()
    return open_info_with_hand(RE.Consumables.tarot)
end

function RE.Boosters.buffoon()
    return open_info(RE.Jokers.joker)
end

function RE.Boosters.celestial()
    return open_info(RE.Consumables.celestial)
end

function RE.Boosters.spectral()
    return open_info_with_hand(RE.Consumables.spectral)
end

function RE.Boosters.standard()
    return open_info_with_hand(RE.Deck.playing_card)
end