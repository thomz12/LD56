function start()
    find_entity("play_level_1_button").scripts.button.on_click = function()
        load_scene("scenes/game.jbscene")
        bunny_game.start_game(1)
    end
    find_entity("play_level_2_button").scripts.button.on_click = function()
        load_scene("scenes/game.jbscene")
        bunny_game.start_game(2)
    end
    find_entity("play_level_3_button").scripts.button.on_click = function()
        load_scene("scenes/game.jbscene")
        bunny_game.start_game(3)
    end
end