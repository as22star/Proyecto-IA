%Hola mundo
%Este script fue cambiado por Cesar
%Hola  Cesar, esto si funciona entonces
%No se usar Matlab, ehhh GIT init?
%A no, era git clone jjssjjsj
%Holaa
%Hola mundo 

function [row, col] = playAgentStudent(board)
simulations = 1;  % Número de simulaciones por movimiento
exploration_constant = sqrt(2);  % Constante de exploración para UCB1

% Verificar si el tablero está completo
if all(board(:) ~= 0)
    error('El tablero está completo. No hay movimientos posibles.');
end

% Ejecutar MCTS para determinar la mejor jugada
best_move = MCTS(board, 1, simulations, exploration_constant);

% Convertir el índice del mejor movimiento en coordenadas de fila y columna
[row, col] = ind2sub([5, 5], best_move);

end

function best_move = MCTS(board, player, simulations, exploration_constant)
% Crear nodo raíz
root = create_node(board, player);

% Realizar simulaciones
for i = 1:simulations
    node = select_node(root, exploration_constant);
    if ~is_terminal(node.board)
        expand(node);
    end
    result = simulate(node.board, node.player);
    backpropagate(node, result);
end




end

function node = create_node(board, player, move)
if nargin < 3
    move = [];
end
node.board = board;
node.player = player;
node.move = move;  % Añadir movimiento a la estructura del nodo
node.visits = 0;
node.wins = 0;
node.children = [];  % Inicializar como arreglo vacío
node.parent = [];
end

function node = select_node(node, exploration_constant)
% Seleccionar nodo usando UCB1
while ~isempty(node.children)
    ucb_values = arrayfun(@(n) UCB1(n, exploration_constant), node.children);
    [~, best_child_idx] = max(ucb_values);
    node = node.children(best_child_idx);
end
end

function terminal = is_terminal(board)
% Determinar si el tablero está en estado terminal
terminal = check_win(board, 1) || check_win(board, 2) || all(board(:) ~= 0);
end

function expand(node)
% Expandir nodo
available_moves = find_available_moves(node.board);
if isempty(available_moves)
    return;  % No hay movimientos disponibles
end

for i = 1:size(available_moves, 1)
    move = available_moves(i, :);
    new_board = node.board;
    new_board(move(1), move(2)) = node.player;
    new_node = create_node(new_board, 3 - node.player, sub2ind(size(new_board), move(1), move(2)));
    new_node.parent = node;
    
    % Asegurarse de que cada nuevo nodo hijo tiene el campo "move" definido
    if ~isfield(new_node, 'move')
        error('El nodo hijo no tiene el campo "move" definido.');
    end
    
    % Agregar nuevo nodo hijo
    if isempty(node.children)
        node.children = new_node;
    else
        node.children(end+1) = new_node;
    end
end
end

function moves = find_available_moves(board)
% Encontrar posiciones disponibles en el tablero
[rows, cols] = find(board == 0);
moves = [rows, cols];
end

function result = simulate(board, player)
% Simular juego desde el nodo hasta el final
current_board = board;
current_player = player;
while ~is_terminal(current_board)
    move = random_move(current_board);
    current_board(move(1), move(2)) = current_player
    current_player = 3 - current_player;  % Cambiar de jugador
    
end
result = evaluate_board(current_board)
end

function move = random_move(board)
% Seleccionar aleatoriamente una posición disponible en el tablero
available_moves = find_available_moves(board);
idx = randi(size(available_moves, 1));
row = available_moves(idx, 1);
col = available_moves(idx, 2);
move = [row, col];
end

function result = evaluate_board(board)
% Evaluar el resultado del tablero
if check_win(board, 1)
    result = 1;  % Gana el jugador 1
elseif check_win(board, 2)
    result = 2;  % Gana el jugador 2
else
    result = 0;  % Empate o no terminal
end
end


function win = check_win(board, player)
% Función interna para verificar si un jugador ha ganado en el tablero dado.

% Verificar filas
for i = 1:2
    idxStart = i;
    idxEnd = 3 + i;
    if any(all(board(:, idxStart:idxEnd) == player, 2))
        win = true;
        return;
    end
end

% Verificar columnas
for i = 1:2
    idxStart = i;
    idxEnd = 3 + i;
    if any(all(board(idxStart:idxEnd, :) == player, 1))
        win = true;
        return;
    end
end

% Verificar diagonales principales
main_diagonals = [...
    sub2ind([5,5], [1 2 3 4], [2 3 4 5]); ...
    sub2ind([5,5], [1 2 3 4], [1 2 3 4]); ...
    sub2ind([5,5], [2 3 4 5], [2 3 4 5]); ...
    sub2ind([5,5], [2 3 4 5], [1 2 3 4])];
for d = 1:size(main_diagonals, 1)
    if all(board(main_diagonals(d, :)) == player)
        win = true;
        return;
    end
end

% Verificar diagonales secundarias
secondary_diagonals = [...
    sub2ind([5,5], [1 2 3 4], [4 3 2 1]); ...
    sub2ind([5,5], [1 2 3 4], [5 4 3 2]); ...
    sub2ind([5,5], [2 3 4 5], [4 3 2 1]); ...
    sub2ind([5,5], [2 3 4 5], [5 4 3 2])];
for d = 1:size(secondary_diagonals, 1)
    if all(board(secondary_diagonals(d, :)) == player)
        win = true;
        return;
    end
end

% Si no se encontró ninguna línea de 4 fichas consecutivas
win = false;

end

function backpropagate(node, result)
% Actualizar estadísticas del nodo
while ~isempty(node)
    node.visits = node.visits + 1
    if node.player == result
        node.wins = node.wins + 1
    end
    node = node.parent;
end
end

