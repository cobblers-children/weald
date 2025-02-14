defmodule WealdWeb.Router do
  use WealdWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WealdWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WealdWeb do
    pipe_through :browser

    live "/", HomeLive, :index

    live "/pomodoro", PomodoroLive.Index, :index
    live "/pomodoro/:id/edit", PomodoroLive.Index, :edit

    live "/pomodoro/:id", PomodoroLive.Show, :show
    live "/pomodoro/:id/show/edit", PomodoroLive.Show, :edit

    live "/pomodoro/timer", TimerLive, :index

    live "/tasks", TaskLive.Index, :index
    live "/tasks/new", TaskLive.Index, :new
    live "/tasks/:id/edit", TaskLive.Index, :edit
    live "/tasks/:id/delete", TaskLive.Index, :delete

    live "/tasks/:id", TaskLive.Show, :show
    live "/tasks/:id/show/edit", TaskLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", WealdWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:weald, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WealdWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
