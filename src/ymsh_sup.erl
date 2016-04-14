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

-module(ymsh_sup).
-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-include_lib("yolf/include/yolf.hrl").

-define(SERVER, ?MODULE).

start_link(Cfg) ->
    ?LOG_SUPERVISOR(?SERVER),
    supervisor:start_link({local, ?SERVER}, ?MODULE, [Cfg]).

init([_Cfg]) ->
    ?LOG_SUPERVISOR_INIT(?SERVER),

    EventMngr = ?WORKER(ymsh_event),

    Children = [EventMngr],

    {ok, {{one_for_one, 2, 10}, Children}}.
