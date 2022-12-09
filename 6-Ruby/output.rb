file = File.open "input.txt"
sequence = file.read.split ''

marker = []
i = 0

# Part one

for c in sequence do
    i += 1
    marker.append c
    if marker.length == 4
        if marker.uniq.length == marker.length
            puts i
            break
        else
            marker.shift
        end
    end
end

# Part two

marker = []
i = 0

for c in sequence do
    i += 1
    marker.append c
    if marker.length == 14
        if marker.uniq.length == marker.length
            puts i
            break
        else
            marker.shift
        end
    end
end