function G.FUNCS.remotro_reconnect()
	if RE.Client.connected() then
		love.thread.getChannel("uiToNetwork"):push("disconnect!")
	else
		if not RE.NETWORKING_THREAD then
			RE.net_thread_start()
		end
		RE.Client.connect()
	end
end
