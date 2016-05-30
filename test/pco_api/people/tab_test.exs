defmodule PcoApi.People.TabTest do
  use ExUnit.Case, async: false
  doctest PcoApi.People.Tab
  alias PcoApi.People.Tab
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".get requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/tabs/" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("tab.json"))
    end
    Tab.get
  end

  test ".get returns a list of Record structs", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      Plug.Conn.resp(conn, 200, Fixture.read("tabs.json"))
    end
    assert [%PcoApi.Record{} | _rest] = Tab.get
  end

  test ".get(id) returns a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/tabs/1" == conn.request_path
      Plug.Conn.resp conn, 200, Fixture.read("me.json")
    end
    tab = Tab.get(1)
    assert %PcoApi.Record{id: "1"} = tab
  end

  test ".get queries from a params list", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/tabs/" == conn.request_path
      assert "where%5Bname%5D=Employment" == conn.query_string
      Plug.Conn.resp(conn, 200, Fixture.read("tabs.json"))
    end
    PcoApi.Query.where(name: "Employment")
    |> Tab.get
  end

  test ".get queries a params list and a specific path", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/tabs/foo" == conn.request_path
      assert "where%5Bname%5D=Employment" == conn.query_string
      Plug.Conn.resp(conn, 200, Fixture.read("tabs.json"))
    end
    PcoApi.Query.where(name: "Employment")
    |> Tab.get("foo")
  end

  test ".self retrieves the details of a Tab when passed a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/tabs/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("tab.json"))
    end
    tab = %PcoApi.Record{links: %{"self" => "https://api.planningcenteronline.com/people/v2/tabs/1"}}
    tab |> Tab.self
  end

  test ".self gets Tab details even if no self link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/tabs/1000" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("tab.json"))
    end
    %PcoApi.Record{id: "1000", links: %{}} |> Tab.self
  end

  test ".field_definitions gets a list of associated FieldDefinition records with a field_definitions link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/tabs/1/field_definitions" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("field_definitions.json"))
    end
    assert [%PcoApi.Record{type: "FieldDefinition"} | _rest] = record_with_link |> Tab.field_definitions
  end

  def record_with_link do
    field_definitions_url = "https://api.planningcenteronline.com/people/v2/tabs/1/field_definitions"
    self_url = "https://api.planningcenteronline.com/people/v2/tabs"
    %PcoApi.Record{
      links: %{"field_definitions" => field_definitions_url, "self" => self_url},
      type: "Tab"
    }
  end
end
