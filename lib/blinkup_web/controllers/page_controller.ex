defmodule BlinkupWeb.PageController do
  use BlinkupWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
