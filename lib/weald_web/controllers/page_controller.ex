defmodule WealdWeb.PageController do
  use WealdWeb, :controller

  def home(conn, params) do
    render(conn, :home, params)
  end
end
