
%% LastChange: 2013-07-02 17:30:19
%% Copr. (c) 2013-2015, Simple <ljy0922@gmail.com>

%%tcp_server监听参数
-define(TCP_OPTIONS, [
        binary, 
        {packet, 0}, 
        {active, false}, 
        {reuseaddr, true}, 
        {nodelay, false},
        {delay_send, true},
        {send_timeout, 5000},
        {keepalive, true},
        {exit_on_close, true}
    ]).

-define(RECV_TIMEOUT, 5000).

%%ets read-write 属性
-define(ETSRC,{read_concurrency,true}).
-define(ETSWC,{write_concurrency,true}).

%%自然对数的底
-define(E, 2.718281828459).

%% 通用错误码
-define(SUCC, 0).
-define(ERROR_IGNORE, -1).
-define(ERROR_SYSTEM, 1).
-define(ERROR_LEVEL_LIMIT, 2).
-define(ERROR_DIAMOND_NOT_ENOUGH, 3).
-define(ERROR_GOLD_NOT_ENOUGH, 4).
-define(ERROR_SOUL_NOT_ENOUGH, 5).
-define(ERROR_ITEM_NOT_ENOUGH, 6).
-define(ERROR_KNOW_NOT_ENOUGH, 7).
-define(ERROR_NO_MON, 8).
-define(ERROR_TOO_FREQUENTLY, 9).


%% ---------------------------------
%% Print in standard output
-define(PRINT(Format),
    io:format(Format++"~n", [])).
-define(PRINT(Format, Args),
    io:format(Format++"~n", Args)).
-define(TEST_MSG(Format),
    logger:test_msg(?MODULE,?LINE,Format, [])).
-define(TEST_MSG(Format, Args),
    logger:test_msg(?MODULE,?LINE,Format, Args)).
-define(DEBUG(Format),
    logger:debug_msg(?MODULE,?LINE,Format, [])).
-define(DEBUG(Format, Args),
    logger:debug_msg(?MODULE,?LINE,Format, Args)).
-define(INFO_MSG(Format),
    logger:info_msg(?MODULE,?LINE,Format, [])).
-define(INFO_MSG(Format, Args),
    logger:info_msg(?MODULE,?LINE,Format, Args)).
-define(WARNING_MSG(Format),
    logger:warning_msg(?MODULE,?LINE,Format, [])).
-define(WARNING_MSG(Format, Args),
    logger:warning_msg(?MODULE,?LINE,Format, Args)).
-define(ERROR_MSG(Format),
    logger:error_msg(?MODULE,?LINE,Format, [])).
-define(ERROR_MSG(Format, Args),
    logger:error_msg(?MODULE,?LINE,Format, Args)).
-define(CRITICAL_MSG(Format),
    logger:critical_msg(?MODULE,?LINE,Format, [])).
-define(CRITICAL_MSG(Format, Args),
    logger:critical_msg(?MODULE,?LINE,Format, Args)).
-define(TRY_CATCH(Expression,ErrReason), 
        try 
            Expression
        catch 
            _:ErrReason -> 
                ?ERROR_MSG("Reason: ~p~nStacktrace: ~p", [ErrReason,erlang:get_stacktrace()]) 
        end).
-define(TRY_CATCH(Expression), ?TRY_CATCH(Expression,ErrReason)).

-define(DO_HANDLE_INFO(Info,State),  
        try 
            do_handle_info(Info, State) 
        catch _:Reason -> 
                ?ERROR_MSG("Info: ~w~n,State: ~w~nReason: ~w~nstrace: ~p", [Info,State, Reason, erlang:get_stacktrace()]),
                {noreply, State}
        end).

-define(DO_HANDLE_CAST(Info,State),  
        try 
            do_handle_cast(Info, State) 
        catch _:Reason -> 
                ?ERROR_MSG("CastInfo: ~w~nState: ~w~nReason: ~w~nstrace: ~p", [Info,State, Reason, erlang:get_stacktrace()]),
                {noreply, State}
        end).

-define(DO_HANDLE_CALL(Request, From, State),  
        try 
            do_handle_call(Request, From, State) 
        catch _:Reason -> 
                ?ERROR_MSG("Request: ~w~nState: ~w~nReason: ~w~nstrace: ~p", [Request,State, Reason, erlang:get_stacktrace()]),
                {reply, error, State}
        end).


