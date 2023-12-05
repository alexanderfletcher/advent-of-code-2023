defmodule Day01.Part1 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&find_first_and_last_number/1)
    |> Enum.sum()
  end

  def find_first_and_last_number(line) do
    extracted_numbers =
      line
      |> String.replace(~r/[a-zA-Z ]/, "")

    first_number =
      extracted_numbers
      |> String.first()

    last_number =
      extracted_numbers
      |> String.last()

    [first_number, last_number]
    |> Enum.join()
    |> String.to_integer()
  end
end

defmodule Day01.Part2 do
  @values_to_find %{
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "0" => 0,
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }

  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&find_first_and_last_number/1)
    |> Enum.sum()
  end

  def find_first_position(string_to_search) do
    fn input_string ->
      string_to_search
      |> String.split(input_string)
      |> List.first()
      |> String.length()
      |> List.wrap()
      |> List.insert_at(0, input_string)
    end
  end

  def find_last_position(string_to_search) do
    fn input_string ->
      string_to_search
      |> String.split(input_string)
      |> List.last()
      |> String.length()
      |> List.wrap()
      |> List.insert_at(0, input_string)
    end
  end

  def find_first_and_last_number(line) do
    first_number =
      @values_to_find
      |> Map.keys()
      |> Enum.map(find_first_position(line))
      |> Enum.min_by(fn x -> Enum.at(x, 1) end)
      |> Enum.at(0)
      |> then(fn x -> Map.get(@values_to_find, x) end)

    last_number =
      @values_to_find
      |> Map.keys()
      |> Enum.map(find_last_position(line))
      |> Enum.min_by(fn x -> Enum.at(x, 1) end)
      |> Enum.at(0)
      |> then(fn x -> Map.get(@values_to_find, x) end)

    [first_number, last_number]
    |> Enum.join()
    |> String.to_integer()
  end
end

defmodule Mix.Tasks.Day01 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day01-input.txt")
    IO.puts("--- Part 1 ---")
    IO.puts(Day01.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day01.Part2.solve(input))
    IO.puts("")
  end
end
