defmodule PcoApi.People.List.Rule.ResultTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.List.Rule.Result
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list lists results with a rule url", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/lists/1/rules/2/results"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    record_with_link |> Result.list
  end

  test ".get gets a result by id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/lists/1/rules/2/results/3"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    record_with_link |> Result.get(3)
  end

  test ".person gets the associated person for a result", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/4"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    rule_result |> Result.person
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/lists/1/rules/2/results"
    %PcoApi.Record{
      links: %{"results" => url},
      type: "Rule"
    }
  end

  defp rule_result do
    %PcoApi.Record{
      attributes: %{},
      id: "3",
      links: %{"person" => "https://api.planningcenteronline.com/people/v2/people/4"},
      type: "RuleResult"
    }
  end
end
