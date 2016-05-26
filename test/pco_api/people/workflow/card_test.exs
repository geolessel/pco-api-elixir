defmodule PcoApi.People.Workflow.CardTest do
  use ExUnit.Case
  alias PcoApi.People.Workflow.Card
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
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_cards.json"))
    end
    record_with_link |> Card.get
  end

  test ".get gets cards with a cards link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_cards.json"))
    end
    record_with_link |> Card.get
  end

  test ".get gets cards without a cards link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_cards.json"))
    end
    record_without_link |> Card.get
  end

  test ".get gets cards by workflow id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_cards.json"))
    end
    record_without_link |> Card.get
  end

  test ".get gets cards by card id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_cards.json"))
    end
    record_without_link |> Card.get(1)
  end

  test ".activities gets a list of activities with an activities link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/activities" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_activities.json"))
    end
    card_record_with_links |> Card.activities
  end

  test ".assignee gets a person record with an assignee link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("me.json"))
    end
    card_record_with_links |> Card.assignee
  end

  test ".notes gets a list of notes with a notes link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/notes" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_notes.json"))
    end
    card_record_with_links |> Card.notes
  end

  test ".person gets a person record with a person link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("me.json"))
    end
    card_record_with_links |> Card.person
  end

  def card_record_with_links do
    activities_url = "https://api.planningcenteronline.com/people/v2/workflows/1/cards/1/activities"
    assignee_url = "https://api.planningcenteronline.com/people/v2/people/1"
    notes_url = "https://api.planningcenteronline.com/people/v2/workflows/1/cards/1/notes"
    person_url = "https://api.planningcenteronline.com/people/v2/people/1"
    self_url = "https://api.planningcenteronline.com/people/v2/workflows/1/cards/1"
    %PcoApi.Record{
      links: %{
        "activities" => activities_url,
        "assignee" => assignee_url,
        "notes" => notes_url,
        "person" => person_url,
        "self_url" => self_url
      },
      type: "WorkflowCard"
    }
  end

  def record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/workflows/1/cards"
    %PcoApi.Record{
      links: %{"cards" => url},
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
