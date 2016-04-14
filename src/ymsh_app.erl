%% Copyright 2016 Grzegorz Junka
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(ymsh_app).
-behaviour(application).

-export([start/2, stop/1]).

-include("ymsh.hrl").

start(_StartType, _StartArgs) ->
    ylog:init(),
    ylog:tin(<<"Ygramesh: Log started.">>),
    case setup() of
        {error, _} = Err -> Err;
        Cfg -> start_sup(Cfg)
    end.

setup() ->
    try
        {ok, Mod} = application:get_env(ygramesh, storage_app),
        true = is_atom(Mod),
        Cfg = #cfg{store = Mod},
        ylog:in(<<"Read config:">>, endl, Cfg, endl,
                <<"Starting: ">>, Mod, endl),
        ok = application:start(Mod),
        Cfg
    catch
        throw:Term -> {error, Term};
        error:Term -> {error, Term}
    end.

start_sup(Cfg) ->
    case ymsh_sup:start_link(Cfg) of
        {ok, Pid} ->
            ymsh_event_logger:add_handler(),
            {ok, Pid};
        Other ->
            {error, Other}
    end.

stop(_State) ->
    ylog:tin(<<"Ygramesh: Stopping log.">>),
    ylog:stop(),
    ok.
