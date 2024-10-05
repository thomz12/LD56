local hats = {
    [1] = {
        offset = juice.vec2.new(80, 224) -- cowboy
    },
    [2] = {
        offset = juice.vec2.new(80, 208) -- viking
    },
    [3] = {
        offset = juice.vec2.new(80, 160) -- top hat
    },
    [4] = {
        offset = juice.vec2.new(80, 240) -- fez
    },
}

local hat = {}

function start()
    hat = hats[math.random(#hats)]
    juice.routine.create(function()
         entity.sprite.origin = hat.offset
    end)
end

function lose_hat()
    local world = entity.transform.world_position
    entity.transform.type = 2
    entity.transform.position = world

    juice.routine.create(function()
        local pos = juice.vec2.new(entity.transform.position.x, entity.transform.position.y)
        local rot = entity.transform.rotation
        local dir =  math.random(-128, 128)
        juice.routine.wait_seconds_func(2.0, function(x)
            entity.transform.position = juice.vec3.new(
                pos.x + x * dir,
                pos.y - juice.ease.in_back(x) * 256,
                entity.transform.position.z
            )
            entity.transform.rotation = rot + x * 360 * 5
        end)
        destroy_entity(entity)
    end)
end