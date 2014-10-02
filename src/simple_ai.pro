%% The idea of the database AI is to randomly choose positions to shoot at
%% until a hit is found, when a hit is found, it tries to shoot in surrounding
%% squares until the ship is sunk. Then it begins to shoot at random places.

:- use_module(library(random)).

debug_board([[~,~,~,~,~,~,~,~,~,~],
             [~,~,~,~,~,~,~,~,~,~],
             [~,~,~,~,~,~,~,~,~,~],
             [~,~,~,~,m,~,~,~,~,~],
             [~,~,~,m,h,m,~,~,~,~],
             [~,~,~,~,t,~,~,~,~,~],
             [~,~,~,~,~,~,~,~,~,~],
             [~,~,~,~,s,~,~,~,~,~],
             [~,~,~,~,s,~,~,~,~,~],
             [~,~,~,~,~,~,~,h,~,~],
             [~,~,~,~,~,~,~,~,~,~]]).

test_me :-
    debug_board(Board),
    first_occurrence_of(h, Board, Y),
    write(Y),
    nl,
    look_at(Board, {4,5}, Elem),
    write('element is:'),
    nl,
    write(Elem),
    nl,
    exhausted(Board, {4,4}, IsExhausted),
    write(IsExhausted).

%% The element we look for is the head of row, return counter :)
occurence_in_row(_,       [],              _,         no_elem).
occurence_in_row(LookFor, [LookFor|Elems], Counter,   Counter).
occurence_in_row(LookFor, [Elem   |Elems], CounterIn, CounterOut) :-
    NewCounter is CounterIn + 1,
    occurence_in_row(LookFor, Elems, NewCounter, CounterOut).

%% Given something to search for and a board, either return the coordinate
%% matching whatever to look for, or return no (prolog no answer)
%% [Row|Rows] is the board
occurence_in_board(LookFor, []        , _,         no_elem).
occurence_in_board(LookFor, [Row|Rows], CounterIn, CounterOut) :-
    occurence_in_row(LookFor, Row, 0, ColNum),
    (ColNum == no_elem ->
        NewCounter is CounterIn + 1,
        occurence_in_board(LookFor, Rows, NewCounter, CounterOut)
    ;
        CounterOut = {ColNum, CounterIn}
    ).

%% first_occurence_of takes a Board and a value to look for
%% (such as h, m, s), then returns the first coordinate which
%% holds such a value.
first_occurrence_of(LookFor, Board, ReturnCoordinate) :-
    occurence_in_board(LookFor, Board, 0, ReturnCoordinate).

look_at(Board, {X,Y}, Value) :-
    look_at_board(Board, {X,Y}, Y, Value).

look_at_board([Row|Rows], {X,Y}, 0, Value) :-
    look_at_row(Row, X, Value).
look_at_board([Row|Rows], {X,Y}, RowCounter, Value) :-
    NextRowCounter is RowCounter - 1,
    look_at_board(Rows, {X,Y}, NextRowCounter, Value).

look_at_row([Head|Tail], 0, Head).
look_at_row([Head|Tail], X, Element) :-
    NextX is X - 1,
    look_at_row(Tail, NextX, Element).

exhausted(Board, {X, Y}, Response) :-
    A1 is Y - 1,
    A2 is Y + 1,
    A3 is X - 1,
    A4 is X + 1,
    look_at(Board, {X,  A1}, Resp1),
    look_at(Board, {X,  A2}, Resp2),
    look_at(Board, {A3, Y},  Resp3),
    look_at(Board, {A4, Y},  Resp4),
    (
        (Resp1 \= '~', Resp2 \= '~', Resp3 \= '~', Resp4 \= '~') ->
        Response = true
    ;
        Response = false
    ).

%% Interface for other modules to use, given a board, returns
%% the choice of the AI.
%% FIXME: Needs implementation
ai_choice(Board, [ShotX, ShotY]) :-
    needs_implementation.
