defmodule Aoc2023.Day09 do
  require Logger
  require Math

  def run(input) do
    input = prepare_input(input)

    solution_1 = solve_part_one(input)
    Logger.info("solved", day: :day_09, solution: solution_1, part: :one)
    solution_2 = solve_part_two(input)
    Logger.info("solved", day: :day_09, solution: solution_2, part: :two)
  end

  defp prepare_input(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn h -> String.split(h, " ", trim: true) |> Enum.map(&String.to_integer/1) end)
  end

  def solve_part_one(histories) do
    Enum.reduce(histories, 0, fn history, acc -> extract_history_end(history) + acc end)
  end

  def solve_part_two(histories) do
    Enum.reduce(histories, 0, fn history, acc ->
      extract_history_start(history, Enum.take(history, 1)) + acc
    end)
  end

  defp extract_history_end(history), do: extract_history_end(history, [], 0, [])

  defp extract_history_end([l | []], last, diff, acc),
    do: extract_history_end(Enum.reverse(acc), [l | last], diff, [])

  defp extract_history_end(history = [f, s | t], last, diff, acc) do
    if length(Enum.dedup(history)) == 1 do
      find_value_end(last, diff)
    else
      extract_history_end([s | t], last, s - f, [s - f | acc])
    end
  end

  defp find_value_end([n | []], diff), do: n + diff
  defp find_value_end([n | last], diff), do: find_value_end(last, n + diff)

  defp extract_history_start(history, start), do: extract_history_start(history, start, 0, [])

  defp extract_history_start([_ | []], start, diff, acc),
    do: extract_history_start(Enum.reverse(acc), [List.last(acc) | start], diff, [])

  defp extract_history_start(history = [f, s | t], start = [_ | ts], diff, acc) do
    if length(Enum.dedup(history)) == 1 do
      find_value_start(ts, diff)
    else
      extract_history_start([s | t], start, s - f, [s - f | acc])
    end
  end

  defp find_value_start([n | []], diff), do: n - diff

  defp find_value_start([n | start], diff), do: find_value_start(start, n - diff)
end
