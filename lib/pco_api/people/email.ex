defmodule PcoApi.People.Email do
  use PcoApi.Actions
  # use PcoApi.Actions
  # endpoint "people/v2/"
  # record_type "Email"

  def get, do: get("people/v2/emails")
  def get(id) when is_integer(id), do: get("people/v2/emails/#{id}")

  def create(%PcoApi.Record{type: "Person", id: person_id}, %PcoApi.Record{type: "Email"} = record) do
    record |> create("people/#{person_id}/emails")
  end
end

