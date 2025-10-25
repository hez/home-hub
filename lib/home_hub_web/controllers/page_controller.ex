defmodule HomeHubWeb.PageController do
  use HomeHubWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
