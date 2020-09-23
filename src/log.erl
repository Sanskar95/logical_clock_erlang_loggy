-module(log).
-export([start/1, stop/1]).

start(Nodes) ->
  spawn_link(fun() -> init(Nodes) end).

stop(Logger) ->
  Logger ! stop.

init(Nodes) ->
  loop(time:clock(Nodes), []).

loop(Clock, HoldBackQ) ->
  receive
    {log, From, Time, Msg} ->
      UpdatedClock = time:update(From, Time, Clock),
      SortedQueue = lists:keysort(2, [{From, Time, Msg} | HoldBackQ]),
      InvalidMessageQueue = iterateAndValidate(SortedQueue, UpdatedClock, []),
      loop(UpdatedClock, InvalidMessageQueue);
    stop ->
      ok
  end.

log(From, Time, Msg) ->
  io:format("log: ~w ~w ~p~n", [Time, From, Msg]).


%iterate over the sorted queue and check for safe messages and print else put them to queue again
iterateAndValidate(SortedQueue, Clock, InvalidMessageQueue) ->
  lists:foreach(fun({From, Time, Msg}) ->
%%    io:format("log: ~w  ~p~n", [Clock, Time]),
    case time:safe(Time, Clock) of
      true ->
        log(From, Time, Msg);
      false ->
        lists:append([{From, Time, Msg}], InvalidMessageQueue)
    end
                end, SortedQueue),
  InvalidMessageQueue.