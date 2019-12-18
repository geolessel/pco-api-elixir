defmodule PcoApi.People.Person.FieldDatumTest do
  use ExUnit.Case, async: false
  alias PcoApi.People.Person.FieldDatum
  alias TestHelper.Fixture

  setup do
    bypass = Bypass.open()
    Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test ".list lists a Person's field data with a url", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/field_data"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_with_link |> FieldDatum.list()
  end

  test ".list lists a Person's field data with a Person id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/field_data"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_without_link |> FieldDatum.list()
  end

  test ".get gets a field datum by id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/field_data/2"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_with_link |> FieldDatum.get(2)
  end

  test ".get gets a field datum by id with a person id", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/field_data/2"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    record_without_link |> FieldDatum.get(2)
  end

  test ".new with attributes builds a PcoApi.Record" do
    assert FieldDatum.new(value: "Grilled Cheese") == new_record
  end

  test ".create with a record link and person creates a record", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/field_data"
      assert conn.method == "POST"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    new_record |> FieldDatum.create(%PcoApi.Record{type: "Person", id: "1"})
  end

  test ".create with a person and record link creates a record", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/field_data"
      assert conn.method == "POST"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    %PcoApi.Record{type: "Person", id: "1"} |> FieldDatum.create(new_record)
  end

  test ".field_definition gets the associated field definition", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/field_data/2/field_definition"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    field_datum |> FieldDatum.field_definition()
  end

  test ".field_option gets the associated field option", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/field_data/2/field_option"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    field_datum |> FieldDatum.field_option()
  end

  test ".tab gets the associated field option", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert conn.request_path == "/people/v2/people/1/field_data/2/tab"
      assert conn.method == "GET"
      Plug.Conn.resp(conn, 200, Fixture.dummy())
    end)

    field_datum |> FieldDatum.tab()
  end

  defp record_with_link do
    url = "https://api.planningcenteronline.com/people/v2/people/1/field_data"

    %PcoApi.Record{
      links: %{"field_data" => url},
      type: "Person"
    }
  end

  defp record_without_link, do: %PcoApi.Record{type: "Person", id: "1"}

  def field_datum do
    field_definition =
      "https://api.planningcenteronline.com/people/v2/people/1/field_data/2/field_definition"

    field_option =
      "https://api.planningcenteronline.com/people/v2/people/1/field_data/2/field_option"

    tab = "https://api.planningcenteronline.com/people/v2/people/1/field_data/2/tab"

    %PcoApi.Record{
      links: %{
        "field_definition" => field_definition,
        "field_option" => field_option,
        "tab" => tab
      },
      type: "FieldDatum"
    }
  end

  defp new_record,
    do: %PcoApi.Record{attributes: %{"value" => "Grilled Cheese"}, type: "FieldDatum"}
end
