%Hola mundo
%Este script fue cambiado por Cesar
%Hola  Cesar, esto si funciona entonces
%No se usar Matlab, ehhh GIT init?
%A no, era git clone jjssjjsj
%Holaa
%Hola mundo 

function [row, col] = playAgentStudent(board)
% playAgentStudent implementa un agente que juega '4 en raya' en un tablero 5x5 usando MCTS.
%
% Entradas:
%         - board: [5x5] matriz conteniendo el estado actual del juego.
%                  Cada posición de esta matriz contiene un elemento del
%                  conjunto {0, 1, 2}. La codificación es la siguiente:
%                  0 = posición disponible
%                  1 = posición ocupada por el agente manual (jugador 1)
%                  2 = posición ocupada por el agente del estudiante (jugador 2)
%
% Salidas:
%         - row: [1x1] entero del conjunto {1, 2, 3, 4, 5} que indica la fila donde
%                el estudiante ha colocado la marca actual
%         - col: [1x1] entero del conjunto {1, 2, 3, 4, 5} que indica la columna donde
%                el estudiante ha colocado la marca actual
%
% Dr. Marco E. Benalcázar
% marco.benalcazar@epn.edu.ec

% Parámetros MCTS
% Parámetros MCTS
simulations = 25;  % Número de simulaciones por movimiento
exploration_constant = sqrt(2);  % Constante de exploración para UCB1

% Verificar si el tablero está completo
if all(board(:) ~= 0)
    % Si el tablero está completo, devolver una jugada aleatoria
    [row, col] = random_move(board);
    return;
end

% Ejecutar MCTS para determinar la mejor jugada
try
    best_move = MCTS(board, 2, simulations, exploration_constant);
catch
    % En caso de error, devolver una jugada aleatoria
    [row, col] = random_move(board);
    return;
end

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

% Verificar si se encontraron movimientos posibles
if isempty(root.children)
    error('No se encontraron movimientos posibles desde la raíz.');
end

% Encuentra el movimiento con la mejor tasa de victorias
win_ratios = arrayfun(@(child) child.wins / max(child.visits, 1), root.children);  
[~, best_move_idx] = max(win_ratios);

% Asegurarse que el nodo tiene el campo move definido antes de usarlo
if isfield(root.children(best_move_idx), 'move')
    best_move = root.children(best_move_idx).move;
else
    error('El nodo hijo no tiene el campo "move" definido.');
end
end

function node = select_node(node, exploration_constant)
% Seleccionar nodo usando UCB1
while ~isempty(node.children)
    ucb_values = arrayfun(@(n) UCB1(n, exploration_constant), node.children);
    [~, best_child_idx] = max(ucb_values);
    node = node.children(best_child_idx);
end
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

function result = simulate(board, player)
% Simular juego desde el nodo hasta el final
current_board = board;
current_player = player;
while ~is_terminal(current_board)
    move = random_move(current_board);
    current_board(move(1), move(2)) = current_player;
    current_player = 3 - current_player;  % Cambiar de jugador
end
result = evaluate_board(current_board);
end

function backpropagate(node, result)
% Actualizar estadísticas del nodo
while ~isempty(node)
    node.visits = node.visits + 1;
    if node.player == result
        node.wins = node.wins + 1;
    end
    node = node.parent;
end
end

function value = UCB1(node, exploration_constant)
% Calcular UCB1
if node.visits == 0
    value = inf;
else
    value = (node.wins / node.visits) + exploration_constant * sqrt(log(node.parent.visits) / node.visits);
end
end

function moves = find_available_moves(board)
% Encontrar posiciones disponibles en el tablero
[rows, cols] = find(board == 0);
moves = [rows, cols];
end

function [row, col] = random_move(board)
% Seleccionar aleatoriamente una posición disponible en el tablero
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
node.move = move;  % Añadir movimiento a la estructura del nodo
node.visits = 0;
node.wins = 0;
node.children = [];  % Inicializar como arreglo vacío
node.parent = [];
end

function terminal = is_terminal(board)
% Determinar si el tablero está en estado terminal
terminal = check_win(board, 1) || check_win(board, 2) || all(board(:) ~= 0);
end

function win = check_win(board, player)
% Verificar si un jugador ha ganado
% Para un tablero de 5x5, se necesita verificar si hay 4 fichas consecutivas en filas, columnas o diagonales
win = ...
    any(all(board == player, 1)) || ... % Filas
    any(all(board == player, 2)) || ... % Columnas
    check_diagonals(board, player);     % Diagonales
end

function win = check_diagonals(board, player)
% Verificar diagonales
win = false;
for i = 1:2
    diag_vec = diag(board, i-3);
    if length(diag_vec) >= 4 && all(diag_vec == player)
        win = true;
        return;
    end
end
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

