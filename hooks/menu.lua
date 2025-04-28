RE.Menu = {}
RE.Menu.Protocol = {}

function RE.Menu.Protocol.start_run(request, ok, err)
    if G.STATE ~= G.STATES.MENU then
        err("cannot do this action, must be in menu (" .. G.STATES.MENU .. ") but in " .. G.STATE)
        return
    end

    back_obj = G.P_CENTERS[bundle["back"]]
    if not back_obj then
        err("could not find back " .. bundle["back"])
        return
    end

    if not back_obj.unlocked then
        err("back " .. bundle["back"] .. " is not unlocked")
        return
    end

    -- Balatro assumes that run start will occur in run setup,
    -- which will populate the viewed deck (back). We must "pretend"
    -- this is the case as well. 
    G.GAME.viewed_back = back_obj
    G.FUNCS.start_run(e, {stake = bundle["stake"], seed = bundle["seed"], challenge = nil});

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        no_delete = true,
        func = function()
            ok(RE.Blinds.get_all())
            return true
        end
    }))
end
