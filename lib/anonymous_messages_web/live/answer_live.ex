defmodule AnonymousMessagesWeb.AnswerLive do
  import Ecto.Query
  alias Phoenix.Socket.Broadcast
  alias AnonymousMessages.Repo
  alias AnonymousMessages.Answer
  alias AnonymousMessages.Question
  alias AnonymousMessagesWeb.Endpoint
  use AnonymousMessagesWeb, :live_view

  def render(assigns) do
    ~H"""
    <p class="text-2xl text-orange-500"><%= @question.description %></p>
    <div>
      <ul class="mt-8 flex flex-col space-y-2" id={"#{@question.id}"} phx-update="stream">
        <li
          :for={{dom_id, answer} <- @streams.answers}
          class="bg-black text-white p-2 font-medium rounded-md px-3"
          id={dom_id}
        >
          <p><%= answer.answer %></p>
          <div class="flex justify-end space-x-3 items-center">
            <p class="text-xs"><%= NaiveDateTime.to_string(answer.updated_at) %></p>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe("answer-#{id}")
    end

    questionQuery = from q in Question, where: q.id == ^id
    query = from a in Answer, where: a.question_id == ^id, order_by: [desc: a.updated_at]

    socket =
      socket
      |> assign(:question_id, id)
      |> stream(:answers, Repo.all(query))
      |> assign(:question, Repo.one(questionQuery))

    {:ok, socket}
  end

  def handle_info(
        %Broadcast{
          topic: "answer-" <> _question_id,
          event: "new-answer",
          payload: %{"answer" => answer}
        },
        socket
      ) do
    {:noreply, socket |> stream_insert(:answers, answer, at: 0)}
  end
end