-define(DIFF_SECONDS_1970_1900, 2208988800).
-define(DIFF_SECONDS_0000_1900, 62167219200).
-define(ONE_DAY_SECONDS, 86400).                    %%一天的时间（秒）
-define(ONE_DAY_MILLISECONDS, 86400000).                %%一天时间（毫秒）


%% 初始值
-define(DEFAULT_P_HP, 100).
-define(DEFAULT_P_ATT, 10).
-define(DEFAULT_P_ATTACSPEED, 5).
-define(DEFAULT_P_ATTSPEED, 2).
-define(DEFAULT_P_DIST, 100).
-define(DEFAULT_P_RUNSPEED, 5).
-define(DEFAULT_P_RUNACSPEED, 5).
-define(SEX_BOY, 0).
-define(SEX_GIRL, 1).
-define(SEX_NO, 2).



%% db
%  player_gsv init_data的表
-define(PLAYER_GSV_TAB_LIST, [db_hero, db_map, db_elite, db_mon, 
                              db_item, db_trap, db_other, 
                              db_email, db_handbook, db_shop_limit,
                          db_dungeon, db_goal, db_sign, db_pay, 
                          db_activity_pay, db_record_index]).

%% 账户 id 映射表
-define(DB_ACCNAME, db_accname).
%% 英雄名字 id 的映射表
-define(DB_NAME, db_name).

%% 账号和密码的关联表
-define(DB_PASSWD, db_passwd).

-define(DB_HERO, db_hero).

-define(DB_DUNGEON, db_dungeon).

-define(DB_GOAL, db_goal).
-define(DB_SIGN, db_sign).

-define(DB_PAY, db_pay).

-define(DB_ACTIVITY_PAY, db_activity_pay).

%% mvm team
-define(DB_MVM_TEAM, db_mvm_team).
-record(db_mvm_team, {team_id, team}).
%% mvm rank
-define(DB_MVM_RANK, db_mvm_rank).
%% #db_mvm_rank{rank = 0, id = maxrank}
-record(db_mvm_rank, {rank_id = 1, id = 0, team_id = 1, name = "", sex = 0, lv = 1}).


%% pvp录像表,PSC_reocrd结构
-define(DB_RECORD, db_record).
%% mvm录像表，PSC_record_mvm结构
-define(DB_RECORD_MVM, db_record_mvm).
%% 玩家的id为key value是#PSC_record_index的list，一个PSC_record对应两个#PSC_record_index战斗双方一人一份
-define(DB_RECORD_INDEX, db_record_index).
%% db_record_index
-record(db_record_index, {id = 0, pvpList = [], mvmList = []}).
%% 录像类型
%% pvp录像
-define(RECORD_TYPE_PVP, 1).
%% mvm录像
-define(RECORD_TYPE_MVM, 2).

-record(db_pay, {id = 0, vipLv = 0, totalPay = 0, rebateNum = 0, rebateDate = 0, rebatePay = 0, activityPay = 0, firstPay = 0}).
-record(c_goal, {id,name,hook,max, award}).

-record(c_sign, {id, name, award}).

-record(c_pay, {id, name, price, diamond, gift}).
-record(c_activity_pay, {id,name,pay,award}).

%% 魔神
-record(c_elite, {typeId = 0, name = 0, lv = 0, hp = 0, hpAdd = 0, att = 0, attAdd = 0, attInterval = 0, attDist = 0, attType = 0, runSpeed = 0, view = 0, patrol = 0, track = 0, skillId = 0, geniusId = 0, wind = 0, wood = 0, fire = 0, hill = 0, attr = 0, finishPart = 0, rebornPart = 0, reborn = 0, drop = []}).

%% 魔神强化的配置文件
-record(c_elite_attr_up,{key,soul,soulAdd,itemList}).




%% 地图表
-define(DB_MAP, db_map).
% db_map中value结构 是#db_map的list

%% 魔神表
-define(DB_ELITE, db_elite).

%% 小怪表
-define(DB_MON, db_mon).

%% 道具表
-define(DB_ITEM, db_item).
%  删除道具 
-define(ITEM_DEL, 1).
%  增加道具
-define(ITEM_ADD, 0).

%% 陷阱表
-define(DB_TRAP, db_trap).

-record(suff_status, {
        curr_time = 0, 
        last_time = 0, 
        suff_list = [],  %% suff_list = mon_list ++ elite_list
        mon_list = [], 
        elite_list = [], 
        status = 0
    }).

