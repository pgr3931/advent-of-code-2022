defmodule Calc do
  def calculateNextPosition(direction, steps, head) do
    Enum.reduce(1..String.to_integer(steps), head, fn(x, acc) -> x + acc end)
  end

  def updateHead(direction, head) do
    case direction do
      "U" ->
        Map.update!(head, :y, &(&1 + 1))
      "D" ->
        Map.update!(head, :y, &(&1 - 1))
      "R" ->
        Map.update!(head, :x, &(&1 + 1))
      "L" ->
        Map.update!(head, :x, &(&1 - 1))
    end
  end
end

positions = MapSet.new(["0,0"])
head = %{x: 0, y: 0}
tail = %{x: 0, y: 0}
input = File.read!("input.txt")
moves = String.split(input, "\n")

head = for move <- moves do
  [direction, steps] = String.split(move)
  for move <- 1..String.to_integer(steps) do
    IO.inspect Calc.updateHead(direction, head)
  end
end

IO.inspect(head)
