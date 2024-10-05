function show()
    juice.routine.create(function()
        juice.routine.wait_seconds_func(0.25, function(x)
            entity.sprite.color.a = 1.0 - x
        end)
    end)
end