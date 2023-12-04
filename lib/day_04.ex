defmodule Aoc2023.Day04 do
  require Logger

  def run(input) do
    cards = prepare_input(input)

    [solution_1, solution_2] =
      Task.await_many([
        Task.async(Aoc2023.Day04, :solve_part_one, [cards]),
        Task.async(Aoc2023.Day04, :solve_part_two, [cards])
      ])

    Logger.info("solved", day: :day_04, solution: solution_1, part: :one)
    Logger.info("solved", day: :day_04, solution: solution_2, part: :two)
  end

  defp prepare_input(input) do
    Enum.reduce(String.split(input, "\n", trim: true), [], fn row, acc ->
      [_, first, second] = String.split(row, [":", "|"], trim: true)

      [
        Enum.map([first, second], fn values ->
          String.split(values, " ", trim: true) |> Enum.map(&String.to_integer/1) |> MapSet.new()
        end)
        | acc
      ]
    end)
    |> Enum.reverse()
  end

  def solve_part_one(cards) do
    Enum.reduce(cards, 0, fn [winning, scratched], acc ->
      (MapSet.intersection(winning, scratched) |> MapSet.size() |> calc) + acc
    end)
  end

  def solve_part_two(cards) do
    winners =
      Enum.reduce(cards |> Enum.with_index(), %{}, fn {[winning, scratched], index}, acc ->
        winners = MapSet.intersection(winning, scratched) |> MapSet.size()
        new_cards = Stream.iterate(index + 1, &(&1 + 1)) |> Enum.take(winners)

        Enum.reduce(new_cards, Map.put(acc, index, Map.get(acc, index, 0) + 1), fn next, acc ->
          Map.put(acc, next, Map.get(acc, next, 0) + Map.get(acc, index))
        end)
      end)

    Map.values(winners) |> Enum.sum()
  end

  defp calc(0), do: 0
  defp calc(num), do: calc(num, 1)
  defp calc(1, acc), do: acc
  defp calc(num, acc), do: calc(num - 1, acc * 2)
end
