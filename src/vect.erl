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




%% API
-export([]).
