defmodule PcoApi.People.ListTest do
  use ExUnit.Case
  doctest PcoApi.People.List
  alias PcoApi.People.List
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".get requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("lists.json"))
    end
    List.get
  end

  test ".get returns a list of Record structs", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      Plug.Conn.resp(conn, 200, Fixture.read("lists.json"))
    end
    assert [%PcoApi.Record{} | _rest] = List.get
  end

  test ".get(id) returns a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/1" == conn.request_path
      Plug.Conn.resp conn, 200, Fixture.read("list.json")
    end
    list = List.get(1)
    assert %PcoApi.Record{id: "1"} = list
  end

  test ".get queries from a params list", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/" == conn.request_path
      assert "where%5Bdescription%5D=Inactive+Members" == conn.query_string
      Plug.Conn.resp(conn, 200, Fixture.read("lists.json"))
    end
    PcoApi.Query.where(description: "Inactive Members")
    |> List.get
  end

  test ".get queries a params list and a specific path", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/foo" == conn.request_path
      assert "where%5Bdescription%5D=Inactive+Members" == conn.query_string
      Plug.Conn.resp(conn, 200, Fixture.read("lists.json"))
    end
    PcoApi.Query.where(description: "Inactive Members")
    |> List.get("foo")
  end

  test ".self retrieves the details of a List when passed a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("list.json"))
    end
    list = %PcoApi.Record{links: %{"self" => "https://api.planningcenteronline.com/people/v2/lists/1"}}
    list |> List.self
  end

  test ".self gets List details even if no self link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/1000" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("list.json"))
    end
    %PcoApi.Record{id: "1000", links: %{}} |> List.self
  end

  test ".people gets a list of people with a people link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/1/people" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("people.json"))
    end
    assert [%PcoApi.Record{type: "Person"} | _rest] = record_with_link |> List.people
  end

  test ".rules gets a list of rules with a rules link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/1/rules" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("rules.json"))
    end
    assert [%PcoApi.Record{type: "Rule"} | _rest] = record_with_link |> List.rules
  end

  # test ".shares gets a list of shares with a shares link", %{bypass: bypass} do
  #   Bypass.expect bypass, fn conn ->
  #     assert "/people/v2/lists/1/shares" == conn.request_path
  #     Plug.Conn.resp(conn, 200, Fixture.read("shares.json"))
  #   end
  #   assert [%PcoApi.Record{type: "ListShare"} | _rest] = record_with_link |> List.shares
  # end

  def record_with_link do
    person_url = "https://api.planningcenteronline.com/people/v2/people/1"
    people_url = "https://api.planningcenteronline.com/people/v2/lists/1/people"
    rules_url = "https://api.planningcenteronline.com/people/v2/lists/1/rules"
    shares_url = "https://api.planningcenteronline.com/people/v2/lists/1/shares"
    %PcoApi.Record{
      links: %{"created_by" => person_url, "owner" => person_url, "people" => people_url, "rules" => rules_url, "shares" => shares_url, "updated_by" => person_url},
      type: "List"
    }
  end
end
