function filter(bits, most)
    for i in 1:size(bits, 2)
        ones = sum(bits[:, i])
        if most
            target = ones >= size(bits, 1)/2
        else
            target = ones < size(bits, 1)/2
        end

        # println("i=$i ones=$ones size=$(size(bits, 1)) target=$target nbits=$(size(bits,1))")
        bits = bits[bits[:, i] .== target, :]
        # println("i=$i bits=$bits")

        if size(bits, 1) == 1
            println("return bits=$bits")
            return bits[1, :]
        end
    end
    error("did not terminate len=$(size(bits,1))")
end

function main(input)
    lines = collect(eachline(input))
    bits = BitArray(lines[l][i] == '1' for l in eachindex(lines), i in eachindex(lines[1]))

    ones = sum(bits, dims=1)[1, :]
    nbits = size(bits, 1)
    ones = collect(n > nbits/2 for n in ones)

    weight = reverse(2 .^ (0:(size(ones, 1)-1)))

    gamma = sum(ones .* weight)
    epsilon = sum((1 .- ones) .* weight)
    println("power: ", gamma*epsilon)

    oxy = sum(filter(bits, true) .* weight)
    co2 = sum(filter(bits, false) .* weight)

    println("ones: $ones")
    println("co2: $co2, oxy: $oxy")
    println("life support: ", oxy * co2)
end

main("input.txt")
# main("test.txt")
