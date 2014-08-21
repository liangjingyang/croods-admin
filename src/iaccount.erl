

-module(iaccount).

-export([
    event/1
    ]).

-include_lib("nitrogen_core/include/wf.hrl").
-include("croods_admin.hrl").

event(?S_ACCOUNT) ->
    Body = account_body(),
    wf:replace(right_body, #panel{id = right_body, body = Body}),
    ok;

event(add_account) ->
    User = string:strip(wf:q(userbox)),
    Passwd = string:strip(wf:q(passwdbox)),
    Group = string:strip(wf:q(groupdrop)),
    case dets:lookup(?D_USER, User) of
	[] ->
	    case dets:lookup(?D_GROUP, Group) of
		[#d_group{user_list = UserList} = GroupRec] ->
		    UserRec = #d_user{name = User, passwd = Passwd, group = Group},
		    dets:insert(?D_USER, UserRec),
		    UserList2 = [User|lists:delete(User, UserList)],
		    dets:insert(?D_GROUP, GroupRec#d_group{user_list = UserList2}),
		    event(?S_ACCOUNT),
		    wf:flash(wf:f("用户 ~s 添加成功", [User])),
		    ok;
		_ ->
		    wf:flash("无效的用户组")
	    end;
	_ ->
	    wf:flash("用户名已存在")
    end,
    ok;

event({del_user, User}) ->
    case dets:lookup(?D_USER, User) of
	[#d_user{group = Group}] ->
	    dets:delete(?D_USER, User),
	    case dets:lookup(?D_GROUP, Group) of
		[] ->
		    ignore;
		[#d_group{user_list = UserList} = GroupRec] ->
		    UserList2 = lists:delete(User, UserList),
		    dets:insert(?D_GROUP, GroupRec#d_group{user_list = UserList2})
	    end;
	_ ->
	    ignore
    end,
    event(?S_ACCOUNT),
    wf:flash(wf:f("用户 ~s 删除成功", [User])),
    ok;

event({edit_group, Name}) ->
    GroupList = dets:match_object(?D_GROUP, '_'),
    GroupOptions = [#option{text = G#d_group.group}||G<-GroupList],
    CellId = "group" ++ Name,
    DataId = editgroupdrop,
    wf:replace(CellId, #tablecell{id = CellId, body = [
	    #dropdown {id=DataId, next=adduserbtn, style = "width:auto", options = GroupOptions}, 
	    #link{id = edit_group, text = "/确定", 
		postback = {mod, ?MODULE, {edit_group_confirm, Name, DataId}}}
		]}),
    ok;
event({edit_group_confirm, User, Id}) ->
    Group = wf:q(Id),
    [UserRec] = dets:lookup(?D_USER, User),
    dets:insert(?D_USER, UserRec#d_user{group = Group}),
    case dets:lookup(?D_GROUP, UserRec#d_user.group) of
	[#d_group{user_list = UserListO} = GroupRecO] ->
	    dets:insert(?D_GROUP, GroupRecO#d_group{user_list = lists:delete(User, UserListO)});
	[] ->
	    ignore
    end,
    [#d_group{user_list = UserListN} = GroupRecN] = dets:lookup(?D_GROUP, Group),
    dets:insert(?D_GROUP, GroupRecN#d_group{user_list = [User|UserListN]}),
    CellId = "group" ++ User,
    wf:replace(CellId,
	#tablecell{id = CellId, body = [
		#span{text = Group}, 
		#link{id = edit_group, text = "/编辑", postback = {mod, ?MODULE, {edit_group, User}}}]}
	),
    misc:flash(wf:f("修改用户组为 ~s 成功", [Group])),
    ok;

event({reset_passwd, Name}) ->
    CellId = "passwd" ++ Name,
    DataId = "passwdbox" ++ Name,
    
    wf:defer(edit_passwd, DataId, #validate { validators=[
		#is_required { text="Required" }
		]}),
    wf:replace(CellId, #tablecell{id = CellId, body = [
		#textbox{id = DataId, next = edit_passwd},
	    #link{text = "/确定", 
		postback = {mod, ?MODULE, {reset_passwd_confirm, Name, DataId}}}
		]}),
    ok;
event({reset_passwd_confirm, User, Id}) ->
    Passwd = wf:q(Id),
    [UserRec] = dets:lookup(?D_USER, User),
    dets:insert(?D_USER, UserRec#d_user{passwd = Passwd}),
    CellId = "passwd" ++ User,
    wf:replace(CellId, #tablecell{id = CellId, body = 
	    [#link{text = "重置密码", postback = {mod, ?MODULE, {reset_passwd, User}}}]
	    }),
    misc:flash(wf:f("密码修改成功")),
    ok;
    

event(Msg) ->
    misc:flash(#p{body = [wf:f("account event: ~p~n", [Msg])]}),
    ok.


account_body() ->

    wf:defer(adduserbtn, userbox, #validate { validators=[
		#is_required { text="Required" }
		]}),
    wf:defer(adduserbtn, passwdbox, #validate { validators=[
		#is_required { text="Required" }
		]}),
    wf:defer(adduserbtn, groupdrop, #validate { validators=[
		#is_required { text="Required" }
		]}),
    GroupList = dets:match_object(?D_GROUP, '_'),
    GroupOptions = [#option{text = G#d_group.group}||G<-GroupList],
    UserList = dets:match_object(?D_USER, '_'),
    UserList2 = lists:map(fun(U) ->
		    #d_user{name = Name, group = Group} = U,
		    [
			Name, 
			"group" ++ Name, 
			[#span{text = Group}, #link{id = edit_group, text = "/编辑"}],
			{mod, ?MODULE, {edit_group, Name}}, 
			"passwd" ++ Name,
			{mod, ?MODULE, {reset_passwd, Name}},
			{mod, ?MODULE, {del_user, Name}}]
	    end, UserList),
    UserMap = [
	    user@text,
	    group@id,
	    group@body,
	    edit_group@postback,
	    reset_passwd_cell@id,
	    reset_passwd@postback,
	    del_user@postback
	    ],
    [
	#h3{text = ?S_ACCOUNT},
	#p{},
	"不同的用户组拥有不同的权限。",
	#p{},
	#br{},

	#table { style = "width:auto;", rows = [
		#tablerow{id = title, style = "background-color: #ccc;", cells = [
			#tablecell{text = "用户名"},
			#tablecell{text = "用户组"},
			#tablecell{text = "编辑操作"},
			#tablecell{text = "删除操作"}
			]},
		#bind { 
		    id=tableBinding, 
		    data = UserList2, 
		    map = UserMap, 
		    transform = fun misc:alternate_color/2,
		    body = #tablerow{id = top, cells = [
			    #tablecell{id = user},
			    #tablecell{id = group},
			    #tablecell{id = reset_passwd_cell, body = [
				    #link{id = reset_passwd, text = "重置密码"}]},
			    #tablecell{body = [#link{id = del_user, text = "删除"}]}
			    ]}}
		]},
	#br{},
	#hr{},
	#br{},
	#h3{text = "添加用户"},
	#br{},
	#p{},
	#label { text="用户名"},
	#p{},
	#textbox {id=userbox, next=passwdbox, style = "width:auto"},
	#p{},
	#label { text="密码"},
	#p{},
	#textbox {id=passwdbox, next=groupdrop, style = "width:auto"},
	#p{},
	#label { text="用户组"},
	#p{},
	#dropdown {id=groupdrop, next=adduserbtn, style = "width:auto", options = GroupOptions},
	#p{},
	#button{id = adduserbtn, postback = {mod, ?MODULE, add_account}, text = "添加用户"},
	#p{},
	#br{}
	].
