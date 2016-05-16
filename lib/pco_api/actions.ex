defmodule PcoApi.Actions do
  defmacro __using__(_opts) do
    quote do
      import PcoApi.Actions
      use HTTPoison.Base

      def request(:get, url, params) do
        case get(url, [], params: params, hackney: [basic_auth: {PcoApi.key, PcoApi.secret}]) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            body["data"]
          {:ok, %HTTPoison.Response{body: body}} ->
            %{"errors" => [%{"detail" => detail, "title" => title}]} = body
            raise "Request returned non-200 response. Error: #{title}: #{detail}"
          {:error, _} ->
            raise "PcoApi.People error"
        end
      end

      # if this is a full URL, don't add the endpoint. This allows using direct links.
      def process_url(url) do
        endpoint = __MODULE__.api_endpoint
        case url |> String.starts_with?(endpoint) do
          true  -> url
          false -> endpoint <> url
        end
      end
      def process_response_body(body), do: body |> Poison.decode!
    end
  end

  defmacro endpoint(url) do
    quote do
      def unquote(:api_endpoint)(), do: unquote(url)
    end
  end

  # TODO: this probably doesn't belong here
  defmacro linked_association(name) do
    quote do
      def unquote(:"#{name}")(record) do
        # TODO: error handling when the association link doesn't exist
        request(:get, record.links[Atom.to_string(unquote(name))], [])
        |> Enum.map(fn(%{"attributes" => attrs, "id" => id, "links" => links, "type" => type}) ->
          %PcoApi.Record{attributes: attrs, id: id, links: links, type: type}
        end)
      end
    end
  end
end
