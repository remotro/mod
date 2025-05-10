RE.Menu = {}
RE.Menu.Protocol = {}

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
        ok(RE.Blinds.choices())
    end)
end
