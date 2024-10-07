local function uuid()
    math.randomseed(os.time())
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

local max_reached = 1
local has_username = true
local playfab_username = ""

function start()
    if not playfab.signed_in then
        playfab.init("5F861")
        local id = juice.load_string("player_id")
        if not id or id == "" then
            id = uuid()
            juice.save_string("player_id", id)
        end
        playfab.sign_in(id, function(login_success, login_body)
            if login_success then
                if not login_body.NewlyCreated then
                    juice.info("Returning account")
                    -- Get user account.
                    playfab.get_player_profile(function(get_profile_success, get_profile_body)
                        if get_profile_success then
                            if not get_profile_body.PlayerProfile.DisplayName then
                                has_username = false
                                juice.info("User has no username!")
                                -- Try to create random username.
                                local new_username = "Wrangler #" .. math.random(1000, 9999)
                                playfab.set_display_name(new_username, function(name_result, name_body)
                                    if name_result then
                                        bunny_game.set_username(new_username)
                                        entity:find_child("player_name_text").ui_text.text = "Welcome, " .. new_username 
                                    end
                                end)
                            else
                                juice.info("Got username")
                                bunny_game.set_username(get_profile_body.PlayerProfile.DisplayName)
                                entity:find_child("player_name_text").ui_text.text = "Welcome, " .. bunny_game.get_username()
                            end
                        end
                    end)
                else
                    -- New account
                    local new_username = "Wrangler #" .. math.random(1000, 9999)
                    juice.prompt("Username for leaderboards:", "new_username")
                    playfab.set_display_name(new_username, function(name_result, name_body)
                        if name_result then
                            bunny_game.set_username(new_username)
                            entity:find_child("player_name_text").ui_text.text = "Welcome, " .. new_username
                        end
                    end)
                end
            end
        end)
    else
        entity:find_child("player_name_text").ui_text.text = "Welcome, " .. bunny_game.get_username()
    end

    find_entity("spawner").scripts.bunny_spawner.start_spawning_main_menu()
    local max_string = juice.load_string("max_reached")
    if not max_string or max_string == "" then
        max_string = "1"
        juice.save_string("max_reached", max_string)
    end
    max_reached = tonumber(max_string)

    if max_reached > 1 then
        find_entity("play_level_2_button").scripts.light_button.enable()
    else
        find_entity("play_level_2_button").scripts.light_button.disable()
    end

    if max_reached > 2 then
        find_entity("play_level_3_button").scripts.light_button.enable()
    else
        find_entity("play_level_3_button").scripts.light_button.disable()
    end

    find_entity("play_level_1_button").scripts.light_button.on_click = function()
        bunny_game.start_game(1)
        load_level()
    end
    find_entity("play_level_2_button").scripts.light_button.on_click = function()
        bunny_game.start_game(2)
        load_level()
    end
    find_entity("play_level_3_button").scripts.light_button.on_click = function()
        bunny_game.start_game(3)
        load_level()
    end
    entity:find_child("view_leaderboards_button").scripts.light_button.on_click = function()
        juice.routine.create(function()
            juice.routine.wait_seconds_func(0.5, function(x)
                find_entity("ui_container").ui_element.anchor.x = juice.math.lerp(0.5, 1.5, juice.ease.in_out_expo(x))
                find_entity("leaderboards").scripts.leaderboard.show_leaderboard(1)
            end)
        end)
    end
    entity:find_child("leaderboards_return_button").scripts.light_button.on_click = function()
        juice.routine.create(function()
            juice.routine.wait_seconds_func(0.5, function(x)
                find_entity("ui_container").ui_element.anchor.x = juice.math.lerp(1.5, 0.5, juice.ease.in_out_expo(x))
            end)
        end)
    end
    entity:find_child("name_edit_button").scripts.light_button.on_click = function()
        local new_name = juice.prompt("Username for leaderboards:", bunny_game.get_username())
        playfab.set_display_name(new_name, function(name_result, name_body)
            if name_result then
                bunny_game.set_username(name_body.DisplayName)
                entity:find_child("player_name_text").ui_text.text = "Welcome, " .. bunny_game.get_username()
            end
        end)
    end
end

function load_level()
    find_entity("ui_fade_panel").scripts.fade.fade_in(function()
        load_scene("scenes/game.jbscene")
    end)
end

function update()
    if playfab.signed_in then
        entity:find_child("view_leaderboards_button").scripts.light_button.enable()
    else
        entity:find_child("view_leaderboards_button").scripts.light_button.disable()
    end
end
