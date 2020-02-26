orc(1,0).
touchdown(4,4).
human(2,0).
:- dynamic(solution/1).

not_north_safe(ProbY, Y, X):-
    orc(A, X), A > Y, A < ProbY.
not_south_safe(ProbY, Y, X):-
   orc(A, X), A < Y, A > ProbY.
not_west_safe(ProbX, Y, X):-
    orc(Y, A), A < X, A > ProbX.
not_east_safe(ProbX, Y, X):-
    orc(Y, A), A > X, A < ProbX.

borders(Y,X) :-
    Y =< 4,
    Y >= 0,
    X =< 4,
    X >= 0.

safe(Y, X) :-
    not(orc(Y, X)),
    borders(Y, X).

run(Length, List, TryNum) :-
    retractall(solution(_)),
    try(TryNum, List, Length),
    solution(1) -> !; writeln("Algorithm didn't find a path").

try(0, Pathes, Lengths):- !.

try(TryNum, Path, Length):-
    rugby(0,0, Path) -> length(Path, Length), !;
   	Try is TryNum - 1,
    try(Try, Path, Length).

rugby(Y, X, []):-
    touchdown(Y, X) -> assert(solution(1)).


rugby(Y, X, [Move | Actions]):-
    random(0, 8, Dir),
	step(Y, X, ProbY, ProbX, Move, Dir),
    safe(ProbY, ProbX) -> rugby(ProbY, ProbX, Actions), !.

step(Y, X, ProbY, ProbX, north, 0) :-
    ProbY is Y + 1,
    ProbX is X.

step(Y, X, ProbY, ProbX, east, 1) :-
    ProbY is Y,
    ProbX is X + 1.

step(Y, X, ProbY, ProbX, west, 2) :-
    ProbY is Y,
    ProbX is X - 1.

step(Y, X, ProbY, ProbX, south, 3) :-
    ProbY is Y - 1,
    ProbX is X.

step(Y, X, ProbY, ProbX, (pass_north, ProbY, ProbX), 4):-
    human(ProbY, X),
    ProbY > Y,
    not(not_north_safe(ProbY, Y, X)),
    %(not(orc(A, X)); not(A > Y); not(A < ProbY)),
    ProbX is X.

step(Y, X, ProbY, ProbX, (pass_south, ProbY, ProbX), 5):-
    human(ProbY, X),
    ProbY < Y,
    not(not_south_safe(ProbY, Y, X)),
    %(not(orc(A, X)); not(A < Y); not(A > ProbY)),
    ProbX is X.

step(Y, X, ProbY, ProbX, (pass_west, ProbY, ProbX), 6):-
    human(Y, ProbX),
    ProbX < X,
    not(not_west_safe(ProbX, Y, X)),
    %(not(orc(Y, A)); not(A < X); not(A > ProbX)),
    ProbY is Y.

step(Y, X, ProbY, ProbX, (pass_east, ProbY, ProbX), 7):-
    human(Y, ProbX),
    ProbX > X,
    not(not_east_safe(ProbX, Y, X)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y.

%time(run(Steps, Moves, 100)).
