local start_y = 0
local time = 0
local text_duration = 1

local started = false

function start()
    juice.routine.create(function()
        --start_y = entity.transform.position.y
    end)
end

function setup_text(text, duration, color)
    local top_text = entity:find_child("top_text")
    
    entity.ui_text.text = text
    top_text.ui_text.text = text
    top_text.ui_text.color = color

    text_duration = duration
end

function update(delta_time)
    time = time + delta_time

    if not started then
        start_y = entity.transform.position.y
        started = true
    end

    entity.transform.position = juice.vec3.new(
        math.floor(entity.transform.position.x),
        math.floor(start_y + time * 16),
        math.floor(entity.transform.position.z)
    )

    if time > text_duration then
        destroy_entity(entity)
    end
end