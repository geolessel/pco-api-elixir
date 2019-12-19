defmodule PcoApi.Actions.Self do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      import PcoApi.Actions.Self

      def self(%PcoApi.Record{links: %{"self" => self}}), do: get(self)
    end
  end
end
