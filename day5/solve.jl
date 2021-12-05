module Day5

function main(input)
    lines = collect(eachline(input))
    src = zeros(Int, (size(lines, 1), 2))
    dst = zeros(Int, (size(lines, 1), 2))
    for i in eachindex(lines)
        line = lines[i]
        s,d = split(line, "->")
        s = collect(parse(Int, t) for t in split(s, ","))
        d = collect(parse(Int, t) for t in split(d, ","))
        src[i, :] .= min(s, d)
        dst[i, :] .= max(s, d)
    end

    src .+= 1
    dst .+= 1

    maxx = max(maximum(dst[:, 1]), maximum(src[:, 1]))
    maxy = max(maximum(dst[:, 2]), maximum(src[:, 2]))

    grid = zeros(Int, (maxx, maxy))

    for i in eachindex(src[:, 1])
        s = src[i, :]
        d = dst[i, :]
        if s[1] == d[1]
            # a, b = min(s[2],d[2]), max(s[2], d[2])
            a, b = s[2], d[2]
            # println("vert: x=$(s[1]), $a:$b")

            grid[s[1], a:b] .+= 1
        elseif s[2] == d[2]
            # a, b = min(s[1],d[1]), max(s[1], d[1])
            a, b = s[1], d[1]
            # println("horiz: y=$(s[2]), $a:$b")

            grid[a:b, s[2]] .+= 1
        elseif abs(d[1]-s[1]) == abs(d[2]-s[2])
            # println("not orthogonal $s -> $d")

            ixs = collect(zip(s[1]:d[1], s[2]:(s[2] < d[2] ? 1 : -1):d[2]))
            for ix in ixs
                grid[ix...] += 1
            end
        else
            error("not orthogonal or diagonal $s -> $d")
        end
    end

    # println("grid:")
    # display(transpose(grid))
    # println()

    println("overlaps: $(sum(grid .>= 2))")

end

end

if abspath(PROGRAM_FILE) == @__FILE__
    Day5.main(isassigned(ARGS, 1) ? ARGS[1] : "input.txt")
end
