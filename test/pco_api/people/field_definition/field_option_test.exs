defmodule PcoApi.People.Person.FieldDefinition.FieldOptionTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.FieldDefinition.FieldOption
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list lists field options with a link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/field_definitions/1/field_options"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    field_definition_with_links |> FieldOption.list()
  end

  test ".list lists field options with a definition id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/field_definitions/1/field_options"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    field_definition_without_links |> FieldOption.list()
  end

  test ".get gets a field option by id with a definition link", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/field_definitions/1/field_options/2"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    field_definition_with_links |> FieldOption.get(2)
  end

  test ".get gets a field option by id with a definition id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/field_definitions/1/field_options/2"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    field_definition_without_links |> FieldOption.get(2)
  end

  test ".new with attributes builds a PcoApi.Record" do
    attrs = [value: "Elixir", sequence: 1]
    assert FieldOption.new(attrs) == new_record
  end

  test ".create with a new record and a definition creates a record", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/field_definitions/1/field_options"
      assert conn.method == "POST"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    new_record |> FieldOption.create(field_definition_without_links)
  end

  test ".create with a definition and a new record creates a record", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/field_definitions/1/field_options"
      assert conn.method == "POST"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    field_definition_without_links |> FieldOption.create(new_record)
  end

  defp field_definition_with_links do
    url = "https://api.planningcenteronline.com/people/v2/field_definitions/1/field_options"

    %PcoApi.Record{
      type: "FieldDefinition",
      links: %{"field_options" => url}
    }
  end

  defp field_definition_without_links, do: %PcoApi.Record{type: "FieldDefinition", id: "1"}

  defp new_record do
    %PcoApi.Record{
      attributes: %{
        "value" => "Elixir",
        "sequence" => 1
      },
      type: "FieldOption"
    }
  end
end
