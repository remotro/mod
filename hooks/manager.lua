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
				RE.Shop.Protocol.buy_main(request.body, result_responder("shop/buymain/result"))
			elseif request.kind == "shop/buyuse" then
				RE.Shop.Protocol.buy_and_use(request.body, result_responder("shop/buyuse/result"))
			elseif request.kind == "shop/buyvoucher" then
				RE.Shop.Protocol.buy_voucher(request.body, result_responder("shop/buyvoucher/result"))
			elseif request.kind == "shop/buybooster" then
				RE.Shop.Protocol.buy_booster(request.body, result_responder("shop/buybooster/result"))
			elseif request.kind == "shop/reroll" then
				RE.Shop.Protocol.reroll(request.body, result_responder("shop/reroll/result"))
			elseif request.kind == "shop/continue" then
				RE.Shop.Protocol.continue(request.body, result_responder("shop/continue/result"))
        
			elseif request.kind == "overview/cash_out" then
				RE.Overview.Protocol.cash_out(result_responder("shop/info"))
			end
		end
	until not request
end
