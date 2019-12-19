defmodule PcoApi.People.PhoneNumber do
  @moduledoc false

  use PcoApi.Actions

  def list(%PcoApi.Record{type: "Person", links: %{"phone_numbers" => url}}), do: get(url)
  def list(%PcoApi.Record{type: "Person", id: id}), do: get("people/#{id}/phone_numbers")

  def get(%PcoApi.Record{type: "Person", id: person_id}, id),
    do: get("people/#{person_id}/phone_numbers/#{id}")

  def new(attrs) when is_list(attrs), do: new(attrs, "PhoneNumber")

  def create(%PcoApi.Record{type: "Person", id: person_id}, %PcoApi.Record{} = record) do
    record |> create("people/#{person_id}/phone_numbers")
  end
end
