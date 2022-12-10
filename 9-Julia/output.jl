mutable struct Coordinates
    x
    y
end

function updateCoordinates(direction::String, coord::Coordinates)
    if direction == "U"
        coord.y += 1
    elseif direction == "D"
        coord.y -= 1
    elseif direction == "R"
        coord.x += 1
    elseif direction == "L"
        coord.x -= 1
    end
end

function calculateDiagonal(head::Coordinates, tail::Coordinates, direction::String)
    x = head.x - tail.x
    y = head.y - tail.y

    if x >= 1 && direction != "R" && direction != "L" 
        return "R"
    elseif x <= -1 && direction != "L" && direction != "R" 
        return "L"
    elseif y >= 1 && direction != "U" && direction != "D" 
        return "U"
    elseif y <= -1 && direction != "D" && direction != "U" 
        return "D"
    end
end

function testPrint(rope::Array{Coordinates})
    head = rope[1]

    for y in 0:20
        for x in 0:25
            knot = findfirst(r -> begin
                return abs(y - 20) == r.y && x  == r.x
            end, rope)

            if abs(y - 20) == head.y && x == head.x
                print("H")
            elseif knot !== nothing
                print(knot - 1 )
            elseif y == 20 && x == 0
                print("s")
            else
                print(".")
            end
        end
        println("")
    end
end

function testResultPrint(positions::Set{String})
    coords = map(pos -> begin
        x, y = split(pos, ",")
        return Coordinates(parse(Int, x), parse(Int, y))
    end, collect(positions))

    for y in 0:20
        for x in 0:25
            if y == 20 && x == 0
                print("s")
            elseif any(c -> abs(y - 20) == c.y && x  == c.x, coords) 
                print("#")
            else
                print(".")
            end
        end
        println("")
    end
end

positions = Set(["0,0"])
head = Coordinates(0, 0)
tail = Coordinates(0, 0)

moves = readlines("input.txt")

# Part one

for move in moves    
    # println(move)
    # println("\n")

    direction, steps = split(move, " ")
    for i in 1:parse(Int, steps)
        updateCoordinates(String(direction), head)
        if abs(tail.x - head.x) == 2 || abs(tail.y - head.y) == 2
            if abs(tail.x - head.x) == 1 || abs(tail.y - head.y) == 1
                diagonal = calculateDiagonal(head, tail, String(direction))
                updateCoordinates(String(direction), tail)
                updateCoordinates(String(diagonal), tail)
            else
                updateCoordinates(String(direction), tail)
            end
        end

        # testPrint(head, tail)
        # println("\n")

        push!(positions, "$(tail.x),$(tail.y)")
    end
end

# testResultPrint(positions)
println(length(positions))

# Part two

positions = Set(["0,0"])
x = 10 
rope = Array{Coordinates, 1}(undef, x) 

for i = 1:x
    rope[i] = Coordinates(0, 0)
end

for move in moves    
    # println(move)
    # println("\n")

    direction, steps = split(move, " ")
    for i in 1:parse(Int, steps)
        currHead = rope[1]
        currTail = rope[2]
        updateCoordinates(String(direction), rope[1])

        prev = direction

        for i in 2:10
            currHead = rope[i - 1]
            currTail = rope[i]

            if (currTail.x - currHead.x == 2 && currTail.y == currHead.y)
                rope[i].x = rope[i].x - 1
            elseif (currTail.x - currHead.x == -2 && currTail.y == currHead.y)
                rope[i].x = rope[i].x + 1
            elseif (currTail.y - currHead.y == 2 && currTail.x == currHead.x)
                rope[i].y = rope[i].y - 1
            elseif (currTail.y - currHead.y == -2 && currTail.x == currHead.x)
                rope[i].y = rope[i].y + 1
            elseif (abs(currTail.x - currHead.x) == 1 && abs(currTail.y - currHead.y) == 2) || 
                (abs(currTail.y - currHead.y) == 1 && abs(currTail.x - currHead.x) == 2) || 
                (abs(currTail.y - currHead.y) == 2 && abs(currTail.x - currHead.x) == 2)
                if currHead.x < currTail.x
                    rope[i].x = rope[i].x - 1 
                else
                    rope[i].x = rope[i].x + 1 
                end

                if currHead.y < currTail.y
                    rope[i].y = rope[i].y - 1 
                else
                    rope[i].y = rope[i].y + 1 
                end
            end
        end
        # testPrint(rope)
        # println("\n")
       
        push!(positions, "$(currTail.x),$(currTail.y)")
    end
 
end

# testResultPrint(positions)
println(length(positions))