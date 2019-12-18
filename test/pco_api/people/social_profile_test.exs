defmodule PcoApi.People.SocialProfileTest do
  use ExUnit.Case
  alias PcoApi.People.SocialProfile
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
      Plug.Conn.resp(conn, 200, Fixture.read("social_profiles.json"))
    end)

    record_with_link() |> SocialProfile.list()
  end

  test ".list gets social_profiles with an social_profiles link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1/social_profiles" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("social_profiles.json"))
    end)

    record_with_link() |> SocialProfile.list()
  end

  test ".list gets social_profiles without an address link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1/social_profiles" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("social_profiles.json"))
    end)

    record_with_link() |> SocialProfile.list()
  end

  test ".list gets social_profiles by person id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1/social_profiles" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("social_profiles.json"))
    end)

    record_with_link() |> SocialProfile.list()
  end

  test ".get(id) gets social_profiles by person id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1/social_profiles/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("social_profile.json"))
    end)

    record_without_link() |> SocialProfile.get(1)
  end

  test ".person gets a person record with a person link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1" == conn.request_path
      Plug.Conn.resp(conn, 200, Fixture.read("me.json"))
    end)

    assert %PcoApi.Record{type: "Person"} =
             social_profile_record_with_links() |> SocialProfile.person()
  end

  test ".new returns a SocialProfile Record" do
    assert %PcoApi.Record{type: "SocialProfile"} = profile()
  end

  test ".create POSTs to a Person's social_profiles URL", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "/people/v2/people/1/social_profiles" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    %PcoApi.Record{type: "Person", id: 1} |> SocialProfile.create(profile())
  end

  defp social_profile_record_with_links do
    person_url = "https://api.planningcenteronline.com/people/v2/people/1"
    self_url = "https://api.planningcenteronline.com/people/v2/social_profiles/1"

    %PcoApi.Record{
      links: %{
        "person" => person_url,
        "self" => self_url
      },
      type: "SocialProfile"
    }
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/people/1/social_profiles"

    %PcoApi.Record{
      links: %{"social_profiles" => url},
      type: "Person"
    }
  end

  defp record_without_link do
    %PcoApi.Record{
      id: "1",
      type: "Person"
    }
  end

  defp profile do
    SocialProfile.new(site: "facebook", url: "http://example.com", verified: false)
  end
end
