defmodule Aoc2023.Day06 do
  require Logger

  def run(input) do
    [times, distances] = String.split(input, "\n", trim: true)

    races =
      Enum.zip(
        String.split(times, ["Time:", " "], trim: true) |> Enum.map(&String.to_integer/1),
        String.split(distances, ["Distance:", " "], trim: true) |> Enum.map(&String.to_integer/1)
      )

    race =
      {Enum.map_join(races, &elem(&1, 0)) |> String.to_integer(),
       Enum.map_join(races, &elem(&1, 1)) |> String.to_integer()}

    [solution_1, solution_2] =
      Task.await_many([
        Task.async(Aoc2023.Day06, :solve_part_one, [races]),
        Task.async(Aoc2023.Day06, :solve_part_two, [race])
      ])

    Logger.info("solved", day: :day_06, solution: solution_1, part: :one)
    Logger.info("solved", day: :day_06, solution: solution_2, part: :two)
  end

  def solve_part_one(races), do: Enum.reduce(races, 1, &(&2 * solve_part_two(&1)))

  def solve_part_two({time, distance}) do
    Enum.reduce_while(0..time, 0, fn t, acc ->
      if (time - t) * t > distance,
        do: {:cont, acc + 1},
        else: if(acc > 0, do: {:halt, acc}, else: {:cont, acc})
    end)
  end
end
