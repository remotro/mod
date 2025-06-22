RE.Menu = {}
RE.Menu.Protocol = {}

function RE.Menu.info()
    saved_game = get_compressed(G.SETTINGS.profile..'/'..'save.jkr')
    if saved_game ~= nil then saved_game = STR_UNPACK(saved_game) end
    if not saved_game then
        return { saved_run = nil, unrelated = "required because lua json + serde json hate eachother and are subtly incompatible" }
    end
 
    return {
        saved_run = {
            deck = saved_game.BACK.key,
            stake = saved_game.GAME.stake,
            best_hand = saved_game.GAME.round_scores.hand.amt,
            round = saved_game.GAME.round,
            ante = saved_game.GAME.round_resets.ante,
            money = saved_game.GAME.dollars,
        }
    }
end

function RE.Menu.Protocol.start_run(request, ok, err)
    if G.STATE ~= G.STATES.MENU then
        err("cannot do this action, must be in menu (" .. G.STATES.MENU .. ") but in " .. G.STATE)
        return
    end

    back_obj = G.P_CENTERS[request["deck"]]
    if not back_obj then
        err("could not find deck " .. request["deck"])
        return
    end

    if not back_obj.unlocked then
        err("deck " .. request["deck"] .. " is not unlocked")
        return
    end

    -- Balatro assumes that run start will occur in run setup,
    -- which will populate the viewed deck (back). We must "pretend"
    -- this is the case as well. 
    G.GAME.viewed_back = back_obj
    G.FUNCS.start_run(e, {stake = request["stake"], seed = request["seed"], challenge = nil});
    RE.Screen.await(G.STATES.BLIND_SELECT, function()
        ok(RE.Blinds.info())
    end)
end

function RE.Menu.Protocol.continue_run(ok, err)
    if G.STATE ~= G.STATES.MENU then
        err("cannot do this action, must be in menu (" .. G.STATES.MENU .. ") but in " .. G.STATE)
        return
    end

    saved_game = get_compressed(G.SETTINGS.profile..'/'..'save.jkr')
    if saved_game ~= nil then saved_game = STR_UNPACK(saved_game) end
    if not saved_game then
        err("no saved game")
        return
    end
    G.FUNCS.start_run(e, {savetext = saved_game});
    RE.Util.hammer(function()
        RE.Screen.Protocol.get(ok, err)
    end, 10)
end