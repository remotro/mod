RE.Overview = {}
RE.Overview.Protocol = {}

function RE.Overview.round(cb)
    -- Wait for the animated round overview list showing to finish
    RE.Util.await(
        function()
            local last = G.RE.earnings[#G.RE.earnings]
            return last ~= nil and last.name == "bottom"
        end, 
        function(res)
            cb({ total_money = G.RE.earnings[#G.RE.earnings].dollars })
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
    RE.Screen.await(G.STATES.SHOP, function(new_state)
        if new_state == G.STATES.SHOP then
            ok({})
        end
    end)
end
