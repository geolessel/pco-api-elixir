defmodule PcoApi.People.AddressTest do
  use ExUnit.Case
  alias PcoApi.People.Address
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path |> String.match?(~r|people/v2|)
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("addresses.json"))
    end
    record_with_link |> Address.list
  end

  test ".list lists addresses with an addresses link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1/addresses" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("addresses.json"))
    end
    record_with_link |> Address.list
  end

  test ".list lists addresses without an address link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1/addresses" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("addresses.json"))
    end
    record_without_link |> Address.list
  end

  test ".list lists addresses by person id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1/addresses" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("addresses.json"))
    end
    record_without_link |> Address.list
  end

  test ".get gets addresses by address id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1/addresses/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("address.json"))
    end
    record_without_link |> Address.get(1)
  end

  test ".new builds a record", %{bypass: bypass} do
    expected = %PcoApi.Record{attributes: %{
                                 "street" => "123 Main",
                                 "city" => "Carlsbad"},
                              type: "Address"}
    assert Address.new(street: "123 Main", city: "Carlsbad") == expected
  end

  test ".create with a Person Record and a new Record creates an Address", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1/addresses" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    record_without_link |> Address.create(new_address)
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

  def new_address do
    Address.new(street: "123 Main", city: "Oceanside")
  end
end
