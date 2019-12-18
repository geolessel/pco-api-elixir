defmodule PcoApi.People.Workflow.StepTest do
  use ExUnit.Case
  alias PcoApi.People.Workflow.Step
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".get requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path |> String.match?(~r|people/v2|)
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_steps.json"))
    end)

    record_with_link |> Step.get()
  end

  test ".get gets steps with a steps link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/workflows/1/steps" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_steps.json"))
    end)

    record_with_link |> Step.get()
  end

  test ".get gets steps without a steps link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/workflows/1/steps" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_steps.json"))
    end)

    record_without_link |> Step.get()
  end

  test ".get gets steps by workflow id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/workflows/1/steps" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_steps.json"))
    end)

    record_without_link |> Step.get()
  end

  test ".get gets steps by step id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/workflows/1/steps/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_steps.json"))
    end)

    record_without_link |> Step.get(1)
  end

  test ".default_assignee gets a person record with a default_assignee link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("me.json"))
    end)

    step_record_with_links |> Step.default_assignee()
  end

  def step_record_with_links do
    default_assignee_url = "https://api.planningcenteronline.com/people/v2/people/1"

    %PcoApi.Record{
      links: %{
        "default_assignee" => default_assignee_url
      },
      type: "WorkflowStep"
    }
  end

  def record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/workflows/1/steps"

    %PcoApi.Record{
      links: %{"steps" => url},
      type: "Workflow"
    }
  end

  def record_without_link do
    %PcoApi.Record{
      id: "1",
      type: "Workflow"
    }
  end
end
