defmodule PcoApi.People do
  use PcoApi.Actions

  endpoint "https://api.planningcenteronline.com/people/v2/"

  def me do
    get("me")
  end
end
