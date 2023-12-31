include("common.jl")

function repeat_line(states :: Vector{State}, lengths :: Vector{Int}, n_repeats = 5)
    new_states = Vector{State}(undef, length(states) * n_repeats + n_repeats - 1)
    new_lengths = Vector{Int}(undef, length(lengths) * n_repeats)

    for i in 1:n_repeats
        for (index, state) in enumerate(states)
            new_states[(i - 1) * (length(states) + 1) + index] = state
        end

        if i != n_repeats
            new_states[(i - 1) * (length(states) + 1) + length(states) + 1] = UNKNOWN
        end

        for (index, len) in enumerate(lengths)
            new_lengths[(i - 1) * length(lengths) + index] = len
        end
    end

    return new_states, new_lengths
end

struct Key
    state :: State
    states_len :: Int
    lengths_len :: Int
end

function hash(key :: Key, h :: UInt)
    h = hash(key.state, h)
    h = hash(key.states_len, h)
    h = hash(key.lengths_len, h)

    return h
end

function possible_combinations(states :: Vector{State}, lengths :: Vector{Int}, cache :: Dict{Key, Int})
    if length(states) == 0
        if length(lengths) == 0
            return 1
        else
            return 0
        end
    end

    if length(lengths) == 0
        if DAMAGED in states
            return 0
        else
            return 1
        end
    end

    key = Key(states[1], length(states), length(lengths))
    if haskey(cache, key)
        return cache[key]
    end

    result = 0
    if states[1] == OPERATIONAL || states[1] == UNKNOWN
        result += possible_combinations(states[2:end], lengths, cache)
    end

    if states[1] == DAMAGED || states[1] == UNKNOWN
        if length(states) >= lengths[1] && !(OPERATIONAL in states[1:lengths[1]]) && (length(states) == lengths[1] || states[lengths[1] + 1] != DAMAGED)
            result += possible_combinations(states[lengths[1] + 2:end], lengths[2:end], cache)
        end
    end

    cache[key] = result

    return result
end


function main()
    lines = parse_input("input/input.txt")
    repeated = [repeat_line(states, lengths) for (states, lengths) in lines]

    total = 0
    for (i, line) in enumerate(repeated)
        map = Dict{Key, Int}()
        total += possible_combinations(line..., map) 
    end

    println(total)
end

main()
