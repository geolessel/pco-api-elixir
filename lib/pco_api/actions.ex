defmodule PcoApi.Actions do
  defmacro __using__(_opts) do
    quote do
      import PcoApi.Actions
      use HTTPoison.Base

      def request(:get, url, params) do
        case get(url, [], params: params, hackney: [basic_auth: {PcoApi.key, PcoApi.secret}]) do
          {:ok, %HTTPoison.Response{status_code: code, body: body}} when (code in 200..299) ->
            body["data"]
          {:ok, %HTTPoison.Response{body: body}} ->
            %{"errors" => [%{"detail" => detail, "title" => title}]} = body
            raise "Request returned non-200 response. Error: #{title}: #{detail}"
          {:error, _} ->
            raise "PcoApi.People error"
        end
      end

      def get, do: get("")
      def get(id) when is_integer(id), do: get(Integer.to_string(id))
      def get(url) when is_binary(url), do: request(:get, url, []) |> new
      def get(params) when is_list(params), do: get(params, "")
      def get(%PcoApi.Record{links: %{"self" => self}}), do: get self
      def get(%PcoApi.Record{id: id}), do: get String.to_integer(id)
      def get(params, url) when is_list(params), do: request(:get, url, params) |> new

      def new(results) when is_list(results), do: results |> Enum.map(&(&1 |> new))
      def new(%{"id" => id, "links" => links, "attributes" => attrs, "type" => type}) do
        %PcoApi.Record{id: id, links: links, attributes: attrs, type: type}
      end

      # HTTPoison.Base API

      # if this is a full URL, don't add the endpoint. This allows using direct links.
      def process_url(url) do
        endpoint = __MODULE__.api_endpoint
        case url |> String.starts_with?(endpoint) do
          true  -> url
          false -> endpoint <> Regex.replace(~r{^https?://.+/}, url, "") # enforce the endpoint
        end
      end
      def process_response_body(body), do: body |> Poison.decode!
    end
  end

  defmacro endpoint(url) do
    quote do
      def unquote(:api_endpoint)() do
        Application.get_env(:pco_api, :endpoint_base) <> unquote(url)
      end
    end
  end
end
