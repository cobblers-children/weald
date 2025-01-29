defmodule WealdWeb.TimerLive do
  use WealdWeb, :live_view

  alias Weald.Pomodori

  def mount(_params, _session, socket) do
    {:ok, socket
      |> resetClock()
    }
  end

  def render(assigns) do
    ~H"""
    <div class="text-lg">
      <.link
        phx-click={WealdWeb.CoreComponents.show_modal("timer-modal")}
      >
        <div :if={!@mini}>
          New Pomodoro
        </div>
        <div :if={@mini}
          class={["time",
                  @phase,
                  @paused && "animate-pulse"
                ]}
        >
          <div class="text-2xl tabular-nums">
            <%= @text %>
          </div>
        </div>
      </.link>

      <.modal id="timer-modal">
        <div class={["time", @phase, "text-6xl sm:text-9xl text-right tabular-nums"]} phx-click={@action}>
          <%= @text %>
        </div>
        <div class="text-right">
          <button id="pomodoro" phx-click={@action} phx-hook="Countdown" class="text-2xl"><%= @prompt %></button>
        </div>
      </.modal>
    </div>
    """
  end

  def handle_event("start", _params, socket) do
    if (!Map.has_key?(socket.assigns, "pomodoro")) do
      remaining = socket.assigns.seconds

      data = %{
        remaining: remaining,
        due_at: DateTime.add(DateTime.utc_now(), remaining)
      }

      case Pomodori.create_pomodoro(data) do
        {:ok, pomodoro} ->
          {:noreply, socket
                     |> assign(:pomodoro, pomodoro)
                     |> startTimer()}

        {:error, %Ecto.Changeset{} = changeset} ->
          IO.inspect(changeset)
          {:noreply, socket}
      end
    else
#      TODO: calculate unpause time
      {:noreply, startTimer(socket)}
    end
  end

  def handle_event("pause", _params, socket) do
    {:noreply, pauseResume(socket)}
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
      |> assign(%{ prompt: "Pause", action: "pause", mini: true, paused: false })
  end

  def finishTimer(socket) do
    if (socket.assigns.phase == "pomodoro") do
      cancelTimer(socket)
        |> assign(%{ prompt: "Start Break", action: "start", phase: "break" })
        |> setTime(5 * 60)
        |> push_event("timer-end", %{message: "Time for a break."})
    else
      cancelTimer(socket)
        |> resetClock()
        |> push_event("timer-end", %{message: "Break time is over."})
    end

  end

  def resetClock(socket) do
    socket
      |> assign(%{ prompt: "Start Pomodoro", action: "start", phase: "pomodoro", mini: false})
      |> setTime(25 * 60)
  end

  def pauseResume(socket) do
    if (socket.private[:timer]) do
      socket
        |> cancelTimer()
        |> assign(%{ prompt: "Resume", action: "pause", paused: true })
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
