bunny_game = {}

local total_score = 0
local total_caught = 0
local selected_difficulty = 1
local returning_from = 0

function bunny_game.start_game(difficulty)
    total_score = 0
    total_caught = 0
    selected_difficulty = difficulty
end

function bunny_game.get_username()
    return bunny_game.username
end

function bunny_game.set_username(username)
    bunny_game.username = username
end

function bunny_game.set_return_from_level()
    returning_from = selected_difficulty
end

function bunny_game.get_return_from_level()
    return returning_from
end

function bunny_game.add_score(score)
    total_score = total_score + score
end

function bunny_game.catch_bunny()
    total_caught = total_caught + 1
end

function bunny_game.get_score()
    return total_score
end

function bunny_game.get_caught_bunnies()
    return total_caught
end

function bunny_game.get_current_difficulty()
    return selected_difficulty
end