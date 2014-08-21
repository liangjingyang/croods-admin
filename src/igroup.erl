
-module(igroup).

-export([
    event/1
    ]).

-include_lib("nitrogen_core/include/wf.hrl").
-include("croods_admin.hrl").

event(?S_GROUP) ->
    Body = group_body(),
    wf:replace(right_body, #panel{id = right_body, body = Body}),
    ok;

event({del_group, Group}) ->
    case dets:lookup(?D_GROUP, Group) of
	[] ->
	    ignore;
	[#d_group{user_list = UserList}] ->
	    lists:foreach(fun(U) ->
			case dets:lookup(?D_USER, U) of
			    [] ->
				ignore;
			    [UserRec] ->
				dets:insert(?D_USER, UserRec#d_user{group = ""})
			end
		end, UserList),
	    dets:delete(?D_GROUP, Group)
    end,
    event(?S_GROUP),
    misc:flash(wf:f("用户组 ~s 删除成功", [Group])),
    ok;

event(add_group) ->
    Group = string:strip(wf:q(groupbox)),
    case dets:lookup(?D_GROUP, Group) of
	[] ->
	    dets:insert(?D_GROUP, #d_group{group = Group});
	_G ->
	    ignore
    end,
    event(?S_GROUP),
    misc:flash(wf:f("用户组 ~s 添加成功", [Group])),
    ok;

event(Msg) ->
    misc:flash(#p{body = [wf:f("group event: ~p~n", [Msg])]}),
    ok.


group_body() ->

    wf:defer(addgroupbtn, groupbox, #validate { validators=[
		#is_required { text="Required" }
		]}),
    GroupList = dets:match_object(?D_GROUP, '_'),
    GroupList2 = lists:map(fun(G) ->
		    #d_group{group = Group, user_list = UserList} = G,
		    [Group, string:join(UserList, ","),
			{mod, ?MODULE, {del_group, Group}}]
	    end, GroupList),
    GroupMap = [
	    group@text,
	    user_list@text,
	    del_group@postback
	    ],
    [
	#h3{text = ?S_GROUP},
	#p{},
	"不同的用户组拥有不同的权限。",
	#p{}, 
	#br{},

	#table { style = "width:auto;", rows = [
		#tablerow{id = title, style = "background-color: #ccc;", cells = [
			#tablecell{text = "用户组"},
			#tablecell{text = "组成员列表"},
			#tablecell{text = "删除操作"}
			]},
		#bind { 
		    id=tableBinding, 
		    data = GroupList2, 
		    map = GroupMap, 
		    transform = fun misc:alternate_color/2,
		    body = #tablerow{id = top, cells = [
			    #tablecell{id = group},
			    #tablecell{id = user_list},
			    #tablecell{body = [#link{id = del_group, text = "删除"}]}
			    ]}}
		]},
	#br{},
	#hr{},
	#br{},
	#h3{text = "添加用户组"},
	#br{},
	#p{},
	#label { text="用户组"},
	#p{},
	#textbox {id=groupbox, next=addgroupbtn, style = "width:auto"},
	#p{},
	#button{id = addgroupbtn, postback = {mod, ?MODULE, add_group}, text = "添加用户组"},
	#p{},
	#br{}
	].
