function [row, col] = playAgentProfessor(board)
% playAgentProfessor implementa el agente del profesor
%
% Entradas:
%
%         - board: [3x3] matriz conteniendo el estado actual del juego.
%                  Cada posición de esta matriz contiene un elemento del
%                  conjunto {0, 1, 2}. La codificación es la siguiente:
%                  0 = posición disponible
%                  1 = posición ocupada por el agente del estudiante
%                  2 = posición ocupada por el agente del profesor o el
%                      agente manual
% Salidas:
%
%           - row: [1x1] entero del conjunto {1, 2, 3, 4, 5} que indica la fila donde
%                  el estudiante ha colocado la marca actual
%           - col: [1x1] entero del conjunto {1, 2, 3, 4, 5} que indica la columna donde
%                  el estudiante ha colocado la marca actual
% 
% Marco E. Benalcázar, Ph.D.
% marco.benalcazar@epn.edu.ec

[row, col] = playRandomly5x5(board);
return