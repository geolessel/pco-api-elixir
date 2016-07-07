defmodule PcoApi.People.Household.MembershipTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.Household.Membership
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list lists households with a url", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/households/1/household_memberships"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    record_with_link |> Membership.list
  end

  test ".list lists households with an id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/households/1/household_memberships"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    record_without_link |> Membership.list
  end

  test ".get gets a household membership by id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/households/1/household_memberships/2"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    record_with_link |> Membership.get(2)
  end

  test ".new with attributes builds a PcoApi.Record" do
    expected =
      %PcoApi.Record{
        attributes: %{"pending" => false},
        type: "HouseholdMembership"
      }
    assert Membership.new(pending: false) == expected
  end

  test ".household gets the associated household", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/households/1/household_memberships/2/household"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    membership |> Membership.household
  end

  test ".person gets the associated household", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/households/1/household_memberships/2/person"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    membership |> Membership.person
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/households/1/household_memberships"
    %PcoApi.Record{
      links: %{"household_memberships" => url},
      type: "Household"
    }
  end

  defp record_without_link, do: %PcoApi.Record{type: "Household", id: "1"}

  def membership do
    %PcoApi.Record{
      type: "HouseholdMembership",
      links: %{
        "household" => "https://api.planningcenteronline.com/people/v2/households/1/household_memberships/2/household",
        "person" => "https://api.planningcenteronline.com/people/v2/households/1/household_memberships/2/person"
      }
    }
  end
end
