function update(delta_time)
    entity.transform.rotation = (entity.transform.rotation + delta_time * 90) % 360
    entity:find_child("hand_location").transform.rotation = -entity.transform.rotation
end