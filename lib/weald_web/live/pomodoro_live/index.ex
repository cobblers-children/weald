defmodule WealdWeb.PomodoroLive.Index do
  use WealdWeb, :live_view

  alias Weald.Pomodori
  alias Weald.Pomodori.Pomodoro

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :pomodoro_collection, Pomodori.list_pomodoro())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pomodoro")
    |> assign(:pomodoro, Pomodori.get_pomodoro!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Pomodoro")
    |> assign(:pomodoro, %Pomodoro{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pomodoro")
    |> assign(:pomodoro, nil)
  end

  @impl true
  def handle_info({WealdWeb.PomodoroLive.FormComponent, {:saved, pomodoro}}, socket) do
    {:noreply, stream_insert(socket, :pomodoro_collection, pomodoro)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pomodoro = Pomodori.get_pomodoro!(id)
    {:ok, _} = Pomodori.delete_pomodoro(pomodoro)

    {:noreply, stream_delete(socket, :pomodoro_collection, pomodoro)}
  end
end
