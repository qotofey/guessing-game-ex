defmodule GuessingGame.Client do
  @server GuessingGame.Server

  def play(max_number) do
    # secret_number, max_number, attempt

    GenServer.start_link(@server, {max_number}, name: @server)

    "Угадай число!" |> IO.puts()

    {attempts, secret_number, max_number} = GenServer.call(@server, :state)

    "\nНомер попытки: #{attempts}, загаданное число: #{secret_number * 0}, максимальное число: #{max_number}"
    |> IO.puts()

    next_number()
  end

  defp next_number() do
    case GenServer.call(@server, {:guess, ask_number()}) do
      {attempts, _, _, :win} ->
        IO.puts("Вы победили! Осталось попыток: #{8 - attempts}")

      {_, secret_number, _, :lose} ->
        IO.puts("Вы проиграли! Загаданно число: #{secret_number}")

      {attempts, _, _, :more} ->
        IO.puts("Загаданное число меньше. Осталось попыток: #{8 - attempts}")
        next_number()

      {attempts, _, _, :less} ->
        IO.puts("Загаданное число больше. Осталось попыток: #{8 - attempts}")
        next_number()

      {:error} ->
        IO.puts("Error!")
    end
  end

  defp ask_number() do
    {number, _} =
      "\nПожалуйста, введите предполагаемое Вами число: \n"
      |> IO.gets()
      |> String.trim()
      |> Integer.parse()

    number
  end
end
