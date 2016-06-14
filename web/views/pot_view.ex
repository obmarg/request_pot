defmodule RequestPot.PotView do
  use RequestPot.Web, :view

  def render("show.json", %{pot: pot}) do
    render_one(pot, RequestPot.PotView, "pot.json")
  end

  def render("pot.json", %{pot: pot}) do
    %{name: pot.name,
      private: pot.private,
      request_count: pot.request_count,
      url: pot.url}
  end
end
