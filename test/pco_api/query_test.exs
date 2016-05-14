defmodule PcoApi.QueryTest do
  use ExUnit.Case, async: true
  doctest PcoApi.Query
  alias PcoApi.Query

  test "where with new params returns a list of where params" do
    expected = [{"where[first_name]", "geoffrey"}]
    assert Query.where(first_name: "geoffrey") == expected
  end

  test "where with existing params prepends to the params list" do
    expected = [{"where[b]", "bb"}, {"where[a]", "aa"}]
    assert Query.where([{"where[a]", "aa"}], b: "bb") == expected
  end

  test "where allows piping" do
    expected = [{"where[b]", "bb"}, {"where[a]", "aa"}]
    actual = Query.where(a: "aa") |> Query.where(b: "bb")
    assert actual == expected
  end
end
