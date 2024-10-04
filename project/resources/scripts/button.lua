on_click = function() end

function start()
    -- Mouse exit callback
    entity.ui_element.on_mouse_exit = function ()
        entity.ui_panel.color = juice.color.new(1.0, 1.0, 1.0, 1.0)
    end

    -- Mouse stay callback (hovered)
    entity.ui_element.on_mouse_stay = function ()
        entity.ui_panel.color = juice.color.new(0.9, 0.9, 0.9, 1.0)
        if juice.input.is_key_released("mouse_left") then
            entity.ui_panel.color = juice.color.new(0.5, 0.5, 0.5, 1.0)
            on_click()
        end
    end
end