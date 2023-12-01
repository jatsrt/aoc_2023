import Config

config :logger, :console,
  level: :info,
  format: "[$level] $time $message $metadata\n",
  metadata: [:level, :solution, :part, :day]
