%Alla Chepurova
% query to run - time(run(Steps, Moves)).

%=====the map======
orc(0,4).
touchdown(3,4).
human(3,3).

%========dynamic predicates which used to identify the best solution and make only one pass========
:- dynamic(solution/2).
:- dynamic(pass/1).

%==========predicate to identify borders==========
borders(Y,X) :-
    Y =< 4,
    Y >= 0,
    X =< 4,
    X >= 0.

%==========predicate to identify whether we are on the safe cell===========
safe(Y,X, Sequence) :-
    not(orc(Y,X)),
    not(memberchk((Y, X), Sequence)).

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
run(X, Y) :-
  assert(pass(1)),
  retractall(solution(_,_)),

  %finding all the path, writing all of them to array
  findall(Steps, regbyRecursive(0, 0, _, [(0,0)], Steps, 0), List),

  %if there is any solution - write the best one
  solution(_,_) ->
  min_list(List, X),
  solution(X, Y);

  %or else inform about fail
  writeln("Algorithm didn't find a path").


%==========final stage - we found touchdown=========
regbyRecursive(Y, X, [], Sequence, Steps, Flag) :-
    Flag = 1,
    touchdown(Y, X).

%==========separate function for recursive step to identify our first move and calculate the length=========
regbyRecursive(Y, X, [Move | Actions], Sequence, Steps, Flag) :-
    Flag = 0,
    step(Y, X, ProbY, ProbX, Move),
    probe(ProbY, ProbX, Actions, Sequence, Steps, 1),
    length([Move | Actions], Steps),
    not(solution(Steps, _)),

    %important moment - identify the facts database that there is a solution!
    assert(solution(Steps, [Move | Actions])).

%=========just intermediate recursive step==========
regbyRecursive(Y, X, [Move | Actions], Sequence, Steps, Flag) :-
    Flag = 1,
    step(Y, X, ProbY, ProbX, Move),
    probe(ProbY, ProbX, Actions, Sequence, Steps, 1).

%=========checking for acceptance and go further==========
probe(Y, X, Actions, Sequence, Steps, Flag) :-
    borders(Y, X),
    safe(Y, X, Sequence),
    regbyRecursive(Y, X, Actions, [(Y, X) | Sequence], Steps, Flag).

%==========functions for passes in different directions==========
step(Y, X, ProbY, ProbX, (pass_north_east, ProbY, ProbX)):-
    pass(1) ->
    human(ProbY, ProbX),
    A is ProbY - Y,
    B is ProbX - X,
    A =:= B,
    not(not_north_east_safe(Y, X, A)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y + A,
    ProbX is X + A,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_north_west, ProbY, ProbX)):-
    pass(1) ->
    human(ProbY, ProbX),
    A is ProbY - Y,
    B is X - ProbX,
    A =:= B,
    not(not_north_west_safe(Y, X, A)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y + A,
    ProbX is X - A,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_south_west, ProbY, ProbX)):-
    pass(1) ->
    human(ProbY, ProbX),
    A is Y - ProbY,
    B is X - ProbX,
    A =:= B,
    not(not_south_west_safe(Y, X, A)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y - A,
    ProbX is X - A,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_south_east, ProbY, ProbX)):-
    pass(1) ->
    human(ProbY, ProbX),
    A is Y - ProbY,
    B is ProbX - X,
    A =:= B,
    not(not_south_east_safe(Y, X, A)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y - A,
    ProbX is X - A,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_north, ProbY, ProbX)):-
    pass(1) ->
    human(ProbY, X),
    ProbY > Y,
    not(not_north_safe(ProbY, Y, X)),
    %(not(orc(A, X)); not(A > Y); not(A < ProbY)),
    ProbX is X,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_south, ProbY, ProbX)):-
   	pass(1) ->
    human(ProbY, X),
    ProbY < Y,
    not(not_south_safe(ProbY, Y, X)),
    %(not(orc(A, X)); not(A < Y); not(A > ProbY)),
    ProbX is X,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_west, ProbY, ProbX)):-
    pass(1) ->
    human(Y, ProbX),
    ProbX < X,
    not(not_west_safe(ProbX, Y, X)),
    %(not(orc(Y, A)); not(A < X); not(A > ProbX)),
    ProbY is Y,
    retractall(pass(1)).

step(Y, X, ProbY, ProbX, (pass_east, ProbY, ProbX)):-
    pass(1) ->
    human(Y, ProbX),
    ProbX > X,
    not(not_east_safe(ProbX, Y, X)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y,
    retractall(pass(1)).

%==========functions for steps - just go up, down, left, right==========

step(Y, X, ProbY, ProbX, east) :-
    ProbY is Y,
    ProbX is X + 1.

step(Y, X, ProbY, ProbX, north) :-
    ProbY is Y + 1,
    ProbX is X.

step(Y, X, ProbY, ProbX, west) :-
    ProbY is Y,
    ProbX is X - 1.

step(Y,X,ProbY, ProbX, south) :-
    ProbY is Y - 1,
    ProbX is X.
