defmodule PcoApi.People.List.ShareTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.List.Share
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list lists shares with a url", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/lists/1/shares"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_with_link() |> Share.list()
  end

  test ".list lists shares without a url", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/lists/1/shares"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_without_link() |> Share.list()
  end

  test ".get gets a share by id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/lists/1/shares/2"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_with_link() |> Share.get(2)
  end

  test ".person gets the associated person for a share", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    share() |> Share.person()
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/lists/1/shares"

    %PcoApi.Record{
      links: %{"shares" => url},
      type: "List"
    }
  end

  defp record_without_link, do: %PcoApi.Record{type: "List", id: "1"}

  defp share do
    %PcoApi.Record{
      links: %{"person" => "https://api.planningcenteronline.com/people/v2/people/1"},
      type: "ListShare"
    }
  end
end
