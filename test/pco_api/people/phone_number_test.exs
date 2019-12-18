defmodule PcoApi.People.PhoneNumberTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.PhoneNumber
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list lists phone numbers with a link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/phone_numbers"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    person_with_links |> PhoneNumber.list()
  end

  test ".list lists phone numbers without a link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1/phone_numbers" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    person_without_link |> PhoneNumber.list()
  end

  test ".get gets phone numbers by id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1/phone_numbers/2" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    person_without_link |> PhoneNumber.get(2)
  end

  test ".new builds a record" do
    expected = %PcoApi.Record{
      attributes: %{
        "number" => "555-555-5555",
        "carrier" => "AT&T",
        "location" => "mobile"
      },
      type: "PhoneNumber"
    }

    assert PhoneNumber.new(number: "555-555-5555", carrier: "AT&T", location: "mobile") ==
             expected
  end

  test ".create with a Person Record and a new Record creates a Phone Number", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1/phone_numbers" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    person_without_link |> PhoneNumber.create(new_phone)
  end

  defp person_with_links do
    url = "https://api.planningcenteronline.com/people/v2/people/1/phone_numbers"

    %PcoApi.Record{
      links: %{"phone_numbers" => url},
      type: "Person"
    }
  end

  defp person_without_link do
    %PcoApi.Record{
      type: "Person",
      id: "1"
    }
  end

  defp new_phone, do: PhoneNumber.new(number: "555-555-5555")
end
