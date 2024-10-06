local levels = {
    [1] = {
        allowed_bunnies = { 1, 2 },
        one_hat_chance = 0.1,
        two_hat_chance = 0.0,
        spawn_delay = 3.0,
    },
    [2] = {
        allowed_bunnies = { 1, 2, 3 },
        one_hat_chance = 0.2,
        two_hat_chance = 0.1,
        spawn_delay = 2.0
    },
    [3] = {
        allowed_bunnies = { 2, 3, 4, 5, 6 },
        one_hat_chance = 0.3,
        two_hat_chance = 0.2,
        spawn_delay = 2.0
    },
}

local spawning = true

function start_spawning()
    find_entity("timer").scripts.timer.start_timer(120)
    juice.routine.create(function()
        while spawning do
            local cur_level = levels[1]
            local bunny = spawn("prefabs/bunny.jbprefab")
            bunny.transform.position = juice.vec3.new(
                bunny.transform.position.x, 
                math.random() * 128 - 64,
                bunny.transform.position.z
            )
            bunny.scripts.bunny.bunny_number = cur_level.allowed_bunnies[math.random(#cur_level.allowed_bunnies)]

            local hats = 0

            if math.random() < cur_level.one_hat_chance then
                hats = 1
                if math.random() < cur_level.two_hat_chance then
                    hats = 2
                end
            end

            bunny.scripts.bunny.set_hats(hats)
            juice.routine.wait_seconds(cur_level.spawn_delay)
        end
    end)
end