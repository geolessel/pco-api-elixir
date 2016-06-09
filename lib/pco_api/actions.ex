defmodule PcoApi.Actions do
  defmacro __using__(opts) do
    quote do
      import PcoApi.Actions
      use PcoApi.Client

      use PcoApi.Actions.Get
      use PcoApi.Actions.Create
      use PcoApi.Actions.Self
      use PcoApi.Actions.New
    end
  end

  defmacro endpoint(url) do
    quote do
      def unquote(:api_endpoint)() do
        unquote(url)
      end
    end
  end
end
