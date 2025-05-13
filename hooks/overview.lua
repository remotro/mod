RE.Overview = {}
RE.Overview.Protocol = {}

function RE.Overview.round(cb)
    -- Wait for the animated round overview list showing to finish
    RE.Util.await(
        function()
            local last = G.RE.earnings[#G.RE.earnings]
            return last.name == "bottom"
        end, 
        function(res)
            cb({ total_money = G.RE.earnings[#G.RE.earnings].dollars })
        end
    )
end

