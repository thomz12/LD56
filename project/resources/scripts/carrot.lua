local start_y
local time = 0

function start()
    start_y = entity.transform.position.y
end

function update(delta_time)
    time = time + delta_time
    entity.transform.position = juice.vec3.new(
        entity.transform.position.x,
        start_y + math.sin(time * math.pi) * 4,
        entity.transform.position.z)
end