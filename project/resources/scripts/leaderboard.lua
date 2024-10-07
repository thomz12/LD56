local leaderboard_names = {
    level_1 = "Easy",
    level_2 = "Medium",
    level_3 = "Hard",
    bunnies_caught = "Total Bunnies",
    bunnies_caught_max = "Bunnies in Round",
}

local leaderboards = {
    [1] = "level_1",
    [2] = "level_2",
    [3] = "level_3",
    [4] = "bunnies_caught",
    [5] = "bunnies_caught_max",
}

local entries = {}

local current_leaderboard = 1

function start()
    entity:find_child("leaderboard_next_button").scripts.light_button.on_click = function()
        local next = current_leaderboard + 1
        if next > #leaderboards then
            next = 1
        end
        show_leaderboard(next)
    end
    entity:find_child("leaderboard_prev_button").scripts.light_button.on_click = function()
        local prev = current_leaderboard - 1
        if prev < 1 then
            prev = #leaderboards
        end
        show_leaderboard(prev)
    end
end

function show_leaderboard(index)
    current_leaderboard = index
    local name = leaderboards[index]
    entity:find_child("leaderboard_title_text").ui_text.text = leaderboard_names[name]
    entity:find_child("loading_image").ui_element.enabled = true

    for i = 1, 8 do
        entity:find_child("leaderboard_entry_" .. tostring(i)).ui_element.enabled = false
    end

    playfab.get_leaderboard(name, 0, 10, function(get_result, get_body)
        entity:find_child("loading_image").ui_element.enabled = false
        if get_result then
            for i, entry in ipairs(get_body.Leaderboard) do
                local entry_ui = entity:find_child("leaderboard_entry_" .. tostring(i))
                entry_ui.ui_element.enabled = true
                entry_ui:find_child("leaderboard_name").ui_text.text = entry.DisplayName
                entry_ui:find_child("leaderboard_rank").ui_text.text = "#" .. tostring(entry.Position + 1)
                entry_ui:find_child("leaderboard_score").ui_text.text = tostring(entry.StatValue)

                local rank = "noob"
                
                if entry.Position == 0 then
                    rank = "gold"
                elseif entry.Position == 1 then
                    rank = "silver"
                elseif entry.Position == 2 then
                    rank = "bronze"
                end

                entry_ui:find_child("background_name").ui_image.image = juice.resources:load_texture(string.format("sprites/leaderboard_%s.png", rank))
                entry_ui:find_child("background_rank").ui_image.image = juice.resources:load_texture(string.format("sprites/leaderboard_%s_small.png", rank))
                entry_ui:find_child("background_score").ui_image.image = juice.resources:load_texture(string.format("sprites/leaderboard_%s_small.png", rank))
            end
        end
    end)
end