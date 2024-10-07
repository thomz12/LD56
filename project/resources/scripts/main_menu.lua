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
                playfab.get_player_profile(function(get_profile_success, get_profile_body)
                    if get_profile_success then
                        if not get_profile_body.PlayerProfile.DisplayName then
                            has_username = false
                            juice.info("User has no username!")
                            playfab.set_display_name("Wrangler #" .. math.random(1000, 9999), function()

                            end)
                        end
                    end
                end)
            end
        end)
    end

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
        load_scene("scenes/game.jbscene")
        bunny_game.start_game(1)
    end
    find_entity("play_level_2_button").scripts.light_button.on_click = function()
        load_scene("scenes/game.jbscene")
        bunny_game.start_game(2)
    end
    find_entity("play_level_3_button").scripts.light_button.on_click = function()
        load_scene("scenes/game.jbscene")
        bunny_game.start_game(3)
    end
end

function update()
    if playfab.signed_in then
        entity:find_child("view_leaderboards_button").scripts.light_button.enable()
    else
        entity:find_child("view_leaderboards_button").scripts.light_button.disable()
    end
end
