function start()
    juice.routine.create(function()
        -- Update the collider because of prefab bug...
        entity.physics_circle.radius = entity.physics_circle.radius
    end)
end