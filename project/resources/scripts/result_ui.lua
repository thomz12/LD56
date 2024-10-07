function start()
    juice.routine.create(function()
        juice.routine.wait_seconds_func(1, function(x)
            entity.ui_panel.color.a = juice.math.lerp(1, 0, x)
            entity.ui_element.enabled = false
        end)
    end)
end

function show_ui(success)

    if success then
        juice.save_string("max_reached", tostring(bunny_game.get_current_difficulty() + 1))
    else
        entity:find_child("header_text").ui_text.text = "Game Over!"
    end

    find_entity("lasso").scripts.lasso.quit_drawing()

    local carrots = find_entity("garden").scripts.garden.carrots
    local penalty = 1.0 - (0.1 * (5 - carrots))

    juice.info("Penalty: " .. tostring(penalty))
    local final_score = math.floor(bunny_game.get_score() * penalty)

    if carrots == 5 then
        entity:find_child("final_score_text").ui_text.text = "Score: " .. final_score
        entity:find_child("bunnies_text").ui_text.text = "Bunnies Caught: " .. bunny_game.get_caught_bunnies()
    else
        entity:find_child("final_score_text").ui_text.text = "Score: " .. final_score
        entity:find_child("bunnies_text").ui_text.text = "Penalty: " .. math.floor(penalty * 100) .. "%"
    end
    entity:find_child("status_message").ui_text.text = "Uploading score..."

    local stats = {}
    stats["level_" .. tostring(math.tointeger(bunny_game.get_current_difficulty()))] = final_score
    stats["bunnies_caught"] = bunny_game.get_caught_bunnies()
    stats["bunnies_caught_max"] = bunny_game.get_caught_bunnies()

    bunny_game.set_return_from_level()

    if playfab.signed_in then
        playfab.update_player_statistics(stats, function(update_result, update_body)
            if update_result then
                entity:find_child("status_message").ui_text.text = "Uploaded score!"
            end
        end)
    else
        entity:find_child("status_message").ui_text.text = "Score upload failed"
    end

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