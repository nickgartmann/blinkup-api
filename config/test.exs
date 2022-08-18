import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :blinkup, Blinkup.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "blinkup_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blinkup, BlinkupWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  secret_key_base: "47sMXPTL0cI8CwklXrVugCeYxJ3pHOE8sZ+gSF+IOX9ObtNX/9796lkaMjSET9Iv",
  server: true

# In test we don't send emails.
config :blinkup, Blinkup.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
