clc;
close all;
clear all;
warning off all;

% Dr. Marco E. Benalcázar
% marco.benalcazar@epn.edu.ec

% Añade la librería del 'tic-tac-toe'
addpath('Toolbox TicTacToe');

% Lista de opciones:
% Opción 1: Agente de estudiantes vs. humano (juego manual)
% Opción 2: Agente del profesor vs. humano (juego manual)
% Opción 3: Agente de estudiantes vs. agente del profesor
% Nota: En las opciones 2 y 3 se ha incluído como agente del profesor uno
%       que realiza jugadas aleatorias. El agente del profesor que realiza
%       movimientos "inteligentes" se pondrá a prueba el día de la defensa del
%       del presente proyecto.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             AQUÍ DEBE CAMBIAR EL VALOR DE LA VARIABLE OPTION
%                          
% IMPORTANTE: Colocar el valor de la variable option en 1 cuando
% quiera probar su agente con un usuario; caso contrario, coloque el valor
% en 3 cuando quiera verificar que su programa es capaz de interactuar con
% el agente del profesor. Recuerde que el agente del profesor implementado
% en este código no es inteligente, pues realiza jugadas al azar
option = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numEpisodes = 1; % Número de veces que se repite el juego
tictactoe5x5(option, numEpisodes);