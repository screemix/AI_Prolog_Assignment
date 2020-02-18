orc(4,4).
touchdown(1,3).

borders(Y,X) :-
    Y =< 4,
    Y >= 0,
    X =< 4,
    X >= 0.

safe(Y,X, Sequence) :-
    not(orc(Y,X)),
    not(memberchk((Y, X), Sequence)).

% launch
run(Moves, Steps) :-
  regbyRecursive(0, 0, Moves, [(0,0)]),
  length(Moves, Steps).

% final stage - we found touchdown
regbyRecursive(Y, X, [], Sequence) :-
    touchdown(Y, X).

regbyRecursive(Y, X, [Move | Actions], Sequence) :-
    step(Y, X, ProbY, ProbX, Move),
    probe(ProbY, ProbX, Actions, Sequence).

probe(Y, X, Actions, Sequence) :-
    borders(X,Y),
    safe(Y, X, Sequence),
    regbyRecursive(Y, X, Actions, [(Y, X) | Sequence]).

step(Y, X, ProbY, ProbX, east) :-
    ProbY is Y,
    ProbX is X + 1.

step(Y, X, ProbY, ProbX, north) :-
    ProbY is Y + 1,
    ProbX is X.

step(Y, X, ProbY, ProbX, west) :-
    ProbY is Y,
    ProbX is X - 1.

step(Y, X, ProbY, ProbX, south) :-
    ProbY is Y - 1,
    ProbX is X.
