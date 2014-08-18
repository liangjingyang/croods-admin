
-module(misc).

-include("croods_admin.hrl").

-compile(export_all).

request(Req) ->
    Ticket = "123456",
    Args = "faiengoi2ihvlkjg",
    Token = erlang:md5(Ticket ++ Args),
    ServerId = wf:q(server_list),
    {D, P} = get_server_by_id(ServerId),
    {ok, {{_, 200, _}, _, Data}} = httpc:request(post, 
	    {lists:concat(["http://", D, ":", P, "/"]), 
		[], 
		"application/octet-stream", 
		term_to_binary({{Token, Args}, Req})}, 
	    [{timeout, 5000}, {connect_timeout, 5000}], 
	    []),
    binary_to_term(list_to_binary(Data)).

get_server_by_id(Id) ->
    case lists:keyfind(Id, 1, get_server_list()) of
	false ->
	    ithrow("please select curect server!");
	{_, D, P} ->
	    {D, P}
    end.

get_server_list() ->
    [
	{"S1", "www.heromaze.com", 8443},
	{"S2", "www.heromaze.com", 8443},
	{"S3", "www.heromaze.com", 8443},
	{"S4", "www.heromaze.com", 8443},
	{"S5", "www.heromaze.com", 8443}
	].

ithrow(Error) ->
    erlang:throw({error, Error}).




