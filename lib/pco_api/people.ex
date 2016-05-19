defmodule PcoApi.People do
  use PcoApi.Actions

  endpoint "people/v2/"

  def me do
    get("me")
  end
end
