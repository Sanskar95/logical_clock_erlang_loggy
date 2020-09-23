-module(worker).

-export([start/5, stop/1, peers/2]).

start(Name, Logger, Seed, Sleep, Jitter) ->
    spawn_link(fun() -> init(Name, Logger, Seed, Sleep, Jitter) end).

stop(Worker) ->
    Worker ! stop.

init(Name, Log, Seed, Sleep, Jitter) ->
    random:seed(Seed, Seed, Seed),
    receive
	{peers, Peers} ->
	    loop(Name, Log, Peers, Sleep, Jitter, time:zero());
	stop ->
	    ok
    end.

peers(Wrk, Peers) ->
    Wrk ! {peers, Peers}.

loop(Name, Log, Peers, Sleep, Jitter, Time) ->
    Wait = random:uniform(Sleep),
    receive
	{msg, Time, Msg} ->
	    UpdatedTime = time:inc(Name, time:merge(Time, Time)),
	    Log ! {log, Name, UpdatedTime, {received, Msg}},
	    loop(Name, Log, Peers, Sleep, Jitter, UpdatedTime);
	stop ->
	    ok;
	Error ->
	    Log ! {log, Name, time, {error, Error}}
    after Wait ->
	    Selected = select(Peers),
			UpdatedTime = time:inc(Name, Time),
	    Message = {hello, random:uniform(500)},
	    Selected ! {msg, UpdatedTime, Message},
	    jitter(Jitter),
	    Log ! {log, Name, UpdatedTime, {sending, Message}},
	    loop(Name, Log, Peers, Sleep, Jitter, UpdatedTime)
    end.

select(Peers) ->
    lists:nth(random:uniform(length(Peers)), Peers).

jitter(0) ->
    ok;
jitter(Jitter) ->
    timer:sleep(random:uniform(Jitter)).
