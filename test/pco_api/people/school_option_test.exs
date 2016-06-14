defmodule PcoApi.People.SchoolOptionTest do
  use ExUnit.Case, async: false
  doctest PcoApi.People.SchoolOption
  alias PcoApi.People.SchoolOption
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/school_options" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("school_option.json"))
    end
    SchoolOption.list
  end

  test ".list returns a list of Record structs", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      Plug.Conn.resp(conn, 200, Fixture.read("school_options.json"))
    end
    assert [%PcoApi.Record{} | _rest] = SchoolOption.list
  end

  test ".get(id) returns a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/school_options/1" == conn.request_path
      Plug.Conn.resp conn, 200, Fixture.read("me.json")
    end
    school_option = SchoolOption.get(1)
    assert %PcoApi.Record{id: "1"} = school_option
  end

  test ".list queries from a params list", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/school_options" == conn.request_path
      assert "where%5Bvalue%5D=Carlsbad+Elementary" == conn.query_string
      Plug.Conn.resp(conn, 200, Fixture.read("school_options.json"))
    end
    PcoApi.Query.where(value: "Carlsbad Elementary")
    |> SchoolOption.list
  end

  test ".self retrieves the details of a Workflow when passed a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/school_options/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("school_option.json"))
    end
    school_options = %PcoApi.Record{links: %{"self" => "https://api.planningcenteronline.com/people/v2/school_options/1"}}
    school_options |> SchoolOption.self
  end

  test ".self gets SchoolOption details even if no self link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/school_options/1000" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("school_option.json"))
    end
    %PcoApi.Record{id: "1000", links: %{}} |> SchoolOption.self
  end

  test ".promotes_to_school gets a SchoolOption record with a promotes_to_school link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/school_options/2" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("school_option.json"))
    end
    assert %PcoApi.Record{type: "SchoolOption"} = record_with_link |> SchoolOption.promotes_to_school
  end

  test ".create POSTs to the endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/school_options" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    elementary_school |> SchoolOption.create
  end

  test ".new returns a List Record" do
    assert %PcoApi.Record{type: "SchoolOption"} = elementary_school
  end

  defp elementary_school do
    SchoolOption.new(school_types: ["elementary"], beginning_grade: "1", ending_grade: "2")
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/school_options/2"
    %PcoApi.Record{
      links: %{"promotes_to_school" => url},
      type: "Workflow"
    }
  end
end
