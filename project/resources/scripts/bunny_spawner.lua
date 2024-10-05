spawning = true
spawn_delay = 2.0

function start()
    juice.routine.create(function()
        while spawning do
            local bunny = spawn("prefabs/bunny.jbprefab")
            bunny.transform.position = juice.vec3.new(
                bunny.transform.position.x, 
                math.random() * 128 - 64,
                bunny.transform.position.z
                )
            juice.routine.wait_seconds(spawn_delay)
        end
    end)
end