function status = checkBoard5x5(board)
% checkBoard5x5(board) checks the current status of the board to determine the
% current status of the game.
%
% Syntaxis:
%
% status = checkBoard5x5(board)
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
% status: structure with the fields 'state' and 'winner'. When there is
% a winner status.state = 'win' and status.winner indicates which agent
% won. When the game is still in progress, then status.state = 'inProgress'
% and status.winner = []
%
%
% Marco E. Benalcázar, Ph.D.
% marco.benalcazar@epn.edu.ec


if size(board,1) ~= 5 || size(board,2) ~= 5
    error('La matriz del juego no es de 5 x 5');
else
    %% Player 1:
    for i = 1:2 % Rows
        idxStart = i;
        idxEnd = 3 + i;
        if ~isempty(  find( sum( board(:, idxStart:idxEnd) == 1, 2 ) == 4, 1 )  )
            status.state = 'win';
            status.winner = 1;
            status.line = 'row';
            % Indices to highlight the wining states
            r = find( sum( board(:, idxStart:idxEnd) == 1, 2 ) == 4, 1 );
            col = idxStart:idxEnd;
            row = r*ones(1, length(col));
            status.idx = sub2ind([5,5],row,col);
            return;
        end
    end
    
    for i = 1:2 % Columns
        idxStart = i;
        idxEnd = 3 + i;
        if ~isempty(  find( sum( board(idxStart:idxEnd, :) == 1, 1 ) == 4, 1 )  )
            status.state = 'win';
            status.winner = 1;
            status.line = 'col';
            % Indices to highlight the wining states
            c = find( sum( board(idxStart:idxEnd, :) == 1, 1 ) == 4, 1 );
            row = idxStart:idxEnd;
            col = c*ones(1, length(row));
            status.idx = sub2ind([5,5],row,col);
            return;
        end
    end
    
    % Main diagonals
    % (1,2),(2,3),(3,4),(4,5)
    % (1,1),(2,2),(3,3),(4,4)
    % (2,2),(3,3),(4,4),(5,5)
    % (2,1),(3,2),(4,3),(5,4)
    r = [1:4; 1:4; 2:5; 2:5];
    c = [2:5; 1:4; 2:5; 1:4];
    for i = 1:4
        idx = sub2ind([5,5],r(i,:),c(i,:));
        sumVal = sum( board( idx ) == 1 );
        if sumVal == 4
            status.state = 'win';
            status.winner = 1;
            status.line = 'mDiag';
            % Indices to highlight the wining states
            status.idx = idx;
            return;
        end
    end
    
    % Secondary diagonals: rotation of 90 deegrees
    for i = 1:4
        idx = sub2ind([5,5],r(i,:),c(i,:));
        mtx = zeros(5,5);
        mtx(idx) = 1;
        mtx90 = logical(rot90(mtx, 1));
        sumVal = sum( board( mtx90 ) == 1 );
        if sumVal == 4
            status.state = 'win';
            status.winner = 1;
            status.line = 'sDiag';
            % Indices to highlight the wining states
            status.idx = find( mtx90 == 1 );
            return;
        end
    end
    
    %% Player 2:
    for i = 1:2 % Rows
        idxStart = i;
        idxEnd = 3 + i;
        if ~isempty(  find( sum( board(:, idxStart:idxEnd) == 2, 2 ) == 4, 1 )  )
            status.state = 'win';
            status.winner = 2;
            status.line = 'row';
            % Indices to highlight the wining states
            r = find( sum( board(:, idxStart:idxEnd) == 2, 2 ) == 4, 1 );
            col = idxStart:idxEnd;
            row = r*ones(1, length(col));
            status.idx = sub2ind([5,5],row,col);
            return;
        end
    end
    
    for i = 1:2 % Columns
        idxStart = i;
        idxEnd = 3 + i;
        if ~isempty(  find( sum( board(idxStart:idxEnd, :) == 2, 1 ) == 4, 1 )  )
            status.state = 'win';
            status.winner = 2;
            status.line = 'col';
            % Indices to highlight the wining states
            c = find( sum( board(idxStart:idxEnd, :) == 2, 1 ) == 4, 1 );
            row = idxStart:idxEnd;
            col = c*ones(1, length(row));
            status.idx = sub2ind([5,5],row,col);
            return;
        end
    end
    
    % Main diagonals
    % (1,2),(2,3),(3,4),(4,5)
    % (1,1),(2,2),(3,3),(4,4)
    % (2,2),(3,3),(4,4),(5,5)
    % (2,1),(3,2),(4,3),(5,4)
    r = [1:4; 1:4; 2:5; 2:5];
    c = [2:5; 1:4; 2:5; 1:4];
    for i = 1:4
        idx = sub2ind([5,5],r(i,:),c(i,:));
        sumVal = sum( board( idx ) == 2 );
        if sumVal == 4
            status.state = 'win';
            status.winner = 2;
            status.line = 'mDiag';
            % Indices to highlight the wining states
            status.idx = idx;
            return;
        end
    end
    
    % Secondary diagonals: rotation of 90 deegrees
    for i = 1:4
        idx = sub2ind([5,5],r(i,:),c(i,:));
        mtx = zeros(5,5);
        mtx(idx) = 1;
        mtx90 = logical(rot90(mtx, 1));
        sumVal = sum( board( mtx90 ) == 2 );
        if sumVal == 4
            status.state = 'win';
            status.winner = 2;
            status.line = 'sDiag';
            % Indices to highlight the wining states
            status.idx = find( mtx90 == 1 );
            return;
        end
    end
    
    % Check for draws otherwise the game is still in progress
    if sum(board(:) == 0) == 0
        status.state = 'draw';
        status.winner = [];
        status.line = [];
        status.idx = [];
        return;
    else
        status.state = 'inProgress';
        status.winner = [];
        status.line = [];
        status.idx = [];
    end
end
return