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
                RE.Play.Protocol.play(request.body, result_responder("play/hand"))
            end
		end
	until not request
end
