defmodule AnonymousMessages.Question do
  alias AnonymousMessages.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "questions" do
    belongs_to :user, User, type: :integer
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:user_id, :description])
    |> validate_required([:user_id, :description])
  end
end
