
-module(misc).

-include("croods_admin.hrl").

-compile(export_all).

request(Req) ->
    Ticket = "123456",
    Args = "faiengoi2ihvlkjg",
    Token = erlang:md5(Ticket ++ Args),
    {ok, {{_, 200, _}, _, Data}} = httpc:request(post, 
	    {"http://www.heromaze.com:8443/", 
		[], 
		"text/html", 
		term_to_binary({{Token, Args}, Req})}, 
	    [], 
	    []),
    binary_to_term(list_to_binary(Data)).

