

-module(account).

-export([
    event/1
    ]).

-include_lib("nitrogen_core/include/wf.hrl").
-include("croods_admin.hrl").

event(?S_ACCOUNT) ->
    Body = account_body(),
    wf:replace(right_body, #panel{id = right_body, body = Body}),
    ok;

event(?S_GROUP) ->
    ok;

event(?S_ACCESS) ->
    ok;

event(Msg) ->
    misc:flash(#p{body = [wf:f("player_info event: ~p~n", [Msg])]}),
    ok.


account_body() ->
    UserList = dets:match_object(?D_USER, '_'),
    UserList2 = lists:map(fun(U) ->
		    #d_user{name = Name, group = Group} = U,
		    [Name, Group]
	    end, UserList),
    UserList3 = [["用户名", "用户组"]|UserList2],
    UserMap = [
	    user@text,
	    group@text
	    ],
    [
	#h3{text = "用户管理"},
	#br{},

	#table { style = "width:auto;", rows=[
		#bind { 
		    id=tableBinding, 
		    data=UserList3, 
		    map=UserMap, 
		    body=#tablerow { cells=[
			    #tablecell {id=user, 
				style = "text-align:right; background-color:#ddd"},
			    #tablecell {id=group, 
				style = "text-align:left; background-color:#eee"}
			    ]}}
		]},
	#br{}
	].
