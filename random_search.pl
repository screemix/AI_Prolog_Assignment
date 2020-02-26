orc(1,0).
touchdown(4,4).
human(2,0).
:- dynamic(solution/1).

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
    random(0, 4, Dir),
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

%time(run(Steps, Moves, 100)).
