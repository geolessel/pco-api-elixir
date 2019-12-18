defmodule PcoApi.People.ListTest do
  use ExUnit.Case, async: false
  doctest PcoApi.People.List
  alias PcoApi.People.List
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/lists" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("list.json"))
    end)

    List.list()
  end

  test ".list returns a list of Record structs", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, Fixture.read("lists.json"))
    end)

    assert [%PcoApi.Record{} | _rest] = List.list()
  end

  test ".get(id) returns a single record", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/lists/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("list.json"))
    end)

    list = List.get(1)
    assert %PcoApi.Record{id: "1", type: "List"} = list
  end

  test ".created_by gets the list's creator", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("list.json"))
    end)

    assert %PcoApi.Record{} = bypass |> record_with_links |> List.created_by()
  end

  test ".owner gets the list's owner", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/2" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    assert %PcoApi.Record{} = bypass |> record_with_links |> List.owner()
  end

  test ".people gets people in the list", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/lists/1/people" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    assert %PcoApi.Record{} = bypass |> record_with_links |> List.people()
  end

  test ".rules gets list rules", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/lists/1/rules" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    assert %PcoApi.Record{} = bypass |> record_with_links |> List.rules()
  end

  test ".shares gets list shares", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/lists/1/shares" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    assert %PcoApi.Record{} = bypass |> record_with_links |> List.shares()
  end

  test ".updated_by gets list updated_by", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/lists/1/updated_by" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    assert %PcoApi.Record{} = bypass |> record_with_links |> List.updated_by()
  end

  test ".run POSTs to the list's URL", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/lists/1/run" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_with_links(bypass) |> List.run()
  end

  defp record_with_links(bypass) do
    %PcoApi.Record{
      type: "List",
      links: %{
        "created_by" => "http://localhost:#{bypass.port}/people/v2/people/1",
        "owner" => "http://localhost:#{bypass.port}/people/v2/people/2",
        "people" => "http://locahost:#{bypass.port}/people/v2/lists/1/people",
        "rules" => "http://localhost:#{bypass.port}/people/v2/lists/1/rules",
        "shares" => "http://localhost:#{bypass.port}/people/v2/lists/1/shares",
        "updated_by" => "http://localhost:#{bypass.port}/people/v2/lists/1/updated_by",
        "self" => "http://localhost:#{bypass.port}/people/v2/lists/1"
      }
    }
  end
end
