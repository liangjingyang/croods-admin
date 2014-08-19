%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("croods_admin.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "Croods-Admin".

left_title() ->
    [
	#p{},
	"Current Server&nbsp;&nbsp;&nbsp;&nbsp;",
	#dropdown { id = server_list, options=[
		#option { text="S1" },
		#option { text="S2" },
		#option { text="S3" },
		#option { text="S5" }
		]}
	].

get_menu_data() ->
    [
	[?F_PLAYER, "玩家管理", {menu, ?F_PLAYER}],
	[?F_ACCOUNT, "用户和组", {menu, ?F_ACCOUNT}],
	[?F_SERVER, "服务器管理", {menu, ?F_SERVER}]
	].

get_menu_map() ->
    [
	menuButton@id,
	menuButton@text,
	menuButton@postback
	].
get_second_menu_data(f_player) ->
    [
	[?S_PLAYER_INFO, "玩家详情", {mod, player_info, ?S_PLAYER_INFO}],
	[?S_EMAIL, "发邮件", {mod, email, ?S_EMAIL}]
	];
get_second_menu_data(f_account) ->
    [
	[?S_ACCOUNT, "用户管理", {mod, account, ?S_ACCOUNT}],
	[?S_GROUP, "组管理", {mod, account, ?S_GROUP}],
	[?S_ACCESS, "权限管理", {mod, account, ?S_ACCESS}]
	];
get_second_menu_data(_) ->
    [
	[test, "测试", {right, sid3}]
	].

get_second_menu_map() ->
    [
	link@id,
	link@text,
	link@postback
	].

get_second_menu(Id) ->
    Data = get_second_menu_data(Id),
    Map = get_second_menu_map(),
    #table { class = tiny, rows = [
	    #bind { 
		id = tableBinding, 
		data = Data, 
		map = Map, 
		%transform = fun alternate_color/2, 
		body = #tablerow { 
		    id = top,
		    cells = [
			#tablecell { id = titleLabel },
			#tablecell { id = authorLabel },
			#tablecell { id = descriptionLabel },
			#tablecell { body = #link { id = link, url = "" } }
			]}}
	    ]}.

%%% ALTERNATE BACKGROUND COLORS %%%
alternate_color(DataRow, Acc) when Acc == []; Acc==odd ->
    {DataRow, even, {top@style, "background-color: #eee; width: 100%"}};

alternate_color(DataRow, Acc) when Acc == even ->
    {DataRow, odd, {top@style, "background-color: #ddd;"}}.

left_body() ->
    case wf:user() /= undefined of 
	true  -> left_body_authed();
	false -> left_body_not_authed()
    end.

left_body_not_authed() ->
    wf:wire(okButton, userTextBox, #validate { validators=[
		#is_required { text="Required" }
		]}),
    wf:wire(okButton, passTextBox, #validate { validators=[
		#is_required { text="Required" }
		]}),
    [
	#br{},
	#p{},
	#label { text="Username"},
	#p{},
	#textbox { id=userTextBox, next=passTextBox, style = "width:60%"},
	#p{},
	#label { text="Password"},
	#p{},
	#password { id=passTextBox, next=okButton, style = "width:60%"},
	#p{},
	#br{},
	#button { id=okButton, text="Login", postback=login_btn, style =
	    "width:100%"},
	#p{},
	#br{},
	#flash{}
	].

left_body_authed() ->
    Data = get_menu_data(),
    Map = get_menu_map(),
    [
	#bind{id = aaa, data = Data, map = Map, body = [
		#button{id = menuButton}
		]},
	#p{},
	#p{},
	#br{},
	#hr{},
	#p{},
	#p{},
	#br{},
	#link{text = "Logout", postback = logout_btn}
	].

right() ->
    [
	#flash{},
	#panel { id = right_body, body = inner_body() }
	].

inner_body() -> 
    case wf:user() of 
	undefined  -> Text = "Welcome to Croods-Admin";
	User -> Text = wf:f("Welcome ~s", [User])
    end,
    [
	#h1 { text=Text, style = "text-align: center" },
	#br{},
	#p{},
	#h3{ text = "贵有恒，何须三更眠五更起", style = "text-align: center"},
	#p{}, 	
	#p{},
	#h3{ text = "最无益，只怕一日曝十日寒", style = "text-align: center"},
	#p{}, 	
	#br{}
	].

event({menu, Id}) ->
    wf:remove(secondMenu),
    wf:insert_after(Id, #panel{
	    id = secondMenu,
	    body = get_second_menu(Id)
	    });
event(login_btn) ->
    User = wf:q(userTextBox),
    Passwd = wf:q(passTextBox),
    case dets:lookup(?D_USER, User) of
	[#d_user{passwd = Passwd}] ->
	    wf:user(User),
	    wf:redirect_from_login("index");
	_ ->
	    wf:flash("无效的用户名密码")
    end;

event(logout_btn) ->
    wf:clear_session(),
    wf:redirect_from_login("index");

event({mod, Mod, Msg}) ->
    case catch Mod:event(Msg) of
	ok ->
	    ok;
	{error, Error} ->
	    misc:flash(#p{body = [wf:f("~p~n", [Error])]});
	_Error ->
	    misc:flash(#p{body = [wf:f("~p~n", [_Error])]})
    end;
event(_Other) ->
    wf:replace(right_body, #panel{id = right_body, body = [io_lib:format("~p~n", [_Other])]}),
    ok.

evnet_invalid(_Other) ->
    wf:replace(right_body, #panel{id = right_body, body = [io_lib:format("~p~n", [_Other])]}),
    ok.

inplace_textbox_event({mod, Mod, Tag}, Value) ->
    Value2 = Mod:inplace_textbox_event(Tag, Value),
    Value2;
inplace_textbox_event(Tag, Value) ->
    misc:flash(#p{body = [wf:f("inplace_textbox_event, tag:~p~nvalue:~p~n", [Tag, Value])]}),
    Value.


