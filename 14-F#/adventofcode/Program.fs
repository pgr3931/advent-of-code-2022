open System.IO
open System

type Coords(x: int, y: int) =
    member this.x = x
    member this.y = y
    member private this.Ident = this.x, this.y
    interface IComparable<Coords> with
        member this.CompareTo other =
            compare this.Ident other.Ident
    interface IComparable with
        member this.CompareTo obj =
            match obj with
                | null                 -> 1
                | :? Coords as other -> (this :> IComparable<_>).CompareTo other
                | _                    -> invalidArg "obj" "not a Category"
    interface IEquatable<Coords> with
        member this.Equals other =
            this.Ident = other.Ident
    override this.Equals obj =
        match obj with
          | :? Coords as other -> (this :> IEquatable<_>).Equals other
          | _                    -> false
    override this.GetHashCode () =
        hash this.Ident

let isValid (rocks: Set<Coords>) (sand: Set<Coords>) (pos: Coords) = not <| rocks.Contains(pos) && not <| (sand |> Set.contains pos)

let maxDepth (rocks: Set<Coords>) = rocks |> Seq.mapi (fun i v -> i, v.y) |> Seq.maxBy snd |> snd

let isPastLastRock (rocks: Set<Coords>) (pos: Coords) = pos.y > maxDepth rocks

let isValidWithFloor (rocks: Set<Coords>) (sand: Set<Coords>) (pos: Coords) = 
    let max =  maxDepth rocks + 2
    isValid rocks sand pos && pos.y < max

let isSourceBlocked (pos: Coords) = pos.y = 0 && pos.x = 500

let rocks = 
    File.ReadLines("input.txt") 
    |> Seq.map (fun s -> 
        s.Split([|" -> "|], StringSplitOptions.None) 
        |> Array.toList 
        |> List.map(fun p -> Coords(p.Split([|','|])[0] |> int, p.Split([|','|])[1] |> int))
        |> List.pairwise
        |> List.map(fun pair -> 
            if fst(pair).x = snd(pair).x then
                [Math.Min(fst(pair).y, snd(pair).y)..Math.Max(fst(pair).y, snd(pair).y)] 
                |> List.map(fun y -> Coords(fst(pair).x, y))
            else 
                [Math.Min(fst(pair).x, snd(pair).x)..Math.Max(fst(pair).x, snd(pair).x)] 
                |> List.map(fun x -> Coords(x, fst(pair).y))
        ) |> List.concat
    ) 
    |> Seq.concat
    |> Set.ofSeq

// Part one

let mutable sand = Set.ofList []
let mutable pastLastrock = false
while not <| pastLastrock do
    let mutable valid = true
    let mutable source = Coords(500, 1)
    while valid && not <| pastLastrock do
        let copy = Coords(source.x, source.y - 1)
        pastLastrock <- isPastLastRock rocks copy
        valid <- isValid rocks sand source
        if not <| valid then
            source <- Coords(source.x - 1, source.y)
            valid <- isValid rocks sand source
        if not <| valid then
            source <- Coords(source.x + 2, source.y)
            valid <- isValid rocks sand source
        if valid then
            source <- Coords(source.x, source.y + 1)
        else
            sand <- sand.Add(copy)

printfn "%d" sand.Count


//for y in [0..9] do
//    for x in [0..9] do       
//        if sand |> Set.exists((fun c -> c.x = x + 494 && c.y = y)) then
//            printf("o")
//        else if y = 0 && x + 494 = 500 then
//            printf("+")
//        else if rocks |> Set.exists((fun c -> c.x = x + 494 && c.y = y)) then
//            printf("#")
//        else
//            printf(".")
//    printfn("")

// Part two

sand <- Set.ofList []
let mutable sourceBlocked = false
while not <| sourceBlocked do
    let mutable valid = true
    let mutable source = Coords(500, 1)
    while valid && not <| sourceBlocked do
        let copy = Coords(source.x, source.y - 1)
        valid <- isValidWithFloor rocks sand source
        if not <| valid then
            source <- Coords(source.x - 1, source.y)
            valid <- isValidWithFloor rocks sand source
        if not <| valid then
            source <- Coords(source.x + 2, source.y)
            valid <- isValidWithFloor rocks sand source
        if valid then
            source <- Coords(source.x, source.y + 1)
        else
            sand <- sand.Add(copy)
            sourceBlocked <- isSourceBlocked copy

printfn("")
printfn "%d" sand.Count


//for y in [0..11] do
//    for x in [0..24] do
//        if sand |> List.exists((fun c -> c.x = x + 489 && c.y = y)) then
//            printf("o")
//        else if y = 0 && x + 489 = 500 then
//            printf("+")
//        else if y = 11 || rocks |> Set.exists((fun c -> c.x = x + 489 && c.y = y)) then
//            printf("#")
//        else
//            printf(".")
//    printfn("")


