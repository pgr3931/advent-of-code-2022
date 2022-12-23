local function split(s, sep)
    local fields = {}
    local pattern = string.format("([^%s]+)", sep)
    _ = string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)

    return fields
end

local adjencyList = {}
local pred = {}
local dist = {}

local function bfs(src, dest)
    local queue = {}
    local visited = {}

    for i = 1, #adjencyList do
        table.insert(visited, false)
        dist[i] = math.maxinteger
        pred[i] = -1;
    end

    visited[src.index] = true;
    dist[src.index] = 0;
    table.insert(queue, src.index);

    while next(queue) ~= nil do
        local u = table.remove(queue)
        local node = adjencyList[u]
        for i = 1, #node.nodes do
            local pos = 0
            for j = 1, #adjencyList do
                if adjencyList[j].name == node.nodes[i] then
                    pos = j
                    break
                end
            end

            if not visited[pos] then
                visited[pos] = true
                dist[pos] = dist[node.index] + 1
                pred[pos] = node.index
                table.insert(queue, pos)

                if pos == dest.index then
                    return true
                end
            end
        end
    end

    return false
end

local function printShortestDistance(src, dest)
    for _ = 1, #adjencyList do
        table.insert(pred, nil)
        table.insert(dist, nil)
    end

    if not bfs(src, dest) then
        print('Given source and destination are not connected');
        return;
    end

    local path = {}
    local crawl = dest.index
    table.insert(path, crawl)
    while pred[crawl] ~= -1  do
        crawl = pred[crawl]
        table.insert(path, crawl)        
    end

    print('Shortest path length is: ' .. dist[dest.index])
    print('Path:')
    for i = #path, 1,-1 do
        print(path[i] .. ' ')
    end
end

local lines = io.lines('input.txt')



local index = 1
for line in lines do
    local nodes = split(string.sub(line, (string.find(line, ',') or string.len(line)) - 2), ', ')
    local flowrate = string.sub(line, string.find(line, '=') + 1, string.find(line, ';') - 1)
    local node = {
        index = index,
        open = false,
        name = string.sub(line, 7, 8),
        flowrate = flowrate,
        nodes = nodes
    }
    table.insert(adjencyList, node)
    index = index + 1
end


local src = adjencyList[1]
for i = 1, 30 do
    print('== Minute ' .. i .. ' ==')

    pred = {}
    dist = {}

    local valves = ''
    local pressure = 0
    local next = {}
    local maxPressure = 0
    for j = 1, #adjencyList do
        if adjencyList[j].open then
            valves = valves .. ' ' .. adjencyList[j].name
            pressure = pressure + adjencyList[j].flowrate
        end

        table.insert(pred, nil)
        table.insert(dist, nil)

        if j ~= src.index then
            bfs(src, adjencyList[j])
            if maxPressure < (30 - i - dist[j]) * adjencyList[j].flowrate then
                maxPressure = (30 - i - dist[j]) * adjencyList[j].flowrate
                next = adjencyList[j]
            end
        end
    end

    if valves == '' then
        print ('No valves are open.')
    else
        print ('Valves ' .. valves .. ' are open, relaeasing ' .. pressure ..  ' pressure.')
    end

    print('You move to valve ' .. next.name)

    print('')
end

-- printShortestDistance({index = 1}, {index = 4})

-- for k, v in pairs(adjencyList) do
--     print(k, v.name, v.flowrate)
--     for i = 1, #v.nodes do
--         print(v.nodes[i])
--     end
-- end