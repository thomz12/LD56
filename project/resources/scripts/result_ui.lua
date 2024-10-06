function start()
    juice.routine.create(function()
        juice.routine.wait_seconds_func(1, function(x)
            entity.ui_panel.color.a = juice.math.lerp(1, 0, x)
            entity.ui_element.enabled = false
        end)
    end)
end

function show_ui()

    entity:find_child("final_score_text").ui_text.text = "Score: " .. bunny_game.get_score()
    entity:find_child("bunnies_text").ui_text.text = "Bunnies Caught: " .. bunny_game.get_caught_bunnies()
    entity:find_child("status_message").ui_text.text = "Uploading score..."

    juice.routine.create(function()
        entity.ui_element.enabled = true
        juice.routine.wait_seconds_func(1, function(x)
            entity.ui_panel.color.a = x * 0.5
            entity:find_child("game_over_screen_header").ui_element.offset.y = juice.math.lerp(160, 0, juice.ease.out_bounce(x))
        end)
        entity:find_child("button_accept").scripts.light_button.on_click = function()
            hide_ui()
        end
    end)
end

function hide_ui()
    juice.routine.create(function()
        entity.ui_element.enabled = true
        juice.routine.wait_seconds_func(1, function(x)
            entity.ui_panel.color.a = 0.5 + x * 0.5
            entity:find_child("game_over_screen_header").ui_element.offset.y = juice.math.lerp(0, 160, juice.ease.in_expo(x))
        end)
        load_scene("scenes/main.jbscene")
    end)
end