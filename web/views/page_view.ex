defmodule TicTacToe.PageView do
  use TicTacToe.Web, :view

  def get_square(board, xpos, ypos) do
    board
    |> Map.get(ypos)
    |> Map.get(xpos)
    |> case do
      :empty ->
        ""
      type ->
        type
    end
  end
end
