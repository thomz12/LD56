function start()
    entity.physics_box.on_collision_start = function (body1, body2)
        juice.info("Bunny reached garden!")
    end
end