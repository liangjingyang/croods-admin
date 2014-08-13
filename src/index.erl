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
     ["button1", {data,1}],
     ["button2", {data,2}],
     ["button3", {data,3}],
     ["button4", {data,4}]
    ].

get_menu_map() ->
    [
     b1@text,
     b1@postback
    ].


left_body() ->
    Data = get_menu_data(),
    Map = get_menu_map(),
    [
     #flash{},
     #p{},
     #button { text="Show Flash Message", postback=menu1 },
     #p{},
     #button { text="Show Flash Message2", postback=menu2 },
     #bind{id = aaa, data = Data, map = Map, body = [
						     #hr{},
						     #button{id = b1}
						    ]}
    ].

right() ->
    #container_12 { body=[
			  #grid_8 { alpha=true, prefix=2, suffix=2, omega=true, body=inner_body() }
			 ]}.

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
event(menu1) ->
    wf:flash("1", "hahaha");
event(menu2) ->
    wf:flash("2", "hahaha");
event({data, Data}) ->
    Message = "Clicked On Data: " ++ wf:to_list(Data),
    wf:wire(#alert { text=Message }),
    ok.
