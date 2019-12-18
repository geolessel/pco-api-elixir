defmodule PcoApi.People.ConnectedPeopleTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.ConnectedPeople
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list lists connected people with a url", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/connected_people"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_with_link |> ConnectedPeople.list()
  end

  test ".list lists connected people without a url", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/connected_people"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_without_link |> ConnectedPeople.list()
  end

  test ".get gets a connected_person by id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/connected_people/2"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_without_link |> ConnectedPeople.get(2)
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/people/1/connected_people"

    %PcoApi.Record{
      links: %{"connected_people" => url},
      type: "Person"
    }
  end

  defp record_without_link, do: %PcoApi.Record{type: "Person", id: "1"}
end
