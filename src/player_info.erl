
-module(player_info).

-compile(export_all).

-include("croods_admin.hrl").
-include("proto.hrl").
-include_lib("nitrogen_core/include/wf.hrl").

event(init) ->
    Body = player_info_title(),
    wf:replace(right_body, #panel{id = right_body, body = Body}),
    ok;
event(playerId) ->
    Value = wf:q(playerId),
    Req = #areq_player_info{type = ?TYPE_PLAYER_ID, data = list_to_integer(Value)},
    Data = misc:request(Req),
    %wf:flash(wf:f("player_info response: ~p~n", [Data])),
    Title = player_info_title(),
    Body = player_info_body(Data),
    wf:replace(right_body, #panel{id = right_body, body = Title ++ Body}),
    ok;

event(name) ->
    Value = wf:q(name),
    Req = #areq_player_info{type = ?TYPE_PLAYER_NAME, data = Value},
    Data = misc:request(Req),
    wf:flash(wf:f("player_info response: ~p~n", [Data])),
    ok;
event(accname) ->
    Value = wf:q(accname),
    Req = #areq_player_info{type = ?TYPE_PLAYER_ACCNAME, data = Value},
    Data = misc:request(Req),
    wf:flash(wf:f("player_info response: ~p~n", [Data])),
    ok;
event(Msg) ->
    wf:flash(#p{body = [wf:f("player_info event: ~p~n", [Msg])]}),
    ok.

inplace_textbox_event(Tag, Value) ->
    wf:flash(#p{body = [wf:f("player_info, inplace_textbox_event, tag:~p~nvalue:~p~n", [Tag, Value])]}),
    Value.


player_info_title() ->
    [
	#h3{text = "玩家详情"},
	#br{},
	#label{text = "按玩家Id查询："},
	#textbox{id = playerId},
	#button{postback = {mod, ?MODULE, playerId}, text = "查询"},
	#br{},
	#label{text = "按玩家名字查询："},
	#textbox{id = name},
	#button{postback = {mod, ?MODULE, name}, text = "查询"},
	#br{},
	#label{text = "按玩家账户查询："},
	#textbox{id = accname},
	#button{postback = {mod, ?MODULE, accname}, text = "查询"}
	].

player_info_body(Data) ->
    #ares_player_info{
	hero = Hero, 
	eliteList = EliteList,
	monList = MonList,
	trapList = TrapList,
	itemList = ItemList,
	skinList = SkinList,
	other = Other,
	isOnline = IsOnline
	} = Data,
    #'PSC_hero'{
	id = Id, name = Name, accname = Accname, sex = Sex,
	gold = Gold, diamond = Diamond, hourglass = Hourglass,
	soul = Soul, lv = Lv
	} = Hero,
    
    HeroData = 
	[
	    ["id", Id, "性别", Sex, "等级", Lv],
	    ["名字", Name, "金币", Gold, "魂魄", Soul],
	    ["账户名", Accname, "钻石", Diamond, "时之沙", Hourglass]
	    ],
    HeroMap = 
	[
	    hero_key@text,
	    hero_value@text,
	    hero_key2@text,
	    hero_value2@text,
	    hero_key3@text,
	    hero_value3@text
	    ],
    
    [
	#br{},
	#hr{},
	#br{},
	#h4{text = "英雄信息"},
	#table { class=hero_info_left, rows=[
		#bind { 
		    id=tableBinding, 
		    data=HeroData, 
		    map=HeroMap, 
		    body=#tablerow { id=top, cells=[
			    #tablecell {id=hero_key, style = "text-align:right; background-color:#ddd"},
			    #tablecell {id=hero_value, style = "text-align:left; background-color:#eee"},
			    #tablecell {id=hero_key2, style = "text-align:right; background-color:#ddd"},
			    #tablecell {id=hero_value2, style = "text-align:left; background-color:#eee"},
			    #tablecell {id=hero_key3, style = "text-align:right; background-color:#ddd"},
			    #tablecell {id=hero_value3, style = "text-align:left; background-color:#eee"}
			    ]}}
		]},
	#br{}
	].



