defmodule NL2026OTPDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :nl2026_otp_demo,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: []
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {NL2026OTPDemo.Application, []}
    ]
  end
end
