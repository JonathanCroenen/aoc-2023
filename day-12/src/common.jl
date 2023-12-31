

@enum State begin
    OPERATIONAL
    DAMAGED
    UNKNOWN
end


function parse_input(path :: String) :: Vector{Tuple{Vector{State}, Vector{Int}}}
    lines = []
    open(path, "r") do file
        for line in eachline(file)
            states = []
            lengths = []

            head, tail = split(line, " ")
            for char in head
                if char == '.'
                    push!(states, OPERATIONAL)
                elseif char == '#'
                    push!(states, DAMAGED)
                elseif char == '?'
                    push!(states, UNKNOWN)
                end
            end

            for length in split(tail, ",")
                push!(lengths, parse(Int, length))
            end

            push!(lines, (states, lengths))
        end
    end

    return lines
end


function is_valid(states :: Vector{State}, lengths :: Vector{Int})
    block_length = 0
    block_lengths = []
    for state in states
        if state == DAMAGED
            block_length += 1
        elseif state == OPERATIONAL && block_length > 0
            push!(block_lengths, block_length)

            block_length = 0
        end
    end

    if block_length > 0
        push!(block_lengths, block_length)
    end

    if length(block_lengths) != length(lengths)
        return false
    end

    for (length, block_length) in zip(lengths, block_lengths)
        if length != block_length
            return false
        end
    end

    return true
end
