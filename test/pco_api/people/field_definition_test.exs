defmodule PcoApi.People.Person.FieldDefinitionTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.FieldDefinition
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list lists field definitions", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/field_definitions"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    FieldDefinition.list
  end

  test ".get gets a field definition by id", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/field_definitions/1"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    FieldDefinition.get(1)
  end

  test ".new with attributes builds a PcoApi.Record" do
    attrs = [
      config: nil,
      data_type: "boolean",
      deleted_at: nil,
      name: "Elixir",
      sequence: 1,
      slug: "elixir"]
    assert FieldDefinition.new(attrs) == new_record
  end

  test ".create with a new record creates a record", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/field_definitions"
      assert conn.method == "POST"
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    new_record |> FieldDefinition.create
  end

  test ".field_options gets the associated field options", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/field_definitions/1/field_options"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    field_definition |> FieldDefinition.field_options
  end

  test ".tab gets the associated tab", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/people/v2/field_definitions/1/tab"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy)
    end
    field_definition |> FieldDefinition.tab
  end

  defp field_definition do
    options = "https://api.planningcenteronline.com/people/v2/field_definitions/1/field_options"
    tab     = "https://api.planningcenteronline.com/people/v2/field_definitions/1/tab"
    %PcoApi.Record{
      type: "FieldDefinition",
      links: %{
        "field_options" => options,
        "tab" => tab
      }
    }
  end

  defp new_record do
    %PcoApi.Record{
      attributes: %{
        "config" => nil,
        "data_type" => "boolean",
        "deleted_at" => nil,
        "name" => "Elixir",
        "sequence" => 1,
        "slug" => "elixir"},
      type: "FieldDefinition"}
  end
end
