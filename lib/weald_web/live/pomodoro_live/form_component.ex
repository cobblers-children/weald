defmodule WealdWeb.PomodoroLive.FormComponent do
  use WealdWeb, :live_component

  alias Weald.Pomodori

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="pomodoro-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:stage]}
          type="select"
          label="Stage"
          prompt="Choose a value"
          options={Ecto.Enum.values(Weald.Pomodori.Pomodoro, :stage)}
        />
        <.input field={@form[:running]} type="checkbox" label="Running" />
        <.input field={@form[:remaining]} type="number" label="Remaining" />
        <.input field={@form[:due_at]} type="datetime-local" label="Due at" />
        <.input field={@form[:finished_at]} type="datetime-local" label="Finished at" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Pomodoro</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"pomodoro" => pomodoro_params}, socket) do
    changeset = Pomodori.change_pomodoro(socket.assigns.pomodoro, pomodoro_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"pomodoro" => pomodoro_params}, socket) do
    save_pomodoro(socket, socket.assigns.action, pomodoro_params)
  end

  defp save_pomodoro(socket, :edit, pomodoro_params) do
    case Pomodori.update_pomodoro(socket.assigns.pomodoro, pomodoro_params) do
      {:ok, pomodoro} ->
        notify_parent({:saved, pomodoro})

        {:noreply,
         socket
         |> put_flash(:info, "Pomodoro updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_pomodoro(socket, :new, pomodoro_params) do
    case Pomodori.create_pomodoro(pomodoro_params) do
      {:ok, pomodoro} ->
        notify_parent({:saved, pomodoro})

        {:noreply,
         socket
         |> put_flash(:info, "Pomodoro created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
