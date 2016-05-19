defmodule PcoApi.People.PersonTest do
  use ExUnit.Case, async: true
  doctest PcoApi.People.Person
  alias PcoApi.People.Person
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  # .get
  test ".get requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("me.json"))
    end
    Person.get
  end

  test ".get returns a list of Record structs", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      Plug.Conn.resp(conn, 200, Fixture.read("people_list.json"))
    end
    assert [%PcoApi.Record{} | rest] = Person.get
  end

  test ".get(id) returns a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1" == conn.request_path
      Plug.Conn.resp conn, 200, Fixture.read("me.json")
    end
    person = Person.get(1)
    assert %PcoApi.Record{id: "1"} = person
  end

  test ".get queries from a params list", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/" == conn.request_path
      assert "where%5Blast_name%5D=Lessel&where%5Bfirst_name%5D=Geoffrey" == conn.query_string
      Plug.Conn.resp(conn, 200, Fixture.read("people_list.json"))
    end
    PcoApi.Query.where(first_name: "Geoffrey")
    |> PcoApi.Query.where(last_name: "Lessel")
    |> Person.get
  end

  test ".get queries a params list and a specific path", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/foo" == conn.request_path
      assert "where%5Blast_name%5D=Lessel" == conn.query_string
      Plug.Conn.resp(conn, 200, Fixture.read("people_list.json"))
    end
    PcoApi.Query.where(last_name: "Lessel")
    |> Person.get("foo")
  end

  #.get_list
  test ".get_list takes a list of Records and queries the details of each", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path |> String.match?(~r{/people/v2/people/[12]})
      Plug.Conn.resp(conn, 200, Fixture.read("me.json"))
    end
    me = %PcoApi.Record{links: %{"self" => "https://api.planningcenteronline.com/people/v2/people/1"}}
    em = %PcoApi.Record{links: %{"self" => "https://api.planningcenteronline.com/people/v2/people/2"}}
    [me, em] |> Person.get_list
  end
end