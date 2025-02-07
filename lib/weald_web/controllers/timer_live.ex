defmodule WealdWeb.TimerLive do
  use WealdWeb, :live_view

  alias Weald.Pomodori
  alias Weald.Pomodori.Pomodoro


  def mount(_params, _session, socket) do
    results = Pomodori.list_incomplete()
    pomodoro = List.first(results, %Pomodoro{})

    pomodoro = update_remaining(pomodoro)
    socket = socket |> resetClock(pomodoro)

    if (pomodoro.running) do
      if (pomodoro.remaining > 0) do
        {:ok, socket |> startTimer()}
      else
        {:ok, socket |> finishTimer()}
      end
    else
      {:ok, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="text-lg">
      <.link
        phx-click={WealdWeb.CoreComponents.show_modal("timer-modal")}
      >
        <div :if={@pomodoro.id == nil}>
          New Pomodoro
        </div>
        <div :if={@pomodoro.id}
          class={["time",
                  @pomodoro.stage,
                  !@pomodoro.running && "animate-pulse"
                ]}
        >
          <div class="text-2xl tabular-nums">
            <%= @text %>
          </div>
        </div>
      </.link>

      <.modal id="timer-modal">
        <div class={["time large", @pomodoro.stage, "text-6xl sm:text-9xl text-right tabular-nums"]} phx-click={@action}>
          <%= @text %>
        </div>
        <div class="text-right">
          <button id="pomodoro-button" phx-click={@action} phx-hook="Countdown" class="text-2xl"><%= @prompt %></button>
        </div>
      </.modal>
    </div>
    """
  end

  def handle_event("start", _params, socket) do
    {:noreply, startTimer(socket)}
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

    pomodoro = socket.assigns.pomodoro
    due = DateTime.add(DateTime.utc_now(), pomodoro.remaining)

    %{socket | private: Map.put(socket.private, :timer, timer)}
      |> save_pomodoro(%{running: true, due_at: due})
  end

  def finishTimer(socket) do
    finishTimer(socket, socket.assigns.pomodoro.stage)
  end

  def finishTimer(socket, :pomodoro) do
    cancelTimer(socket)
      |> setTime(5 * 60)
      |> save_pomodoro(%{ stage: :break, running: false, remaining: 5 * 60})
      |> push_event("timer-end", %{message: "Time for a break."})
  end

  def finishTimer(socket, :break) do
    cancelTimer(socket)
      |> save_pomodoro(%{ stage: :done, running: false, remaining: 0, finished_at: DateTime.utc_now()})
      |> resetClock()
      |> push_event("timer-end", %{message: "Break time is over."})
  end

  def resetClock(socket, pomodoro \\ %Pomodoro{}) do
    socket
      |> assign(:pomodoro, pomodoro)
      |> setTime(pomodoro.remaining)
      |> setPrompts
  end

  def pauseResume(socket) do
    if (socket.private[:timer]) do
      socket
        |> save_pomodoro(%{ running: false, remaining: socket.assigns.seconds })
        |> cancelTimer()
    else
      socket
        |> startTimer()
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

  defp setPrompts(socket) do
    pomodoro = socket.assigns.pomodoro

    attrs =
      cond do
        (pomodoro.running) -> %{ prompt: "Pause", action: "pause"}
        (pomodoro.due_at) ->  %{ prompt: "Resume", action: "pause" }
        (pomodoro.stage == :break) -> %{ prompt: "Start Break", action: "start"}
        true -> %{ prompt: "Start Pomodoro", action: "start"}
      end

    socket |> assign(attrs)
  end

#  Update fields in a pomodoro found in the database
  defp update_remaining(pomodoro) do
    if (pomodoro.running) do
      remaining = max(0, DateTime.diff(pomodoro.due_at, DateTime.utc_now()))

      Map.put(pomodoro, :remaining, remaining)
    else
      pomodoro
    end
  end

  defp save_pomodoro(socket, attrs) do
    pomodoro = socket.assigns.pomodoro

    results =
    if (pomodoro.id == nil) do
      Pomodori.create_pomodoro(attrs)
    else
      Pomodori.update_pomodoro(pomodoro, attrs)
    end

    {_ok, updated} = results

    socket
      |> assign(pomodoro: updated)
      |> setPrompts()
  end
end
