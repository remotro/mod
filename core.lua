RE = SMODS.current_mod

function RE.load_re_file(file)
	local chunk, err = SMODS.load_file(file, "Remotro")
	if chunk then
		local ok, func = pcall(chunk)
		if ok then
			return func
		else
			error("Failed to process file: " .. func)
		end
	else
		error("Failed to find or compile file: " .. tostring(err))
	end
	return nil
end

function RE.load_re_dir(directory)
	local files = NFS.getDirectoryItems(RE.path .. "/" .. directory)
	local regular_files = {}

	for _, filename in ipairs(files) do
		local file_path = directory .. "/" .. filename
		if file_path:match(".lua$") then
			if filename:match("^_") then
				MP.load_mp_file(file_path)
			else
				table.insert(regular_files, file_path)
			end
		end
	end

	for _, file_path in ipairs(regular_files) do
		RE.load_re_file(file_path)
	end
end

function RE.net_thread_start()
	RE.NETWORKING_THREAD = love.thread.newThread(RE.SOCKET)
	RE.NETWORKING_THREAD:start(SMODS.Mods["Remotro"].config.server_url, SMODS.Mods["Remotro"].config.server_port)
end

RE.JSON = RE.load_re_file("vendor/json/json.lua")
RE.SOCKET = RE.load_re_file("vendor/socket/socket.lua")
RE.load_re_file("net/client.lua")

RE.load_re_dir("hooks")
RE.load_re_dir("ui")

RE.net_thread_start()
RE.Client.connect()
