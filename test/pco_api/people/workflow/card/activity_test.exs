defmodule PcoApi.People.Workflow.Card.ActivityTest do
  use ExUnit.Case
  alias PcoApi.People.Workflow.Card.Activity
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
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_activities.json"))
    end
    record_with_link |> Activity.list
  end

  test ".list gets activities with an activities link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/activities" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_activities.json"))
    end
    record_with_link |> Activity.list
  end

  test ".list gets activities with only a self link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/activities" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_activities.json"))
    end
    record_with_self_link |> Activity.list
  end

  test ".get gets activity by activities id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/activities/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_activity.json"))
    end
    record_with_self_link |> Activity.get(1)
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/workflows/1/cards/1/activities"
    %PcoApi.Record{
      links: %{"activities" => url},
      type: "WorkflowCard"
    }
  end

  defp record_with_self_link do
    url = "https://api.planningcenteronline.com/people/v2/workflows/1/cards/1"
    %PcoApi.Record{
      id: "1",
      links: %{"self" => url},
      type: "WorkflowCard"
    }
  end
end
