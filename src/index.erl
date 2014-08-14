%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "Welcome to Nitrogen".

left_title() ->
    [
     #p{},
     "Current Server&nbsp;&nbsp;&nbsp;&nbsp;",
     #dropdown { options=[
			  #option { text="S1" },
			  #option { text="S2" },
			  #option { text="S3" },
			  #option { text="S5" }
			 ]}
    ].

get_menu_data() ->
    [
	%[text, data, id],
	["玩家管理", {data,1}, "id1"],
	["用户管理", {data,2}, "id2"],
	["权限管理", {data,3}, "id3"],
	["服务器管理", {data,4}, "id4"],
	["button5", {data,5}, "id5"],
	["button6", {data,6}, "id6"],
	["button7", {data,7}, "id7"],
	["button8", {data,8}, "id8"]
	].

get_menu_map() ->
    [
	menuButton@text,
	menuButton@postback,
	menuButton@id
	].
get_second_menu_data("id1") ->
    [
	["玩家详情", "/"],
	["发邮件", "/"]
	];
get_second_menu_data(_) ->
    [
	["测试", "/"]
	].

get_second_menu_map() ->
    [
	link@text,
	link@url
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
			#tablecell { body = #link { id = link } }
			]}}
	    ]}.
    
%%% ALTERNATE BACKGROUND COLORS %%%
alternate_color(DataRow, Acc) when Acc == []; Acc==odd ->
        {DataRow, even, {top@style, "background-color: #eee; width: 100%"}};

alternate_color(DataRow, Acc) when Acc == even ->
        {DataRow, odd, {top@style, "background-color: #ddd;"}}.

left_body() ->
    Data = get_menu_data(),
    Map = get_menu_map(),
    [
	#bind{id = aaa, data = Data, map = Map, body = [
		#button{id = menuButton}
		]}
	].

right() ->
    #panel { body = inner_body() }.

inner_body() -> 
    [
     #h1 { text="Welcome to Nitrogen" },
     #p{},
     "
	If you can see this page, then your Nitrogen server is up and
	running. Click the button below to test postbacks.
	",
	#p{}, 	
	#button { id=button, text="Click me!", postback=click },
		#p{},
	"
	Run <b>./bin/dev help</b> to see some useful developer commands.
	",
		#p{},
		"
     <b>Want to see the ",#link{text="Sample Nitrogen jQuery Mobile Page",url="/mobile"},"?</b>
		"
    ].

event(click) ->
    wf:replace(button, #panel { 
			  body="You clicked the button!", 
			  actions=#effect { effect=highlight }
			 });
event({data, Data}) ->
    Id = "id" ++ wf:to_list(Data),
    wf:remove(secondMenu),
    wf:insert_after(Id, #panel{
	    id = secondMenu,
	    body = get_second_menu(Id)
	    }),
    ok;
event(_) ->
    ok.

