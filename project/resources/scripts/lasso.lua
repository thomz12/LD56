local is_drawing = false

local line_begin = {}
local can_complete = false
line_connect_threshold = 16.0
max_radius = 256.0

on_circle_complete = function() end

local last_segments = 0

function update(delta_time)
    -- Check for start of drawing.
    if not is_drawing then
        if juice.input.is_key_pressed("mouse_left") then
            start_drawing()
        end
    end

    -- If already drawing.
    if is_drawing then
        if juice.input.is_key_released("mouse_left") then
            end_drawing()
        end
        local pos = get_mouse_pos()
        entity.transform.position = juice.vec3.new(pos.x, pos.y, entity.transform.position.z)

        if #entity.line.points > last_segments then
            last_segments = #entity.line.points
            segment_added(last_segments)
        end

        validate_line()

        -- Calculate distance from begin point.
        local direction = juice.vec2.new(line_begin.x - pos.x, line_begin.y - pos.y)
        local distance = math.sqrt(direction.x * direction.x + direction.y * direction.y)

        -- Check distance to threshold.
        if distance < line_connect_threshold then
            if can_complete then
                -- Cirlce completed!
                complete_circle()

                -- Instantly start redrawing circle.
                start_drawing()
            end
        else
            -- Cirlces can only be completed after moving from starting position.
            if not can_complete then
                can_complete = true
            end
        end
    end
end

---Get current mouse pos.
function get_mouse_pos()
    return find_entity("camera").camera:screen_to_world(juice.input.get_mouse_position())
end

---Completed a valid circle.
function complete_circle()
    
    local average = juice.vec2.new()

    for index = 1, #entity.line.points do
        average.x = average.x + entity.line.points[index].position.x
        average.y = average.y + entity.line.points[index].position.y
    end

    average.x = average.x / #entity.line.points
    average.y = average.y / #entity.line.points

    local radius = max_radius

    for index = 1, #entity.line.points do
        local distance = juice.vec2.new(average.x - entity.line.points[index].position.x, average.y - entity.line.points[index].position.y):length()
        if distance < radius then
            radius = distance
        end
    end

    -- Assign values to circle entity.
    local circle_entity = entity:find_child("lasso_circle")
    circle_entity.transform.position = juice.vec3.new(average.x, average.y, 0)
    circle_entity.physics_circle.radius = radius
    circle_entity.transform.scale = juice.vec2.new(radius / 512 * 2, radius / 512 * 2)

    on_circle_complete()
end

function segment_added(number)
    local segment = create_entity("segment" .. tostring(number))
    segment:set_parent(entity:find_child("segment_holder"))
    segment:add_component("transform")
    
    local point1 = entity.line.points[number - 1].position
    local point2 = entity.line.points[number].position

    local average = juice.vec2.new((point1.x + point2.x) / 2, (point1.y + point2.y) / 2)
    local direction = juice.vec2.new(point1.x - point2.x, point1.y - point2.y)
    local length = direction:length()
    
    segment.transform.position = juice.vec3.new(average.x, average.y, entity.transform.position.z)
    segment.transform.rotation = math.atan(direction.y, direction.x) * (180 / math.pi)

    segment:add_component("physics_box")
    segment.physics_box.size = juice.vec2.new(length, 4)
    segment.physics_box.category_bits = 4
    segment.physics_box.is_sensor = true
end

function validate_line()
    -- todo: validate a line
end

function line_blocked()
    juice.info("line got blocked!")
end

---Start drawing the line.
function start_drawing()
    clear_line()
    line_begin = get_mouse_pos()
    is_drawing = true
    can_complete = false
    last_segments = 1

    local segment_holder = create_entity("segment_holder")
    segment_holder:set_parent(entity:find_child("lasso_hitbox"))
end

---Finish drawing the line.
function end_drawing()
    clear_line()
    is_drawing = false
end

---Clear the line.
function clear_line()
    entity.line.points:clear()

    local segments = entity:find_child("segment_holder")
    if segments ~= nil then
        destroy_entity(entity:find_child("segment_holder"))
    end
end