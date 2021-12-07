module Day7

function pt2_fuel(x)
    return (x * (x+1))÷2
end

function main(path)
    positions = collect(parse(Int, w) for l in eachline(path) for w in split(l, ","))

    fuel = minimum(
        sum(abs.(positions .- x))
        for x in minimum(positions):maximum(positions)
    )
    println("fuel=$fuel")

    fuel = minimum(
        sum(@. pt2_fuel(abs(positions - x)))
        for x in minimum(positions):maximum(positions)
    )
    println("fuel[pt2]=$fuel")
end

end

if abspath(PROGRAM_FILE) == @__FILE__
    Day7.main(isassigned(ARGS, 1) ? ARGS[1] : "input.txt")
end
