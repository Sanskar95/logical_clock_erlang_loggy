%%%-------------------------------------------------------------------
%%% @author Sanskar95
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Sep 2020 01:18
%%%-------------------------------------------------------------------
-author("Sanskar95").
-module(vect).


zero() -> [].

inc(Name, Time) ->
  case lists:keyfind(Name, 1, Time) of
    {Name, T} ->

      lists:keyreplace(Name, 1, Time, {Name, T + 1});
    false ->
      [{Name, 0} | Time]
  end.

merge([], Time) ->
  Time;
merge([{Name, Ti} | Rest], Time) ->
  case lists:keyfind(Name, 1, Time) of
    {Name, Tj} ->
      [{Name, Tj} | merge(Rest, lists:keydelete(Name, 1, Time))];
    false ->
      [{Name, Ti} | merge(Rest, Time)]
  end.

leq([], _) ->
  true;
leq([{Name, Ti} | Rest], Time) ->
  case lists:keyfind(Name, 1, Time) of
    {Name, Tj} ->
      if
        Ti =< Tj ->
          true;
        true ->
          false

      end;
    false ->

      leq(Rest, Time)
  end.

clock(Nodes) ->
  lists:foldl(fun(Node, Acc) -> [{Node, zero()} | Acc] end, [], Nodes).

update(From, Time, Clock) ->
  {_Name, Tj} = lists:keyfind(From, 1, Time),
  case lists:keyfind(From, 1, Clock) of
    {From, _} ->
      lists:keyreplace(From, 1, Clock, {From, Time});
    false ->
      [{From, Time} | Clock]
  end.

safe(Time, Clock) ->
  SafeFlagList = [],
  lists:foreach(fun({Name, Ti}) ->
    case lists:keyfind(Name, 1, Clock) of
      {Name, TimeInClock} ->
        lists:append(leq(Time, TimeInClock), SafeFlagList);
      false ->
        lists:append(true, SafeFlagList)
    end
                end, Time),

  case length(SafeFlagList) == length(Time) of
    true ->
      true;
    false ->
      false
  end.
%% API
-export([safe/2, update/3, clock/1, inc/2, zero/0, merge/2]).
