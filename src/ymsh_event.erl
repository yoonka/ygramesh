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

-module(ymsh_event).

-export([start_link/0,
         add_handler/2,
         delete_handler/2]).

-export([example_log/1]).

-include_lib("yolf/include/yolf.hrl").

-define(SERVER, ?MODULE).

start_link() ->
    ?LOG_WORKER(?SERVER),
    gen_event:start_link({local, ?SERVER}).

add_handler(Handler, Args) ->
    ok = gen_event:add_handler(?SERVER, Handler, Args).

delete_handler(Handler, Args) ->
    ok = gen_event:delete_handler(?SERVER, Handler, Args).

%%------------------------------------------------------------------------------

example_log(Err) ->
    gen_event:notify(?SERVER, {example_log, Err}).
