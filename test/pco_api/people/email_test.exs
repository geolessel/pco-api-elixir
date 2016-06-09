defmodule PcoApi.People.EmailTest do
  use ExUnit.Case
  doctest PcoApi.People.Email
  alias PcoApi.People.Email
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".get requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/emails" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    Email.get
  end

  test ".get(id) requests a specific email", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/emails/1" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    Email.get(1)
  end
end
