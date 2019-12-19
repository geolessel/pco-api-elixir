defmodule PcoApi.People.OrganizationTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.Organization
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list requests the v2 endpoint", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.get()
  end

  test ".apps requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/apps" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.apps()
  end

  test ".campuses requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/campuses" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.campuses()
  end

  test ".carriers requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/carriers" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.carriers()
  end

  test ".emails requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/emails" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.emails()
  end

  test ".field_definitions requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/field_definitions" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.field_definitions()
  end

  test ".households requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/households" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.households()
  end

  test ".inactive_reasons requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/inactive_reasons" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.inactive_reasons()
  end

  test ".lists requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/lists" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.lists()
  end

  test ".marital_statuses requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/marital_statuses" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.marital_statuses()
  end

  test ".message_groups requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/message_groups" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.message_groups()
  end

  test ".messages requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/messages" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.messages()
  end

  test ".name_prefixes requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/name_prefixes" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.name_prefixes()
  end

  test ".name_suffixes requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/name_suffixes" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.name_suffixes()
  end

  test ".people requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.people()
  end

  test ".people_imports requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people_imports" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.people_imports()
  end

  test ".reports requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/reports" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.reports()
  end

  test ".school_options requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/school_options" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.school_options()
  end

  test ".social_profiles requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/social_profiles" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.social_profiles()
  end

  test ".stats requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/stats" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.stats()
  end

  test ".tabs requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/tabs" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.tabs()
  end

  test ".workflows requests the apps the org is subscribed to", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/workflows" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    Organization.workflows()
  end
end
