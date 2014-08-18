
%% error code

%% success
-define(ADMIN_SUCC, 0).
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
%% email type error
-define(ADMIN_ERROR_EMAIL_TYPE, 7).

%% proto id
-record(ares_err, {error}).

%% 查询玩家详细信息
-record(areq_player_info, {type, data}).
-record(ares_player_info, {account, hero, eliteList, monList, trapList, itemList, skinList,
	other, isOnline}).
%% 根据玩家id查询
-define(TYPE_PLAYER_ID, 1).
%% 根据玩家名字查询
-define(TYPE_PLAYER_NAME, 2).
%% 根据玩家账号查询
-define(TYPE_PLAYER_ACCNAME, 3).

%% 给玩家发邮件
% 发给所有人
-define(TYPE_EMAIL_ALL, 1).
% 发给列表的玩家
-define(TYPE_EMAIL_ID_LIST, 2).
-define(TYPE_EMAIL_NAME_LIST, 3).
-define(TYPE_EMAIL_ACCNAME_LIST, 4).
-record(areq_email, {type, list, str, itemList}).

