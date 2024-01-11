defmodule AssignAsyncExampleWeb.RandomNumberLive do
  use AssignAsyncExampleWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    number = really_complicated_function()

    {:ok, assign(socket, number: number)}
  end

  def handle_event("generate_number", _, socket) do
    number = really_complicated_function()

    {:noreply, assign(socket, number: number)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center h-screen bg-gradient-to-r from-blue-500 to-purple-600">
      <div class="text-center bg-white shadow-lg rounded-lg p-10">
        <h1 class="text-4xl font-bold text-gray-800 mb-5">Random Number Generator</h1>
        <!-- Display Area -->
        <div :if={@number } class="text-6xl font-bold text-green-600 mb-5">
          <%= @number %>
        </div>
        <!-- Generate Button -->
        <button
          phx-click="generate_number"
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-300 ease-in-out transform hover:scale-105"
        >
          Generate Random Number
        </button>
      </div>
    </div>
    """
  end

  def really_complicated_function() do
    # Simulate a really complicated function, takes a long time to run and will fail sometimes
    :timer.sleep(5000)

    if Enum.random(1..10) > 5 do
      :error
    else
      Enum.random(1..100)
    end
  end
end
