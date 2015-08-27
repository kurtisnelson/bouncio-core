use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bouncer, Bouncer.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Set a higher stacktrace during test
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :bouncer, Bouncer.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bouncer_test",
  username: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox
