defmodule PcoApi.People.WorkflowTest do
  use ExUnit.Case, async: false
  doctest PcoApi.People.Workflow
  alias PcoApi.People.Workflow
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  # .get
  test ".get requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("workflow.json"))
    end
    Workflow.get
  end

  test ".get returns a list of Record structs", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_list.json"))
    end
    assert [%PcoApi.Record{} | rest] = Workflow.get
  end

  test ".get(id) returns a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/1" == conn.request_path
      Plug.Conn.resp conn, 200, Fixture.read("me.json")
    end
    workflow = Workflow.get(1)
    assert %PcoApi.Record{id: "1"} = workflow
  end

  # TODO: This test is currently passing but it should fail because "Membership" is not a perfect match.
  test ".get queries from a params list", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/" == conn.request_path
      assert "where%5Bname%5D=Membership" == conn.query_string
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_list.json"))
    end
    PcoApi.Query.where(name: "Membership")
    |> Workflow.get
  end

  test ".get queries a params list and a specific path", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/workflows/foo" == conn.request_path
      assert "where%5Bname%5D=Membership" == conn.query_string
      Plug.Conn.resp(conn, 200, Fixture.read("workflow_list.json"))
    end
    PcoApi.Query.where(name: "Membership")
    |> Workflow.get("foo")
  end

  #.get_list
  test ".get_list takes a list of Records and queries the details of each", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path |> String.match?(~r{/people/v2/workflows/[12]})
      Plug.Conn.resp(conn, 200, Fixture.read("workflow.json"))
    end
    foo = %PcoApi.Record{links: %{"self" => "https://api.planningcenteronline.com/people/v2/workflows/1"}}
    bar = %PcoApi.Record{links: %{"self" => "https://api.planningcenteronline.com/people/v2/workflows/2"}}
    [foo, bar] |> Workflow.get_list
  end
end
