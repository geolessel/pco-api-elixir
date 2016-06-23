defmodule PcoApi.Actions do
  defmacro __using__(opts) do
    quote do
      import PcoApi.Actions
      use PcoApi.Client

      case unquote(opts) |> Keyword.has_key?(:only) do
        true ->
          unquote(opts) |> Keyword.fetch!(:only) |> Enum.each(fn(option) ->
            case option do
              :list   -> use PcoApi.Actions.List
              :get    -> use PcoApi.Actions.Get
              :create -> use PcoApi.Actions.Create
              :self   -> use PcoApi.Actions.Self
              :new    -> use PcoApi.Actions.New
            end
          end)
        _ ->
          use PcoApi.Actions.List
          use PcoApi.Actions.Get
          use PcoApi.Actions.Create
          use PcoApi.Actions.Self
          use PcoApi.Actions.New
      end
    end
  end
end
