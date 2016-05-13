defmodule PcoApi.PeopleTest do
  use ExUnit.Case
  doctest PcoApi.People

  setup do
    HTTPoison.start
  end

  test "can get a page from PCO" do
    assert %HTTPoison.Response{} = PcoApi.People.get!("people")
  end
end
