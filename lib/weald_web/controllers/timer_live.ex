defmodule WealdWeb.TimerLive do
  use WealdWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket
      |> assign(%{ prompt: "Start" })
      |> setTime(25 * 60)}
  end

  def handle_event("start", _params, socket) do
    {:noreply, startTimer(socket, 25 * 60)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= @text %>
    </div>
    <div><button phx-click="start"><%= @prompt %></button></div>
    """
  end

  def handle_info(:tick, socket) do
    if (socket.assigns.seconds <= 0) do
      :timer.cancel(socket.private.timer)

      {:noreply, setTime(socket, 0)}
    else
      {:noreply, setTime(socket, socket.assigns.seconds - 1)}
    end
  end

  def setTime(socket, time) do
    text = Time.from_seconds_after_midnight(time)
      |> Timex.format!("{0m}:{0s}")

    assign(socket, %{seconds: time, text: text})
  end

  def startTimer(socket, time) do
    {ok, timer} = :timer.send_interval(1000, self(), :tick)

    if (socket.private[:timer]) do
      IO.inspect(:timer.cancel(socket.private.timer))
    end

    %{socket | private: Map.put(socket.private, :timer, timer)}
      |> setTime(time)
      |> assign(%{ prompt: "Restart" })
  end
end
