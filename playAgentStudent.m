function [row, col] = playAgentStudent(board)
% playAgentStudent implements an agent that plays '4 in a row' on a 5x5 board using MCTS.
%
% Inputs:
%         - board: [5x5] matrix containing the current state of the game.
%                  Each position in this array contains an element of the
%                  set {0, 1, 2}. The coding is as follows:
%                  0 = available position
%                  1 = position occupied by manual agent (player 1)
%                  2 = position occupied by the student's agent (player 2)
%
% Outputs:
%         - row: [1x1] integer from the set {1, 2, 3, 4, 5} indicating the row where
%                the student has placed the current mark
%         - col: [1x1] integer from the set {1, 2, 3, 4, 5} indicating the column where
%                the student has placed the current mark

% Parameters for MCTS
simulations = 5000;  % Number of simulations per move
exploration_constant = sqrt(2);  % Exploration constant for UCB1

% Check for immediate winning moves or blocks
[row, col] = check_immediate_win_or_block(board, 2);
if row ~= -1 && col ~= -1
    return;
end

% Execute MCTS to determine the best move
try
    best_move = MCTS(board, 2, simulations, exploration_constant);
catch
    % In case of error, return a random move
    [row, col] = random_move(board);
    return;
end

% Convert the index of the best move to row and column coordinates
[row, col] = ind2sub([5, 5], best_move);

end

function best_move = MCTS(board, player, simulations, exploration_constant)
% Create root node
root = create_node(board, player);

% Perform simulations
for i = 1:simulations
    node = select_node(root, exploration_constant);
    if ~is_terminal(node.board)
        expand(node);
    end
    result = simulate(node.board, node.player);  % Changed to use heuristic_move in simulation
    backpropagate(node, result);
end

% Verify if possible moves are found
if isempty(root.children)
    error('No possible moves found from root.');
end

% Find the move with the best win rate
win_ratios = arrayfun(@(child) child.wins / max(child.visits, 1), root.children);  
[~, best_move_idx] = max(win_ratios);

% Ensure the node has the move field defined before using it
if isfield(root.children(best_move_idx), 'move')
    best_move = root.children(best_move_idx).move;
else
    error('The child node does not have the "move" field defined.');
end
end

function node = select_node(node, exploration_constant)
% Select node using UCB1
while ~isempty(node.children)
    ucb_values = arrayfun(@(n) UCB1(n, exploration_constant), node.children);
    [~, best_child_idx] = max(ucb_values);
    node = node.children(best_child_idx);
end
end

function expand(node)
% Expand node
available_moves = find_available_moves(node.board);
if isempty(available_moves)
    return;  % No available moves
end

for i = 1:size(available_moves, 1)
    move = available_moves(i, :);
    new_board = node.board;
    new_board(move(1), move(2)) = node.player;
    new_node = create_node(new_board, 3 - node.player, sub2ind(size(new_board), move(1), move(2)));
    new_node.parent = node;
    
    % Add new child node
    if isempty(node.children)
        node.children = new_node;
    else
        node.children(end+1) = new_node;
    end
end
end

function result = simulate(board, player)
% Simulate game from the node to the end
current_board = board;
current_player = player;
depth = 0;
max_depth = 10; % Limiting the depth of the simulation

while ~is_terminal(current_board) && depth < max_depth
    move = heuristic_move(current_board, current_player);  % Changed from random_move to heuristic_move
    current_board(move(1), move(2)) = current_player;
    current_player = 3 - current_player;  % Switch player
    depth = depth + 1;
end

result = evaluate_board(current_board);
end

function backpropagate(node, result)
% Update node statistics
while ~isempty(node)
    node.visits = node.visits + 1;
    if node.player == result
        node.wins = node.wins + 1;
    end
    node = node.parent;
end
end

function value = UCB1(node, exploration_constant)
% Calculate UCB1
if node.visits == 0
    value = inf;
else
    value = (node.wins / node.visits) + exploration_constant * sqrt(log(node.parent.visits) / node.visits);
end
end

function moves = find_available_moves(board)
% Find available positions on the board
[rows, cols] = find(board == 0);
moves = [rows, cols];
end

function [row, col] = random_move(board)
% Randomly select an available position on the board
available_moves = find_available_moves(board);
idx = randi(size(available_moves, 1));
row = available_moves(idx, 1);
col = available_moves(idx, 2);
end

function node = create_node(board, player, move)
if nargin < 3
    move = [];
end
node.board = board;
node.player = player;
node.move = move;  % Add move to node structure
node.visits = 0;
node.wins = 0;
node.children = [];  % Initialize as empty array
node.parent = [];
end

function terminal = is_terminal(board)
% Determine if the board is in a terminal state
terminal = check_win(board, 1) || check_win(board, 2) || all(board(:) ~= 0);
end

