defmodule WealdWeb.TaskLive.FormComponent do
  use WealdWeb, :live_component

  alias Weald.Tasks

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage task records in your database.</:subtitle>
      </.header>

      <.simple_form
        :if={@action in [:new, :edit]}
        for={@form}
        id="task-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:description]} type="text" label="Description" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(Weald.Tasks.Task, :status)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Task</.button>
        </:actions>
      </.simple_form>

      <.simple_form
        :if={@action in [:delete]}
        for={@form}
        id="task-form"
        phx-target={@myself}
        phx-value-id={@myself}
        phx-submit="delete"
      >
        <.input field={@form[:description]} type="text" label="Description" disabled/>
        <.input
          field={@form[:status]}
          disabled
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(Weald.Tasks.Task, :status)}
        />
        <:actions>
          <.button phx-disable-with="Deleting...">Delete Task</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{task: task} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Tasks.change_task(task))
     end)}
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset = Tasks.change_task(socket.assigns.task, task_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.action, task_params)
  end

  def handle_event("delete", _params, socket) do
    save_task(socket, :delete)
  end

  defp save_task(socket, :edit, task_params) do
    case Tasks.update_task(socket.assigns.task, task_params) do
      {:ok, task} ->
        notify_parent({:saved, task})

        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_patch(to: socket.assigns.patch)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_task(socket, :new, task_params) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        notify_parent({:saved, task})

        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_task(socket, :delete) do
    case Tasks.delete_task(socket.assigns.task) do
      {:ok, task} ->
        notify_parent({:deleted, task})

        {:noreply,
          socket
          |> put_flash(:info, "Task deleted successfully")
          |> push_patch(to: socket.assigns.patch)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
  
  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
