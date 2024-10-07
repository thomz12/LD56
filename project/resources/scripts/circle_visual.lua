can_capture = false

local caught = 0
local multiplier = 1

function start()
    entity.physics_circle.on_collision_start = function (body1, body2)
        if can_capture then
            if not body2.parent.scripts.bunny.is_captured() then
                body2.parent.scripts.bunny.capture(multiplier)
                caught = caught + 1
            end
        end
    end
end

function show(new_multiplier)
    multiplier = new_multiplier
    can_capture = true
    caught = 0
    juice.routine.create(function()
        entity.sprite.color = juice.color.new(0, 0, 0, 1)
        juice.routine.wait_seconds(0.05)
        entity.sprite.color = juice.color.new(1, 1, 1, 1)
        juice.routine.wait_seconds(0.05)
        entity.sprite.color.a = 0
        can_capture = false

        if caught == 1 then
            entity.audio:play()
        end
    end)
end