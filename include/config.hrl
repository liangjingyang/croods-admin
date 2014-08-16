
%%%  道具配置文件
%% typeid道具的typeid
%% lv:等级
%% name:名称
%% gold:金币
%% effect：使用效果
-record(c_item, {typeid = 0, name = "", gold = 0, effect = undefined, data = []}).
-record(c_shop, {vs = 0, beginTime = 0, endTime = 0, list = []}).
-record(c_goal, {id,name,hook,max, award}).

-record(c_sign, {id, name, award}).

-record(c_pay, {id, name, price, diamond, gift}).
-record(c_activity_pay, {id,name,pay,award}).

%% 魔神
-record(c_elite, {typeId = 0, name = 0, lv = 0, hp = 0, hpAdd = 0, att = 0, attAdd = 0, attInterval = 0, attDist = 0, attType = 0, runSpeed = 0, view = 0, patrol = 0, track = 0, skillId = 0, geniusId = 0, wind = 0, wood = 0, fire = 0, hill = 0, attr = 0, finishPart = 0, rebornPart = 0, reborn = 0, drop = []}).

%% 魔神强化的配置文件
-record(c_elite_attr_up,{key,soul,soulAdd,itemList}).
%% 战斗评级宝箱配置记录
-record(c_war_award, {key, drop}).

%% 副本配置文件record
-record(c_dungeon, {key,name,bossFloor,bossId,hard,dayNight,sectionAward}).
-record(c_dungeon_boss, {typeId,type,actionId,hard,drop}).

% player_gsv State record
-record(p_state, {id, c_pid, ets}).



%%% 怪物配置文件
%% typeid怪物的typeid
%% name:名称
%% lv：等级
%% hp:初始生命
%% att初始攻击c_mon{,}.[]"
%% attInterval攻击间隔 单位：毫秒
%% attDist攻击距离 单位：格子
%% attType主动还是被动， 主动是0，被动是1
%% runSpeed奔跑速度 单位：像素/帧 目前是1秒30帧
%% view视野 单位：格子
%% patrol巡逻范围 单位：格子
%% track追击范围 单位：格子
%% skillId:技能id 对应c_skill里的id
%% geniusId:天赋Id 对应c_skill里的id

-record(c_mon, {
        typeId = 0, 
        color = 1,
        name = 0,
        lv = 0,
        hp = 0,
        hpAdd = 0,

        att = 0,
        attAdd = 0,
        day = 1, 
        night = 1,
        attInterval = 0,
        attDist = 0,
        runSpeed = 0,

        view = 0,
        patrol = 0,
        track = 0,
        skillId = 0,
        wind = 0,

        wood = 0,
        fire = 0,
        hill = 0,
        attr = 1,
        part = 0,

        hg = 0,
        hgAdd = 0,
        hgSpeed = 0,

        drop = []
    }).

%%% 技能配置文件record
-record(c_skill,{id = 0, lv = 0, lvLim = 0, name = "", cool = 0, gold = 0, soul = 0, itemList = [], effect}).
-record(c_trap,{typeId = 0, type = 0, name = "", lv = 0, lvLim = 0, attr = 0, skillList = [], effect = [], reborn = []}).
-record(c_mon_reborn, {key, lv = 0, hourglass = 0, gold = 0, soul = 0, itemList = []}).
%-record(c_mon_to_time, {section,color,min,minAdd,max,maxAdd}).
-record(c_trap_lv, {key, gold = 0, know = 0, itemList = []}).
-record(c_hero_lv,{lv,phyExp = 0,lvExp = 0}).
-record(c_pve_rule,{key,num,minLv,maxLv,minColor,maxColor,dayNight,dropRate,elite}).

-record(c_exp, {lv, exp, totalExp}).
-record(c_mon_to_soul, {color, soul, hourglass}).
%-record(c_vip, {vip, pay, hourglass, award}).
-record(c_vip, {lv,pay,detect,buyPhy,sprint,jump,shareRecord,hunterBargain,hunter,roundTime,hourglass,protect,mount,onMap,relive,heart,award}).
-record(c_map_limit, {section, lv, road, mon}).

