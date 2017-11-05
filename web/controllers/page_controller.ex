defmodule TicTacToe.PageController do
    use TicTacToe.Web, :controller
        
    def index(conn, params) do
        new_game(conn, params)
    end

    @doc """
    New game handler. Loads a new empty board
    """
    def new_game(conn, _params) do
        %{game_id: game_id, board: board} = TicTacToe.Game.new_game()
        
        render conn, "index.html", game_id: game_id, board: board 
    end

    @doc """
    Move handler. input of game_id and xpos and ypos
    """
    def move(conn, %{"game_id" => game_id, "xpos" => xpos, "ypos" => ypos}) do
        game_id = String.to_integer(game_id)
        case TicTacToe.Game.move(game_id, xpos, ypos, "O") do
            {:ok, state = %{result: _}} ->
                json(conn, state)
            {:ok, state} ->
                computer_move(conn, state)
            {:error, reason, state} ->
                json(conn, Map.put(state, :error, reason))
        end
    end

    defp computer_move(conn, %{game_id: game_id}) do
        {:ok, game_state} = TicTacToe.Game.computer_move(game_id)
        json(conn, game_state)
    end
end
