defmodule AnonymousMessages.Repo do
  use Ecto.Repo,
    otp_app: :anonymous_messages,
    adapter: Ecto.Adapters.Postgres
end
