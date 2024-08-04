defmodule GuessingGame do
  def run(max_number \\ 128) do
    GuessingGame.Client.play(max_number)
  end
end
