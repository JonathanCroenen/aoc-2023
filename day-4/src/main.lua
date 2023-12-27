local function read_input(file)
    local lines = {}
    for line in io.lines(file) do
        table.insert(lines, line)
    end

    return lines
end

local function parse_card(card)
    card = string.gsub(card, "Card(%s+)(%d+): ", "")
    local div, _ = string.find(card, "|")

    local winning = {}
    for n in string.gmatch(string.sub(card, 0, div), "%d+") do
        winning[tonumber(n)] = true
    end

    local ours = {}
    for n in string.gmatch(string.sub(card, div + 1), "%d+") do
        table.insert(ours, tonumber(n))
    end

    return winning, ours
end

local function part1(cards)
    local total = 0

    for _, card in ipairs(cards) do
        local winning, ours = parse_card(card)

        local hits = 0
        for _, n in ipairs(ours) do
            if winning[n] then
                hits = hits + 1
            end
        end

        if hits > 0 then
            total = total + 2 ^ (hits - 1)
        end
    end

    return total
end

local function part2(cards)
    local n_cards = {}
    for i = 1, #cards do
        n_cards[i] = 1
    end

    for i, card in ipairs(cards) do
        local multiplier = n_cards[i]
        local winning, ours = parse_card(card)

        local hits = 0
        for _, n in ipairs(ours) do
            if winning[n] then
                hits = hits + 1
            end
        end

        for j = i + 1, i + hits do
            n_cards[j] = n_cards[j] + multiplier
        end
    end

    local total = 0
    for _, n in ipairs(n_cards) do
        total = total + n
    end

    return total
end

local lines = read_input("input/input.txt")

local solution1 = part1(lines)
print("Part1:", solution1)

local solution2 = part2(lines)
print("Part2:", solution2)
