# PcoApi

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add pco_api to your list of dependencies in `mix.exs`:

     ```elixir
     def deps do
       [{:pco_api, "~> 0.1.0"}]
     end
     ```

  2. Ensure pco_api is started before your application:

     ```elixir
     def application do
       [applications: [:pco_api]]
     end
     ```

## Usage

To get this working locally, `PcoApi` needs to know your API key/id
and secret. If you need to get one, go to
[https://api.planningcenteronline.com/oauth/applications](https://api.planningcenteronline.com/oauth/applications)
and set up a **Personal Access Token**.

Once you have an **Application ID** and **Secret**, you need to use
those in environment variables when you start your app. For
development, you can start up an `iex` session by `export`ing the
variables, or you can explicitly set them during startup:

```bash
> PCO_API_KEY="MY_KEY" PCO_API_SECRET="MY_SECRET" iex -S mix
```

You can then grab a list of people in your account with:

```elixir
iex(1)> PcoApi.People.get("people")
```
