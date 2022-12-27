local function split(s, sep)
    local fields = {}
    local pattern = string.format("([^%s]+)", sep)
    _ = string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)

    return fields
end

local adjacencyList = {}
local root = nil
local T = 30

-- read the input and create a graph (adjacencyList)
for line in io.lines('input.txt') do
    local neighborNames = split(string.sub(line, (string.find(line, ',') or string.len(line)) - 2), ', ')
    local flowrate = string.sub(line, string.find(line, '=') + 1, string.find(line, ';') - 1)
    local neighbors = {}
    for i = 1, #neighborNames do
        neighbors[neighborNames[i]] = 1
    end
    local name = string.sub(line, 7, 8)
    local node = {
        name = name,
        open = false,
        flowrate = tonumber(flowrate),
        neighbors = neighbors,
    }
    adjacencyList[name] = node

    -- the node labeled AA is our starting point
    if name == 'AA' then
        root = node
    end
end

for _, node in pairs(adjacencyList) do
    if node.name ~= root.name and node.flowrate == 0 then
        for name1, distance1node in pairs(node.neighbors) do
            for name2, distance2node in pairs(node.neighbors) do
                if name1 ~= name2 then
                    local distance12 = adjacencyList[name1].neighbors[name2]
                    if distance12 == nil then
                        distance12 = math.maxinteger
                    end

                    local new_distance12 = distance1node + distance2node
                    if new_distance12 < distance12 then
                        adjacencyList[name1].neighbors[name2] = new_distance12
                        adjacencyList[name2].neighbors[name1] = new_distance12
                    end
                end
            end
        end
        for name, _ in pairs(node.neighbors) do
            adjacencyList[name].neighbors[node.name] = nil
        end
        node.neighbors = nil
    end
end

local temp = {}
for name, node in pairs(adjacencyList) do
    if node.neighbors ~= nil then
        temp[name] = node
    end
end

adjacencyList = temp

local bestRewardSoFar = 0
local call = 1

local function reward(node, t, currentReward)
    if call % 100000 == 0 then
        print(call)
        print(bestRewardSoFar)
    end
    call = call + 1

    if t >= T then
        if currentReward > bestRewardSoFar then
            bestRewardSoFar = currentReward
        end
        return 0
    end

    local sumOfPotentialFlow = 0
    local openValves = {}
    for i = 1, #adjacencyList do
        if not adjacencyList[i].open then
            table.insert(openValves, adjacencyList[i])
        end
    end

    table.sort(openValves, function (a, b)
        return a.flowrate > b.flowrate
    end)

    local tRemaining = T-t
    for i = 1, #openValves do
        if tRemaining <= 0 or openValves[i].flowrate == 0 then
            break
        end
        sumOfPotentialFlow = sumOfPotentialFlow + openValves[i].flowrate * tRemaining
        tRemaining = tRemaining - 2
    end

    -- terminal conditions
    -- prune the graph if there is no potentially better solution 
    if sumOfPotentialFlow == 0 or (currentReward + sumOfPotentialFlow) < bestRewardSoFar then
        return 0
    end

    -- find all neighbors of node
    local neighbors = {}
    for i = 1, #node.neighbors do
        for j = 1, #adjacencyList do
            if adjacencyList[j].name == node.neighbors[i] then
                table.insert(neighbors, adjacencyList[j])
                break
            end
        end
    end

    local maxReward = 0

    -- there is no reward if the flowrate is 0 or the valve is already open
    -- so go to the next valve
    if node.flowrate == 0 or node.open then
        for i = 1, #neighbors do
            local potentialReward = reward(neighbors[i], t + 1, currentReward)
            if potentialReward > maxReward then
                maxReward = potentialReward
            end
        end
    else
        -- otherwise decide whether it's better to open the valve 
        -- or immediately move to the next one
        for i = 1, #neighbors do
            -- open the current valve, then move to the next
            node.open = true
            local potentialReward = node.flowrate * (T - t - 1) + reward(neighbors[i], t + 2, currentReward + node.flowrate * (T - t - 1))
            if potentialReward > maxReward then
                maxReward = potentialReward
            end

            node.open = false

            -- move to the next valve, without opening the current one
            potentialReward = reward(neighbors[i], t + 1, currentReward)
            if potentialReward > maxReward then
                maxReward = potentialReward
            end
        end
    end

    return maxReward
end

-- local maxpressure = reward(root, 0, 0)

print()
-- print('Max pressure: ' .. maxpressure)

-- Part two

bestRewardSoFar = 2228
call = 1
T = 26

