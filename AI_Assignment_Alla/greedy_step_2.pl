%Alla Chepurova
% query to run - time(run(Steps, Moves)).

%=====the map======
orc(2,0).
human(1,2).
touchdown(0,4).

%========dynamic predicates which used to identify the best solution and make only one pass========
:- dynamic(pass/1).
:- dynamic(solution/1).

%==========predicate to identify borders==========
borders(Y,X) :-
    Y =< 4,
    Y >= 0,
    X =< 4,
    X >= 0.

%==========predicate to identify whether we are on the safe cell===========
safe(Y, X) :-
    not(orc(Y, X)),
    borders(Y, X).

%=========set of predicates which identify whether passes of different directions will be safe==========
not_north_safe(ProbY, Y, X):-
    orc(A, X), A > Y, A < ProbY.
not_south_safe(ProbY, Y, X):-
   orc(A, X), A < Y, A > ProbY.
not_west_safe(ProbX, Y, X):-
    orc(Y, A), A < X, A > ProbX.
not_east_safe(ProbX, Y, X):-
    orc(Y, A), A > X, A < ProbX.

not_north_east_safe(X, Y, A):-
    orc(Y1, X1),
    B1 = Y1 - Y,
    B2 = X1 - X,
    B1 =:= B2,
    A > B1.
not_north_west_safe(X, Y, A):-
    orc(Y1, X1),
    B1 = Y1 - Y,
    B2 = X - X1,
    B1 =:= B2,
    A > B1.
not_south_east_safe(X, Y, A):-
    orc(Y1, X1),
    B1 = Y - Y1,
    B2 = X1 - X,
    B1 =:= B2,
    A > B1.
not_south_west_safe(X, Y, A):-
    orc(Y1, X1),
    B1 = Y - Y1,
    B2 = X - X1,
    B1 =:= B2,
    A > B1.

%==========the main function, whether find the path or inform about fail===========
run(Length, Path) :-
    retractall(solution(_)),
    assert(pass(1)),
    rugby(0,0, Path, 0),
    solution(1) -> length(Path, Length);
    writeln("Algorithm didn't find a path").

%==========are there touchdown in area we are able to see===========
touchdown_in_vis_area(Y, X, ProbY, ProbX, Move):-
    touchdown(ProbY, ProbX), A is abs(ProbX - X),
    B is abs(ProbY - Y), A < 2, B < 2 -> step(Y, X, ProbY, ProbX, Move, Dir), Dir < 4.

%==========final stage - we found touchdown (recursive base), but is it situated on two cells further=========
rugby(Y, X, [Move], Attempt):-
    Attempt < 100,
    touchdown_in_vis_area(Y, X, ProbY, ProbX, Move)-> assert(solution(1)).

regby(Y, X, [FirstMove, SecondMove], StepNum):-
    Attempt < 100,
    step(Y, X, ProbY, ProbX, FirstMove, Dir),
    safe(ProbY, ProbX),
    touchdown_in_vis_area(ProbY, ProbX, ProbYY, ProbXX, SecondMove) -> assert(solution(1)).

%===========recursive step==========
rugby(Y, X, [Move | Actions], Attempt):-
    Attempt < 100,
    random(0, 5, Dir), step(Y, X, ProbY, ProbX, Move, Dir), safe(ProbY, ProbX)->
    Newattempt is Attempt + 1, rugby(ProbY, ProbX, Actions, Newattempt);
    Attempt < 100,
    step(Y, X, ProbY, ProbX, Move, OtherDir), safe(ProbY, ProbX), !,
    Newattempt is Attempt + 1,
    rugby(ProbY, ProbX, Actions, Newattempt).

%==========functions for passes in different directions==========
step(Y, X, ProbY, ProbX, (pass_north_east, ProbY, ProbX), 4):-
    pass(1),
    human(ProbY, ProbX),
    A is ProbY - Y,
    B is ProbX - X,
    A =:= B,
    A < 3,
    not(not_north_east_safe(Y, X, A)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y + A,
    ProbX is X + A,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_north_west, ProbY, ProbX), 4):-
    pass(1),
    human(ProbY, ProbX),
    A is ProbY - Y,
    B is X - ProbX,
    A =:= B,
    A < 3,
    not(not_north_west_safe(Y, X, A)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y + A,
    ProbX is X - A,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_south_west, ProbY, ProbX), 4):-
    pass(1),
    human(ProbY, ProbX),
    A is Y - ProbY,
    B is X - ProbX,
    A =:= B,
    A < 3,
    not(not_south_west_safe(Y, X, A)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y - A,
    ProbX is X - A,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_south_east, ProbY, ProbX), 4):-
    pass(1),
    human(ProbY, ProbX),
    A is Y - ProbY,
    B is ProbX - X,
    A =:= B,
    A < 3,
    not(not_south_east_safe(Y, X, A)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y - A,
    ProbX is X - A,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_north, ProbY, ProbX), 4):-
    pass(1),
    human(ProbY, X),
    ProbY > Y,
    not(not_north_safe(ProbY, Y, X)),
    %(not(orc(A, X)); not(A > Y); not(A < ProbY)),
    ProbX is X,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_south, ProbY, ProbX), 4):-
    pass(1),
    human(ProbY, X),
    ProbY < Y,
    not(not_south_safe(ProbY, Y, X)),
    %(not(orc(A, X)); not(A < Y); not(A > ProbY)),
    ProbX is X,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_west, ProbY, ProbX), 4):-
    pass(1),
    human(Y, ProbX),
    ProbX < X,
    not(not_west_safe(ProbX, Y, X)),
    %(not(orc(Y, A)); not(A < X); not(A > ProbX)),
    ProbY is Y,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_east, ProbY, ProbX), 4):-
    pass(1),
    human(Y, ProbX),
    ProbX > X,
    not(not_east_safe(ProbX, Y, X)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y,
    retractall(pass(1)).

%==========functions for steps - just go up, down, left, right==========
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
