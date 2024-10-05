local time = 0

function update(delta_time)
    time = time + delta_time

    entity.physics.velocity = juice.vec2.new(0.5, 0)
end