local function rewardPartTwo (node, node2, distance, distance2, t, currentReward)
    if call % 1000000 == 0 then
        print("call "..call)
        -- print("t "..t)
        print("best "..bestRewardSoFar)
        -- print("nodes "..node.name.." "..node2.name)
    end
    call = call + 1

    if t >= T then
        if currentReward > bestRewardSoFar then
            bestRewardSoFar = currentReward
        end
        return 0
    end

    local closedValves = {}
    for _, n in pairs(adjacencyList) do
        if not n.open then
            table.insert(closedValves, n)
        end
    end

    table.sort(closedValves, function (a, b)
        return a.flowrate > b.flowrate
    end)

    local sumOfPotentialFlow = 0
    local tRemaining = T - t - 1 - distance
    local tRemaining2 = T - t - 1 - distance2
    for i = 1, #closedValves, 2 do
        if tRemaining <= 0 or closedValves[i].flowrate == 0 then
            break
        end
        sumOfPotentialFlow = sumOfPotentialFlow + closedValves[i].flowrate * math.max(tRemaining, tRemaining2) + (i + 1 <= #closedValves and closedValves[i + 1].flowrate * math.min(tRemaining, tRemaining2) or 0)
        local tAdd = 0
        local tAdd2 = 0
        if i + 3 <= #closedValves and closedValves[i].neighbors[closedValves[i+3]] == nil then
            --print("TADD")
            tAdd = 2
        end
        if i + 4 <= #closedValves and closedValves[i+1].neighbors[closedValves[i+4]] == nil then
            tAdd2 = 2
        end
        tRemaining = tRemaining - 3
        tRemaining2 = tRemaining2 - 3
    end

    local optimism = 1

    -- terminal conditions
    -- prune the graph if there is no potentially better solution 
    if sumOfPotentialFlow == 0 or (currentReward + sumOfPotentialFlow / optimism) < bestRewardSoFar then
        if currentReward > bestRewardSoFar then
            bestRewardSoFar = currentReward
        end

        return 0
    end

    -- find all neighbors of node
    local neighbors = {}
    for neighbor_name, _ in pairs(node.neighbors) do
        local n = adjacencyList[neighbor_name]
        table.insert(neighbors, n)
    end

    table.sort(neighbors, function (a, b)
        return a.flowrate > b.flowrate
    end)

    local neighbors2 = {}
    for neighbor_name, _ in pairs(node2.neighbors) do
        table.insert(neighbors2, adjacencyList[neighbor_name])
    end
    table.sort(neighbors2, function (a, b)
        return a.flowrate < b.flowrate
    end)
    -- if node.name ~= node2.name then
    --     table.insert(neighbors2, neighbors2[1])
    --     table.remove(neighbors2, 1)
    -- end

    local maxReward = 0

    for i = 1, #neighbors do
        for j = 1, #neighbors2 do
            local potentialReward = 0
            local nextNode = neighbors[i]
            local nextNode2 = neighbors2[j]
            local nextDistance = adjacencyList[node.name].neighbors[neighbors[i].name] - 1
            local nextDistance2 = adjacencyList[node2.name].neighbors[neighbors2[j].name] - 1

            if distance > 0 then
                nextNode = node
                nextDistance = distance - 1
                i = #neighbors
            end

            if distance2 > 0 then
                nextNode2 = node2
                nextDistance2 = distance2 - 1
                j = #neighbors2
            end

            -- both open, then move

            if i == math.floor(#neighbors * (1 - node.flowrate / closedValves[1].flowrate)) + 1 and j == math.floor(#neighbors2 * (1 - node2.flowrate / closedValves[1].flowrate)) + 1  
            and node.flowrate > 0 and not node.open and node2.flowrate > 0 and not node2.open and distance == 0 and distance2 == 0 then
                node.open = true
                node2.open = true

                potentialReward = (node.flowrate + (node.name ~= node2.name and node2.flowrate or 0)) * (T - t - 1) +
                    rewardPartTwo(node, node2, 0, 0, t + 1, currentReward + (node.flowrate + (node.name ~= node2.name and node2.flowrate or 0)) * (T - t - 1))

                if potentialReward > maxReward then
                    maxReward = potentialReward
                end

                node.open = false
                node2.open = false
            end

            -- human opens, elephant moves

            if  node.flowrate > 0 and not node.open and i == math.floor(#neighbors * (1 - node.flowrate / closedValves[1].flowrate)) + 1 and (node.name ~= node2.name or node2.name ~= closedValves[1].name) and distance == 0 then
                node.open = true

                potentialReward = node.flowrate * (T - t - 1) + rewardPartTwo(node, nextNode2, distance, nextDistance2, t + 1, currentReward + node.flowrate * (T - t - 1))
                if potentialReward > maxReward then
                    maxReward = potentialReward
                end

                node.open = false
            end

            -- elephant opens, human moves

            if node2.flowrate > 0 and not node2.open and j == math.floor(#neighbors2 * (1 - node2.flowrate / closedValves[1].flowrate)) + 1 and (node.name ~= node2.name or node.name ~= closedValves[1].name) and distance2 == 0 then
                node2.open = true

                potentialReward = node2.flowrate * (T - t - 1) + rewardPartTwo(nextNode, node2, nextDistance, distance2, t + 1, currentReward + node2.flowrate * (T - t - 1))
                if potentialReward > maxReward then
                    maxReward = potentialReward
                end

                node2.open = false
            end

            -- both move
            step = math.min(nextDistance, nextDistance2)
            potentialReward = rewardPartTwo(nextNode, nextNode2, nextDistance - step, nextDistance2 - step, t + 1 + step, currentReward)
            if potentialReward > maxReward then
                maxReward = potentialReward
            end
        end
    end

    return maxReward
end

maxpressure = rewardPartTwo(root, root, 0, 0, 0, 0)

print()
print('Max pressure: ' .. maxpressure)
