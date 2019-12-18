defmodule PcoApi.People.Workflow.Card.NoteTest do
  use ExUnit.Case
  alias PcoApi.People.Workflow.Card.Note
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path |> String.match?(~r|people/v2|)
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_notes.json"))
    end)

    record_with_link |> Note.list()
  end

  test ".list gets notes with a notes link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/notes" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_notes.json"))
    end)

    record_with_link |> Note.list()
  end

  test ".list gets notes with only a self link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/notes" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_notes.json"))
    end)

    record_with_self_link |> Note.list()
  end

  test ".get gets note by notes id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/notes/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_card_note.json"))
    end)

    record_with_self_link |> Note.get(1)
  end

  test ".new returns a WorkflowCardNote Record" do
    assert %PcoApi.Record{type: "WorkflowCardNote"} = new_note
  end

  test ".create POSTs to the workflow card endpoint", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/1/notes" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_with_self_link |> Note.create(new_note)
  end

  defp new_note do
    Note.new(note: "This guy is the best!")
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
