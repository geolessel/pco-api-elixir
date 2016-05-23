defmodule PcoApi.People.AddressTest do
  use ExUnit.Case
  alias PcoApi.People.Address
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
      Plug.Conn.resp(conn, 200, Fixture.read("addresses.json"))
    end
    record_with_link |> Address.get
  end

  test ".get gets addresses with an addresses link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1/addresses" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("addresses.json"))
    end
    record_with_link |> Address.get
  end

  test ".get gets addresses without an address link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1/addresses" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("addresses.json"))
    end
    record_without_link |> Address.get
  end

  test ".get gets addresses by person id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1/addresses" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("addresses.json"))
    end
    record_without_link |> Address.get
  end

  test ".get gets addresses by address id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1/addresses/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("address.json"))
    end
    record_without_link |> Address.get(1)
  end

  def record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/people/1/addresses"
    %PcoApi.Record{
      links: %{"addresses" => url},
      type: "Person"
    }
  end

  def record_without_link do
    %PcoApi.Record{
      id: "1",
      type: "Person"
    }
  end
end
