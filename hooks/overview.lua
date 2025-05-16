RE.Overview = {}
RE.Overview.Protocol = {}

local function translate_config(config)
    local kind
    if string.find(config.name, "^joker") then
        kind = { Joker = config.card.ability.name }
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
            
            cb({ earnings = earnings, total_earned = total_earned })
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
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        no_delete = true,
        func = function()
            G.FUNCS.cash_out(fakebutton)
            RE.Screen.await(G.STATES.SHOP, function(new_state)
                if new_state == G.STATES.SHOP then
					RE.Util.await(
						function()
							return G.shop_jokers ~= nil and G.shop_vouchers ~= nil and G.shop_booster ~= nil
						end,
						function(res)
							ok(RE.Shop.info())
						end)
						
                end
            end)
            return true
        end
}))
end
