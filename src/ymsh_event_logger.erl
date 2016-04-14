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

-module(ymsh_event_logger).
-behaviour(gen_event).

-export([add_handler/0, delete_handler/0]).

-export([init/1, handle_event/2, handle_call/2,
         handle_info/2, code_change/3, terminate/2]).

-include_lib("yolf/include/yolf.hrl").

-record(state, {}).

add_handler() ->
    ymsh_event:add_handler(?MODULE, []).

delete_handler() ->
    ymsh_event:delete_handler(?MODULE, []).

init([]) ->
    ?LOG_WORKER_INIT(?MODULE),
    {ok, #state{}}.

handle_event({example_log, Err}, State) ->
    error_logger:error_msg("Error example log: ~p~n", [Err]),
    {ok, State}.

handle_call(_Request, State) ->
    {ok, ok, State}.

handle_info(_Info, State) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
