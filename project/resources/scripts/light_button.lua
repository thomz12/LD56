on_click = function() end

local enabled = true

function start()
    -- Mouse exit callback
    entity.ui_element.on_mouse_exit = function ()
        if not enabled then
            return
        end
        entity.ui_9_slice.image = juice.resources:load_texture("sprites/ui_button_lightest.png")
    end

    -- Mouse stay callback (hovered)
    entity.ui_element.on_mouse_stay = function ()
        if not enabled then
            return
        end
        entity.ui_9_slice.image = juice.resources:load_texture("sprites/ui_button_light.png")
        if juice.input.is_key_held("mouse_left") then
            entity.ui_9_slice.image = juice.resources:load_texture("sprites/ui_button.png")
        end
        if juice.input.is_key_released("mouse_left") then
            entity.ui_9_slice.image = juice.resources:load_texture("sprites/ui_button_lightest.png")
            on_click()
        end
    end
end

function enable()
    entity.ui_9_slice.image = juice.resources:load_texture("sprites/ui_button_lightest.png")
    enabled = true
end

function disable()
    entity.ui_9_slice.image = juice.resources:load_texture("sprites/ui_button_disabled.png")
    enabled = false
end
