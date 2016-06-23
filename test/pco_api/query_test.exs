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

  test "per_page with an integer returns a param tuple" do
    expected = [{"per_page", "30"}]
    assert Query.per_page(30) == expected
  end

  test "per_page with a string returns a param tuple" do
    expected = [{"per_page", "30"}]
    assert Query.per_page(30) == expected
  end

  test "per_page allows piping" do
    expected = [{"per_page", "30"}, {"where[b]", "bb"}]
    assert (Query.where(b: "bb") |> Query.per_page(30)) == expected
  end

  test "after_record with an integer returns a param tuple" do
    expected = [{"after", "100"}]
    assert Query.after_record(100) == expected
  end

  test "after_record with a string returns a param tuple" do
    expected = [{"after", "100"}]
    assert Query.after_record(100) == expected
  end

  test "after_record allows piping" do
    expected = [{"after", "100"}, {"per_page", "100"}]
    assert (Query.per_page(100) |> Query.after_record(100)) == expected
  end
end
