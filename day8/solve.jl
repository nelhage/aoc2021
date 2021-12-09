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

const SEGMENTS_TO_DIGIT = begin
    mapping = Dict()
    for (i, segs) in enumerate(DIGITS)
        mapping[segs] = i -1
    end
    mapping
end

const SEGMENTS = 7

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....
#
#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg

function solve(vocab)
    segs_1, = (v for v in vocab if length(v) == 2)
    segs_4, = (v for v in vocab if length(v) == 4)
    segs_7, = (v for v in vocab if length(v) == 3)

    cf = segs_1
    a = setdiff(segs_7, cf)
    bd = setdiff(segs_4, cf)

    segs_5, = (v for v in vocab if length(v) == 5
               && length(intersect(v, segs_1)) == 1
               && length(intersect(v, union(a,bd))) == 3)

    g = setdiff(segs_5, union(a, bd, cf))

    segs_3, = (v for v in vocab if length(v) == 5
               && length(intersect(v, union(a, cf, g))) == 4)

    d = setdiff(segs_3, union(a, cf, g))
    b = setdiff(bd, d)

    segs_2, = (v for v in vocab if length(v) == 5
               && v != segs_3
               && v != segs_5)

    e = setdiff(segs_2, segs_3)
    f = setdiff(segs_3, segs_2)
    c = setdiff(cf, f)

    mapping = collect(0 for i in 1:SEGMENTS)

    bwd = [a, b, c, d, e, f, g]
    for (i, dst) in enumerate(bwd)
        src, = dst
        mapping[src+1] = i-1
    end

    mapping
end


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

    total = 0

    for p in problems
        mapping = solve(p.vocab)
        # println("vocab=$(p.vocab) mapping=$(mapping)")
        digits = collect(
            begin
            segs = BitSet(mapping[i+1] for i in obs)
            SEGMENTS_TO_DIGIT[segs]
            end
            for obs in p.display)
        total += parse(Int, join(digits))
    end

    println("total=$total")
end

end

if abspath(PROGRAM_FILE) == @__FILE__
    Day8.main(isassigned(ARGS, 1) ? ARGS[1] : "input.txt")
end
