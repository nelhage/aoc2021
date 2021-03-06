function main()
    depth = 0
    horiz = 0
    aim = 0

    for line = eachline("input.txt")
        m = match(r"(\w+) (\d+)", line)
        if isnothing(m)
            error("bad line")
        end
        cmd, n = m.captures
        n = parse(Int, n)

        if cmd == "forward"
            horiz += n
            depth += aim * n
        elseif cmd == "up"
            aim -= n
        elseif cmd == "down"
            aim += n
        else
            error("bad cmd: $line")
        end
    end

    println(depth*horiz)
end

main()
