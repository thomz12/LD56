local timer_duration = 120
local started = false
local hovered = false

function start_timer(duration)
    timer_duration = duration
    started = true
end

function start()
    entity.ui_element.on_mouse_enter = function()
        hovered = true
    end
    entity.ui_element.on_mouse_exit = function()
        hovered = false
    end
end

function damp(start, target, smoothing, delta)
    return juice.math.lerp(start, target, 1 - smoothing ^ delta)
end

function stop()
    started = false
end

function update(delta_time)
    if started then
        timer_duration = timer_duration - delta_time
        if timer_duration < 0 then
            timer_duration = 0
            started = false
            find_entity("result_ui").scripts.result_ui.show_ui(true)
        end
        local minutes = math.floor((timer_duration % 3600) / 60)
        local seconds = math.floor((timer_duration % 60))
        local text = string.format("%02d:%02d", minutes, seconds)
        entity:find_child("timer_text_shadow").ui_text.text = text 
        entity:find_child("timer_text").ui_text.text = text
    end

    local element = entity:find_child("timer_background").ui_element
    if hovered then
        element.offset.y = damp(element.offset.y, 30, 0.00005, delta_time)
    else
        element.offset.y = damp(element.offset.y, 0, 0.00005, delta_time)
    end
end
