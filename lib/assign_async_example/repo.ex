defmodule AssignAsyncExample.Repo do
  use Ecto.Repo,
    otp_app: :assign_async_example,
    adapter: Ecto.Adapters.Postgres
end
