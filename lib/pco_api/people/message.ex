defmodule PcoApi.People.Message do
  use PcoApi.Actions, only: [:list, :get]

  import PcoApi.RecordAssociation
  linked_association(:message_group)
  linked_association(:to)

  def list(params) when is_list(params), do: get(params, "messages")

  def get(id) when is_integer(id), do: get("messages/#{id}")
end
