function G.FUNCS.remotro_reconnect()
	if RE.Client.connected() then
		love.thread.getChannel("uiToNetwork"):push("disconnect!")
	else
		RE.Client.connect()
	end
end
