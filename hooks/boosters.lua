RE.Boosters = {}
RE.Boosters.Protocol = {}

function RE.Boosters.booster(card)
    return {
        kind = string.sub(card.config.center.key, 1, -3),
        price = card.cost,
    }
end

local function open_info(convert)
    local options = {}
    for i, card in ipairs(G.pack_cards.cards) do
        table.insert(options, convert(card))
    end
    local kind = RE.Boosters.booster(SMODS.OPENED_BOOSTER).kind
    return {
        booster = kind,
        options = options,
        selections_left = G.GAME.pack_choices
    }
end

local function open_info_with_hand(convert)
    local options = open_info(convert)
    options.hand = {}
    for i, card in ipairs(G.hand.cards) do
        table.insert(options.hand, { card = RE.Deck.playing_card(card), selected = card.highlighted })
    end
    return options
end

local function tarot_option(c)
    if c.ability.set == "Tarot" then
        return { Tarot = RE.Consumables.tarot(c).kind }
    elseif c.ability.set == "Spectral" then
        if c.config.center.key == "c_soul" then
            return { Soul = {} }
        else
            return { Spectral = RE.Consumables.spectral(c).kind }
        end
    end
end

local function arcana_info()
    return open_info_with_hand(tarot_option)
end

local function buffoon_info()
    return open_info(RE.Jokers.joker)
end

local function celestial_option(c)
    if c.ability.set == "Planet" then
        return { Planet = RE.Consumables.planet(c).kind }
    elseif c.config.center.key == "c_black_hole" then
        return { BlackHole = {} }
    end
end

local function celestial_info()
    return open_info(celestial_option)
end

local function spectral_option(c)
    if c.config.center.key == "c_soul" then
        return { Soul = {} }
    elseif c.config.center.key == "c_black_hole" then
        return { BlackHole = {} }
    else
        return { Spectral = RE.Consumables.spectral(c).kind }
    end
end

local function spectral_info()
    return open_info_with_hand(spectral_option)
end

local function standard_info()
    return open_info_with_hand(RE.Deck.playing_card)
end

local function pack_info(context)
    if context == "arcana" then
        return arcana_info()
    elseif context == "buffoon" then
        return buffoon_info()
    elseif context == "celestial" then
        return celestial_info()
    elseif context == "spectral" then
        return spectral_info()
    elseif context == "standard" then
        return standard_info()
    end
end

local function context_info(context)
    if context == "shop" then
        return RE.Shop.info()
    end
end

function RE.Boosters.info()
    if SMODS.OPENED_BOOSTER == nil or G.pack_cards == nil then
        return nil
    end
    local booster = RE.Boosters.booster(SMODS.OPENED_BOOSTER)
    if string.find(booster.kind, "arcana") then
        if #G.hand.cards == 0 then
            return nil
        end
        return { Arcana = arcana_info() }
    elseif string.find(booster.kind, "buffoon") then
        return { Buffoon = buffoon_info() }
    elseif string.find(booster.kind, "celestial") then
        return { Celestial = celestial_info() }
    elseif string.find(booster.kind, "spectral") then
        if #G.hand.cards == 0 then
            return nil
        end
        return { Spectral = spectral_info() }
    elseif string.find(booster.kind, "standard") then
        return { Standard = standard_info() }
    end
end

function RE.Boosters.Protocol.skip(request, context, pack, ok, err)
    if RE.Boosters.info() == nil then
        err("Cannot do this action, must be in booster state but in state " .. G.STATE)
        return
    end
    G.FUNCS.skip_booster(nil)
    RE.Util.enqueue(function()
        ok(context_info(context))
    end)
end

function RE.Boosters.Protocol.select(request, context, pack, ok, err)
    if RE.Boosters.info() == nil then
        err("Cannot do this action, must be in booster state but in state " .. G.STATE)
        return
    end
    G.FUNCS.use_card({config = {ref_table = G.pack_cards.cards[request.index + 1]}})
    RE.Util.enqueue(function()
        if RE.Boosters.info() then
            ok({Again = pack_info(pack)})
        else
            ok({Again = context_info(context)})
        end
    end)
end

function RE.Boosters.Protocol.click(request, context, pack, ok, err)
    if RE.Boosters.info() == nil then
        err("Cannot do this action, must be in booster state but in state " .. G.STATE)
        return
    end
    local hand = G.hand.cards
    sendTraceMessage("cards: " .. #hand)
    local indices = request.indices
    local invalid_indices = {}
    for _, index in ipairs(indices) do
        if index < 0 or index >= #hand then
            table.insert(invalid_indices, index)
        end
    end
    if #invalid_indices > 0 then
        err("invalid card indices: " .. table.concat(invalid_indices, ", "))
        return
    end

    for _, index in ipairs(indices) do
        hand[index + 1]:click()
    end
    ok(pack_info(pack))
end
