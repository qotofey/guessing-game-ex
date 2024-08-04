defmodule GuessingGame.Server do
  use GenServer

  def init({max_number}) do
    secret_number = 1..max_number |> Enum.random()
    state = {0, secret_number, max_number}
    {:ok, state}
  end

  def handle_call(:state, _, {attempts, secret_number, max_number}) do
    {:reply, {attempts, secret_number, max_number}, {attempts, secret_number, max_number}}
  end

  def handle_call({:guess, _}, _, {attempts, secret_number, max_number}) when attempts > 8 do
    new_state = {attempts + 1, secret_number, max_number}

    {:reply, new_state |> Tuple.append(:lose), new_state}
  end

  def handle_call({:guess, estimated_number}, _, {attempts, secret_number, max_number}) when estimated_number == secret_number do
    new_state = {attempts + 1, secret_number, max_number}

    {:reply, new_state |> Tuple.append(:win), new_state}
  end

  def handle_call({:guess, estimated_number}, _, {attempts, secret_number, max_number}) when estimated_number < secret_number do
    state = {attempts + 1, secret_number, max_number}

    {:reply, state |> Tuple.append(:less), state}
  end

  def handle_call({:guess, estimated_number}, _, {attempts, secret_number, max_number}) when estimated_number > secret_number do
    state = {attempts + 1, secret_number, max_number}

    {:reply, state |> Tuple.append(:more), state}
  end

  def terminate(_reason, _state) do
    IO.puts "!"
  end
end
