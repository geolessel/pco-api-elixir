defmodule PcoApi.People.List.Rule.ConditionTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.List.Rule.Condition
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list lists conditions with a rule url", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/lists/1/rules/2/conditions"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    record_with_link |> Condition.list
  end

  test ".get gets a condition by id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/lists/1/rules/2/conditions/3"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    record_with_link |> Condition.get(3)
  end

  test ".results gets the associated results for a condition", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/lists/1/rules/2/conditions/3/results"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    rule_result |> Condition.results
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/lists/1/rules/2/conditions"
    %PcoApi.Record{
      links: %{"conditions" => url},
      type: "Rule"
    }
  end

  defp rule_result do
    %PcoApi.Record{
      attributes: %{},
      id: "3",
      links: %{"results" => "https://api.planningcenteronline.com/people/v2/lists/1/rules/2/conditions/3/results"},
      type: "RuleResult"
    }
  end
end
