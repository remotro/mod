function G.FUNCS.remotro_reconnect()
	love.thread.getChannel("uiToNetwork"):push("disconnect!")
	RE.network_bootstrap()
	RE.Client.connect()
end
