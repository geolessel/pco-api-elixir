defmodule PcoApi.People.Workflow.Card.TaskTest do
  use ExUnit.Case
  alias PcoApi.People.Workflow.Card.Task
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
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_tasks.json"))
    end
    record_with_link |> Task.get
  end

  test ".get gets tasks with a tasks link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/tasks" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_tasks.json"))
    end
    record_with_link |> Task.get
  end

  test ".get gets tasks with only a self link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/tasks" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_tasks.json"))
    end
    record_with_self_link |> Task.get
  end

  test ".get gets task by tasks id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/tasks/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_task.json"))
    end
    record_with_self_link |> Task.get(1)
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/workflows/1/cards/1/tasks"
    %PcoApi.Record{
      links: %{"tasks" => url},
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

  defp record_without_link do
    %PcoApi.Record{
      id: "1",
      type: "WorkflowCard"
    }
  end
end
