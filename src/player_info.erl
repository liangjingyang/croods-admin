
-module(player_info).

-compile(export_all).

-include("croods_admin.hrl").
-include("proto.hrl").
-include("config.hrl").
-include_lib("nitrogen_core/include/wf.hrl").

event(init) ->
    Body = player_info_title(),
    wf:replace(right_body, #panel{id = right_body, body = Body}),
    ok;
event(playerId) ->
    Value = wf:q(playerId),
    Req = #areq_player_info{type = ?TYPE_PLAYER_ID, data = list_to_integer(Value)},
    ServerId = wf:q(server_list),
    Data = misc:request(ServerId, Req),
    wf:flash(wf:f("玩家 ~p 信息查询成功!", [Value])),
    Title = player_info_title(),
    Body = player_info_body(Data),
    wf:replace(right_body, #panel{id = right_body, body = Title ++ Body}),
    ok;

event(name) ->
    Value = wf:q(name),
    Req = #areq_player_info{type = ?TYPE_PLAYER_NAME, data = Value},
    ServerId = wf:q(server_list),
    Data = misc:request(ServerId, Req),
    wf:flash(wf:f("玩家 ~p 信息查询成功!", [Value])),
    Title = player_info_title(),
    Body = player_info_body(Data),
    wf:replace(right_body, #panel{id = right_body, body = Title ++ Body}),
    ok;
event(accname) ->
    Value = wf:q(accname),
    Req = #areq_player_info{type = ?TYPE_PLAYER_ACCNAME, data = Value},
    ServerId = wf:q(server_list),
    Data = misc:request(ServerId, Req),
    wf:flash(wf:f("玩家 ~p 信息查询成功!", [Value])),
    Title = player_info_title(),
    Body = player_info_body(Data),
    wf:replace(right_body, #panel{id = right_body, body = Title ++ Body}),
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
	soul = Soul, lv = Lv, exp = Exp, phy = Phy, know = Know,
	pvpAtt = PvpAtt, pvpSuff = PvpSuff, pveAtt = PveAtt, pveSuff = PveSuff,
	onHero = OnHero, vip = Vip, totalDiamond = TotalDiamond, detect = Detect,
	buyPhy = BuyPhy, shareRecord = ShareRecord, hunter = Hunter,
	hunterBargain = HunterBargain, atm = Atm
	} = Hero,

    HeroData = 
	[
	    ["id", Id, "名字", Name, "账户名", Accname],
	    ["性别", Sex, "等级", Lv, "经验", Exp],
	    ["金币", Gold, "钻石", Diamond, "时之沙", Hourglass],
	    ["魂魄", Soul, "知识", Know, "vip", Vip], 
	    ["总充值", TotalDiamond, "体力", Phy, "购买体力次数", BuyPhy],
	    ["迎击战次数", Detect, "地下城次数", PveAtt, "英雄入侵次数", PvpAtt],
	    ["魔兽争霸次数", PvpSuff, "分享录像次数", ShareRecord, "怪物猎人出现次数", Hunter],
	    ["讨价还价次数", HunterBargain, "时间沙漏的等级", Atm#'PSC_atm'.lv, "在线状态", IsOnline]
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


    EliteData = lists:map(fun(E) ->
		    #'PSC_elite'{
			id = EId, typeId = ETypeId, lv = ELv, 
			exp = EExp, hpLv = EHpLv, attLv = EAttLv, 
			speedLv = ESpeedLv, skillLv = ESkillLv, 
			geniusLv = EGeniusLv, onMap = EOnMap, onHero = EOnHero} = E,
		    [CE] = config_dyn:find(c_elite, ETypeId),
		    [CE#c_elite.name, EId, ETypeId, ELv, EExp, EHpLv, EAttLv, ESpeedLv, 
			ESkillLv, EGeniusLv, EOnMap, EOnHero]
	    end, EliteList),
    EliteData2 = [["name", "id", "typeId", "等级", "经验", "生命强化", 
		"攻击强化", "速度强化", "技能强化", "天赋强化", 
		"出战1/未出战0", "附身1/未附身0"]|EliteData],
    EliteMap = 
	[
	    ename@text,
	    eid@text,
	    etypeid@text,
	    elv@text,
	    eexp@text,
	    ehplv@text,
	    eattlv@text,
	    espeedlv@text,
	    eskilllv@text,
	    egeniuslv@text,
	    eonmap@text,
	    eonhero@text
	    ],

    MonData = lists:map(fun(M) ->
		    #'PSC_mon'{id = MId, typeId = MTypeId, lv = MLv, 
			exp = MExp, onMap = MOnMap, reborn = MReborn, 
			inTeam = MInTeam} = M,
		    [CM] = config_dyn:find(c_mon, MTypeId),
		    [CM#c_mon.name, MId, MTypeId, MLv, MExp, MOnMap, MReborn, MInTeam]
	    end, MonList),
    MonData2 = [["name", "id", "typeId", "等级", "经验",
		"出战1/0", "转生", "在防守队列1/0"]|MonData],
    MonMap = [
	    mname@text,
	    mid@text,
	    mtypeid@text,
	    mlv@text,
	    mexp@text,
	    monmap@text,
	    mreborn@text,
	    minteam@text
	    ],
    
    [
	#br{},
	#hr{},
	#br{},
	#h4{text = "英雄信息"},
	#table { rows=[
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
	#br{},
	#h4{text = "魔神信息"},
	#table { rows=[
		#bind { 
		    id=tableBinding, 
		    data = EliteData2,
		    map = EliteMap, 
		    transform=fun alternate_color/2,
		    body=#tablerow { id=top, cells=[
			    #tablecell {id=ename},
			    #tablecell {id=eid},
			    #tablecell {id=etypeid},
			    #tablecell {id=elv},
			    #tablecell {id=eexp},
			    #tablecell {id=ehplv},
			    #tablecell {id=eattlv},
			    #tablecell {id=espeedlv},
			    #tablecell {id=eskilllv},
			    #tablecell {id=egeniuslv},
			    #tablecell {id=eonmap},
			    #tablecell {id=eonhero}
			    ]}}            
		]},

	#br{},
	#h4{text = "小怪信息"},
	#table { rows=[
		#bind { 
		    id=tableBinding, 
		    data = MonData2,
		    map = MonMap, 
		    transform=fun alternate_color/2,
		    body=#tablerow { id=top, cells=[
			    #tablecell {id=mname},
			    #tablecell {id=mid},
			    #tablecell {id=mtypeid},
			    #tablecell {id=mlv},
			    #tablecell {id=mexp},
			    #tablecell {id=monmap},
			    #tablecell {id=mreborn},
			    #tablecell {id=minteam}
			    ]}}            
		]}                        
	].                                 
                                           
                                           
alternate_color(DataRow, Acc) when Acc == []; Acc==odd ->
    {DataRow, even, {top@style, "background-color: #eee;"}};

alternate_color(DataRow, Acc) when Acc == even ->
    {DataRow, odd, {top@style, "background-color: #ddd;"}}.
