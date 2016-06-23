defmodule PcoApi.People.List.Rule.Condition.ResultTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.List.Rule.Condition.Result
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list lists results with a url", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/lists/1/rules/2/conditions/3/results"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    record_with_link |> Result.list
  end

  test ".get gets a result by id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/lists/1/rules/2/conditions/3/results/4"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    record_with_link |> Result.get(4)
  end

  test ".person gets the associated person for a condition result", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1"
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    condition_result |> Result.person
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/lists/1/rules/2/conditions/3/results"
    %PcoApi.Record{
      links: %{"results" => url},
      type: "Condition"
    }
  end

  defp condition_result do
    %PcoApi.Record{
      attributes: %{},
      id: "3",
      links: %{"person" => "https://api.planningcenteronline.com/people/v2/people/1"},
      type: "ConditionResult"
    }
  end
end
