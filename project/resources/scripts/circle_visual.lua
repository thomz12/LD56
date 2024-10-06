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
        entity.sprite.color.a = 1
        juice.routine.wait_seconds(0.25)
        entity.sprite.color.a = 0
        can_capture = false
    end)
end