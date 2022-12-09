using adventOfCode;
using System.Text.RegularExpressions;

var cratesDone = false;
var crates2D = new List<List<string?>>();
var crates = new List<Stack<string>>();
var moves = new List<Move>();

for (int i = 0; i < 9; i++)
{
    crates.Add(new Stack<string>());
}

foreach (var line in File.ReadLines("input.txt"))
{
    // crates
    if (!cratesDone && !string.IsNullOrWhiteSpace(line))
    {
        if (line[1] == '1') continue;

        var row = new List<string?>();
        for (int j = 0; j < line.Length; j += 4)
        {
            var c = line.Substring(j, Math.Min(4, line.Length - j)).Replace(" ", string.Empty).Replace("[", string.Empty).Replace("]", string.Empty);
            row.Add(string.IsNullOrWhiteSpace(c) ? null : c);
        }

        crates2D.Add(row);
        continue;
    }

    if (!cratesDone && string.IsNullOrWhiteSpace(line))
    {
        cratesDone = true;
        crates2D.Reverse();
        var i = 0;

        //convert 2d list to stacks
        foreach (var row in crates2D) 
        {
            foreach (var crate in row)
            {
                if (crate != null)
                    crates[i].Push(crate);
                i++;
            }
            i = 0;
        }

        continue;
    }

    // moves
    var numbers = string.Join(" ", Regex.Matches(line, @"\d+").OfType<Match>().Select(m => m.Value)).Split(" ");
    moves.Add(new Move()
    {
        Amount = int.Parse(numbers[0]),
        From = int.Parse(numbers[1]) - 1,
        To = int.Parse(numbers[2]) - 1
    });
}

// Part one

foreach (var move in moves)
{
    for (int i = 0; i < move.Amount; i++)
    {
        var movedCrate = crates[move.From].Pop();
        crates[move.To].Push(movedCrate);
    }
}

Console.WriteLine(string.Join("", crates.Select(c => c.Peek())));

// Part two

var k = 0;
crates.Clear();
for (int i = 0; i < 9; i++)
{
    crates.Add(new Stack<string>());
}

//convert 2d list to stacks
foreach (var row in crates2D)
{
    foreach (var crate in row)
    {
        if (crate != null)
            crates[k].Push(crate);
        k++;
    }
    k = 0;
}

foreach (var move in moves)
{
    var movedCrates = new List<string>();
    for (int i = 0; i < move.Amount; i++)
    {
        movedCrates.Add(crates[move.From].Pop());
    }

    movedCrates.Reverse();

    foreach (var movedCrate in movedCrates)
    {
        crates[move.To].Push(movedCrate);
    }
}

Console.WriteLine(string.Join("", crates.Select(c => c.Peek())));