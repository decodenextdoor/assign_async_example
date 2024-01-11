defmodule AssignAsyncExampleWeb.RandomNumberLiveThree do
  use AssignAsyncExampleWeb, :live_view

  alias Phoenix.LiveView.AsyncResult
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign_async(socket, :number, fn -> {:ok, %{number: really_complicated_function()}} end)}
  end

  @impl true
  def handle_event("generate_number", _, socket) do
    {:noreply,
     socket
     |> assign(:number, AsyncResult.loading())
     |> start_async(:get_random_number, fn -> really_complicated_function() end)}
  end

  def handle_async(:get_random_number, {:ok, res}, socket) do
    %{number: number} = socket.assigns
    {:noreply, assign(socket, :number, AsyncResult.ok(number, res))}
  end

  def handle_async(:get_random_number, {:exit, _reason}, socket) do
    %{number: number} = socket.assigns

    {:noreply,
     assign(socket, :number, AsyncResult.failed(number, "Failed to generate a number."))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center h-screen bg-gradient-to-r from-blue-500 to-purple-600">
      <div class="text-center bg-white shadow-lg rounded-lg p-10">
        <h1 class="text-4xl font-bold text-gray-800 mb-5">Random Number Generator</h1>
        <!-- Display Area -->
        <.async_result :let={number} assign={@number}>
          <:loading>
            <div
              class="spinner-border animate-spin inline-block w-8 h-8 border-4 rounded-full text-blue-700"
              role="status"
            >
              <span class="visually-hidden">Loading...</span>
            </div>
          </:loading>
          <:failed :let={_reason}>
            <div class="mt-5 text-red-500">
              Failed to generate a number.
            </div>
          </:failed>

        <div  class="text-6xl font-bold text-green-600 mb-5">
          <%= number %>
        </div>
          <button
            phx-click="generate_number"
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-300 ease-in-out transform hover:scale-105"
          >
            Generate Random Number
          </button>
        </.async_result>
      </div>
    </div>
    """
  end

  def really_complicated_function() do
    # Simulate a really complicated function, takes a long time to run and will fail sometimes
    :timer.sleep(1000)

    if Enum.random(1..10) > 5 do
      :error
    else
      Enum.random(1..100)
    end
  end
end
