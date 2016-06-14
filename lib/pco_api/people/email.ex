defmodule PcoApi.People.Email do
  use PcoApi.Actions

  def list(params) when is_list(params), do: get(params, "emails")

  def get(id) when is_integer(id), do: get("emails/#{id}")

  @doc """
  Creates a new email address for a Person record.

  ## Examples

    iex> email = %PcoApi.Record{type: "Email", attributes: %{"location" => "work", "address" => "geo@pco.bz"}}
    iex> PcoApi.Record{type: "Person", id: 1} |> PcoApi.People.Email.create(email)
    %PcoApi.Record{type: "Email"}

  """
  def create(%PcoApi.Record{attributes: _, type: _} = person, %PcoApi.Record{type: "Email"} = record), do: create(record, "people/#{person.id}/emails")

  def self(%PcoApi.Record{type: "Email", id: id}), do: get("emails/#{id}")

  def new(attrs) when is_list(attrs), do: new(attrs, "Email")
end

