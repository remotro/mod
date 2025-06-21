RE.Menu = {}
RE.Menu.Protocol = {}

function RE.Menu.info()
    G.UIDEF.run_setup_option()
    if not G.SAVED_GAME then
        sendTraceMessage("No saved game")
        return { saved_run = nil, unrelated = "required because lua json + serde json hate eachother and are subtly incompatible" }
    end
 
    sendTraceMessage("Saved game")
    return {
        saved_run = {
            deck = G.SAVED_GAME.GAME.selected_back_key.key,
            stake = G.SAVED_GAME.GAME.stake,
            best_hand = G.SAVED_GAME.GAME.round_scores.hand.amt,
            round = G.SAVED_GAME.GAME.round,
            ante = G.SAVED_GAME.GAME.round_resets.ante,
            money = G.SAVED_GAME.GAME.dollars,
        }
    }
end

function RE.Menu.Protocol.start_run(request, ok, err)
    if G.STATE ~= G.STATES.MENU then
        err("cannot do this action, must be in menu (" .. G.STATES.MENU .. ") but in " .. G.STATE)
        return
    end

    back_obj = G.P_CENTERS[request["back"]]
    if not back_obj then
        err("could not find back " .. request["back"])
        return
    end

    if not back_obj.unlocked then
        err("back " .. request["back"] .. " is not unlocked")
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
    if G.STATE == G.STATES.MENU then
        err("cannot do this action, must be in menu (" .. G.STATES.MENU .. ") but in " .. G.STATE)
    end
    G.UIDEF.run_setup_option()

    G.FUNCS.start_run(e, { savetext = G.SAVED_GAME });
    RE.Util.enqueue(function()
        ok(RE.Screen.Protocol.get(ok, err))
    end)
end