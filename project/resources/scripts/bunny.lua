local time = 0

local bunny_data = {
    [0] = {
        hop_distance = 8.0,
        hop_height = 8.0,
        hop_duration = 0.5,
        hop_wait_min = 1.0,
        hop_wait_max = 2.5,
    },
    [1] = {
        hop_distance = 8.0,
        hop_height = 16.0,
        hop_duration = 0.5,
        hop_wait_min = 1.0,
        hop_wait_max = 2.0,
    }
}

local bunny = {}

function start()

    bunny = bunny_data[math.random(0, #bunny_data)]

    juice.routine.create(function()
        while true do
            local start_pos = juice.vec2.new(entity.transform.position.x, entity.transform.position.y)
            juice.routine.wait_seconds_func(bunny.hop_duration, function(x)
                entity.transform.position = juice.vec3.new(
                start_pos.x + bunny.hop_distance * x,
                start_pos.y + bunny.hop_height * math.sin(x * math.pi), 0
            )
            end)
            juice.routine.wait_seconds(math.random() * bunny.hop_wait_max - bunny.hop_wait_min)
        end
    end)
end