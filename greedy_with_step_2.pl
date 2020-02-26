orc(4,4).
human(2,3).
touchdown(0,3).
:- dynamic(solution/1).

borders(Y,X) :-
    Y =< 4,
    Y >= 0,
    X =< 4,
    X >= 0.

not_north_safe(ProbY, Y, X):-
    orc(A, X), A > Y, A < ProbY.
not_south_safe(ProbY, Y, X):-
   orc(A, X), A < Y, A > ProbY.
not_west_safe(ProbX, Y, X):-
    orc(Y, A), A < X, A > ProbX.
not_east_safe(ProbX, Y, X):-
    orc(Y, A), A > X, A < ProbX.

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

regby(Y, X, [FirstMove, SecondMove], PrevMove, StepNum):-
    step(Y, X, ProbY, ProbX, FirstMove, Dir),
    safe(ProbY, ProbX, StepNum),
    touchdown_in_vis_area(ProbY, ProbX, ProbYY, ProbXX, SecondMove) -> assert(solution(1)).

regby(Y, X, [Move | Actions], PrevMove, StepNum):-
	step(Y, X, ProbY, ProbX, Move, Dir),
    check(Dir, PrevMove),
    safe(ProbY, ProbX, StepNum), !,
    SN is StepNum - 1,
    regby(ProbY, ProbX, Actions, Dir, SN).

step(Y, X, ProbY, ProbX, (pass_north, ProbY, ProbX), -3):-
    human(ProbY, X),
    ProbY < Y + 3,
    ProbY > Y,
    not(not_north_safe(ProbY, Y, X)),
    %(not(orc(A, X)); not(A > Y); not(A < ProbY)),
    ProbX is X.

step(Y, X, ProbY, ProbX, (pass_east, ProbY, ProbX), -4):-
    human(Y, ProbX),
    ProbX < X + 3,
    ProbX > X,
    not(not_east_safe(ProbX, Y, X)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y.
step(Y, X, ProbY, ProbX, (pass_south, ProbY, ProbX), 3):-
    human(ProbY, X),
    ProbY > Y-3,
    ProbY < Y,
    not(not_south_safe(ProbY, Y, X)),
    %(not(orc(A, X)); not(A < Y); not(A > ProbY)),
    ProbX is X.

step(Y, X, ProbY, ProbX, (pass_west, ProbY, ProbX), 4):-
    human(Y, ProbX),
    ProbX > X - 3,
    ProbX < X,
    not(not_west_safe(ProbX, Y, X)),
    %(not(orc(Y, A)); not(A < X); not(A > ProbX)),
    ProbY is Y.

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
