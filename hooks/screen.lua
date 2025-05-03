RE.Screen = {}
RE.Screen.Protocol = {}

function RE.Screen.Protocol.get(ok, err)
    sendTraceMessage(G.STATE)
    if G.STATE == G.STATES.MENU then
        ok({Menu = {}})
    elseif G.STATE == G.STATES.BLIND_SELECT then
        ok({SelectBlind = RE.Blinds.info()})
    elseif G.STATE == G.STATES.SELECTING_HAND then
        ok({Play = RE.Play.info()})
    end
end