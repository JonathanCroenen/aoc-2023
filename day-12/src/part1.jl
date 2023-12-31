include("./common.jl")



function generate_combinations(states :: Vector{State}, lengths :: Vector{Int})
    num_unknowns = UInt64(sum(state == UNKNOWN for state in states))

    num_combinations = 0
    for i in 0:2^num_unknowns - 1
        combination = Array{State, 1}(undef, num_unknowns)
        for j in 1:num_unknowns
            if i & (1 << (j - 1)) == 0
                combination[j] = OPERATIONAL
            else
                combination[j] = DAMAGED
            end
        end

        states_copy = copy(states)
        combination_index = 1
        for (index, state) in enumerate(states_copy)
            if state == UNKNOWN
                states_copy[index] = combination[combination_index]
                combination_index += 1
            end
        end

        if is_valid(states_copy, lengths)
            num_combinations += 1
        end
    end

    return num_combinations
end

function main()
    lines = parse_input("input/input.txt")

    total = 0
    for (states, lengths) in lines
        total += generate_combinations(states, lengths)
    end

    println(total)
end

main()
