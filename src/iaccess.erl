
-module(iaccess).

-export([
    event/1
    ]).

-include_lib("nitrogen_core/include/wf.hrl").
-include("croods_admin.hrl").

event(?S_ACCESS) ->
    Body = access_body(),
    wf:replace(right_body, #panel{id = right_body, body = Body}),
    ok;

event({edit_access, Group}) ->
    [#d_group{access_list = AccessList}] = dets:lookup(?D_GROUP,
	    Group),
    CellId = "access_list" ++ Group,
    wf:replace(edit_access, #link{id = edit_access, text = "保存", postback =
	    {mod, ?MODULE, {edit_access_confirm, Group}}}),
    wf:replace(CellId, access_table(?ACCESS_LIST, CellId)),
    lists:foreach(fun(A) ->
		wf:replace("access" ++ A, #checkbox{id = "access" ++ A, text = A, checked = true})
	end, AccessList),
    ok;

event({edit_access_confirm, Group}) ->
    AccessList = lists:foldl(fun(A, Acc) ->
		case wf:q("access" ++ A) of
		    "on" ->
			[A|Acc];
		    _ ->
			Acc
		end
	end, [], ?ACCESS_LIST),
    io:format("access newlist :~p~n", [AccessList]),
    [GroupRec] = dets:lookup(?D_GROUP, Group),
    dets:insert(?D_GROUP, GroupRec#d_group{access_list = AccessList}),
    CellId = "access_list" ++ Group,
    wf:replace(edit_access, #link{id = edit_access, text = "编辑权限", 
	    postback = {mod, ?MODULE, {edit_access, Group}}}),
    wf:replace(CellId, #tablecell{id = CellId, text = string:join(AccessList, ",")}),
    misc:flash("保存成功"),
    ok;


event(Msg) ->
    misc:flash(#p{body = [wf:f("group event: ~p~n", [Msg])]}),
    ok.

access_body() ->

    GroupList = dets:match_object(?D_GROUP, '_'),
    GroupList2 = lists:map(fun(G) ->
		    #d_group{group = Group, access_list = AccessList} = G,
		    [Group, "access_list" ++ Group, string:join(AccessList, ","),
			{mod, ?MODULE, {edit_access, Group}}]
	    end, GroupList),
    GroupMap = [
	    group@text,
	    access_list@id,
	    access_list@text,
	    edit_access@postback
	    ],
    [
	#h3{text = ?S_ACCESS},
	#p{},
	"不同的用户组拥有不同的权限。",
	#p{}, 
	#br{},

	#table { style = "width:auto;", rows = [
		#tablerow{id = title, style = "background-color: #ccc;", cells = [
			#tablecell{text = "用户组"},
			#tablecell{text = "权限列表"},
			#tablecell{text = "编辑权限"}
			]},
		#bind { 
		    id=tableBinding, 
		    data = GroupList2, 
		    map = GroupMap, 
		    transform = fun misc:alternate_color/2,
		    body = #tablerow{id = top, cells = [
			    #tablecell{id = group},
			    #tablecell{id = access_list},
			    #tablecell{body = [#link{id = edit_access, text = "编辑权限"}]}
			    ]}}
		]},
	#br{}
	].

access_table(List, Id) ->
    Rows = access_table_row(List, []),
    #table{id = Id, rows = lists:reverse(Rows)}.

access_table_row([], Acc) ->
    Acc;
access_table_row([A1], Acc) ->
    Row = 
	#tablerow{id = top, cells = [
		#tablecell{body = #checkbox{id = "access" ++ A1, text = A1}}
		]},
    [Row|Acc];
access_table_row([A1, A2], Acc) ->
    Row = 
	#tablerow{id = top, cells = [
		#tablecell{body = #checkbox{id = "access" ++ A1, text = A1}},
		#tablecell{body = #checkbox{id = "access" ++ A2, text = A2}}
		]},
    [Row|Acc];
access_table_row([A1, A2, A3|T], Acc) ->
    Row = 
	#tablerow{id = top, cells = [
		#tablecell{body = #checkbox{id = "access" ++ A1, text = A1}},
		#tablecell{body = #checkbox{id = "access" ++ A2, text = A2}},
		#tablecell{body = #checkbox{id = "access" ++ A3, text = A3}}]},
    access_table_row(T, [Row|Acc]).