%% 杂七杂八表
-define(DB_OTHER, db_other).
-record(db_other, {
        id = 0, 
        mon_last_exp_time = 0, 
        last_phy_time = 0, 
        last_pve_suff_time = 0, 
        last_login_time = 0, 
        last_logout_time = 0, 
        suff_status = #suff_status{},
        guideStep = 0, 
        suff_mon_num = 0, 
        hero_pve_num = 0, 
        hero_pvp_num = 0, 
        mvm_num = 0,
        last_sign_time = 0,
        last_rebate_time = 0,
	mvm_rank_id = 0,
	mvm_team_id = 0
    }).

%% 手册表
-define(DB_HANDBOOK, db_handbook).

%% 邮件表
-define(DB_EMAIL, db_email).
%% 邮件道具表
-define(DB_EMAIL_ITEM, db_email_item).

%% shop表
%% 3个key， default, now, all
-define(DB_SHOP, db_shop).
-record(c_shop, {vs = 0, beginTime = 0, endTime = 0, list = []}).

%% shop_limit 表，每个玩家一条记录
-define(DB_SHOP_LIMIT, db_shop_limit).
-record(db_shop_limit, {time = 0, list = []}).

%% 邮件类型
%  关押
-define(EMAIL_PRISON, 1).
%  录像
-define(EMAIL_RECORD, 2).
%  道具
-define(EMAIL_SYSTEM, 3).

%% 战斗评级宝箱配置记录
-record(c_war_award, {key, drop}).

%% 副本配置文件record
-record(c_dungeon, {key,name,bossFloor,bossId,hard,dayNight,sectionAward}).
-record(c_dungeon_boss, {typeId,type,actionId,hard,drop}).

% player_gsv State record
-record(p_state, {id, c_pid, ets}).

-define(STATUS_RUN, 0).
-define(STATUS_PATROL, 1).
-define(STATUS_TRACK, 2).
-define(STATUS_FIGHT, 3).
-define(STATUS_RETURN, 4).
-define(STATUS_DEAD, 5).
-define(STATUS_QUEUE, 6).
-define(STATUS_STAND, 7).
-define(STATUS_WAIT_RELIVE, 8).

-define(MAP_TILE_SIZE, 128).

-define(LEFT, 1).
-define(RIGHT, 2).
-define(UP, 3).
-define(DOWN, 4).

%%%  道具配置文件
%% typeid道具的typeid
%% lv:等级
%% name:名称
%% gold:金币
%% effect：使用效果
-record(c_item, {typeid = 0, name = "", gold = 0, effect = undefined, data = []}).



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

-record(mon, {
        id = 0,                         % 1
        typeId = 0,                     % 2
        level = 0,                      % 3
        hp = 100,                       % 4
        att = 10,                       % 5
        attAcSpeed = 5,
        attInterval = 2,
        attDist = 1,
        attType = 0,
        runSpeed = 5,                   % 10
        runAcSpeed = 5,
        camp = 0,
        dir = 1,
        view = 2,                       % 视野
        patrol = 3,                     % 巡逻          % 15
        track = 4,                     % 追击
        status = 6,
        bornTK = 0,
        currTK = 0,
        aimId = 0                       % 20
    }).

-record(sprite, {
        id = 0,
        dbId = 0,
        typeId = 0,
        camp = 0,
        lv = 0,
        reborn = 0,
        hpLim = 0,
        hpLimRate = 1,
        hp = 100,
        speed = 0,
        att = 10,
        attRate = 1,
        attType = 0,
        attInterval = 2000,
        lastAttTime = 0,
        attDist = 1,
        patrol = 2,
        view = 2,
        track = 3,
        runSpeed = 2,
        runSpeedRate = 1,
        skillList = [],
        geniusId = 0,
        addSkillRate = 0,
        beHurtRate = 1,
        hurtRate = 1,
        undeadRate = 0,
        unControl = undefined,
        teleportRate = 0,
        addReduceHurtRate = 0,
        isJump = false,
        onTrap = undefined,                             % undefined 表示不在陷阱上，其他表示正在陷阱中, PSC_trap
        effectList = [],
        bornTK = 0,
        currTK = 0,
        lastTK = 0,
        lastWalkTime = 0,
        dir = 0,
        status = 0,
        aimId = 0,
        wind = 0,
        wood = 0,
        fire = 0,
        hill = 0,
        buff = [],
        buff2 = [],                                     % 用来存影响生命上限等类型的buff
        hurt = 0,
        attr = 0,
        drop = [],
        %% 魔神专用的三个字段用来计算属性
        attLv = 0,
        hpLv = 0,
        speedLv = 0,
        extractAtt = 0                                  % 同化技能专用字段
    }).

