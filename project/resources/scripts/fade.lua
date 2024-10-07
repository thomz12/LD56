function start()
    entity.ui_panel.color.a = 1.0
    juice.routine.create(function()
        juice.routine.wait_seconds_func(1.0, function(x)
            entity.ui_panel.color.a = 1.0 - x
        end)
    end)
end

function fade_in(callback)
    juice.routine.create(function()
        entity.ui_element.input_type = 3
        juice.routine.wait_seconds_func(1.0, function(x)
            entity.ui_panel.color.a = x
        end)
        callback()
    end)
end