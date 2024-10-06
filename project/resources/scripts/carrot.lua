local start_y
local time = 0

local bunny = nil

function start()
    start_y = entity.transform.position.y

    juice.routine.create(function()
        while not bunny do
            entity.sprite.origin.x = 96
            juice.routine.wait_seconds(5)
            for i = 1, 6 do
                entity.sprite.origin.x = 96 + 16 * i
                juice.routine.wait_seconds(0.05)
            end
        end
        entity.sprite.origin.x = 96
    end)
end

function damp(start, target, smoothing, delta)
    return juice.math.lerp(start, target, 1 - smoothing ^ delta)
end

function follow(target)
    bunny = target
end

function update(delta_time)
    time = time + delta_time

    if bunny ~= nil then
        if bunny.transform ~= nil then
            entity.transform.position = juice.vec3.new(
                damp(entity.transform.position.x, bunny.transform.position.x, 0.5, delta_time),
                damp(entity.transform.position.y, bunny.transform.position.y, 0.5, delta_time),
                entity.transform.position.z
            )
        else
            bunny = nil
        end
    else
        entity.transform.position = juice.vec3.new(
            entity.transform.position.x,
            start_y + math.sin(time * math.pi) * 4,
            entity.transform.position.z)
    end
end