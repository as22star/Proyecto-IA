function player = setWhoGoesFirst()
% setWhoGoesFirst flips a fair coin and decides which agent goes first. 
%
% Syntaxis:
%
% player = setWhoGoesFirst()
%
% Output:
% 
% player: Integer that indicates who plays first. If player = 1, then agent 1
% goes first; otherwise if player = 2, then agent 2 goes first
%
% Marco E. Benalcázar, Ph.D.
% playAgentProfessor implements an agent for playing tic-tac-toe. This
% function chooses randomly an empty position (row,col) on the board.
% 
% Syntaxis:
%
% [row, col] = playAgentProfessor(board)
%
% Input:
%
% board: [5x5] matrix of integers where each element is either 0, 1, or 2:
%
% 0 = available position
% 1 = positions chosen by agent 1
% 2 = positions chosen by agent 2
%
% Output:
% 
% [row, col]: Denotes the position (row, col) chosen by the agent implemented 
%             by the professor
% 
% Marco E. Benalcázar, Ph.D.
% marco.benalcazar@epn.edu.ec

% Drawing the turn using a fair coin
if rand >= 0.5
    player = 1;
else
    player = 2;
end 
return