defmodule Aoc2023.Day02 do
  require Logger

  @possibles %{"blue" => 14, "green" => 13, "red" => 12}

  def run(input) do
    input = String.split(input, "\n") |> Enum.map(&prepare_game/1)

    [solution_1, solution_2] =
      Task.await_many([
        Task.async(Aoc2023.Day02, :solve_part_one, [input]),
        Task.async(Aoc2023.Day02, :solve_part_two, [input])
      ])

    Logger.info("solved", day: :day_02, solution: solution_1, part: :one)
    Logger.info("solved", day: :day_02, solution: solution_2, part: :two)
  end

  defp prepare_game(game) do
    Enum.reduce(
      String.split(game, ":", trim: true) |> Enum.at(1) |> String.split([",", ";"], trim: true),
      %{},
      fn grab, acc ->
        [count, color] = String.split(grab, " ", trim: true)

        if String.to_integer(count) >= Map.get(acc, color, 0),
          do: Map.put(acc, color, String.to_integer(count)),
          else: acc
      end
    )
  end

  def solve_part_one(input) do
    Enum.reduce(Enum.with_index(input), 0, fn {values, game_number}, acc ->
      enough = Enum.map(values, fn {c, v} -> v <= Map.get(@possibles, c) end)
      if Enum.all?(enough), do: acc + game_number + 1, else: acc
    end)
  end

  def solve_part_two(input) do
    Enum.reduce(input, 0, fn values, acc ->
      product = Enum.map(values, &elem(&1, 1)) |> Enum.product()
      acc + product
    end)
  end
end
