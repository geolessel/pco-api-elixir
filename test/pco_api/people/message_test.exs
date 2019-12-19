defmodule PcoApi.People.MessageTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.Message
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/messages" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Message.list()
  end

  test ".get(id) returns a single record", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/messages/1" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Message.get(1)
  end

  test ".message_group requests the message group", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/messages/1/message_group" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    message() |> Message.message_group()
  end

  test ".to requests the message recipient", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/messages/1/to" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    message() |> Message.to()
  end

  defp message do
    url_root = "https://api.planningcenteronline.com/people/v2/messages/1/"

    %PcoApi.Record{
      type: "Message",
      id: "1",
      links: %{
        "message_group" => url_root <> "message_group",
        "to" => url_root <> "to"
      }
    }
  end
end
