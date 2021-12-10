module Day9


function flood(x, within)
    while true
        boundary = (
            vcat(x[2:end, :], zero(x[1:1, :])) .+
            vcat(zero(x[1:1, :]), x[1:end-1, :]) .+
            hcat(x[:, 2:end], zero(x[:, 1:1])) .+
            hcat(zero(x[:, 1:1]), x[:, 1:end-1])) .> 0
        boundary = boundary .* within
        next = (x .+ boundary) .> 0
        if x == next
            return x
        end
        x = next
    end
end

function main(path)
    lines = collect(eachline(path))

    grid = hcat((collect(parse(Int, c) for c in line) for line in lines)...)

    minimal = zero(grid) .+ 1

    @. minimal[2:end, :] *= grid[2:end, :] < grid[1:end-1,:]
    @. minimal[1:end-1, :] *= grid[1:end-1, :] < grid[2:end,:]
    @. minimal[:, 2:end] *= grid[:, 2:end] < grid[:, 1:end-1]
    @. minimal[:, 1:end-1] *= grid[:, 1:end-1] < grid[:, 2:end]

    # display(grid)
    # println()
    # display(minimal)

    println("sum=$(sum((grid .+ 1) .* minimal))")

    basins = []

    within = grid .< 9

    for ix in eachindex(minimal)
        if minimal[ix] == 0
            continue
        end

        seed = zero(minimal)
        seed[ix] = 1
        basin = flood(seed, within)
        push!(basins, sum(basin))
    end

    sort!(basins, rev=true)
    println("basins=$basins")
    println("prod = $(prod(basins[1:3]))")
end

end

if abspath(PROGRAM_FILE) == @__FILE__
    Day9.main(isassigned(ARGS, 1) ? ARGS[1] : "input.txt")
end
