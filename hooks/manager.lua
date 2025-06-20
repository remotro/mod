local super_game_update = Game.update

function result_responder(kind)
	local result_kind = "result/" .. kind
	local ok = function (body)
		RE.Client.respond({
			kind = result_kind,
			body = {
				Ok = body
			}
		})
	end
	local err = function (message)
		RE.Client.respond({
			kind = result_kind,
			body = {
				Err = message
			}
		})
	end
	return ok, err
end

function Game:update(dt)
	super_game_update(self, dt)

	repeat
		local request = RE.Client.request()
		if request then
            sendDebugMessage("Recieved " .. request.kind)
			if request.kind == "screen/get" then
				RE.Screen.Protocol.get(result_responder("screen/current"))
			elseif request.kind == "main_menu/start_run" then
				RE.Menu.Protocol.start_run(request.body, result_responder("blind_select/info"))
			elseif request.kind == "main_menu/continue_run" then
				RE.Menu.Protocol.continue_run(request.body, result_responder("screen/current"))
			elseif request.kind == "blind_select/select" then
				RE.Blinds.Protocol.select_blind(request.body, result_responder("play/hand"))
			elseif request.kind == "blind_select/skip" then
				RE.Blinds.Protocol.skip_blind(request.body, result_responder("blind_select/info"))
    
			elseif request.kind == "play/click" then
                RE.Play.Protocol.click(request.body, result_responder("play/hand"))
            elseif request.kind == "play/play" then
                RE.Play.Protocol.play(request.body, result_responder("play/play/result"))
			elseif request.kind == "play/discard" then
				RE.Play.Protocol.discard(request.body, result_responder("play/discard/result"))

			elseif request.kind == "shop/buymain" then
				RE.Shop.Protocol.buy_main(request.body, result_responder("shop/info"))
			elseif request.kind == "shop/buyuse" then
				RE.Shop.Protocol.buy_and_use(request.body, result_responder("shop/info"))
			elseif request.kind == "shop/buyvoucher" then
				RE.Shop.Protocol.buy_voucher(request.body, result_responder("shop/info"))
			elseif request.kind == "shop/buybooster" then
				RE.Shop.Protocol.buy_booster(request.body, result_responder("shop/bought_booster"))
			elseif request.kind == "shop/reroll" then
				RE.Shop.Protocol.reroll(request.body, result_responder("shop/info"))
			elseif request.kind == "shop/continue" then
				RE.Shop.Protocol.continue(request.body, result_responder("blind_select/info"))
        
			elseif request.kind == "overview/cash_out" then
				RE.Overview.Protocol.cash_out(result_responder("shop/info"))
				
			-- booster actions structured like <context>/open/<pack>/action
			elseif string.match(request.kind, ".*/open/.*/.*\z") then
				local ret = string.match(request.kind, "^(.-)/open/.*\z")
				local pack = string.match(request.kind, "^.*/open/(.-)/.*\z")
				local action = string.match(request.kind, "^.*/open/.*/(.+)\z")
				if action == "skip" then
					RE.Boosters.Protocol.skip(request.body, ret, pack, result_responder(ret .. "/info"))
				elseif action == "click" then
					RE.Boosters.Protocol.click(request.body, ret, pack, result_responder(ret .. "/open/" .. pack .. "/info"))
				elseif action == "select" then
					RE.Boosters.Protocol.select(request.body, ret, pack, result_responder(request.kind))
				end
			-- hud actions structured as <context>/hud/<action>
			elseif string.match(request.kind, ".*/hud/.*\z") then
				local context = string.match(request.kind, "^(.-)/hud/.*\z")
				local action = string.match(request.kind, "^.*/hud/(.*)\z")
				sendTraceMessage("hud request, context: " .. context .. " action: " .. action)
				if action == "jokers/sell" then
					RE.Hud.Protocol.sell_joker(request.body, context, result_responder(context .. "/info"))
				elseif action == "jokers/move" then
					RE.Hud.Protocol.move_joker(request.body, context, result_responder(context .. "/info"))
				elseif action == "consumables/sell" then
					RE.Hud.Protocol.sell_consumable(request.body, context, result_responder(context .. "/info"))
				elseif action == "consumables/move" then
					RE.Hud.Protocol.move_consumable(request.body, context, result_responder(context .. "/info"))
				elseif action == "consumables/use" then
					RE.Hud.Protocol.use_consumable(request.body, context, result_responder(context .. "/info"))
				end
			end
		end
	until not request
end
