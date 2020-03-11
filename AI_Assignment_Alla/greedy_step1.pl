%Alla Chepurova
% query to run - time(run(Steps, Moves)).

%=====the map======
orc(1,0).
touchdown(3,3).
human(2,2).

%========dynamic predicates which used to identify the best solution and make only one pass========
:- dynamic(human/2).
:- dynamic(solution/1).
:- dynamic(pass/1).

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
    assert(pass(1)),
    retractall(solution(_)),
    rugby(0,0, Path, 0),
    solution(1) -> length(Path, Length);
    writeln("Algorithm didn't find a path").

%==========final stage - we found touchdown=========
rugby(Y, X, [], Attempt):-
    Attempt < 100,
    touchdown(Y, X) -> assert(solution(1)).

%===========recursive step==========
rugby(Y, X, [Move | Actions], Attempt):-
    Attempt < 100,
    random(0, 4, Dir), step(Y, X, ProbY, ProbX, Move, Dir), safe(ProbY, ProbX)->
    Newattempt is Attempt + 1, rugby(ProbY, ProbX, Actions, Newattempt);
    Attempt < 100,
    step(Y, X, ProbY, ProbX, Move, OtherDir), safe(ProbY, ProbX), !,
    Newattempt is Attempt + 1,
    rugby(ProbY, ProbX, Actions, Newattempt).

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
