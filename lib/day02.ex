defmodule Day02.Part1 do
  @allowed_marbles %{
    red: 12,
    green: 13,
    blue: 14
  }

  def split_and_trim(list, seperator) do
    list
    |> String.split(seperator, trim: true)
    |> Enum.map(&String.trim/1)
  end

  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&determine_total/1)
    |> Enum.sum()
  end

  def determine_total(input) do
    is_valid_game =
      input
      |> split_and_trim([":", ";"])
      |> Enum.drop(1)
      |> Enum.map(&determine_is_valid_game/1)
      |> Enum.all?()

    if is_valid_game do
      Regex.run(~r/Game (\d+): /, input)
      |> List.last()
      |> String.to_integer()
    else
      0
    end
  end

  def number_of_marbles_reducer([number_string, color_string], acc) do
    number_of_marbles = number_string |> String.to_integer()
    color = color_string |> String.to_atom()

    acc
    |> Map.get(color)
    |> Kernel.+(number_of_marbles)
    |> then(fn x -> Map.put(acc, color, x) end)
  end

  def is_game_allowed(marbles) do
    blue_allowed = Map.get(marbles, :blue) <= Map.get(@allowed_marbles, :blue)
    green_allowed = Map.get(marbles, :green) <= Map.get(@allowed_marbles, :green)
    red_allowed = Map.get(marbles, :red) <= Map.get(@allowed_marbles, :red)

    blue_allowed && green_allowed && red_allowed
  end

  def determine_is_valid_game(game_string) do
    initial_marble_bag = %{
      red: 0,
      blue: 0,
      green: 0
    }

    marbles =
      game_string
      |> split_and_trim(",")
      |> Enum.map(fn x -> split_and_trim(x, " ") end)
      |> Enum.reduce(initial_marble_bag, &number_of_marbles_reducer/2)

    is_game_allowed(marbles)
  end
end

defmodule Day02.Part2 do
  def split_and_trim(list, seperator) do
    list
    |> String.split(seperator, trim: true)
    |> Enum.map(&String.trim/1)
  end

  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&determine_total/1)
    |> Enum.sum()
  end

  def extract_maximum(marbles, color) do
    marbles
    |> Enum.map(fn x -> Map.get(x, color) end)
    |> Enum.max()
  end

  def determine_power(marbles) do
    blue_marbles = marbles |> extract_maximum(:blue)
    red_marbles = marbles |> extract_maximum(:red)
    green_marbles = marbles |> extract_maximum(:green)

    blue_marbles * red_marbles * green_marbles
  end

  def determine_total(input) do
    input
    |> split_and_trim([":", ";"])
    |> Enum.drop(1)
    |> Enum.map(&determine_marbles/1)
    |> determine_power
  end

  def number_of_marbles_reducer([number_string, color_string], acc) do
    number_of_marbles = number_string |> String.to_integer()
    color = color_string |> String.to_atom()
    Map.put(acc, color, number_of_marbles)
  end

  def determine_marbles(game_string) do
    initial_marble_bag = %{
      red: 0,
      blue: 0,
      green: 0
    }

    game_string
    |> split_and_trim(",")
    |> Enum.map(fn x -> split_and_trim(x, " ") end)
    |> Enum.reduce(initial_marble_bag, &number_of_marbles_reducer/2)
  end
end

defmodule Mix.Tasks.Day02 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day02-input.txt")
    IO.puts("--- Part 1 ---")
    {time_in_microseconds, ret_val} = :timer.tc(fn -> Day02.Part1.solve(input) end)
    IO.puts(ret_val)
    IO.puts("--- Part 1 time ---")
    IO.puts("#{time_in_microseconds} μs")
    IO.puts("--- Part 2 ---")
    {time_in_microseconds, ret_val} = :timer.tc(fn -> Day02.Part2.solve(input) end)
    IO.puts(ret_val)
    IO.puts("--- Part 2 time ---")
    IO.puts("#{time_in_microseconds} μs")
  end
end
