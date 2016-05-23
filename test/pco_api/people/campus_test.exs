defmodule PcoApi.People.CampusTest do
  use ExUnit.Case
  alias PcoApi.People.Campus
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".get requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path |> String.match?(~r|people/v2|)
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("campuses.json"))
    end
    Campus.get
  end

  test ".get gets campuses", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/campuses/" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("campuses.json"))
    end
    campus = Campus.get
    assert [%PcoApi.Record{type: "Campus"} | _rest] = campus
  end

  test ".get gets a single campus with an id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/campuses/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("campus.json"))
    end
    assert %PcoApi.Record{type: "Campus"} = Campus.get(1)
  end
end
