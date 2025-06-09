RE.Util = {}

function RE.Util.await(a, cb)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        no_delete = true,
        func = function()
            res = a()
            if not res then
                RE.Util.await(a, cb)
                return true
            end
            cb(res)
            return true
        end
    }))
end

function RE.Util.inspectTable(t, filePath, options)
    -- Default options
    options = options or {}
    local currentPath = options.currentPath or "root"
    local maxDepth = options.maxDepth or math.huge
    local visited = options.visited or {}
    local file = options.file or io.open(filePath, "a")
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
            RE.Util.inspectTable(value, filePath, {
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
	file:write("\n")
    -- Close file if we're the top-level caller
    if not options.file then file:close() end
end
