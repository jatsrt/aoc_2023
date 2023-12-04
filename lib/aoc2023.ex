defmodule Aoc2023 do
  require Logger

  @completed_days [
    # :day_01,
    # :day_02,
    # :day_03,
    :day_04
  ]

  def run(), do: Enum.map(@completed_days, &run/1)
  defp run(day), do: run(day, File.read("./data/#{day}.input"))
  defp run(:day_01, {:ok, input}), do: Aoc2023.Day01.run(input)
  defp run(:day_02, {:ok, input}), do: Aoc2023.Day02.run(input)
  defp run(:day_03, {:ok, input}), do: Aoc2023.Day03.run(input)
  defp run(:day_04, {:ok, input}), do: Aoc2023.Day04.run(input)
  defp run(day, {:error, reason}), do: Logger.error("error", reason: reason, day: day)
end
