defmodule AnonymousMessagesWeb.QuestionController do
  alias AnonymousMessages.Repo
  alias AnonymousMessages.Question
  use AnonymousMessagesWeb, :controller
  import Phoenix.HTML.FormData
  import Ecto.Query

  def index(conn, _params) do
    query =
      from u in Question,
        where: u.user_id == ^conn.assigns.current_user.id,
        order_by: [desc: :inserted_at]

    render(conn, :index, questions: Repo.all(query))
  end

  def new(conn, _params) do
    question_changeset = Question.changeset(%Question{}, %{})
    question_changeset = to_form(question_changeset, as: :question)

    render(conn, :new, question: question_changeset)
  end

  def create(conn, %{"question" => question_params}) do
    IO.inspect(question_params)

    question_params = Map.put(question_params, "user_id", conn.assigns.current_user.id)
    changeset = Question.changeset(%Question{}, question_params)

    case Repo.insert(changeset) do
      {:ok, _question} ->
        redirect(conn, to: "/questions")

      {:error, changeset} ->
        changeset = to_form(changeset, as: :question)
        render(conn, :new, question: changeset)
    end
  end
end