-record(buff_key, {parent, func}).
-record(buff, {key, typeId, parent, func, beginTick = 0, lastTick = 0, endTick = 0, args = [], inval = 0, count = 0}). 


%% 先攻
-define(EFFECT_PREEMPT, preempt).
-define(EFFECT_DODGE, dodge).
-define(EFFECT_AIMADDHP, aimaddhp).
-define(EFFECT_CRIT, crit).
-define(EFFECT_REDUCEHURT, reducehurt).
-define(EFFECT_REBOUNDHURT, reboundhurt).
-define(EFFECT_UNDEAD, undead).
-define(EFFECT_TELEPORT, teleport).
-define(EFFECT_SPEEDUP, speedup).
-define(EFFECT_SPRINT, sprint).
-define(EFFECT_JUMP, jump).
-define(EFFECT_POISON, poison).
-define(EFFECT_UNCONTROL, uncontrol).
-define(EFFECT_FIRE, fire).
-define(EFFECT_DROWNING, drowning).
-define(EFFECT_ROCK, rock).
-define(EFFECT_REDUCEHP, reducehp).
-define(EFFECT_RELIVE, relive).
-define(EFFECT_EXIT, exit).
-define(EFFECT_EXTRACT, extract).
-define(EFFECT_SUCKBLOOD, suckblood).
-define(EFFECT_UNPARALLELED, unparalleled).

-define(BUFF_REDUCE_HP, buff_reduce_hp).
-define(BUFF_UNCONTROL, buff_uncontrol).
-define(BUFF_ADD_HURT, buff_add_hurt).
-define(BUFF_ADD_BEHURT, buff_add_behurt).
-define(BUFF_SPEED, buff_speed).
-define(BUFF_ADD_HP, buff_add_hp).
-define(BUFF_ADD_SKILL_RATE, buff_add_skill_rate).
-define(BUFF_HP_LIM_RATE, buff_hp_lim_rate).
-define(BUFF_ATT_RATE, buff_att_rate).
-define(BUFF_EXTRACT, buff_extract).

-define(BUFF_ARG_RATE, buff_arg_rate).
-define(BUFF_ARG_VALUE, buff_arg_value).
-define(BUFF_ARG_RANGE, buff_arg_range).
-record(buff_args, {type, ref, value, value2}).



-record(war_status, {
        
        warId,                                  %% 本场战斗的唯一id
        attName = "",                           %% 攻击者的名字pvp专用
        defName = "",                           %% 防守方的名字PVP专用
        attLv = 0,                              %% 进攻方等级PVP专用
        defLv = 0,                              %% 防守方等级pvp专用
        isWaring = false,                       %% {db_other,1010,40138,12803,0,1399345470,1399345598,undefined,0,0,0,0,0,0}
        warType = 0,                            %% 战斗类型，suff pvp mvm dungeon nowar
        dungeonConfig,                          %% 如果是dungeon的话，当前floor的配置
        dungeon,                                %% 如果是dungeon的话，当前dungeon的数据
        isBossDead = false,                     %% 如果是dungeon的话，boss是否被击杀
        floor = 0,                              %% 如果是dungeon的话，当前挑战的层
        star = 0,                               %% 本场战斗的星级
        foundBox = 0,                           %% 是否找到宝箱
        foundExit = 0,                          %% 是否找到出口
        defMonNum = 0,                          %% 防守怪物数量
        attMonNum = 0,                          %% 进攻怪物数量
        beginTime = 0,                          %% 战斗开始的时间戳
        duration = 0,                           %% 战斗可以持续的时间戳
        endTime = 0,                            %% 战斗结束时间
        endCountdown = 0,                       %% 结束的倒计时
        isPause = false,                        %% 暂停只有PVE用到
        jump = 0,                               %% 英雄的跳跃次数
        sprint = 0,                             %% 英雄的冲刺次数
        aimCamp = 0,                            %% 目标阵营
        dropList = [],                          %% 所有的怪物的掉落，不一定都会掉
        aimLv = 1,                              %% 对手等级
        exit,                                   %% 地图出口
        hard = 1,                               %% 难度系数
        deadList = [],                          %% 怪物死亡的id
        endType = 0,                            %% 结束的类型，1正常，2玩家主动返回，3进入下一层, 4战斗中下线
        fightSeed,                              %% 战斗种子
        normalSeed,                             %% 普通走路的种子
        record,                                 %% 录像
	deadAtmId = 0 				%% mvm 存钱罐是否被打破
    }).

