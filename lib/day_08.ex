defmodule Aoc2023.Day08 do
  require Logger
  require Math

  def run(input) do
    input = prepare_input(input)

    solution_1 = solve_part_one(input)
    Logger.info("solved", day: :day_08, solution: solution_1, part: :one)
    solution_2 = solve_part_two(input)
    Logger.info("solved", day: :day_08, solution: solution_2, part: :two)
  end

  defp prepare_input(input) do
    [directions, pairs] = String.split(input, "\n\n", trim: true)

    directions =
      String.graphemes(directions)
      |> Enum.map(fn
        "L" -> 0
        "R" -> 1
      end)

    pairs =
      String.split(pairs, "\n", trim: true)
      |> Enum.map(fn pair -> String.split(pair, [" = ", ", ", "(", ")"], trim: true) end)
      |> Enum.reduce(%{}, fn [key, left, right], acc -> Map.put(acc, key, {left, right}) end)

    {directions, pairs}
  end

  def solve_part_one({directions, pairs}) do
    follow_directions(directions, "AAA", pairs, directions, 0)
  end

  def solve_part_two({directions, pairs}) do
    distances =
      Enum.map(
        Map.keys(pairs) |> Enum.filter(&String.ends_with?(&1, "A")),
        &follow_directions_2(directions, &1, pairs, directions, 0)
      )

    Enum.reduce(distances, 1, fn {_, x}, acc -> div(x * acc, Math.gcd(x, acc)) end)
  end

  defp follow_directions(_, "ZZZ", _, _, s), do: s
  defp follow_directions([], c, pairs, dor, s), do: follow_directions(dor, c, pairs, dor, s)

  defp follow_directions([d | ds], c, pairs, dor, s) do
    follow_directions(ds, elem(Map.get(pairs, c), d), pairs, dor, s + 1)
  end

  defp follow_directions_2([], c, pairs, dor, s), do: follow_directions_2(dor, c, pairs, dor, s)

  defp follow_directions_2([d | ds], c, pairs, dor, s) do
    n = elem(Map.get(pairs, c), d)

    if String.ends_with?(n, "Z") do
      {n, s + 1}
    else
      follow_directions_2(ds, n, pairs, dor, s + 1)
    end
  end
end
