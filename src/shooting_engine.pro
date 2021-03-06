:- [ocean_engine].

%%********************* SHOOTING HANDLING FUNCTIONS *********************

% shoot([X,Y], Player, UpdatedPlayer)
% the overall shoot function
shoot([X,Y], {Board, CountSunk, Fleet}, {NewBoard, NewCounter, NewFleet}) :-
              check_shoot([X,Y], Fleet, 's', NewFleet),
			  write(': '), write('SHOOT_Fs: '),write(NewFleet),nl,
              get_ship_coordinate([X,Y], Fleet, CoordinateList),
              update_sink_ship(CoordinateList, 's', Board, NewBoard),
			  NewCounter is CountSunk + 1.

shoot([X,Y], {Board, CountSunk, Fleet}, {NewBoard, CountSunk, NewFleet}) :-
              check_shoot([X,Y], Fleet, 'h', NewFleet),
			  write(': '), write('SHOOT_Fh: '),write(NewFleet),nl,
              update_point([X,Y], 'h', Board, NewBoard).

shoot([X,Y], {Board, CountSunk, Fleet}, {NewBoard, CountSunk, NewFleet}) :-
              check_shoot([X,Y], Fleet, 'm', NewFleet),
              update_point([X,Y], 'm', Board, NewBoard).



% check_shoot([X,Y], Fleet, Result, NewFleet)
% check the shoot [X,Y] is 's' sink, or 'h' hit, or 'm' miss.
% If shoot is 's' or 'h', update the Ship and Fleet.

check_shoot([X,Y], [H|T], 's', NewFleet) :-
        check_luckyPoint([X,Y], H, 's', NewShip),
        NewFleet = [NewShip|T].

check_shoot([X,Y], [H|T], 'h', NewFleet) :-
        check_hit([X,Y], H, 'h', NewShip),
        NewFleet = [NewShip|T].

check_shoot([X,Y], [H|T], Result, [H|NewFleet]) :-
        check_miss([X,Y], H),
        check_shoot([X,Y], T, Result, NewFleet).

check_shoot([_X, _Y], [], 'm', []).

% check_luckyPoint([X,Y], Ship, Result, NewShip)
% if [X,Y] is lucky point, return true and update ship state, Result = 's'
check_luckyPoint([X,Y], Ship, 's', NewShip) :-
        {CoordinateList, _HitList, LuckyPoint} = Ship,
        [X,Y] == LuckyPoint,
        NewHitList = CoordinateList,
        NewShip = {CoordinateList, NewHitList, LuckyPoint}.


% check_hit([X,Y], Ship, Result, NewShip)
% if [X,Y] is hit, return true and update ship state, Result = 'h'
check_hit([X,Y], Ship, 'h', NewShip) :-
        {CoordinateList,HitList,LuckyPoint} = Ship,
        [X,Y] \= LuckyPoint,
        member([X,Y], CoordinateList),write('ship was hit at '),
        append(HitList,[X,Y], NewHitList),
        NewShip = {CoordinateList,NewHitList,LuckyPoint}.

% check_hit([X,Y], Ship)
% if [X,Y] is missing, return true
check_miss([X,Y], Ship) :-
        {CoordinateList, _HitList, _LuckyPoint} = Ship,
        \+ member([X,Y], CoordinateList).


% if the ship sinks, update all the points in the ship coordinate list to 's'
update_sink_ship([H|T], Result, BoardIn, BoardOut) :-
        [X,Y] = H,
        update_point([X,Y], Result, Board2, BoardOut),
        update_sink_ship(T, Result, BoardIn, Board2).

update_sink_ship([], _Result, Board, Board).

% get the coordinate list of the ship which contains [X,Y]
get_ship_coordinate([X, Y], [H|_T], CoordinateList) :-
        {CoordinateList, _, _} = H,
        member([X,Y], CoordinateList).

get_ship_coordinate([X,Y], [H|T], CoordinateList2) :-
        {CoordinateList1, _, _} = H,
        \+ member([X,Y], CoordinateList1),
        get_ship_coordinate([X,Y], T, CoordinateList2).

get_ship_coordinate([_X, _Y], [], []).


% update the point [X,Y] on the board with the Result character('s', 'h', 'm')
update_point([X,Y], Result, Board, NewBoard) :-
        split(Y, Board, BeforeLines, WantedLine, AfterLines),
        split(X, WantedLine, BeforeCells, _WantedCell, AfterCells),
        merge(BeforeCells, Result, AfterCells, NewLine),
        merge(BeforeLines, NewLine, AfterLines, NewBoard).


%%********************* END OF SHOOTING HANDLING FUNCTIONS ******************
