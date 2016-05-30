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

  test ".get requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/school_options/" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("school_option.json"))
    end
    SchoolOption.get
  end

  test ".get returns a list of Record structs", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      Plug.Conn.resp(conn, 200, Fixture.read("school_options.json"))
    end
    assert [%PcoApi.Record{} | _rest] = SchoolOption.get
  end

  test ".get(id) returns a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/school_options/1" == conn.request_path
      Plug.Conn.resp conn, 200, Fixture.read("me.json")
    end
    school_option = SchoolOption.get(1)
    assert %PcoApi.Record{id: "1"} = school_option
  end

  test ".get queries from a params list", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/school_options/" == conn.request_path
      assert "where%5Bvalue%5D=Carlsbad+Elementary" == conn.query_string
      Plug.Conn.resp(conn, 200, Fixture.read("school_options.json"))
    end
    PcoApi.Query.where(value: "Carlsbad Elementary")
    |> SchoolOption.get
  end

  test ".get queries a params list and a specific path", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/school_options/foo" == conn.request_path
      assert "where%5Bvalue%5D=Carlsbad+Elementary" == conn.query_string
      Plug.Conn.resp(conn, 200, Fixture.read("school_options.json"))
    end
    PcoApi.Query.where(value: "Carlsbad Elementary")
    |> SchoolOption.get("foo")
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

  def record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/school_options/2"
    %PcoApi.Record{
      links: %{"promotes_to_school" => url},
      type: "Workflow"
    }
  end
end
