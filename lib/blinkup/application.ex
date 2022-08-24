defmodule Blinkup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Blinkup.Repo,
      # Start the Telemetry supervisor
      BlinkupWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Blinkup.PubSub},
      # Start the Endpoint (http/https)
      BlinkupWeb.Endpoint
      # Start a worker by calling: Blinkup.Worker.start_link(arg)
      # {Blinkup.Worker, arg},
    ] ++ Application.get_env(:blinkup, :children)

    hook_module = Application.get_env(:blinkup, :hooks)

    # Run preload hooks
    if hook_module && Kernel.function_exported?(hook_module, :pre_load, 0), do: hook_module.pre_load() 

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blinkup.Supervisor]
    startup_result =  Supervisor.start_link(children, opts)

    # Run post-load hooks
    if hook_module && Kernel.function_exported?(hook_module, :post_load, 0), do: hook_module.post_load() 

    startup_result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BlinkupWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
