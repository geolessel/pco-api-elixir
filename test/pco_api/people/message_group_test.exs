defmodule PcoApi.People.MessageGroupTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.MessageGroup
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/message_groups" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    MessageGroup.list
  end

  test ".get(id) returns a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/message_groups/1" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    MessageGroup.get(1)
  end

  test ".app requests the app the message was sent from", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/message_groups/1/app" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    group |> MessageGroup.app
  end

  test ".from requests the message sender", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/message_groups/1/from" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    group |> MessageGroup.from
  end

  test ".messages requests the message group", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/message_groups/1/messages" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    group |> MessageGroup.messages
  end

  defp group do
    url_root = "https://api.planningcenteronline.com/people/v2/message_groups/1/"
    %PcoApi.Record{
      type: "MessageGroup",
      id: "1",
      links: %{
        "app"      => url_root <> "app",
        "from"     => url_root <> "from",
        "messages" => url_root <> "messages"
      }
    }
  end
end
