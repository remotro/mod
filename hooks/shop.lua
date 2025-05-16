RE.Shop = {}
RE.Shop.Protocol = {}

function RE.Shop.info()
	local main = G.shop_jokers.cards
	local vouchers = G.shop_vouchers.cards
	local boosters = G.shop_booster.cards

	local main_row = {}
	local vouchers_row = {}
	local boosters_row = {}
	for k, card in ipairs(main) do
		local json = {"Failed"}
		if card.ability.set == "Joker" then
			json = { Joker = card.config.center.key }
		elseif card.ability.set == "Tarot" then
			json = { Tarot = card.config.center.key }
		elseif card.ability.set == "Planet" then
			json = { Planet = card.config.center.key }
		elseif card.ability.set == "Spectral" then
			json = { Spectral = card.config.center.key }
		end
		table.insert(main_row, json)
	end
	for k, voucher in ipairs(vouchers) do
		local json = {voucher = voucher.config.center.key}
		table.insert(vouchers_row, json)
	end
	for k, booster in ipairs(boosters) do
		local json = {booster = string.sub(booster.config.center.key,1,-3)}
		table.insert(boosters_row, json)
	end
	return { main = main_row , vouchers = vouchers_row, boosters = boosters_row }
end

function RE.Shop.Protocol.buy_main(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	local card = G.shop_jokers.cards[request.index]
	inspectTable(card, "card.txt")
	inspectTable(G.shop_jokers, "shop_jokers.txt")
	if not G.FUNCS.check_for_buy_space(card) then
		err("Cannot do this action, No space")
	end
	if (card.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (card.cost > 0) then
		err("Not enough money")
		return
	end
	G.FUNCS.buy_from_shop({config={ref_table=card}})
end

function inspectTable(t, filePath, options)
    -- Default options
    options = options or {}
    local currentPath = options.currentPath or "root"
    local maxDepth = options.maxDepth or math.huge
    local visited = options.visited or {}
    local file = options.file or io.open(filePath, "a")  -- "w" = overwrite mode
    local depth = options.depth or 0
    -- Check for circular references
    if visited[t] then
        file:write(currentPath .. " = [CIRCULAR REFERENCE]\n")
        if not options.file then file:close() end
        return
    end
    visited[t] = true
    -- Handle non-table values or max depth reached
    if type(t) ~= "table" or depth >= maxDepth then
        file:write(currentPath .. " = " .. tostring(t) .. "\n")
        if not options.file then file:close() end
        return
    end
    -- Handle empty tables
    if next(t) == nil then
        file:write(currentPath .. " = {}\n")
        if not options.file then file:close() end
        return
    end
    -- Process all key-value pairs
    for key, value in pairs(t) do
        -- Format the path component
        local pathComponent
        if type(key) == "string" then
            pathComponent = "." .. key
        elseif type(key) == "number" then
            pathComponent = "[" .. key .. "]"
        else
            pathComponent = "[" .. tostring(key) .. "]"
        end
        local fullPath = currentPath .. pathComponent
        -- Handle nested tables
        if type(value) == "table" then
            inspectTable(value, filePath, {
                currentPath = fullPath,
                maxDepth = maxDepth,
                visited = visited,
                file = file,
                depth = depth + 1
            })
        else
            file:write(fullPath .. " = " .. tostring(value) .. "\n")
        end
    end
    -- Close file if we're the top-level caller
    if not options.file then file:close() end
end

function RE.Shop.Protocol.buy_and_use(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " ..G.STATE)
		return
	end
	local card = G.shop_jokers.cards[request.index]
	card.config.id = 'buy_and_use'
	if (card.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (card.cost > 0) then
		err("Not enough money")
		return
	end
	G.FUNCS.buy_from_shop({config={ref_table=card}})
end

function RE.Shop.Protocol.buy_voucher(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	local voucher = G.shop_vouchers.cards[request.index]
	if (voucher.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (voucher.cost > 0) then
		err("Not enough money")
		return
	end
	G.FUNCS.use_card({config={ref_table=voucher}})
end

function RE.Shop.Protocol.buy_booster(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	local pack = G.shop_booster.cards[request.index]
	if (pack.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (pack.cost > 0) then
		err("Not enough money")
		return
	end
	G.FUNCS.use_card({config={ref_table=pack}})
end

function RE.Shop.Protocol.reroll(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	if ((G.GAME.dollars-G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost < 0) and G.GAME.current_round.reroll_cost ~= 0 then
		err("Not enough money")
		return
	end
	G.FUNCS.reroll_shop()
end

function RE.Shop.Protocol.continue(request, ok, err)
	if G.STATE ~= G.STATES.SHOP then
		err("Cannot do this action, must be in shop but in " .. G.STATE)
		return
	end
	G.FUNCS.toggle_shop()
	RE.Screen.await(G.STATES.BLIND_SELECT, function()
		ok(RE.Blinds.choices())
	end)
end
