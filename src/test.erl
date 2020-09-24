-module(test).
-export([run/2]).

run(Sleep, Jitter) ->
    Log = log:start([dolores, fergal, michael, noel]),
    A = worker:start(dolores, Log, 13, Sleep, Jitter),
    B = worker:start(fergal, Log, 23, Sleep, Jitter),
    C = worker:start(michael, Log, 33, Sleep, Jitter),
    D = worker:start(noel, Log, 43, Sleep, Jitter),
    worker:peers(A, [B, C, D]),
    worker:peers(B, [A, C, D]),
    worker:peers(C, [A, B, D]),
    worker:peers(D, [A, B, C]),
    timer:sleep(5000),
    log:stop(Log),
    worker:stop(A),
    worker:stop(B),
    worker:stop(C),
    worker:stop(D).
%%-module(test).
%%-export([run/2]).
%%run(Sleep, Jitter) ->
%%    Log = log:start([john, paul, ringo, george]),
%%    A = worker:start(john, Log, 10, Sleep, Jitter),
%%    B = worker:start(paul, Log, 15, Sleep, Jitter),
%%    C = worker:start(ringo, Log, 10, Sleep, Jitter),
%%    D = worker:start(george, Log, 10, Sleep, Jitter),
%%    worker:peers(A, [B]),
%%    worker:peers(B, [A]),
%%%%worker:peers(C, [A, B, D]),
%%%%worker:peers(D, [A, B, C]),
%%    timer:sleep(5000),
%%    log:stop(Log),
%%    worker:stop(A),
%%    worker:stop(B).
%%%%worker:stop(C),
%%%%worker:stop(D).
