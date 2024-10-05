can_capture = false

function start()
    entity.physics_circle.on_collision_start = function (body1, body2)
        if can_capture then
            body2.parent.scripts.bunny.capture()
        end
    end
end

function show()
    can_capture = true
    juice.routine.create(function()
        juice.routine.wait_seconds_func(0.25, function(x)
            entity.sprite.color.a = 1.0 - x
        end)
        can_capture = false
    end)
end