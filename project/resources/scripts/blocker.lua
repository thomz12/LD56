function start()
    if entity.physics_box ~= nil then
        entity.physics_box.on_collision_start = function(body1, body2)
            if string.find(body2.name, "segment") then
                body2.parent.parent.parent.scripts.lasso.line_blocked()
            end
        end
    end

    if entity.physics_circle ~= nil then
        entity.physics_circle.on_collision_start = function(body1, body2)
            if string.find(body2.name, "segment") then
                body2.parent.parent.parent.scripts.lasso.line_blocked()
            end
        end
    end
end