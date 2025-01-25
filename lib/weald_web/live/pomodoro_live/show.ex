defmodule WealdWeb.PomodoroLive.Show do
  use WealdWeb, :live_view

  alias Weald.Pomodori

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pomodoro, Pomodori.get_pomodoro!(id))}
  end

  defp page_title(:show), do: "Show Pomodoro"
  defp page_title(:edit), do: "Edit Pomodoro"
end
