RE.Util = {}

function RE.Util.await(a, cb)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        no_delete = true,
        func = function()
            res = a()
            if not res then
                RE.Util.await(a, cb)
                return true
            end
            cb(res)
            return true
        end
    }))
end