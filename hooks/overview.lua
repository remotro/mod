RE.Overview = {}
RE.Overview.Protocol = {}

local function translate_config(config)
    local kind
    if string.find(config.name, "^joker") then
        kind = { Joker = RE.Jokers.joker(config.card).kind }
    elseif string.find(config.name, "^tag") then
        kind = { Tag = config.tag }
    elseif string.find(config.name, "^blind") then
        kind = { Blind = {} }
    elseif string.find(config.name, "^interest") then
        kind = { Interest = {} }
    elseif string.find(config.name, "hands") then
        kind = { Hands = config.disp }
    elseif string.find(config.name, "discards") then
        kind = { Discards = config.disp }
    end
    return {
        kind = kind,
        value = config.dollars
    }
end

function RE.Overview.round(cb)
    -- Wait for the animated round overview list showing to finish
    RE.Util.await(
        function()
            local last = G.RE.earnings[#G.RE.earnings]
            return last ~= nil and last.name == "bottom"
        end,
        function(res)
            local earnings = {}
            for _, earning in ipairs(G.RE.earnings) do
                if earning.name == "bottom" then
                    break
                end
                local translated = translate_config(earning)
                if translated then
                    table.insert(earnings, translated)
                else
                    err("unknown earning: " .. earning.name)
                end
            end

            local total_earned = 0
            for _, earning in ipairs(earnings) do
                total_earned = total_earned + earning.value
            end
            
            cb({ hud = RE.Hud.info(), earnings = earnings, total_earned = total_earned })
        end
    )
end

function RE.Overview.Protocol.cash_out(ok, err)
    if G.STATE ~= G.STATES.ROUND_EVAL then
        err("cannot do this action, must be in round eval (" .. G.STATES.ROUND_EVAL .. ") but in " .. G.STATE)
        return
    end
    local fakebutton = {
        config = {
            button = ""
        }
    }
    G.FUNCS.cash_out(fakebutton)
    RE.Util.await(function()
        return RE.Shop.info() ~= nil
    end, function(new_state)
        ok(RE.Shop.info())
    end)
end

function RE.Overview.game(cb)
    local outcome = {}
    if G.GAME.round_resets.ante <= G.GAME.win_ante then
        outcome = {
            Loss = {
                {
                    defeated_by = RE.Blinds.current(),
                    round = G.GAME.round,
                    ante = G.GAME.round_resets.ante,
                }
            }
        }
    else
        outcome = "Win"
    end
	return { -- TODO: Take data from the game
		outcome = {Loss = {
                defeated_by = RE.Blinds.current(),
                round = G.GAME.round,
                ante = G.GAME.round_resets.ante,
            }},
        best_hand = 10,
        most_played_hand = {
            kind = "High Card",
            times_played = 10,
        },
        cards_played = 10,
        cards_discarded = 10,
        cards_purchased = 10,
        times_rerolled = 10,
        new_discoveries = 10,
        seed = G.GAME.pseudorandom.seed,
	}
end
