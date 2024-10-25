defmodule WealdWeb.TimerLive do
  use WealdWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket
      |> assign(%{ startPrompt: "Start", pausePrompt: "    " })
      |> setTime(25 * 60)}
  end

  def handle_event("start", _params, socket) do
    {:noreply, startTimer(socket, 25 * 60)}
  end

  def handle_event("pause", _params, socket) do
    {:noreply, pauseResume(socket)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= @text %>
    </div>
    <div>
      <button phx-click="start"><%= @startPrompt %></button>
      <button phx-click="pause"><%= @pausePrompt %></button>
    </div>
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
    {_ok, timer} = :timer.send_interval(1000, self(), :tick)

    if (socket.private[:timer]) do
      IO.inspect(:timer.cancel(socket.private.timer))
    end

    %{socket | private: Map.put(socket.private, :timer, timer)}
      |> setTime(time)
      |> assign(%{ startPrompt: "Restart" })
      |> assign(%{ pausePrompt: "Pause" })
  end

  def pauseResume(socket) do
    if (socket.private[:timer]) do
      IO.inspect(:timer.cancel(socket.private.timer))

      %{socket | private: Map.delete(socket.private, :timer)}
        |> assign(%{ pausePrompt: "Continue" })
    else
      startTimer(socket, socket.assigns.seconds)
    end
  end
end
