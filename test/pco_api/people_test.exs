defmodule PcoApi.PeopleTest do
  use ExUnit.Case
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".resource requests a custom resource path with ids", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("me.json"))
    end)

    PcoApi.People.resource(people: 1)
  end

  test ".resource accepts multiple params", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/workflows/1/cards/2/activities/3" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("me.json"))
    end)

    activity = PcoApi.People.resource(workflows: 1, cards: 2, activities: 3)
    assert %PcoApi.Record{} = activity
  end
end
