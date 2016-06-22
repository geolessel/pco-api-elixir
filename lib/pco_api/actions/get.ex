defmodule PcoApi.Actions.Get do
  defmacro __using__(_opts) do
    quote do
      import PcoApi.Actions.Get
      import PcoApi.Record

      def get(url) when is_binary(url), do: get(url, [])
      # def get(params) when is_list(params), do: get(params, "")
      def get(params, url) when is_list(params) and is_binary(url), do: get(url, params)
      def get(url, params) when is_binary(url) do
        case get(url, [], params: params, hackney: [basic_auth: {PcoApi.key, PcoApi.secret}]) do
          {:ok, %HTTPoison.Response{status_code: code, body: body}} when (code in 200..299) ->
            cond do
              %{"data" => data} = body -> data |> to_record
              true -> body
            end
          {:ok, %HTTPoison.Response{body: body}} ->
            %{"errors" => [%{"detail" => detail, "title" => title}]} = body
            raise "Request returned non-200 response. Error: #{title}: #{detail}"
          {:error, error} ->
            raise "PcoApi.People error"
        end
      end
    end
  end
end
