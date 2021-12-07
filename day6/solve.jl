module Day6

function main(path)
    initial_pop = collect(parse(Int, w) for l in eachline(path) for w in split(l, ","))

    by_life = zeros(Int, 8+1)
    for l in initial_pop
        by_life[l+1] += 1
    end

    for tick in 1:256
        next_gen = zeros(Int, 8+1)
        next_gen[1:8] = by_life[2:9]
        next_gen[6+1] += by_life[0+1]
        next_gen[8+1] += by_life[0+1]
        by_life = next_gen
        println("$tick: pop=$(sum(by_life))")
    end
end

end

if abspath(PROGRAM_FILE) == @__FILE__
    Day6.main(isassigned(ARGS, 1) ? ARGS[1] : "input.txt")
end
