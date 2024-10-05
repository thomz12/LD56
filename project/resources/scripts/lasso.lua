local is_drawing = false

local line_begin = {}
local can_complete = false
local last_segments = 0

local got_blocked = false

line_connect_threshold = 16.0
max_radius = 256.0

circle_threshold = 0.6

on_circle_complete = function() end

function update(delta_time)
    -- Check for start of drawing.
    if not is_drawing then
        if juice.input.is_key_pressed("mouse_left") then
            start_drawing()
        end
    end

    -- If already drawing.
    if is_drawing then
        if got_blocked or juice.input.is_key_released("mouse_left") then
            end_drawing()
        end
        local pos = get_mouse_pos()
        entity.transform.position = juice.vec3.new(pos.x, pos.y, entity.transform.position.z)

        if #entity.line.points > last_segments then
            last_segments = #entity.line.points
            segment_added(last_segments)
        end

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

function get_average_point()
    local average = juice.vec2.new()
    for index = 1, #entity.line.points do
        average.x = average.x + entity.line.points[index].position.x
        average.y = average.y + entity.line.points[index].position.y
    end
    average.x = average.x / #entity.line.points
    average.y = average.y / #entity.line.points
    return average
end

function get_center_from_bounding_box()
    --local min
end

---Completed a valid circle.
function complete_circle()
    
    center = get_average_point()

    local min_dist = max_radius
    local max_dist = 0

    -- Calculate the minimum distance and maximum distance from center.
    for index = 1, #entity.line.points do
        local distance = juice.vec2.new(center.x - entity.line.points[index].position.x, center.y - entity.line.points[index].position.y):length()
        if distance < min_dist then
            min_dist = distance
        end
        if distance > max_dist then
            max_dist = distance
        end
    end

    -- Calculate circle score. 
    -- 1.0 = perfect circle. (All points equal distance from center)
    local circle_score = min_dist / max_dist
    juice.trace("score: " .. tostring(circle_score))

    -- Determine if this circle is good enough.
    if circle_score > circle_threshold then
        -- Assign values to circle entity.
        local circle_entity = entity:find_child("lasso_circle")
        circle_entity.transform.position = juice.vec3.new(center.x, center.y, circle_entity.transform.position.z)
        circle_entity.transform.scale = juice.vec2.new(min_dist / 512 * 2, min_dist / 512 * 2)
        circle_entity.physics_circle.radius = min_dist

        circle_entity.scripts.circle_visual.show()

        on_circle_complete(center, min_dist, circle_score)
    end
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
    segment.physics_box.category_bits = 2
    segment.physics_box.category_mask = 4 | 8
    segment.physics_box.is_sensor = true
end

function line_blocked()
    got_blocked = true
    juice.trace("Line got blocked")
end

---Start drawing the line.
function start_drawing()
    clear_line()
    line_begin = get_mouse_pos()
    is_drawing = true
    can_complete = false
    got_blocked = false
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