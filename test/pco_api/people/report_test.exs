defmodule PcoApi.People.ReportTest do
  use ExUnit.Case, async: false
  doctest PcoApi.People.Report
  alias PcoApi.People.Report
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/reports" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.read("report.json"))
    end
    Report.list
  end

  test ".list returns a list of Record structs", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      Plug.Conn.resp(conn, 200, Fixture.read("reports.json"))
    end
    assert [%PcoApi.Record{} | _rest] = Report.list
  end

  test ".get(id) returns a single record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/reports/1" == conn.request_path
      Plug.Conn.resp conn, 200, Fixture.read("report.json")
    end
    report = Report.get(1)
    assert %PcoApi.Record{id: "1", type: "Report"} = report
  end

  test ".created_by gets the list's creator", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/2" == conn.request_path
      Plug.Conn.resp conn, 200, Fixture.read("report.json")
    end
    assert %PcoApi.Record{} = bypass |> record_with_links |> Report.created_by
  end

  test ".updated_by gets list updated_by", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/people/3" == conn.request_path
      Plug.Conn.resp conn, 200, Fixture.dummy
    end
    assert %PcoApi.Record{} = bypass |> record_with_links |> Report.updated_by
  end

  test ".self gets Report details even if no self link", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/reports/1000" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("report.json"))
    end
    %PcoApi.Record{id: "1000", type: "Report", links: %{}} |> Report.self
  end


  test ".create with a record link and no url creates a record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/people/v2/reports" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    new_report |> Report.create
  end

  def new_report do
    %PcoApi.Record{
      attributes: %{
        "name" => "My Report",
        "body" => "<h1>Foo Bar</h1>"
      },
      type: "Report"
    }
  end

  defp record_with_links(bypass) do
    %PcoApi.Record{
      type: "Report",
      links: %{
        "created_by" => "http://localhost:#{bypass.port}/people/v2/people/2",
        "updated_by" => "http://localhost:#{bypass.port}/people/v2/people/3",
        "self" => "http://localhost:#{bypass.port}/people/v2/reports/1"
      }
    }
  end
end
