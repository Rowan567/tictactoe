// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

$(document).ready(function() {

    $(".square").click(function() {
        var position = $(this).attr('position')
        var xpos = position.substring(0,1)
        var ypos = position.substring(2,3)
        var game_id = $("#board").attr('game_id')
        $.post("/move", 
                {
                    xpos: xpos,
                    ypos: ypos,
                    game_id: game_id
                },
                function(data, status) {
                    set_squares(data.board)
                    if (data.result) {
                        alert(data.result)
                    }
                    if (data.error) {
                        $("#err_msg").html(data.error).fadeIn(500)
                        $("#err_msg").html(data.error).fadeOut(500)
                    }
                })
    })

    function set_squares(board) {
        $.each(board, function(ypos, value) {
            $.each(value, function(xpos, type) {
                if (type != "empty") {
                    $(".square[position='" + xpos + "," + ypos + "']").html(type)
                }
            });
        });
    }
})