%% 进入战斗状态前触发的技能特效
-define(EFFECTS_BEFORE_STATUS_FIGHT, [?EFFECT_PREEMPT]).
%% 每次攻击计算伤害前触发的技能特效
-define(EFFECTS_BEFORE_CALC_HURT, [?EFFECT_CRIT, ?EFFECT_DODGE]).
%% 每次攻击计算伤害后触发的技能特效, 免伤必须在反伤前面
-define(EFFECTS_AFTER_CALC_HURT, [?EFFECT_SUCKBLOOD, ?EFFECT_AIMADDHP, ?EFFECT_REDUCEHURT, ?EFFECT_REBOUNDHURT]).
%% 每次攻击造成伤害后触发的技能特效
-define(EFFECTS_AFTER_HURT, [?EFFECT_UNDEAD, ?EFFECT_TELEPORT, ?EFFECT_EXTRACT, ?EFFECT_UNPARALLELED]).

%% 攻击方触发
-define(EFFECTS_ATT_ONLY, [?EFFECT_CRIT, ?EFFECT_EXTRACT, ?EFFECT_SUCKBLOOD, ?EFFECT_UNPARALLELED]).
-define(EFFECTS_BEATT_ONLY, [?EFFECT_DODGE, ?EFFECT_REDUCEHURT, ?EFFECT_REBOUNDHURT, ?EFFECT_UNDEAD, ?EFFECT_TELEPORT]).

%% 战斗进程
-define(BATTLE_GSV, battle_gsv).

%% 在地图上
-define(ON_MAP, 1).
%% 不在地图上
-define(NOT_ON_MAP, 0).

%% 在防守队列
-define(IN_TEAM, 1).
%% 不在防守队列
-define(NOT_IN_TEAM, 0).

%% 属性: 风林火山魔
-define(ATTR_WIND, 1).
-define(ATTR_WOOD, 2).
-define(ATTR_FIRE, 3).
-define(ATTR_HILL, 4).
-define(ATTR_ELITE, 5).

%% 类型
-define(TYPE_SKILL, 1).
-define(TYPE_ITEM, 2).
-define(TYPE_MON, 3).
-define(TYPE_ELITE, 4).
-define(TYPE_TRAP, 5).
-define(TYPE_GOLD, 6).
-define(TYPE_SOUL, 7).
-define(TYPE_KNOW, 8).
%  怪物碎片
-define(TYPE_MON_PART, 9).
-define(TYPE_ELITE_PART, 10).
%% 开礼盒的时候用到这个类型
-define(TYPE_GOLD_CONST, 11).
-define(TYPE_EXP, 12).
-define(TYPE_PHY, 13).
-define(TYPE_PVP_ATT, 14).
-define(TYPE_PVP_SUFF, 15).
-define(TYPE_PVE_ATT, 16).
-define(TYPE_PVE_SUFF, 17).
-define(TYPE_HOURGLASS, 18).
-define(TYPE_DIAMOND, 19).


% 怪物碎片收集完整，等于一个怪
-define(MON_PART_FINISH, 0).
-define(ELITE_PART_FINISH, 1).

%% 每10分钟增加的经验
-define(TEN_MINUTE_EXP, 100).

%% 英雄的id
-define(HERO_ID, 1).
%% 宝箱的战斗id
-define(BOXMON_ID, 3).
%% dungeon boss id
-define(DUNGEON_BOSS_ID, 4).
%% 进攻方的存钱罐id
-define(ATT_ATM_ID, 71).
%% 防守方的存钱罐id
-define(DEF_ATM_ID, 81).
%% 前端帧数
-define(FRAME_NUM, 30).

%% 每次转生可以降低20级
-define(REBORN_REDUCE_LV, 20).

%% 怪物颜色 绿蓝紫金
-define(COLOR_GREEN, 1).
-define(COLOR_BLUE, 2).
-define(COLOR_PURPLE, 3).
-define(COLOR_GOLD, 4).

