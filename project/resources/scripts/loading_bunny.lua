function update(delta_time)
    entity.ui_element.rotation = (entity.ui_element.rotation + delta_time * 360) % 360
end