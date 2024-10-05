function start()
    if entity.physics_box ~= nil then
        entity.physics_box.on_collision_start = function(body1, body2)
            body2.parent.parent.parent.scripts.lasso.line_blocked()
        end
    end

    if entity.physics_circle ~= nil then
        entity.physics_circle.on_collision_start = function(body1, body2)
            body2.parent.parent.parent.scripts.lasso.line_blocked()
        end
    end
end