
-module(email).

-export([
    event/1
    ]).

-include("croods_admin.hrl").
-include("proto.hrl").
-include("common.hrl").
-include_lib("nitrogen_core/include/wf.hrl").

-define(SEND_TO_ALL, "发送给所有玩家").
-define(SEND_BY_ID, "按照id列表发送").
-define(SEND_BY_ACCNAME, "按照账号列表发送").
-define(SEND_BY_NAME, "按照名字列表发送").


event(?S_EMAIL) ->
    Body = email_body(),
    wf:replace(right_body, #panel{id = right_body, body = Body}),
    ok;

event(send_email) ->
    wf:wire(#confirm{postback = {mod, ?MODULE, confirm_send_email}, text = "确认发送邮件？"});


event(confirm_send_email) ->
    Type = q_email_type(),
    List = q_email_list(),
    case Type of
	?TYPE_EMAIL_ID_LIST ->
	    List2 = [list_to_integer(I)||I<-List];
	_ ->
	    List2 = List
    end,
    Content = q_email_content(),
    Title = q_email_title(),
    Items = q_email_items(),
    Req = #areq_email{type = Type, list = List2, str = Content, title = Title, itemList = Items},
    io:format("areq_email, ~p~n", [Req]),
    #ares_err{error = Err} = misc:request(Req),
    case Err =:= ?ADMIN_SUCC of 
	true ->
	    misc:flash("发送成功，请登录测试账号查看。每秒钟发送500个账号左右，有的账号会有延迟");
	false ->
	    misc:flash(wf:f("发送失败：~p", [Err]))
    end,
    ok;

event(Msg) ->
    misc:flash(#p{body = [wf:f("player_info event: ~p~n", [Msg])]}),
    ok.

q_email_type() ->
    Type = wf:q(email_type),
    if 
	Type =:= ?SEND_TO_ALL ->
	    ?TYPE_EMAIL_ALL;
	Type =:= ?SEND_BY_ID ->
	    ?TYPE_EMAIL_ID_LIST;
	Type =:= ?SEND_BY_ACCNAME ->
	    ?TYPE_EMAIL_ACCNAME_LIST;
	Type =:= ?SEND_BY_NAME ->
	    ?TYPE_EMAIL_NAME_LIST;
	true ->
	    misc:ithrow("发送方式错误")
    end.

q_email_list() ->
    Str = wf:q(email_list),
    List = string:tokens(Str, "\n"),
    [string:strip(L)||L<-List].

q_email_content() ->
    wf:q(email_content).
q_email_title() ->
    wf:q(email_title).
q_email_items() ->
    Str = wf:q(email_items),
    List = string:tokens(Str, "\n"),
    lists:map(fun(S) ->
		[I, N] = string:tokens(S, ","),
		{wf:to_integer(string:strip(I)), wf:to_integer(string:strip(N))}
	end, List).


email_body() ->
    Body = 
    [
	#h3{text = "发邮件"},
	#br{},

	#p{text = "选择发送方式"},
	#dropdown { id = email_type, options=[
		#option { text = ?SEND_TO_ALL },
		#option { text = ?SEND_BY_ID },
		#option { text = ?SEND_BY_ACCNAME },
		#option { text = ?SEND_BY_NAME }
		]},
	#p{},
	#br{},

	#p{text = "列表（换行分割，发送给所有玩家时不填)"},
	#textarea { id = email_list, text="", next = email_content }, 
	#p{},
	#br{},

	#p{text = "邮件标题"},
	#textarea { id = email_title, text = "", next = email_content },
	#p{},
	#br{},

	#p{text = "邮件内容"},
	#textarea { id = email_content, text = "", next = email_items },
	#p{},
	#br{},

	#p{text = "道具列表, 每行一个道具：210011,5    (半角逗号)"},
	#textarea { id = email_items, text = "", next = email_send},
	#p{},
	#br{}, 

	#button{id = email_send, text = "发送", 
		handle_invalid=true,
		on_invalid=#alert{text="At least one validator failed client-side (meaning it didn't need to try the server)"},
		postback = {mod, ?MODULE, send_email}},
	#p{},
	#br{}
	],
    %wf:wire(email_send, email_list, #validate{validators = [
		%#custom { text="请填写玩家id，每行一个", tag=email_list, function=fun email_list_id/2},
		%#custom { text="请填写玩家名字，每行一个", tag=email_list, function=fun email_list_name/2},
		%#custom { text="请填写玩家账号，每行一个", tag=email_list, function=fun email_list_accname/2}

		%]}),
    %wf:wire(email_send, email_content, #validate{validators = [
		%#custom { text="请填写玩家id，每行一个", tag=email_list, function=fun email_true/2}
		%]}),
    %wf:wire(email_send, email_items, #validate{validators = [
		%#custom { text="请填写玩家id，每行一个", tag=email_list, function=fun email_true/2}
		%]}),
    Body.

%email_list_id(_Tag, _Value) ->
    %case q_email_type() of
	%?TYPE_EMAIL_ID_LIST ->
	    %List = q_email_list(),
	    %List2 = [wf:to_integer(L)||L<-List],
	    %length(List2) > 0;
	%_ ->
	    %true
    %end.

%email_list_name(_Tag, _Value) ->
    %case q_email_type() of
	%?TYPE_EMAIL_NAME_LIST ->
	    %List = q_email_list(),
	    %length(List) > 0;
	%_ ->
	    %true
    %end.

%email_list_accname(_Tag, _Value) ->
    %case q_email_type() of
	%?TYPE_EMAIL_ACCNAME_LIST ->
	    %List = q_email_list(),
	    %length(List) > 0;
	%_ ->
	    %true
    %end.

%email_true(_, _) ->
    %true.
