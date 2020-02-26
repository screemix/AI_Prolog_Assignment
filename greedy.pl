orc(3, 4).
orc(4, 3).
touchdown(4,4).
:- dynamic(solution/1).

borders(Y,X) :-
    Y =< 4,
    Y >= 0,
    X =< 4,
    X >= 0.

safe(Y, X, StepNum) :-
    not(orc(Y,X)),
    borders(Y, X),
    StepNum > 0.

touchdown_in_vis_area(Y, X, ProbY, ProbX, Move):-
    step(Y, X, ProbY, ProbX, Move, Dir),
    touchdown(ProbY, ProbX).

run(Steps, Moves) :-
    retractall(solution(_)),
    regby(0,0, Moves, 5, 1000), !,
    solution(1) -> !, length(Moves, Steps); writeln("Algorithm didn't find a path").

check(X, Y):-
	Var is X + Y,
	not(Var = 0).

regby(Y, X, [Move], PrevMove, StepNum):-
    touchdown_in_vis_area(Y, X, ProbY, ProbX, Move) -> assert(solution(1)).

regby(Y, X, [Move | Actions], PrevMove, StepNum):-
	step(Y, X, ProbY, ProbX, Move, Dir),
    check(Dir, PrevMove),
    safe(ProbY, ProbX, StepNum), !,
    SN is StepNum - 1,
    regby(ProbY, ProbX, Actions, Dir, SN).

step(Y, X, ProbY, ProbX, north, 1) :-
    ProbY is Y + 1,
    ProbX is X.

step(Y, X, ProbY, ProbX, east, -2) :-
    ProbY is Y,
    ProbX is X + 1.

step(Y, X, ProbY, ProbX, west, 2) :-
    ProbY is Y,
    ProbX is X - 1.

step(Y, X, ProbY, ProbX, south, -1) :-
    ProbY is Y - 1,
    ProbX is X.

%run(Steps, Moves).
