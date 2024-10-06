bunny_game = {}

score = 0
local selected_difficulty = 1

function bunny_game.start_game(difficulty)
    score = 0
    selected_difficulty = difficulty
end

function bunny_game.get_current_difficulty()
    return selected_difficulty
end

function bunny_game.game_over()
end