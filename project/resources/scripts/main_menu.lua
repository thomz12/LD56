function start()
    find_entity("play_button").scripts.button.on_click = function()
        load_scene("scenes/game.jbscene")
    end
end