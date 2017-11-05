defmodule TicTacToe.Game do
    @moduledoc """
    Game State is held in a GenServer.
    Current implimentation just holds one game in state.
    :new_game call will wipe the current game state to start a new game
    :move is the call by a player to do their move
    :computer_move is the computer deciding where to move 
    """

    use GenServer

    def start_link() do
        GenServer.start_link(__MODULE__, [], [name: __MODULE__])
    end

    def new_game() do
        GenServer.call(__MODULE__, :new_game) 
    end

    def move(game_id, xpos, ypos, type) do
        case GenServer.call(__MODULE__, {:move, game_id, xpos, ypos, type}) do
            {:ok, state} ->
                {:ok, state}
            {:error, reason, state} ->
                {:error, reason, state}
        end
    end
    
    def computer_move(game_id) do
        GenServer.call(__MODULE__, {:computer_move, game_id})
    end

    def init(_) do
        state = %{}
        {:ok, state}
    end

    def handle_call(:new_game, _from, state) do
        game_id = rand_id()
        state = %{:game_id => game_id, :board => TicTacToe.Board.new()}
        {:reply, state, state}
    end

    def handle_call({:move, game_id, xpos, ypos, type}, _from, state = %{board: board, game_id: game_id}) do
        case TicTacToe.Board.move(board, xpos, ypos, type) do
            {:ok, %{result: result, board: board}} ->
                state = Map.put(state, :board, board)
                |> Map.put(:result, result)
                {:reply, {:ok, state}, state}
            {:ok, board} ->
                state = Map.put(state, :board, board)
                {:reply, {:ok, state}, state}
            {:error, reason} ->
                {:reply, {:error, reason, state}, state}
        end
    end

    def handle_call({:computer_move, game_id}, _from, state = %{board: board, game_id: game_id}) do
        case TicTacToe.Board.computer_move(board, "X") do
            {:ok, %{result: result, board: board}} ->
                state = Map.put(state, :board, board)
                |> Map.put(:result, result)
                {:reply, {:ok, state}, state}
            {:ok, board} ->
                state = Map.put(state, :board, board)
                {:reply, {:ok, state}, state}
        end
    end

    defp rand_id() do
        1
    end

end