defmodule CliTest do
  use ExUnit.Case
  import Issues.CLI, only: [ parse_args: 1, sort_into_ascending_order: 1, convert_to_list_of_hashdicts: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["-help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args([ "user", "project", "99"]) == { "user", "project", 99}
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "three calues returned if three given" do
    count = parse_args(["jfeaver", "elixirb", "7"])
    |> tuple_size
    assert(count == 3)
  end

  test "count returned is integer if given" do
    {_, _, n} = parse_args(["jfeaver", "elixirlib", "7"])
    assert is_integer n
  end

  test "count is defaulted if two values given" do
    {_, _, n} = parse_args(["jfeaver", "elixirlib"])
    assert is_integer n
  end

  test "sort ascending orders the correct way" do
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: issue["created_at"]
    assert issues == ~w{a b c}
  end

  defp fake_created_at_list(values) do
    data = for value <- values, do: [{"created_at", value}, {"other_data", "xxx"}]
    convert_to_list_of_hashdicts data
  end

end
