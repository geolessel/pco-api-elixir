defmodule PcoApi.People.MessageGroup do
  use PcoApi.Actions, only: [:list, :get]

  import PcoApi.RecordAssociation
  linked_association(:app)
  linked_association(:from)
  linked_association(:messages)

  def list(params) when is_list(params), do: get(params, "message_groups")

  def get(id) when is_integer(id), do: get("message_groups/#{id}")
end
