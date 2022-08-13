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
      # {Blinkup.Worker, arg}
    ]


    IO.inspect Mix.env()

    ## Start the OTPRegistry if we are in test
    children = if Mix.env() in [:test] do
      children = children ++ [
        Blinkup.OTPRegistry
      ]
    else 
      children
    end


    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blinkup.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BlinkupWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
