defmodule AnonymousMessagesWeb.AnswerController do
  alias AnonymousMessagesWeb.Endpoint
  alias AnonymousMessages.Question
  alias AnonymousMessages.Repo
  alias AnonymousMessages.Answer
  import Phoenix.HTML.FormData
  import Ecto.Query
  use AnonymousMessagesWeb, :controller

  def answer(conn, %{"id" => id}) do
    if String.length(id) > 0 do
      changeset = Answer.changeset(%Answer{}, %{question_id: id})
      query = from u in Question, where: u.id == ^id
      render(conn, :answer, answer: to_form(changeset, as: :answer), object: Repo.one(query))
    else
      redirect(conn, to: ~p"/")
    end
  end

  def submit(conn, %{"answer" => answer, "id" => id}) do
    answer = Map.put(answer, "question_id", id)
    changeset = Answer.changeset(%Answer{}, answer)
    query = from u in Question, where: u.id == ^answer["question_id"]
    object = Repo.one(query)

    case Repo.insert(changeset) do
      {:ok, answer} ->
        Endpoint.broadcast("answer-#{answer.question_id}", "new-answer", %{"answer" => answer})
        redirect(conn, to: ~p"/answer/#{answer.question_id}")

      {:error, changeset} ->
        render(conn, :answer, answer: to_form(changeset, as: :answer), object: object)
    end
  end
end
