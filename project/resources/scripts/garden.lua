carrots = 5

local game_over = false

function start()
    entity.physics_box.on_collision_start = function (body1, body2)
        if carrots > 0 then
            local carrot = entity:find_child("carrot" .. tostring(math.tointeger(carrots)))
            carrot.scripts.carrot.follow(body2)
            carrots = carrots - 1
            entity.audio:play()
        end
        if carrots == 0 and not game_over then
            juice.info("Game Over!")
            game_over = true
            find_entity("timer").scripts.timer.stop()
            find_entity("result_ui").scripts.result_ui.show_ui(false)
        end
    end
end