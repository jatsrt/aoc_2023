defmodule Aoc2023.Day05 do
  require Logger

  def run(input) do
    [seeds | maps] = String.split(input, "\n\n")
    seeds = String.split(seeds, ["seeds:", " "], trim: true) |> Enum.map(&String.to_integer/1)

    # seed_ranges =
    #   Enum.chunk_every(seeds, 2) |> Enum.map(fn [start, len] -> {start, start + len - 1} end)

    maps = Enum.map(maps, &prepare_map/1)

    solution_1 = solve_part_one(seeds, maps)
    Logger.info("solved", day: :day_05, solution: solution_1, part: :one)
  end

  defp prepare_map(input) do
    [_name | values] = String.split(input, "\n", trim: true)

    Enum.reduce(values, [], fn value, acc ->
      [dest, src, len] = String.split(value, " ", trim: true) |> Enum.map(&String.to_integer/1)
      [{dest, src, len} | acc]
    end)
    |> Enum.reverse()
  end

  defp solve_part_one(seeds, maps) do
    Enum.reduce(seeds, [], fn seed, acc ->
      [
        Enum.reduce(maps, seed, fn ranges, x ->
          case Enum.find(ranges, fn {_, src, len} -> x >= src && x <= src + (len - 1) end) do
            {dest, src, _} -> dest + (x - src)
            nil -> x
          end
        end)
        | acc
      ]
    end)
    |> Enum.min()
  end
end
