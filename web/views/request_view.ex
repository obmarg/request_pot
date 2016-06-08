defmodule RequestPot.RequestView do
  use RequestPot.Web, :view

  def render("index.json", %{requests: requests}) do
    render_many(requests, RequestPot.RequestView, "request.json")
  end

  def render("show.json", %{request: request}) do
    render_one(request, RequestPot.RequestView, "request.json")
  end

  def render("request.json", %{request: request}) do
    %{method: request.method,
      content_type: request.content_type,
      headers: request.headers,
      path: request.path,
      query_string: request.query_string,
      id: request.id,
      form_data: request.form_data,
      json_data: request.json_data,
      body: request.body,
      remote_addr: request.remote_addr,
      time: request.time}
  end
end
