defmodule AnonymousMessages.Answer do
  alias AnonymousMessages.Question
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "answers" do
    belongs_to :question, Question
    field :answer, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:question_id, :answer])
    |> validate_required([:question_id, :answer])
  end
end
