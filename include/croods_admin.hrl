
%% 几张表
% 通用内存表
-define(E_MISC, e_misc).
% 通用表
-define(D_MISC, d_misc).
% 日志表
-define(D_LOG, d_log).
% 用户表
-define(D_USER, d_user).
-record(d_user, {name, passwd, group, status = 0}).
% 组
-define(D_GROUP, d_group).
-record(d_group, {group, access_list = [], user_list = [], status = 0}).


%% 一级菜单
-define(F_PLAYER, "玩家管理").
-define(F_ACCOUNT, "用户和组").
-define(F_SERVER, "服务器管理").
%% 二级菜单
-define(S_PLAYER_INFO, "玩家详细信息").
-define(S_EMAIL, "发邮件").
-define(S_ACCOUNT, "用户管理").
-define(S_GROUP, "组管理").
-define(S_ACCESS, "权限管理").
%% 权限列表
-define(ACCESS_LIST, [
	?F_PLAYER, ?F_ACCOUNT, ?F_SERVER,

	?S_PLAYER_INFO, ?S_EMAIL, ?S_ACCOUNT,
	?S_GROUP, ?S_ACCESS
	]).


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
%% not online
-define(ADMIN_ERROR_NOT_ONLINE, 8).

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


%% 踢玩家下线
-record(areq_kickoff, {id = 0}).

%% 设置账号状态
-record(areq_account_status, {id = 0, accname = "", status}).
