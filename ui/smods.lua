SMODS.Mods.Remotro.credits_tab = function()
	return {
		n = G.UIT.ROOT,
		config = {
			r = 0.1,
			minw = 5,
			align = "cm",
			padding = 0.2,
			colour = G.C.BLACK,
		},
		nodes = {
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm",
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = "HeadedBranch225",
							shadow = true,
							scale = 0.6,
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
				},
			},
			{
				n = G.UIT.R,
				config = {
					padding = 0.2,
					align = "cm",
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = "oxycblt",
							shadow = true,
							scale = 0.6,
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
				},
			},
		},
	}
end

SMODS.Mods.Remotro.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = {
			r = 0.1,
			minw = 5,
			align = "cm",
			padding = 0.2,
			colour = G.C.BLACK,
		},
		nodes = {
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm",
					on_demand_tooltip = {
						text = {
							localize('k_the_order_integration_desc'), 
							localize("k_the_order_credit")
						}
					},
				},
				nodes = {
					create_toggle({
						id = "the_order_integration_toggle",
						label = localize("b_the_order_integration"),
						ref_table = SMODS.Mods["Multiplayer"].config.integrations,
						ref_value = "TheOrder",
					}),
				},
			},
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm",
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = localize("k_the_order_credit"),
							shadow = true,
							scale = 0.375,
							colour = G.C.UI.TEXT_INACTIVE,
						},
					},
					{
						n = G.UIT.B,
						config = {
							w = 0.1,
							h = 0.1,
						},
					},
					{
						n = G.UIT.T,
						config = {
							text = localize("k_requires_restart"),
							shadow = true,
							scale = 0.375,
							colour = G.C.UI.TEXT_INACTIVE,
						},
					},
				},
			},
			{
				n = G.UIT.R,
				config = {
					padding = 0.5,
					align = "cm",
					id = "username_input_box",
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							scale = 0.6,
							text = localize("k_username"),
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
					create_text_input({
						w = 4,
						max_length = 25,
						prompt_text = localize("k_enter_username"),
						ref_table = MP.LOBBY,
						ref_value = "username",
						extended_corpus = true,
						keyboard_offset = 1,
						callback = function(val)
							MP.UTILS.save_username(MP.LOBBY.username)
						end,
					}),
					{
						n = G.UIT.T,
						config = {
							scale = 0.3,
							text = localize("k_enter_to_save"),
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
				},
			},
		},
	}
end

function G.FUNCS.remotro_discord(e)
	love.system.openURL("https://github.com/remotro/")
end
