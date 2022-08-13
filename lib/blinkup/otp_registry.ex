defmodule Blinkup.OTPRegistry do
  use GenServer 

  def start_link(default \\ []) do
    GenServer.start(__MODULE__, default, name: __MODULE__)
  end

  def set(key, value) do
    GenServer.cast(__MODULE__, {:set, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def remove(key) do
    GenServer.cast(__MODULE__, {:remove, key})
  end

  # GenServer hooks

  def init(args) do
    {:ok, Enum.into(args, %{})}
  end

  def handle_cast({:set, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_cast({:remove, key}, state) do
    {:noreply, Map.delete(state, key)}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

end
