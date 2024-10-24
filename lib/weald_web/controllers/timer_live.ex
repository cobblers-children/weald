defmodule WealdWeb.TimerLive do
  use WealdWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{seconds: 60, prompt: "Start"})}
  end

  def handle_info(:tick, socket) do
    if (socket.assigns.seconds <= 0) do
      :timer.cancel(socket.private.timer)

      {:noreply, assign(socket, seconds: 0)}
    else
      {:noreply, assign(socket, seconds: socket.assigns.seconds - 1)}
    end
  end

  def handle_event("start", _params, socket) do
    {ok, timer} = :timer.send_interval(1000, self(), :tick)

    if (socket.private[:timer]) do
      IO.inspect(:timer.cancel(socket.private.timer))
    end

    socket = %{socket | private: Map.put(socket.private, :timer, timer)}

    {:noreply, assign(socket, %{seconds: 60, prompt: "Restart"})}
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= Time.from_seconds_after_midnight(@seconds) |> Timex.format!("{0m}:{0s}") %>
    </div>
    <div><button phx-click="start"><%= @prompt %></button></div>
    """
  end
end
