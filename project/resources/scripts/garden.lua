carrots = 5

function start()
    entity.physics_box.on_collision_start = function (body1, body2)
        if carrots > 0 then
            local carrot = entity:find_child("carrot" .. tostring(math.tointeger(carrots)))
            carrot.scripts.carrot.follow(body2)
            carrots = carrots - 1
        end
        if carrots == 0 then
            juice.info("Game over!")
        end
    end
end