orc(3,4).
touchdown(3,2).
human(3,0).
:- dynamic(solution/2).

borders(Y,X) :-
    Y =< 4,
    Y >= 0,
    X =< 4,
    X >= 0.

safe(Y,X, Sequence) :-
    not(orc(Y,X)),
    not(memberchk((Y, X), Sequence)).

not_north_safe(ProbY, Y, X):-
    orc(A, X), A > Y, A < ProbY.
not_south_safe(ProbY, Y, X):-
   orc(A, X), A < Y, A > ProbY.
not_west_safe(ProbX, Y, X):-
    orc(Y, A), A < X, A > ProbX.
not_east_safe(ProbX, Y, X):-
    orc(Y, A), A > X, A < ProbX.

touchdown_in_vis_area(Y, X, ProbY, ProbX, Move):-
    step(Y, X, ProbY, ProbX, Move),
    touchdown(ProbY, ProbX).

run(X, Y) :-
  retractall(solution(_,_)),
  findall(Steps, rugbyRecursive(0, 0, _, [(0,0)], Steps, 0), List),
  solution(_,_) ->
  min_list(List, X),
  solution(X, Y);
  writeln("Algorithm didn't find a path").


% final stage - we found touchdown
rugbyRecursive(Y, X, [], Sequence, Steps, Flag) :-
    Flag = 1,
    touchdown(Y, X).

rugbyRecursive(Y, X, [Move], Sequence, Steps, Flag):-
    touchdown_in_vis_area(Y, X, ProbY, ProbX, Move).

rugbyRecursive(Y, X, [Move | Actions], Sequence, Steps, Flag) :-
    Flag = 0,
    step(Y, X, ProbY, ProbX, Move),
    probe(ProbY, ProbX, Actions, Sequence, Steps, 1),
    length([Move | Actions], Steps),
    not(solution(Steps, _)),
    assert(solution(Steps, [Move | Actions])).

rugbyRecursive(Y, X, [Move | Actions], Sequence, Steps, Flag) :-
    Flag = 1,
    step(Y, X, ProbY, ProbX, Move),
    probe(ProbY, ProbX, Actions, Sequence, Steps, 1).

probe(Y, X, Actions, Sequence, Steps, Flag) :-
    borders(Y, X),
    safe(Y, X, Sequence),
    rugbyRecursive(Y, X, Actions, [(Y, X) | Sequence], Steps, Flag).

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

step(Y, X, ProbY, ProbX, (pass_north, ProbY, ProbX)):-
    human(ProbY, X),
    ProbY > Y,
    not(not_north_safe(ProbY, Y, X)),
    %(not(orc(A, X)); not(A > Y); not(A < ProbY)),
    ProbX is X.

step(Y, X, ProbY, ProbX, (pass_south, ProbY, ProbX)):-
    human(ProbY, X),
    ProbY < Y,
    not(not_south_safe(ProbY, Y, X)),
    %(not(orc(A, X)); not(A < Y); not(A > ProbY)),
    ProbX is X.

step(Y, X, ProbY, ProbX, (pass_west, ProbY, ProbX)):-
    human(Y, ProbX),
    ProbX < X,
    not(not_west_safe(ProbX, Y, X)),
    %(not(orc(Y, A)); not(A < X); not(A > ProbX)),
    ProbY is Y.

step(Y, X, ProbY, ProbX, (pass_east, ProbY, ProbX)):-
    human(Y, ProbX),
    ProbX > X,
    not(not_east_safe(ProbX, Y, X)),
    %(not(orc(Y, A)); not(A > Y); not(A < ProbX)),
    ProbY is Y.

%time(run(Steps, Moves)).
