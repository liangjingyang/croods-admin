
-module(misc).

-include("croods_admin.hrl").

-compile(export_all).

-define(GLOBAL_FLASH_ID, global_flash_id).

init() ->
    config_dyn:init(),
    dets:open_file(?D_LOG, [{file, "site/database/admin_log.dets"}]),
    dets:open_file(?D_MISC, [{file, "site/database/admin_misc.dets"}]),
    dets:open_file(?D_USER, [{file, "site/database/admin_user.dets"}, {keypos, #d_user.name}]),
    dets:open_file(?D_GROUP, [{file, "site/database/admin_group.dets"}, {keypos, #d_group.group}]),
    ets:new(?E_MISC, [named_table, public]),
    case dets:match_object(?D_USER, '_') of
	[] ->
	    dets:insert(?D_USER, #d_user{name = "admin", passwd = "admin", group = "admin"});
	_ ->
	    ignore
    end,
    case dets:match_object(?D_GROUP, '_') of
	[] ->
	    dets:insert(?D_GROUP, #d_group{group = "admin", 
		    access_list = ?ACCESS_LIST, user_list = ["admin"]});
	_ ->
	    ignore
    end,
    ok.

reset_user_admin() ->
    dets:insert(?D_USER, #d_user{name = "admin", passwd = "admin", group = "admin"}),
    dets:insert(?D_GROUP, #d_group{group = "admin", 
	    access_list = ?ACCESS_LIST, user_list = ["admin"]}).


flash(Element) ->
    wf:remove(?GLOBAL_FLASH_ID),
    wf:flash(?GLOBAL_FLASH_ID, Element).

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
	{"S1", "www.heromaze.com", 20136},
	{"S2", "www.heromaze.com", 20136},
	{"S3", "www.heromaze.com", 20136},
	{"S4", "www.heromaze.com", 20136},
	{"S5", "www.heromaze.com", 20136}
	].

ithrow(Error) ->
    erlang:throw({error, Error}).




