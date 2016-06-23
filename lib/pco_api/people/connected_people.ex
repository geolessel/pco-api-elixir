defmodule PcoApi.People.ConnectedPeople do
  use PcoApi.Actions, only: [:get, :list]

  def list(%PcoApi.Record{type: "Person", links: %{"connected_people" => url}}), do: get(url)
  def list(%PcoApi.Record{type: "Person", id: id}), do: get("people/#{id}/connected_people")

  def get(%PcoApi.Record{type: "Person", id: person_id}, id), do: get("people/#{person_id}/connected_people/#{id}")
end
