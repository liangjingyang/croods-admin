
%% error code

%% http body error
-define(ADMIN_ERROR_BODY, 1).
%% token error
-define(ADMIN_ERROR_AUTH, 2).
%% proto error
-define(ADMIN_ERROR_PROTO, 3).
%% no player name
-define(ADMIN_ERROR_NO_NAME, 4).
%% no player accname
-define(ADMIN_ERROR_NO_ACCNAME, 5).
%% system error
-define(ADMIN_ERROR_SYSTEM, 6).

%% proto id
-record(ares_error, {error}).

%% 查询玩家详细信息
-record(areq_player_info, {type, data}).
-record(ares_player_info, {hero, eliteList, monList, trapList, itemList, skinList,
	other, isOnline}).
%% 
-define(TYPE_PLAYER_ID, 1).
-define(TYPE_PLAYER_NAME, 2).
-define(TYPE_PLAYER_ACCNAME, 3).
