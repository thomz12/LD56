function start()
    entity.physics_box.on_collision_start = function(body1, body2)
        body2.parent.parent.parent.scripts.lasso.line_blocked()
    end
end