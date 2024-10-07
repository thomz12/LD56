local time = 0

function update(delta_time)
    time = time + delta_time
    entity.ui_element.rotation = math.sin(time * math.pi) * 15
end