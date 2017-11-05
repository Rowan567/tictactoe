defmodule TicTacToe.Board do
    
    @moduledoc """
    Board 
    functions inside are to create a new empty board, move player
    and move computer functions.
    """

    @doc """
    Create a new empty board.
    Integers are as strings to they can be returned to the client as json
    """
    def new() do
        %{
            "0" => 
                %{"0" => :empty, "1" => :empty,  "2" => :empty},
            "1" => 
                %{"0" => :empty, "1" => :empty,  "2" => :empty},
            "2" => 
                %{"0" => :empty, "1" => :empty,  "2" => :empty}
        }
    end

    @doc """
    move functiont to place either an X or an O on the board.
    Can fail if the position is taken
    """
    def move(board, xpos, ypos, type) do
        case set_value(board, xpos, ypos, type) do
            {:ok, board} ->
                check_board_state(board)
            :error ->
                {:error, "Position full"}
        end
    end

    @doc """
    Computer move currently just decides a random position and tries to move there.
    """
    def computer_move(board, type) do

        # If no positions just picka a random move
        xpos = Enum.random(["0","1","2"])
        ypos = Enum.random(["0","1","2"])
        case move(board, xpos, ypos, type) do
            {:ok, board} ->
                {:ok, board}
            {:error, _} ->
                # If the random move fails just try another random move
                # This will only happen when there is one piece on the board
                # so not much impact
                computer_move(board, type)
        end
    end

    # Checks if the computer has any current positions on the board
    # defp positions_of(board, type) do
    #     Map.to_list(board)
    #     |> Enum.any?(
    #         fn({_, row}) ->
    #             Map.to_list(row)
    #             |> Enum.any?(
    #                 fn({_, cell}) ->
    #                     cell == type
    #                 end)              
    #         end)
    # end

    # Pricate function to set the value in the board map
    defp set_value(board, xpos, ypos, value) do
        
        row = Map.get(board, ypos)
        case Map.get(row, xpos) do
            :empty ->
                row = Map.put(row, xpos, value)
                {:ok, Map.put(board, ypos, row)}
            _ ->
                :error
        end
    end

    # This function will check if the game has been won or lost 
    defp check_board_state(board) do
        case result(board) do
            {:ok, :no_result} ->
                {:ok, board}
            {:ok, result} ->
                {:ok, %{board: board, result: result}}
        end
    end

    # WIll check if the current state of the board is finished 
    defp result(board) do
        case is_winner(board) do
            {true, type} ->
                {:ok, type <> " Winner"}
            false ->
                case is_draw(board) do
                   true ->
                        {:ok, "Draw"}
                    false ->
                        {:ok, :no_result}
                end
        end
    end

    # private function checks all the ways the game can be won
    # and returns the type which one
    defp is_winner(%{"0" => row1, "1" => row2, "2" => row3}) do
        %{"0" => cell00, "1" => cell01, "2" => cell02} = row1
        %{"0" => cell10, "1" => cell11, "2" => cell12} = row2
        %{"0" => cell20, "1" => cell21, "2" => cell22} = row3

        cond do
            cell00 == cell10 and cell00 == cell20 and cell00 != :empty ->
                {true, cell00}
            cell01 == cell11 and cell01 == cell21 and cell01 != :empty ->
                {true, cell01}
            cell02 == cell12 and cell02 == cell22 and cell02 != :empty ->
                {true, cell02}
            cell00 == cell01 and cell00 == cell02 and cell00 != :empty ->
                {true, cell00}
            cell10 == cell11 and cell10 == cell12 and cell10 != :empty ->
                {true, cell10}
            cell20 == cell21 and cell20 == cell22 and cell20 != :empty ->
                {true, cell20}
            cell00 == cell11 and cell00 == cell22 and cell00 != :empty ->
                {true, cell00}
            cell02 == cell11 and cell02 == cell20 and cell02 != :empty ->
                {true, cell02}
            true ->
                false
        end
    end

    # Is draw function loops through all the "cells" to check if 
    # they are all non empty
    defp is_draw(board) do
        Map.to_list(board)
        |> Enum.all?(
            fn({_, row}) ->
                Map.to_list(row)
                |> Enum.all?(
                    fn({_, cell}) ->
                        cell != :empty
                    end)              
            end)
    end
end