defmodule PcoApi.People.EmailTest do
  use ExUnit.Case
  alias PcoApi.People.Email
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/emails" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Email.list()
  end

  test ".list lists emails", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/emails" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Email.list()
  end

  test ".get(id) requests a specific email", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/emails/1" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Email.get(1)
  end

  test ".create posts to create an email", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1/emails" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Email.create(%PcoApi.Record{type: "Person", id: 1}, %PcoApi.Record{type: "Email"})
  end
end
