function [row, col] = playAgentStudent(board)
% playAgentStudent implementa un agente que juega el 'tic-tac-toe' usando
% �rboles.
%
% Entradas:
%
%         - board: [5x5] matriz conteniendo el estado actual del juego.
%                  Cada posici�n de esta matriz contiene un elemento del
%                  conjunto {0, 1, 2}. La codificaci�n es la siguiente:
%                  0 = posici�n disponible
%                  1 = posici�n ocupada por el agente del estudiante
%                  2 = posici�n ocupada por el agente del profesor o el
%                      agente manual
% Salidas:
%
%           - row: [1x1] entero del conjunto {1, 2, 3, 4, 5} que indica la fila donde
%                  el estudiante ha colocado la marca actual
%           - col: [1x1] entero del conjunto {1, 2, 3, 4, 5} que indica la columna donde
%                  el estudiante ha colocado la marca actual
%
% Dr. Marco E. Benalc�zar
% marco.benalcazar@epn.edu.ec

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           C�DIGO A REEMPLAZAR
%  Ustede debe reemplazar el siguiente c�digo con el programa que
%  implemente el agente entrenado con RL
[row, col] = playRandomly5x5(board);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end