defmodule Aoc2023.Day07 do
  require Logger

  @hand_types %{
    [5] => 7,
    [4, 1] => 6,
    [3, 2] => 5,
    [3, 1, 1] => 4,
    [2, 2, 1] => 3,
    [2, 1, 1, 1] => 2,
    [1, 1, 1, 1, 1] => 1
  }

  def run(input) do
    hands_1 = prepare_input_part_1(input)
    hands_2 = prepare_input_part_2(input)

    [solution_1, solution_2] =
      Task.await_many([
        Task.async(Aoc2023.Day07, :solve, [hands_1]),
        Task.async(Aoc2023.Day07, :solve, [hands_2])
      ])

    Logger.info("solved", day: :day_07, solution: solution_1, part: :one)
    Logger.info("solved", day: :day_07, solution: solution_2, part: :two)
  end

  defp prepare_input_part_1(input) do
    Enum.reduce(String.split(input, "\n", trim: true), [], fn hand, acc ->
      [cards, bid] = String.split(hand, " ", trim: true)
      bid = String.to_integer(bid)
      cards = String.graphemes(cards) |> Enum.map(&card_value/1)
      type = Enum.frequencies(cards) |> Map.values() |> Enum.sort() |> Enum.reverse()
      [%{cards: cards, type: Map.get(@hand_types, type), bid: bid} | acc]
    end)
  end

  defp card_value(g, joker \\ false)
  defp card_value("A", _), do: 14
  defp card_value("K", _), do: 13
  defp card_value("Q", _), do: 12
  defp card_value("J", joker), do: if(joker, do: 1, else: 11)
  defp card_value("T", _), do: 10
  defp card_value(v, _), do: String.to_integer(v)

  defp sort_hands(%{type: type_1}, %{type: type_2}) when type_1 != type_2, do: type_1 < type_2

  defp sort_hands(%{cards: cards_1}, %{cards: cards_2}) do
    {card_1, card_2} = Enum.zip(cards_1, cards_2) |> Enum.find(&(elem(&1, 0) != elem(&1, 1)))
    card_1 < card_2
  end

  defp prepare_input_part_2(input) do
    Enum.reduce(String.split(input, "\n", trim: true), [], fn hand, acc ->
      [cards, bid] = String.split(hand, " ", trim: true)
      bid = String.to_integer(bid)
      cards = String.graphemes(cards) |> Enum.map(&card_value(&1, true))

      freqs = Enum.frequencies(cards)
      jokers = Map.get(freqs, 1, 0)
      freqs = Map.put(freqs, 1, 0)

      [{k, v} | _] = Map.to_list(freqs) |> Enum.sort_by(&elem(&1, 1)) |> Enum.reverse()

      type =
        Map.put(freqs, k, min(5, v + jokers))
        |> Map.values()
        |> Enum.sort()
        |> Enum.reverse()
        |> Enum.filter(&(&1 != 0))

      [%{cards: cards, type: Map.get(@hand_types, type), bid: bid} | acc]
    end)
  end

  def solve(hands) do
    sorted = Enum.sort(hands, &sort_hands/2)
    Enum.with_index(sorted) |> Enum.map(fn {%{bid: bid}, i} -> (i + 1) * bid end) |> Enum.sum()
  end
end
