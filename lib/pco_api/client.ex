defmodule PcoApi.Client do
  defmacro __using__(_opts) do
    quote do
      import PcoApi.Client
      use HTTPoison.Base

      def request(:get, url, params) do
        case get(url, [], params: params, hackney: [basic_auth: {PcoApi.key, PcoApi.secret}]) do
          {:ok, %HTTPoison.Response{status_code: code, body: body}} when (code in 200..299) ->
            cond do
              %{"data" => data} = body -> data
              true -> body
            end
          {:ok, %HTTPoison.Response{body: body}} ->
            %{"errors" => [%{"detail" => detail, "title" => title}]} = body
            raise "Request returned non-200 response. Error: #{title}: #{detail}"
          {:error, error} ->
            raise "PcoApi.People error: #{error}"
        end
      end

      def process_url(url) do
        endpoint_base = Application.get_env(:pco_api, :endpoint_base)
        processed = Regex.replace(~r|^https?://.+/(people/v2/)?|U, url, "")
        processed = Regex.replace(~r|people/v2/|, processed, "")
        endpoint_base <> "people/v2/" <> processed
      end

      def process_response_body(body) do
        cond do
          body |> String.match?(~r|access denied|i) -> raise "Access denied. You may not have permission to view this resource."
          true -> body |> Poison.decode!
        end
      end
    end
  end
end