function win = check_win(board, player)
% Check if a player has won
% For a 5x5 board, check if there are 4 consecutive pieces in rows, columns, or diagonals
win = check_rows(board, player) || check_cols(board, player) || check_diagonals(board, player);
end

function win = check_rows(board, player)
win = false;
for row = 1:5
    for col = 1:2
        if all(board(row, col:col+3) == player)
            win = true;
            return;
        end
    end
end
end

function win = check_cols(board, player)
win = false;
for col = 1:5
    for row = 1:2
        if all(board(row:row+3, col) == player)
            win = true;
            return;
        end
    end
end
end

function win = check_diagonals(board, player)
win = false;
% Check major diagonals
for i = 1:2
    diag1 = diag(board, i-3);
    diag2 = diag(flipud(board), i-3);
    if length(diag1) >= 4 && any(arrayfun(@(j) all(diag1(j:j+3) == player), 1:length(diag1)-3))
        win = true;
        return;
    end
    if length(diag2) >= 4 && any(arrayfun(@(j) all(diag2(j:j+3) == player), 1:length(diag2)-3))
        win = true;
        return;
    end
end

% Check minor diagonals (added this part for more comprehensive diagonal checking)
for row = 1:2
    for col = 1:2
        if all(diag(board(row:row+3, col:col+3)) == player)
            win = true;
            return;
        end
        if all(diag(flipud(board(row:row+3, col:col+3))) == player)
            win = true;
            return;
        end
    end
end
end

function result = evaluate_board(board)
% Evaluate the board result
if check_win(board, 1)
    result = 1;  % Player 1 wins
elseif check_win(board, 2)
    result = 2;  % Player 2 wins
    % Stop and delete timers when Player 2 wins
    stopAndDeleteTimers();
else
    result = 0;  % Draw or non-terminal
end
end

function [row, col] = heuristic_move(board, player)
% Heuristic move selection for simulation
% Prioritize moves that create rows of three or block opponent's rows of three
available_moves = find_available_moves(board);
best_move = [];
best_score = -inf;

for i = 1:size(available_moves, 1)
    move = available_moves(i, :);
    temp_board = board;
    temp_board(move(1), move(2)) = player;
    score = evaluate_heuristic(temp_board, player);
    if score > best_score
        best_score = score;
        best_move = move;
    end
end

if isempty(best_move)
    % If no heuristic move is found, select a random move
    [row, col] = random_move(board);
else
    row = best_move(1);
    col = best_move(2);
end
end

function score = evaluate_heuristic(board, player)
% Heuristic evaluation function
score = 0;

% Check rows
for row = 1:5
    for col = 1:2
        line = board(row, col:col+3);
        score = score + evaluate_line(line, player);
    end
end

% Check columns
for col = 1:5
    for row = 1:2
        line = board(row:row+3, col);
        score = score + evaluate_line(line, player);
    end
end

% Check diagonals
for i = 1:2
    diag1 = diag(board, i-3);
    diag2 = diag(flipud(board), i-3);
    for j = 1:length(diag1)-3
        line1 = diag1(j:j+3);
        line2 = diag2(j:j+3);
        score = score + evaluate_line(line1, player) + evaluate_line(line2, player);
    end
end

% Additional check for minor diagonals (added for comprehensive evaluation)
for row = 1:2
    for col = 1:2
        diag1 = diag(board(row:row+3, col:col+3));
        diag2 = diag(flipud(board(row:row+3, col:col+3)));
        score = score + evaluate_line(diag1, player) + evaluate_line(diag2, player);
    end
end
end

function score = evaluate_line(line, player)
% Evaluate a line for the heuristic function
opponent = 3 - player;
if all(line == player)
    score = 1000;  % Win
elseif all(line == opponent)
    score = -1000;  % Opponent win
else
    player_count = sum(line == player);
    opponent_count = sum(line == opponent);
    if player_count == 3 && opponent_count == 0
        score = 100;  % Potential win
    elseif opponent_count == 3 && player_count == 0
        score = -100;  % Block opponent's win
    else
        score = player_count - opponent_count;  % Heuristic value
    end
end
end

function [row, col] = check_immediate_win_or_block(board, player)
% Check for immediate winning moves or blocking moves
opponent = 3 - player;
for move = find_available_moves(board)'
    board(move(1), move(2)) = player;
    if check_win(board, player)
        row = move(1);
        col = move(2);
        return;
    end
    board(move(1), move(2)) = opponent;
    if check_win(board, opponent)
        row = move(1);
        col = move(2);
        return;
    end
    board(move(1), move(2)) = 0;
end
row = -1;
col = -1;
end

function stopAndDeleteTimers()
    % Find all timers in the workspace
    timers = timerfindall;
    
    % Stop and delete each timer
    for i = 1:length(timers)
        stop(timers(i));
        delete(timers(i));
    end
end