%% 激战状态
%% 没有战斗
-define(NO_WAR, 0).
%% 迎击战
-define(SUFF_MON_WAR, 1).
%% 英雄pvp闯迷宫
-define(HERO_PVP_WAR, 2).
%% 魔兽PVP战场
-define(MON_PVP_WAR, 3).
%% 英雄pve
-define(HERO_PVE_WAR, 4).
%% 魔兽PVE战场
-define(MON_PVE_WAR, 5).

%% 阵营 系统
-define(CAMP_SYSTEM, 0).

%% Genius
-define(GENIUS_TAG_LIST, [god_health, god_song, god_wind, god_temple, god_destory, god_right, god_protect]).

%% 体力上限
-define(MAX_PHY, 30).

%% 英雄字段编号
-define(HERO_LV_KEY, 1).
-define(HERO_PHY_KEY, 2).
-define(HERO_DIAMOND_KEY, 3).
-define(HERO_GOLD_KEY, 4).
-define(HERO_SOUL_KEY, 5).
-define(HERO_KNOW_KEY, 6).
-define(HERO_CHARM_KEY, 7).
-define(HERO_PVPATT_KEY, 8).
-define(HERO_PVPSUFF_KEY, 9).
-define(HERO_PVEATT_KEY, 10).
-define(HERO_PVESUFF_KEY, 11).
-define(HERO_EXP_KEY, 12).
-define(HERO_HOURGLASS_KEY, 13).
-define(HERO_VIP_KEY, 14).

%% 星级
-define(STAR_ZERO, 0).
-define(STAR_ONE, 1).
-define(STAR_TWO, 2).
-define(STAR_THREE, 3).

%% 每日次数限制
-define(MAX_PVP_ATT, 20).
-define(MAX_PVP_SUFF, 20).
-define(MAX_PVE_ATT, 20).
-define(MAX_PVE_SUFF, 20).

%% 魔神字段编号
-define(ELITE_LV_KEY, 1).
-define(ELITE_EXP_KEY, 2).
-define(ELITE_HPLV_KEY, 3).
-define(ELITE_ATTLV_KEY, 4).
-define(ELITE_SPEEDLV_KEY, 5).
-define(ELITE_SKILLLV_KEY, 6).
-define(ELITE_GENIUSLV_KEY, 7).
-define(ELITE_BORNTK_KEY, 8).
-define(ELITE_REBORN_KEY, 9).
-define(ELITE_PART_KEY, 10).
-define(ELITE_FINISH_KEY, 11).

%% 小怪的字段编号
-define(MON_LV_KEY, 1).
-define(MON_EXP_KEY, 2).
-define(MON_BORNTK_KEY, 3).
-define(MON_REBORN_KEY, 4).
-define(MON_PART_KEY, 5).
-define(MON_ONMAP_KEY, 6).

-define(ELITE_MOUNT, 1).
-define(ELITE_UNMOUNT, 0).
-define(ELITE_COMMOND_ID, 210012).


%% 英雄最高等级
-define(MAX_HERO_LV, 100).

%% 地图类型
-define(MAP_SAND, 1001).
-define(MAP_MAYA, 1002).
-define(MAP_PRISON, 1003).
-define(MAP_CANDY, 1004).
-define(MAP_UNIVERSE, 1005).
-define(MAP_SNOW, 1006).
-define(MAP_TYPE_LIST, [?MAP_SAND, ?MAP_MAYA, ?MAP_PRISON, ?MAP_CANDY, ?MAP_UNIVERSE, ?MAP_SNOW]).

%% 保存录像
-record(save_fight, {attId = 0, beAttId = 0, hurt = 0}).

-define(WAR_ACTION_SPRINT_BEGIN, 1).
-define(WAR_ACTION_SPRINT_END, 2).
-define(WAR_ACTION_JUMP_UP, 3).
-define(WAR_ACTION_JUMP_DOWN, 4).
-define(WAR_ACTION_TRAP_TOUCH, 5).
-define(WAR_ACTION_TRAP_LEAVE, 6).
-define(WAR_ACTION_DIR, 7).
-define(WAR_ACTION_FIGHT, 8).
-define(WAR_ACTION_CANCEL, 9).
-define(WAR_ACTION_ON_EXIT, 10).
-define(WAR_ACTION_ENTER_MAP, 11).
-define(WAR_ACTION_DEAD, 12).
-define(WAR_ACTION_PAUSE, 13).
-define(WAR_ACTION_RESUME, 14).
-define(WAR_ACTION_RESET_TIME,15).
-define(WAR_ACTION_ATM_DEAD,16).

