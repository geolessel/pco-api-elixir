use Mix.Config

# This needs to go in test setup code in order to use it
# Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}"

config :bypass, enable_debug_log: false
