defmodule PcoApi.People.List.RuleTest do
  use ExUnit.Case
  alias PcoApi.People.List.Rule
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
      Plug.Conn.resp(conn, 200, Fixture.read("rules.json"))
    end
    record_with_link |> Rule.get
  end

  test ".get gets rules with a rules link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/1/rules" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("rules.json"))
    end
    record_with_link |> Rule.get
  end

  test ".get gets rules without a rules link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/1/rules" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("rules.json"))
    end
    record_without_link |> Rule.get
  end

  test ".get gets rules by list id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/1/rules" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("rules.json"))
    end
    record_without_link |> Rule.get
  end

  test ".get gets rules by rule id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/1/rules/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("rules.json"))
    end
    record_without_link |> Rule.get(1)
  end

  test ".conditions gets a list of conditions with an conditions link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/lists/1/rules/1/conditions" == conn.request_path
      Plug.Conn.resp conn, 200, Fixture.dummy
    end
    assert %PcoApi.Record{} = bypass |> rule_record_with_links |> Rule.conditions
  end
  #
  # test ".notes gets a list of notes with a notes link", %{bypass: bypass} do
  #   Bypass.expect bypass, fn conn ->
  #     assert "/people/v2/lists/1/rules/1/notes" == conn.request_path
  #     Plug.Conn.resp(conn, 200, Fixture.read("rule_notes.json"))
  #   end
  #   assert [%PcoApi.Record{type: "WorkflowRuleNote"} | _rest] = rule_record_with_links |> Rule.notes
  # end
  #
  # test ".person gets a person record with a person link", %{bypass: bypass} do
  #   Bypass.expect bypass, fn conn ->
  #     assert "/people/v2/people/1" == conn.request_path
  #     Plug.Conn.resp(conn, 200, Fixture.read("me.json"))
  #   end
  #   assert %PcoApi.Record{type: "Person"} = rule_record_with_links |> Rule.person
  # end

  def rule_record_with_links do
    conditions_url = "https://api.planningcenteronline.com/people/v2/lists/1/rules/1/conditions"
    results_url = "https://api.planningcenteronline.com/people/v2/lists/1/rules/1/results"
    self_url = "https://api.planningcenteronline.com/people/v2/lists/1/rules/1"
    %PcoApi.Record{
      links: %{
        "conditions" => conditions_url,
        "results" => results_url,
        "self_url" => self_url
      },
      type: "Rule"
    }
  end

  def record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/lists/1/rules"
    %PcoApi.Record{
      links: %{"rules" => url},
      type: "List"
    }
  end

  def record_without_link do
    %PcoApi.Record{
      id: "1",
      type: "List"
    }
  end
end
