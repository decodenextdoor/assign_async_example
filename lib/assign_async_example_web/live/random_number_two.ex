defmodule AssignAsyncExampleWeb.RandomNumberLiveTwo do
  use AssignAsyncExampleWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Task.async(fn -> really_complicated_function() end)

    {:ok,
     assign(socket, number: :random)
     |> assign(loading: true)
     |> assign(error: false)}
  end

  @impl true
  def handle_info({ref, result}, socket) do
    case result do
      :error ->
        {:noreply,
         assign(socket, number: :error)
         |> assign(loading: false)
         |> assign(error: true)}

      number ->
        Process.demonitor(ref)

        {:noreply,
         assign(socket, number: number)
         |> assign(loading: false)
         |> assign(error: false)}
    end
  end

  def handle_info({:DOWN, ref, _process, _pid, _reason}, socket), do: {:noreply, socket}

  def handle_event("generate_number", _, socket) do
    Task.async(fn -> really_complicated_function() end)

    {:noreply,
     socket
     |> assign(loading: true)
     |> assign(error: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center h-screen bg-gradient-to-r from-blue-500 to-purple-600">
      <div class="text-center bg-white shadow-lg rounded-lg p-10">
        <h1 class="text-4xl font-bold text-gray-800 mb-5">Random Number Generator</h1>
        <!-- Display Area -->
        <div :if={@number && not @loading} class="text-6xl font-bold text-green-600 mb-5">
          <%= @number %>
        </div>
        <!-- Loading Animation -->
        <div :if={@loading} id="loadingAnimation" class="mt-5">
          <div
            class="spinner-border animate-spin inline-block w-8 h-8 border-4 rounded-full text-blue-700"
            role="status"
          >
            <span class="visually-hidden">Loading...</span>
          </div>
        </div>
        <!-- Error Message -->
        <div :if={@error} id="errorMessage" class="mt-5 text-red-500">
          Failed to generate a number.
        </div>
        <!-- Generate Button -->
        <button
          :if={not @loading}
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
    :timer.sleep(1000)

    if Enum.random(1..10) > 5 do
      :error
    else
      Enum.random(1..100)
    end
  end
end
