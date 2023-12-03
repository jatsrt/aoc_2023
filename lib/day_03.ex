defmodule Aoc2023.Day03 do
  require Logger

  def run(input) do
    engine = build_engine(String.split(input, "\n", trim: true) |> Enum.with_index())

    [solution_1, solution_2] =
      Task.await_many([
        Task.async(Aoc2023.Day03, :solve_part_one, [engine]),
        Task.async(Aoc2023.Day03, :solve_part_two, [engine])
      ])

    Logger.info("solved", day: :day_03, solution: solution_1, part: :one)
    Logger.info("solved", day: :day_03, solution: solution_2, part: :two)
  end

  defp build_engine(rows) do
    Enum.reduce(rows, %{s: %{}, n: []}, fn {data, row}, %{s: acc_s, n: acc_n} ->
      syms = String.split(data, ["."] ++ (0..9 |> Enum.map(&Integer.to_string/1)), trim: true)
      nums = String.split(data, ["."] ++ syms, trim: true)

      symbols =
        Enum.reduce(locations(syms, data, 0, []), %{}, fn {symbol, {col, _}}, acc ->
          Map.put(acc, {row, col}, symbol)
        end)

      numbers =
        Enum.reduce(locations(nums, data, 0, []), [], fn {number, {col, length}}, acc ->
          locs = Stream.iterate(col, &(&1 + 1)) |> Enum.take(length) |> Enum.map(&{row, &1})
          [{String.to_integer(number), locs} | acc]
        end)

      %{s: Map.merge(acc_s, symbols), n: acc_n ++ numbers}
    end)
  end

  def solve_part_one(%{s: symbols, n: numbers}) do
    Enum.filter(numbers, fn {_, locations} ->
      Enum.any?(locations, fn {row, col} ->
        Enum.any?(all_corners({row, col}), &Map.has_key?(symbols, &1))
      end)
    end)
    |> Enum.reduce(0, &(elem(&1, 0) + &2))
  end

  def solve_part_two(%{s: symbols, n: numbers}) do
    Enum.reduce(Enum.filter(symbols, &(elem(&1, 1) == "*")), 0, fn {{row, col}, _}, acc ->
      numbers_found =
        Enum.filter(numbers, fn {_, locations} ->
          Enum.any?(all_corners({row, col}), &Enum.member?(locations, &1))
        end)
        |> Enum.map(&elem(&1, 0))

      if length(numbers_found) == 2, do: acc + Enum.product(numbers_found), else: acc
    end)
  end

  defp locations([symbol | symbols], data, offset, acc) do
    {start, length} = :binary.matches(data, symbol) |> List.first()

    locations(symbols, String.slice(data, (start + length)..-1), offset + length + start, [
      {symbol, {start + offset, length}} | acc
    ])
  end

  defp locations([], _, _, acc), do: acc

  defp all_corners({row, col}, vals \\ [-1, 0, 1]) do
    Enum.reduce(vals, [], fn r_v, acc -> acc ++ Enum.map(vals, &{row + r_v, col + &1}) end)
  end
end
