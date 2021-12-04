module Day4
function load(input)
    local numbers
    local grids

    open(input) do fh
        numbers = collect(parse(Int, x) for x in split(readline(fh), ","))

        grids = []
        while !eof(fh)
            readline(fh)

            lines = collect(
                collect(parse(Int, x) for x in split(readline(fh)))
                for _ in 1:5)
            grid=cat(lines..., dims=2)
            push!(grids, grid)
        end
        grids = cat(grids..., dims=3)
        grids = permutedims(grids, (3, 1, 2))
    end

    return numbers, grids
end

function main(input)
    numbers, grids = load(input)

    marked = zero(grids)

    local first = false

    for number in numbers
        @. marked[grids == number] = 1

        solved = (dropdims(sum(marked, dims=3), dims=3) .== 5) .+
            (dropdims(sum(marked, dims=2), dims=2) .== 5)
        solved = dropdims(sum(solved, dims=2), dims=2)

        if sum(solved) > 0
            if !first
                first = true
                which = argmax(solved)
                winning = grids[which, :, :]
                @. winning[marked[which, :, :] != 0] = 0

                score = sum(winning) * number
                println("First board=$which number=$number score=$score")
            end

            if size(grids, 1) == 1
                which = 1
                winning = grids[which, :, :]
                @. winning[marked[which, :, :] != 0] = 0

                score = sum(winning) * number
                println("Last number=$number score=$score")
                return
            end

            grids = grids[solved .== 0, :, :]
            marked = marked[solved .== 0, :, :]
        end
    end
end

end

Day4.main("input.txt")
