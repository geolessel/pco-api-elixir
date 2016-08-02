defmodule PcoApi.People.HouseholdTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.Household
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/households" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    Household.list
  end

  test ".get(id) returns a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/households/1" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    Household.get(1)
  end

  test ".self retrieves a singular Household record with a url", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/households/1" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    with_links |> Household.self
  end

  test ".self retrieves a singular Household record with an id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/households/1" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    without_links |> Household.self
  end

  test ".new with attributes builds a PcoApi.Record" do
    expected =
      %PcoApi.Record{
        attributes: %{"name" => "Bluth Household"},
        type: "Household"
      }
    assert Household.new(name: "Bluth Household") == expected
  end

  test ".create with a new record creates a record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/households" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    Household.new(name: "Bluth Household") |> Household.create
  end

  test ".household_memberships requests household memberships", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/households/1/household_memberships" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    with_links |> Household.household_memberships
  end

  test ".people requests household people", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/households/1/people" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    with_links |> Household.people
  end

  defp with_links do
    %PcoApi.Record{
      type: "Household",
      links: %{
        "self" => "https://api.planningcenteronline.com/people/v2/households/1",
        "household_memberships" => "https://api.planningcenteronline.com/people/v2/households/1/household_memberships",
        "people" => "https://api.planningcenteronline.com/people/v2/households/1/people"
      }
    }
  end

  defp without_links do
    %PcoApi.Record{
      type: "Household",
      id: "1"
    }
  end
end
