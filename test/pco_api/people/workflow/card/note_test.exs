defmodule PcoApi.People.Workflow.Card.NoteTest do
  use ExUnit.Case
  alias PcoApi.People.Workflow.Card.Note
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
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_notes.json"))
    end
    record_with_link |> Note.get
  end

  test ".get gets notes with a notes link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/notes" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_notes.json"))
    end
    record_with_link |> Note.get
  end

  test ".get gets notes with only a self link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/notes" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_notes.json"))
    end
    record_with_self_link |> Note.get
  end

  test ".get gets note by notes id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/notes/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_note.json"))
    end
    record_with_self_link |> Note.get(1)
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/workflows/1/cards/1/notes"
    %PcoApi.Record{
      links: %{"notes" => url},
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
