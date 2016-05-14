defmodule PcoApi.People.Person do
  @derive [Poison.Encoder]
  defstruct [:attributes, :id, :links]
end
