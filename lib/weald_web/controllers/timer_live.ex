defmodule WealdWeb.TimerLive do
  use WealdWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket
      |> assign(%{ prompt: "Start", foo: "start", phase: "pomodoro"})
      |> setTime(25 * 60)
    }
  end

  def handle_event("start", _params, socket) do
    {:noreply, startTimer(socket)}
  end

  def handle_event("pause", _params, socket) do
    {:noreply, pauseResume(socket)}
  end

  def render(assigns) do
    ~H"""
    <div class={@phase}>
      <div class="time text-9xl text-right">
        <%= @text %>
      </div>
    </div>
    <div class="text-right">
      <button class="text-2xl" phx-click={@foo}><%= @prompt %></button>
    </div>
    """
  end

  def handle_info(:tick, socket) do
    if (socket.assigns.seconds <= 0) do
      {:noreply, finishTimer(socket)}
    else
      {:noreply, setTime(socket, socket.assigns.seconds - 1)}
    end
  end

  def setTime(socket, time) do
    text = Time.from_seconds_after_midnight(time)
      |> Timex.format!("{0m}:{0s}")

    assign(socket, %{seconds: time, text: text})
  end

  def startTimer(socket) do
    socket = cancelTimer(socket)

    {_ok, timer} = :timer.send_interval(1000, self(), :tick)

    %{socket | private: Map.put(socket.private, :timer, timer)}
      |> assign(%{ prompt: "Pause" })
      |> assign(%{ foo: "pause" })
  end

  def finishTimer(socket) do
    cancelTimer(socket)
      |> assign(%{ prompt: "Start", foo: "start", phase: "break" })
      |> setTime(5 * 60)
  end

  def pauseResume(socket) do
    if (socket.private[:timer]) do
      socket
        |> cancelTimer()
        |> assign(%{ prompt: "Resume", foo: "pause" })
    else
      startTimer(socket)
    end
  end

  def cancelTimer(socket) do
    if (socket.private[:timer]) do
      :timer.cancel(socket.private.timer)

      %{socket | private: Map.delete(socket.private, :timer)}
    else
      socket
    end
  end
end
