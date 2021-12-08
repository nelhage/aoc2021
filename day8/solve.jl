module Day8

function parse_segments(segs)
    BitSet(c-'a' for c in segs)
end

function parse_line(line)
    vocab, obs = split(line, " | ")
    return (vocab=collect(parse_segments(s) for s in split(vocab, " ")),
            display=collect(parse_segments(s) for s in split(obs, " ")))
end

const DIGITS = (
    parse_segments("abcefg"),
    parse_segments("cf"),
    parse_segments("acdeg"),
    parse_segments("acdfg"),
    parse_segments("bcdf"),
    parse_segments("abdfg"),
    parse_segments("abdefg"),
    parse_segments("acf"),
    parse_segments("abcdefg"),
    parse_segments("abcdfg"),
)

function main(path)
    problems = collect(
        parse_line(line) for line in eachline(path)
    )

    no = sum(
        1
        for p in problems for o in p.display
        if length(o) in (2, 3, 4, 7)
    )
    println("C(1,4,7,8) = $no")
end

end

if abspath(PROGRAM_FILE) == @__FILE__
    Day8.main(isassigned(ARGS, 1) ? ARGS[1] : "input.txt")
end
