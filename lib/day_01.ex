defmodule Aoc2023.Day01 do
  require Logger

  @num_possibles [
    {"1", 1},
    {"2", 2},
    {"3", 3},
    {"4", 4},
    {"5", 5},
    {"6", 6},
    {"7", 7},
    {"8", 8},
    {"9", 9}
  ]

  @alph_possibles [
    {"one", 1},
    {"two", 2},
    {"three", 3},
    {"four", 4},
    {"five", 5},
    {"six", 6},
    {"seven", 7},
    {"eight", 8},
    {"nine", 9}
  ]

  def run(input) do
    input = String.split(input, "\n")

    [solution_1, solution_2] =
      Task.await_many([
        Task.async(Aoc2023.Day01, :solve, [input, @num_possibles]),
        Task.async(Aoc2023.Day01, :solve, [input, @num_possibles ++ @alph_possibles])
      ])

    Logger.info("solved", day: :day_01, solution: solution_1, part: :one)
    Logger.info("solved", day: :day_01, solution: solution_2, part: :two)
  end

  def solve(input, possibles) do
    Enum.reduce(input, 0, fn line, acc ->
      occurences =
        Enum.reduce(possibles, [], fn {v, i}, acc ->
          case :binary.matches(line, v) |> Enum.map(fn {v, _} -> v end) do
            [] -> acc
            location -> [{i, Enum.min_max(location)} | acc]
          end
        end)

      {min, _} = Enum.min_by(occurences, fn {_, {min, _}} -> min end)
      {max, _} = Enum.max_by(occurences, fn {_, {_, max}} -> max end)
      acc + (min * 10 + max)
    end)
  end
end