%% war结束的类型
-define(WAR_END_CHECK, 0).
-define(WAR_END_NORMAL, 1).
-define(WAR_END_CANCEL, 2).
-define(WAR_END_NEXTFLOOR, 3).
-define(WAR_END_OFFLINE, 4).
-define(WAR_END_TIMELIMIT, 5).

%% 
-define(NOT_FOUND, 0).
-define(FOUND, 1).

%% 战斗id
-define(ATT_HERO_WAR_ID, 1).
-define(DEF_HERO_WAR_ID, 2).
-define(ATT_ELITE_WAR_ID, 101).
-define(DEF_ELITE_WAR_ID, 201).
-define(ATT_TRAP_WAR_ID, 301).
-define(DEF_TRAP_WAR_ID, 401).
-define(ATT_MON_WAR_ID, 501).
-define(DEF_MON_WAR_ID, 601).

%% 通用起始ID
-define(START_ID, 1000).

%% 星级
-define(HARD_STAR_ZERO, 0).
-define(HARD_STAR_ONE, 1).
-define(HARD_STAR_TWO, 2).
-define(HARD_STAR_THREE, 3).
-define(HARD_STAR_FOUR, 4).
-define(HARD_STAR_FIVE, 5).

%% 白天
-define(DAY, 0).
-define(NIGHT, 1).

%% 怪物相性与当前相同
-define(ATTR_DAYNIGHT_SAME, 0).
%% 怪物相性与当前相反
-define(ATTR_DAYNIGHT_OPP, 1).
%% 怪物相性与当前随机
-define(ATTR_DAYNIGHT_RAN, 2).

%% 需要扣钱
-define(NEED_PAY, 1).

%% 宝箱颜色 配合前端，从2起始
%铜
-define(COPPER_BOX, 2).
-define(SILVER_BOX, 3).
-define(GOLD_BOX, 4).

%% 战斗最长时间
-define(MAX_WAR_TIME, 5 * 60).
%% 战斗最大tick
-define(MAX_WAR_TICK, ?MAX_WAR_TIME * ?FRAME_NUM + 50).

%% 各种格子
-define(SRV_TILE_NIL, 0).
-define(SRV_TILE_L, 1).
-define(SRV_TILE_U, 2).
-define(SRV_TILE_R, 4).
-define(SRV_TILE_D, 8).
-define(SRV_TILE_LU, 3).
-define(SRV_TILE_LR, 5).
-define(SRV_TILE_UR, 6 ).
-define(SRV_TILE_LD, 9).
-define(SRV_TILE_UD, 10).
-define(SRV_TILE_RD, 12).
-define(SRV_TILE_LUR, 7).
-define(SRV_TILE_LUD, 11).
-define(SRV_TILE_LRD, 13).
-define(SRV_TILE_URD, 14).
-define(SRV_TILE_LURD, 15).


%% dungeon boss
-define(MIN_DUNGEON_BOSS_TYPEID, 600001).
-define(MAX_DUNGEON_BOSS_TYPEID, 600032).

%% dungeon type
-define(DUNGEON_PVP, 0).
-define(DUNGEON_GRASS, 1001).
-define(DUNGEON_MAYA, 1002).
-define(DUNGEON_PRISON, 1003).
-define(DUNGEON_CANDY, 1004).
-define(DUNGEON_UNIVERSE, 1005).
-define(DUNGEON_SNOW, 1006).
-define(DUNGEON_SAND, 1007).

%% 颜色对掉落的影响
-define(GREEN_RATEFAC, 2).
-define(BLUE_RATEFAC, 2).
-define(PURPLE_RATEFAC, 3).
-define(GOLD_RATEFAC, 4).

%% system notice
-define(NOTICE_ERR_LOGIN_AGAIN, 1).

-define(UNFINISHED, 0).
-define(FINISHED, 1).
-define(UNAWARDED, 0).
-define(AWARDED, 1).

%% activity
-define(ACTIVITY_PAY, 1).
-define(ACTIVITY_GOAL, 2).
-define(ACTIVITY_EVERMAZE, 3).
-define(ACTIVITY_MONHUNTER, 4).
-define(ACTIVITY_TWINS, 5).
-define(ACTIVITY_REBATE, 6).


