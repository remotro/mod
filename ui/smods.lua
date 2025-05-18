SMODS.Mods.Remotro.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = {
			r = 0.1,
			align = "cm",
			padding = 0.2,
			colour = G.C.BLACK,
		},
		nodes = {
			{
				n = G.UIT.R,
				config = {
					padding = 0.25,
					align = "cm",
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							scale = 0.6,
							text = "Server Address",
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
					create_text_input({
							w = 4,
							max_length = 38,
							prompt_text = "Address",
							ref_table = SMODS.Mods["Remotro"].config,
							ref_value = "server_url",
							extended_corpus = true,
							keyboard_offset = 1,
							id = "address",
					}),
					{
						n = G.UIT.T,
						config = {
							scale = 0.3,
							text = "Enter to save",
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
				}
			},
			{
				n = G.UIT.R,
				config = {
					padding = 0.25,
					align = "cm",
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							scale = 0.6,
							text = "Port",
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
					create_text_input({
							w = 4,
							max_length = 5,
							prompt_text = "Port",
							ref_table = SMODS.Mods["Remotro"].config,
							ref_value = "server_port",
							extended_corpus = false,
							keyboard_offset = 1,
							id = "port",
							callback = function(var)
								SMODS.Mods["Remotro"].config.server_port = tonumber(SMODS.Mods["Remotro"].config.server_port)
							end
					}),
					{
						n = G.UIT.T,
						config = {
							scale = 0.3,
							text = "Enter to save",
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
				},
			},
			UIBox_button({
				button = "remotro_reconnect",
				label = RE.Client.connected() and {"Connected"} or {"Disconnected"},
				scale = 0.5,
				id = "reconnect"
			})
		}
	}
end
