local time = 0

local bunny_data = {
    [1] = {
        hop_distance = 8.0,
        hop_height = 8.0,
        hop_duration = 0.5,
        hop_wait_min = 1.0,
        hop_wait_max = 2.5,
        sprite_row = 1,
    },
    [2] = {
        hop_distance = 8.0,
        hop_height = 16.0,
        hop_duration = 0.5,
        hop_wait_min = 1.0,
        hop_wait_max = 2.0,
        sprite_row = 3,
    },
    [3] = {
        hop_distance = 16.0,
        hop_height = 16.0,
        hop_duration = 0.5,
        hop_wait_min = 1.0,
        hop_wait_max = 2.0,
        sprite_row = 10,
    },
    [4] = {
        hop_distance = 32.0,
        hop_height = 8.0,
        hop_duration = 0.5,
        hop_wait_min = 2.0,
        hop_wait_max = 4.0,
        sprite_row = 2,
    },
}

local bunny = {}
local captured = false

function start()

    bunny = bunny_data[math.random(#bunny_data)]

    juice.routine.create(function()
        entity.sprite.origin = juice.vec2.new(0, 256 - (16 * bunny.sprite_row))
        while true do
            local start_pos = juice.vec2.new(entity.transform.position.x, entity.transform.position.y)
            juice.routine.wait_seconds_func(bunny.hop_duration, function(x)
                entity.transform.position = juice.vec3.new(
                start_pos.x + bunny.hop_distance * x,
                start_pos.y + bunny.hop_height * math.sin(x * math.pi), 0
                )
                if (x < 0.5) then
                    entity.sprite.origin.x = 16
                else
                    entity.sprite.origin.x = 32
                end
            end)
            entity.sprite.origin.x = 0
            juice.routine.wait_seconds(math.random() * bunny.hop_wait_max - bunny.hop_wait_min)
        end
    end)
end

--Call to capture the bunny.
function capture()
    captured = true
end

function update()
    
end