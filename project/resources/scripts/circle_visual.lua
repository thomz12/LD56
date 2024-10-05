can_capture = false

function show()
    can_capture = true
    juice.routine.create(function()
        juice.routine.wait_seconds_func(0.25, function(x)
            entity.sprite.color.a = 1.0 - x
        end)
        can_capture = false
    end)
end