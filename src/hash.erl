%%
%%   Copyright 2012 Dmitry Kolesnikov, All Rights Reserved
%%
%%   Licensed under the Apache License, Version 2.0 (the "License");
%%   you may not use this file except in compliance with the License.
%%   You may obtain a copy of the License at
%%
%%       http://www.apache.org/licenses/LICENSE-2.0
%%
%%   Unless required by applicable law or agreed to in writing, software
%%   distributed under the License is distributed on an "AS IS" BASIS,
%%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%   See the License for the specific language governing permissions and
%%   limitations under the License.
%%
%% @doc
%%
-module(hash).

-export([fnv32/1, fnv32a/1, fnv32m/1]).
-export([fnv64/1, fnv64a/1]).
-export([fnv128/1, fnv128a/1]).
-export([seq31/1, seq32/1]).
-export([fold32/1]).
-export([buz32/1, buz32/2]).
-export([pbkdf2/5]).
-export([geo/1, geo/2]).


%%
%% Fowler–Noll–Vo
-spec fnv32(_) -> integer().
-spec fnv32a(_) -> integer().
-spec fnv32m(_) -> integer().
-spec fnv64(_) -> integer().
-spec fnv64a(_) -> integer().
-spec fnv128(_) -> integer().
-spec fnv128a(_) -> integer().

fnv32(X)  -> hash_fnv:fnv32(s(X)).
fnv32a(X) -> hash_fnv:fnv32a(s(X)).
fnv32m(X) -> hash_fnv:fnv32m(s(X)).
fnv64(X)  -> hash_fnv:fnv64(s(X)).
fnv64a(X) -> hash_fnv:fnv64a(s(X)).
fnv128(X)  -> hash_fnv:fnv128(s(X)).
fnv128a(X) -> hash_fnv:fnv128a(s(X)).


%%
%% Uniformly distributed pseudo-random sequences
-spec seq31(integer()) -> integer().
-spec seq32(integer()) -> integer().

seq31(X) when is_integer(X) -> hash_seq:seq31(X).
seq32(X) when is_integer(X) -> hash_seq:seq32(X).


%%
%% XOR folding
-spec fold32(_) -> integer().

fold32(X) -> hash_fold:fold32(s(X)).


%%
%% Cyclic polynomial (BuzHash)
-spec buz32(integer()) -> _.
-spec buz32(_, _) -> {integer(), _}.

buz32(X) -> hash_buz:buz32(X).
buz32(X, Hash) -> hash_buz:buz32(X, Hash).


%%
%% Password-Based Key Derivation Function 2
-spec pbkdf2(atom(), binary(), binary(), integer(), integer()) -> binary().

pbkdf2(PRF, Pass, Salt, C, DkLen) ->  hash_pbkdf2:pbkdf2(PRF, Pass, Salt, C, DkLen).


%%
%% Geo Hash
-spec geo(binary() | {number(), number()}) -> {number(), number()} | binary().
-spec geo(number(), number()) -> binary().

geo(X) when is_binary(X) -> hash_geo:decode(X);
geo({_, _} = X) -> hash_geo:encode(X).

geo(Lat, Lng) -> hash_geo:encode({Lat, Lng}).

%%%----------------------------------------------------------------------------   
%%%
%%% private
%%%
%%%----------------------------------------------------------------------------   

s(X) when is_binary(X) -> X;
s(X) when is_list(X)   -> iolist_to_binary(X).
