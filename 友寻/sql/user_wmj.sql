/** 用户单身属性，单身好友确认数木属性添加 **/
use user_0;
alter table `user_moreinfo_0` add `lonely_confirm` int(10) unsigned not null default 0 comment '单身好友确认数';

use user_1;
alter table `user_moreinfo_1` add `lonely_confirm` int(10) unsigned not null default 0 comment '单身好友确认数';

use user_2;
alter table `user_moreinfo_2` add `lonely_confirm` int(10) unsigned not null default 0 comment '单身好友确认数';

use user_3;
alter table `user_moreinfo_3` add `lonely_confirm` int(10) unsigned not null default 0 comment '单身好友确认数';

use user_4;
alter table `user_moreinfo_4` add `lonely_confirm` int(10) unsigned not null default 0 comment '单身好友确认数';

use user_5;
alter table `user_moreinfo_5` add `lonely_confirm` int(10) unsigned not null default 0 comment '单身好友确认数';

use user_6;
alter table `user_moreinfo_6` add `lonely_confirm` int(10) unsigned not null default 0 comment '单身好友确认数';

use user_7;
alter table `user_moreinfo_7` add `lonely_confirm` int(10) unsigned not null default 0 comment '单身好友确认数';

use user_8;
alter table `user_moreinfo_8` add `lonely_confirm` int(10) unsigned not null default 0 comment '单身好友确认数';

use user_9;
alter table `user_moreinfo_9` add `lonely_confirm` int(10) unsigned not null default 0 comment '单身好友确认数';


use user_0;
alter table user_moreinfo_0 add `callno_upload` tinyint(4) not null default 0 comment '0:未上传1:已上传';

use user_1;
alter table user_moreinfo_1 add `callno_upload` tinyint(4) not null default 0 comment '0:未上传1:已上传';

use user_2;
alter table user_moreinfo_2 add `callno_upload` tinyint(4) not null default 0 comment '0:未上传1:已上传';

use user_3;
alter table user_moreinfo_3 add `callno_upload` tinyint(4) not null default 0 comment '0:未上传1:已上传';

use user_4;
alter table user_moreinfo_4 add `callno_upload` tinyint(4) not null default 0 comment '0:未上传1:已上传';

use user_5;
alter table user_moreinfo_5 add `callno_upload` tinyint(4) not null default 0 comment '0:未上传1:已上传';

use user_6;
alter table user_moreinfo_6 add `callno_upload` tinyint(4) not null default 0 comment '0:未上传1:已上传';

use user_7;
alter table user_moreinfo_7 add `callno_upload` tinyint(4) not null default 0 comment '0:未上传1:已上传';

use user_8;
alter table user_moreinfo_8 add `callno_upload` tinyint(4) not null default 0 comment '0:未上传1:已上传';

use user_9;
alter table user_moreinfo_9 add `callno_upload` tinyint(4) not null default 0 comment '0:未上传1:已上传';





/** 学校，公司属性修改,添加常住地  *****/
use user_0;
alter table user_moreinfo_0 
	modify `company_name` varchar(30) not null default '',
	modify `school` varchar(30) not null default'',
	add `address` varchar(30) not null default '';

use user_1;
alter table user_moreinfo_1 
	modify `company_name` varchar(30) not null default '',
	modify `school` varchar(30) not null default'',
	add `address` varchar(30) not null default '';

use user_2;
alter table user_moreinfo_2 
	modify `company_name` varchar(30) not null default '',
	modify `school` varchar(30) not null default'',
	add `address` varchar(30) not null default '';

use user_3;
alter table user_moreinfo_3 
	modify `company_name` varchar(30) not null default '',
	modify `school` varchar(30) not null default'',
	add `address` varchar(30) not null default '';

use user_4;
alter table user_moreinfo_4 
	modify `company_name` varchar(30) not null default '',
	modify `school` varchar(30) not null default'',
	add `address` varchar(30) not null default '';

use user_5;
alter table user_moreinfo_5 
	modify `company_name` varchar(30) not null default '',
	modify `school` varchar(30) not null default'',
	add `address` varchar(30) not null default '';

use user_6;
alter table user_moreinfo_6 
	modify `company_name` varchar(30) not null default '',
	modify `school` varchar(30) not null default'',
	add `address` varchar(30) not null default '';

use user_7;
alter table user_moreinfo_7 
	modify `company_name` varchar(30) not null default '',
	modify `school` varchar(30) not null default'',
	add `address` varchar(30) not null default '';

use user_8;
alter table user_moreinfo_8 
	modify `company_name` varchar(30) not null default '',
	modify `school` varchar(30) not null default'',
	add `address` varchar(30) not null default '';

use user_9;
alter table user_moreinfo_9 
	modify `company_name` varchar(30) not null default '',
	modify `school` varchar(30) not null default'',
	add `address` varchar(30) not null default '';
	
use user_0;
alter table user_moreinfo_0 
      add `show_second_friend_dync` tinyint(4) not null default 1 comment '是否显示二度好友动态',
      add `allow_second_friend_look_my_dync` tinyint(4) not null default 1 comment '是否允许二度好友查看我的动态',
      add `allow_accept_second_friend_invite` tinyint(4) not null default 1 comment '是否接受二度好友邀请加入群',
      add `allow_add_with_chat` tinyint(4) not null comment '好友与聊天',
      add `allow_my_profile_show` tinyint(4) not null comment '动态相册资料展示';

use user_1;
alter table user_moreinfo_1 
      add `show_second_friend_dync` tinyint(4) not null default 1 comment '是否显示二度好友动态',
      add `allow_second_friend_look_my_dync` tinyint(4) not null default 1 comment '是否允许二度好友查看我的动态',
      add `allow_accept_second_friend_invite` tinyint(4) not null default 1 comment '是否接受二度好友邀请加入群',
      add `allow_add_with_chat` tinyint(4) not null comment '好友与聊天',
      add `allow_my_profile_show` tinyint(4) not null comment '动态相册资料展示';

use user_2;
alter table user_moreinfo_2 
      add `show_second_friend_dync` tinyint(4) not null default 1 comment '是否显示二度好友动态',
      add `allow_second_friend_look_my_dync` tinyint(4) not null default 1 comment '是否允许二度好友查看我的动态',
      add `allow_accept_second_friend_invite` tinyint(4) not null default 1 comment '是否接受二度好友邀请加入群',
      add `allow_add_with_chat` tinyint(4) not null comment '好友与聊天',
      add `allow_my_profile_show` tinyint(4) not null comment '动态相册资料展示';

use user_3;
alter table user_moreinfo_3 
      add `show_second_friend_dync` tinyint(4) not null default 1 comment '是否显示二度好友动态',
      add `allow_second_friend_look_my_dync` tinyint(4) not null default 1 comment '是否允许二度好友查看我的动态',
      add `allow_accept_second_friend_invite` tinyint(4) not null default 1 comment '是否接受二度好友邀请加入群',
      add `allow_add_with_chat` tinyint(4) not null comment '好友与聊天',
      add `allow_my_profile_show` tinyint(4) not null comment '动态相册资料展示';

use user_4;
alter table user_moreinfo_4 
      add `show_second_friend_dync` tinyint(4) not null default 1 comment '是否显示二度好友动态',
      add `allow_second_friend_look_my_dync` tinyint(4) not null default 1 comment '是否允许二度好友查看我的动态',
      add `allow_accept_second_friend_invite` tinyint(4) not null default 1 comment '是否接受二度好友邀请加入群',
      add `allow_add_with_chat` tinyint(4) not null comment '好友与聊天',
      add `allow_my_profile_show` tinyint(4) not null comment '动态相册资料展示';

use user_5;
alter table user_moreinfo_5 
      add `show_second_friend_dync` tinyint(4) not null default 1 comment '是否显示二度好友动态',
      add `allow_second_friend_look_my_dync` tinyint(4) not null default 1 comment '是否允许二度好友查看我的动态',
      add `allow_accept_second_friend_invite` tinyint(4) not null default 1 comment '是否接受二度好友邀请加入群',
      add `allow_add_with_chat` tinyint(4) not null comment '好友与聊天',
      add `allow_my_profile_show` tinyint(4) not null comment '动态相册资料展示';

use user_6;
alter table user_moreinfo_6 
      add `show_second_friend_dync` tinyint(4) not null default 1 comment '是否显示二度好友动态',
      add `allow_second_friend_look_my_dync` tinyint(4) not null default 1 comment '是否允许二度好友查看我的动态',
      add `allow_accept_second_friend_invite` tinyint(4) not null default 1 comment '是否接受二度好友邀请加入群',
      add `allow_add_with_chat` tinyint(4) not null comment '好友与聊天',
      add `allow_my_profile_show` tinyint(4) not null comment '动态相册资料展示';

use user_7;
alter table user_moreinfo_7 
      add `show_second_friend_dync` tinyint(4) not null default 1 comment '是否显示二度好友动态',
      add `allow_second_friend_look_my_dync` tinyint(4) not null default 1 comment '是否允许二度好友查看我的动态',
      add `allow_accept_second_friend_invite` tinyint(4) not null default 1 comment '是否接受二度好友邀请加入群',
      add `allow_add_with_chat` tinyint(4) not null comment '好友与聊天',
      add `allow_my_profile_show` tinyint(4) not null comment '动态相册资料展示';

use user_8;
alter table user_moreinfo_8 
      add `show_second_friend_dync` tinyint(4) not null default 1 comment '是否显示二度好友动态',
      add `allow_second_friend_look_my_dync` tinyint(4) not null default 1 comment '是否允许二度好友查看我的动态',
      add `allow_accept_second_friend_invite` tinyint(4) not null default 1 comment '是否接受二度好友邀请加入群',
      add `allow_add_with_chat` tinyint(4) not null comment '好友与聊天',
      add `allow_my_profile_show` tinyint(4) not null comment '动态相册资料展示';

use user_9;
alter table user_moreinfo_9 
      add `show_second_friend_dync` tinyint(4) not null default 1 comment '是否显示二度好友动态',
      add `allow_second_friend_look_my_dync` tinyint(4) not null default 1 comment '是否允许二度好友查看我的动态',
      add `allow_accept_second_friend_invite` tinyint(4) not null default 1 comment '是否接受二度好友邀请加入群',
      add `allow_add_with_chat` tinyint(4) not null comment '好友与聊天',
      add `allow_my_profile_show` tinyint(4) not null comment '动态相册资料展示';



/** 用户单身确认流水单 **/
use user_0;
create table user_lonely_confirm_0 (
	id int(10) unsigned not null auto_increment,
	uid bigint(20) unsigned not null,
	friend_uid bigint(20) unsigned not null,
	ctime datetime not null,
	primary key (id),
	key (uid)
);

use user_1;
create table user_lonely_confirm_1 (
	id int(10) unsigned not null auto_increment,
	uid bigint(20) unsigned not null,
	friend_uid bigint(20) unsigned not null,
	ctime datetime not null,
	primary key (id),
	key (uid)
);

use user_2;
create table user_lonely_confirm_2 (
	id int(10) unsigned not null auto_increment,
	uid bigint(20) unsigned not null,
	friend_uid bigint(20) unsigned not null,
	ctime datetime not null,
	primary key (id),
	key (uid)
);

use user_3;
create table user_lonely_confirm_3 (
	id int(10) unsigned not null auto_increment,
	uid bigint(20) unsigned not null,
	friend_uid bigint(20) unsigned not null,
	ctime datetime not null,
	primary key (id),
	key (uid)
);

use user_4;
create table user_lonely_confirm_4 (
	id int(10) unsigned not null auto_increment,
	uid bigint(20) unsigned not null,
	friend_uid bigint(20) unsigned not null,
	ctime datetime not null,
	primary key (id),
	key (uid)
);

use user_5;
create table user_lonely_confirm_5 (
	id int(10) unsigned not null auto_increment,
	uid bigint(20) unsigned not null,
	friend_uid bigint(20) unsigned not null,
	ctime datetime not null,
	primary key (id),
	key (uid)
);

use user_6;
create table user_lonely_confirm_6 (
	id int(10) unsigned not null auto_increment,
	uid bigint(20) unsigned not null,
	friend_uid bigint(20) unsigned not null,
	ctime datetime not null,
	primary key (id),
	key (uid)
);

use user_7;
create table user_lonely_confirm_7 (
	id int(10) unsigned not null auto_increment,
	uid bigint(20) unsigned not null,
	friend_uid bigint(20) unsigned not null,
	ctime datetime not null,
	primary key (id),
	key (uid)
);

use user_8;
create table user_lonely_confirm_8 (
	id int(10) unsigned not null auto_increment,
	uid bigint(20) unsigned not null,
	friend_uid bigint(20) unsigned not null,
	ctime datetime not null,
	primary key (id),
	key (uid)
);

use user_9;
create table user_lonely_confirm_9 (
	id int(10) unsigned not null auto_increment,
	uid bigint(20) unsigned not null,
	friend_uid bigint(20) unsigned not null,
	ctime datetime not null,
	primary key (id),
	key (uid)
);



/** 好友昵称备注信息 **/
use user_0;
create table user_mark_0(
id int(10) unsigned not null auto_increment,
uid bigint(20) unsigned not null,
from_uid bigint(20) unsigned not null,
mark varchar(30) not null,
ctime int(10),
primary key (id),
key (uid)
);

use user_1;
create table user_mark_1(
id int(10) unsigned not null auto_increment,
uid bigint(20) unsigned not null,
from_uid bigint(20) unsigned not null,
mark varchar(30) not null,
ctime int(10),
primary key (id),
key (uid)
);

use user_2;
create table user_mark_2(
id int(10) unsigned not null auto_increment,
uid bigint(20) unsigned not null,
from_uid bigint(20) unsigned not null,
mark varchar(30) not null,
ctime int(10),
primary key (id),
key (uid)
);

use user_3;
create table user_mark_3(
id int(10) unsigned not null auto_increment,
uid bigint(20) unsigned not null,
from_uid bigint(20) unsigned not null,
mark varchar(30) not null,
ctime int(10),
primary key (id),
key (uid)
);

use user_4;
create table user_mark_4(
id int(10) unsigned not null auto_increment,
uid bigint(20) unsigned not null,
from_uid bigint(20) unsigned not null,
mark varchar(30) not null,
ctime int(10),
primary key (id),
key (uid)
);

use user_5;
create table user_mark_5(
id int(10) unsigned not null auto_increment,
uid bigint(20) unsigned not null,
from_uid bigint(20) unsigned not null,
mark varchar(30) not null,
ctime int(10),
primary key (id),
key (uid)
);

use user_6;
create table user_mark_6(
id int(10) unsigned not null auto_increment,
uid bigint(20) unsigned not null,
from_uid bigint(20) unsigned not null,
mark varchar(30) not null,
ctime int(10),
primary key (id),
key (uid)
);

use user_7;
create table user_mark_7(
id int(10) unsigned not null auto_increment,
uid bigint(20) unsigned not null,
from_uid bigint(20) unsigned not null,
mark varchar(30) not null,
ctime int(10),
primary key (id),
key (uid)
);

use user_8;
create table user_mark_8(
id int(10) unsigned not null auto_increment,
uid bigint(20) unsigned not null,
from_uid bigint(20) unsigned not null,
mark varchar(30) not null,
ctime int(10),
primary key (id),
key (uid)
);

use user_9;
create table user_mark_9(
id int(10) unsigned not null auto_increment,
uid bigint(20) unsigned not null,
from_uid bigint(20) unsigned not null,
mark varchar(30) not null,
ctime int(10),
primary key (id),
key (uid)
);


/** 用户标签 **/
use user;
create table tag_info(
	tid bigint(20) not null,
	title varchar(30) not null,
	ctime int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';


use user_0;
create table user_tag_0(
	`id`    int(10) unsigned not null auto_increment,
	`uid`   bigint(20) unsigned not null,
	`tid`   bigint(20) unsigned not null,
	`title` varchar(30) not null,
	`bind`  int(10) unsigned not null,
	`ctime` int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_0(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) not null,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_1;
create table user_tag_1(
	`id`    int(10) unsigned not null auto_increment,
	`uid`   bigint(20) unsigned not null,
	`tid`   bigint(20) unsigned not null,
	`title` varchar(30) not null,
	`bind`  int(10) unsigned not null,
	`ctime` int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_1(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) not null,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_2;
create table user_tag_2(
	`id`    int(10) unsigned not null auto_increment,
	`uid`   bigint(20) unsigned not null,
	`tid`   bigint(20) unsigned not null,
	`title` varchar(30) not null,
	`bind`  int(10) unsigned not null,
	`ctime` int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_2(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) not null,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_3;
create table user_tag_3(
	`id`    int(10) unsigned not null auto_increment,
	`uid`   bigint(20) unsigned not null,
	`tid`   bigint(20) unsigned not null,
	`title` varchar(30) not null,
	`bind`  int(10) unsigned not null,
	`ctime` int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_3(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) not null,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_4;
create table user_tag_4(
	`id`    int(10) unsigned not null auto_increment,
	`uid`   bigint(20) unsigned not null,
	`tid`   bigint(20) unsigned not null,
	`title` varchar(30) not null,
	`bind`  int(10) unsigned not null,
	`ctime` int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_4(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) not null,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_5;
create table user_tag_5(
	`id`    int(10) unsigned not null auto_increment,
	`uid`   bigint(20) unsigned not null,
	`tid`   bigint(20) unsigned not null,
	`title` varchar(30) not null,
	`bind`  int(10) unsigned not null,
	`ctime` int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_5(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) not null,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_6;
create table user_tag_6(
	`id`    int(10) unsigned not null auto_increment,
	`uid`   bigint(20) unsigned not null,
	`tid`   bigint(20) unsigned not null,
	`title` varchar(30) not null,
	`bind`  int(10) unsigned not null,
	`ctime` int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_6(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) not null,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_7;
create table user_tag_7(
	`id`    int(10) unsigned not null auto_increment,
	`uid`   bigint(20) unsigned not null,
	`tid`   bigint(20) unsigned not null,
	`title` varchar(30) not null,
	`bind`  int(10) unsigned not null,
	`ctime` int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_7(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) not null,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_8;
create table user_tag_8(
	`id`    int(10) unsigned not null auto_increment,
	`uid`   bigint(20) unsigned not null,
	`tid`   bigint(20) unsigned not null,
	`title` varchar(30) not null,
	`bind`  int(10) unsigned not null,
	`ctime` int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_8(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) not null,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_9;
create table user_tag_9(
	`id`    int(10) unsigned not null auto_increment,
	`uid`   bigint(20) unsigned not null,
	`tid`   bigint(20) unsigned not null,
	`title` varchar(30) not null,
	`bind`  int(10) unsigned not null,
	`ctime` int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_9(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) not null,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';




create database tags_0;
use tags_0;
create table tag_info_0(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_uid_0(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) not null,
	`ctime`  int(10),
	primary key (id),
	key(tid)
) comment '标签与用户的绑定[一对多]';


create database tags_1;
use tags_1;
create table tag_info_1(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_uid_1(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) not null,
	`ctime`  int(10),
	primary key (id),
	key(tid)
) comment '标签与用户的绑定[一对多]';


create database tags_2;
use tags_2;
create table tag_info_2(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_uid_2(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) not null,
	`ctime`  int(10),
	primary key (id),
	key(tid)
) comment '标签与用户的绑定[一对多]';


create database tags_3;
use tags_3;
create table tag_info_3(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_uid_3(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) not null,
	`ctime`  int(10),
	primary key (id),
	key(tid)
) comment '标签与用户的绑定[一对多]';


create database tags_4;
use tags_4;
create table tag_info_4(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_uid_4(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) not null,
	`ctime`  int(10),
	primary key (id),
	key(tid)
) comment '标签与用户的绑定[一对多]';


create database tags_5;
use tags_5;
create table tag_info_5(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_uid_5(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) not null,
	`ctime`  int(10),
	primary key (id),
	key(tid)
) comment '标签与用户的绑定[一对多]';


create database tags_6;
use tags_6;
create table tag_info_6(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_uid_6(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) not null,
	`ctime`  int(10),
	primary key (id),
	key(tid)
) comment '标签与用户的绑定[一对多]';


create database tags_7;
use tags_7;
create table tag_info_7(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_uid_7(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) not null,
	`ctime`  int(10),
	primary key (id),
	key(tid)
) comment '标签与用户的绑定[一对多]';


create database tags_8;
use tags_8;
create table tag_info_8(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_uid_8(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) not null,
	`ctime`  int(10),
	primary key (id),
	key(tid)
) comment '标签与用户的绑定[一对多]';


create database tags_9;
use tags_9;
create table tag_info_9(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_uid_9(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) not null,
	`ctime`  int(10),
	primary key (id),
	key(tid)
) comment '标签与用户的绑定[一对多]';



/** 微信公众号用户每日推荐单身用户明细 **/
use user_0;
create table user_0.user_single_0(
	id                 int(10) unsigned not null auto_increment,
	uid                bigint(20) unsigned not null,
	day                varchar(12) not null,
	single_uid         bigint(20) not null,
	sex                tinyint(2) not null,
	nick               varchar(30) not null,
	birthday           int(10) not null,
	live_location      int(10) unsigned not null,
	live_sublocation   int(10) unsigned not null,
	love               tinyint(2) not null,
	ctime              int(10) unsigned not null,
	primary key (id),
	unique key (uid, day, single_uid)
);

use user_1;
create table user_1.user_single_1(
	id                 int(10) unsigned not null auto_increment,
	uid                bigint(20) unsigned not null,
	day                varchar(12) not null,
	single_uid         bigint(20) not null,
	sex                tinyint(2) not null,
	nick               varchar(30) not null,
	birthday           int(10) not null,
	live_location      int(10) unsigned not null,
	live_sublocation   int(10) unsigned not null,
	love               tinyint(2) not null,
	ctime              int(10) unsigned not null,
	primary key (id),
	unique key (uid, day, single_uid)
);

use user_2;
create table user_2.user_single_2(
	id                 int(10) unsigned not null auto_increment,
	uid                bigint(20) unsigned not null,
	day                varchar(12) not null,
	single_uid         bigint(20) not null,
	sex                tinyint(2) not null,
	nick               varchar(30) not null,
	birthday           int(10) not null,
	live_location      int(10) unsigned not null,
	live_sublocation   int(10) unsigned not null,
	love               tinyint(2) not null,
	ctime              int(10) unsigned not null,
	primary key (id),
	unique key (uid, day, single_uid)
);

use user_3;
create table user_3.user_single_3(
	id                 int(10) unsigned not null auto_increment,
	uid                bigint(20) unsigned not null,
	day                varchar(12) not null,
	single_uid         bigint(20) not null,
	sex                tinyint(2) not null,
	nick               varchar(30) not null,
	birthday           int(10) not null,
	live_location      int(10) unsigned not null,
	live_sublocation   int(10) unsigned not null,
	love               tinyint(2) not null,
	ctime              int(10) unsigned not null,
	primary key (id),
	unique key (uid, day, single_uid)
);

use user_4;
create table user_4.user_single_4(
	id                 int(10) unsigned not null auto_increment,
	uid                bigint(20) unsigned not null,
	day                varchar(12) not null,
	single_uid         bigint(20) not null,
	sex                tinyint(2) not null,
	nick               varchar(30) not null,
	birthday           int(10) not null,
	live_location      int(10) unsigned not null,
	live_sublocation   int(10) unsigned not null,
	love               tinyint(2) not null,
	ctime              int(10) unsigned not null,
	primary key (id),
	unique key (uid, day, single_uid)
);

use user_5;
create table user_5.user_single_5(
	id                 int(10) unsigned not null auto_increment,
	uid                bigint(20) unsigned not null,
	day                varchar(12) not null,
	single_uid         bigint(20) not null,
	sex                tinyint(2) not null,
	nick               varchar(30) not null,
	birthday           int(10) not null,
	live_location      int(10) unsigned not null,
	live_sublocation   int(10) unsigned not null,
	love               tinyint(2) not null,
	ctime              int(10) unsigned not null,
	primary key (id),
	unique key (uid, day, single_uid)
);

use user_6;
create table user_6.user_single_6(
	id                 int(10) unsigned not null auto_increment,
	uid                bigint(20) unsigned not null,
	day                varchar(12) not null,
	single_uid         bigint(20) not null,
	sex                tinyint(2) not null,
	nick               varchar(30) not null,
	birthday           int(10) not null,
	live_location      int(10) unsigned not null,
	live_sublocation   int(10) unsigned not null,
	love               tinyint(2) not null,
	ctime              int(10) unsigned not null,
	primary key (id),
	unique key (uid, day, single_uid)
);

use user_7;
create table user_7.user_single_7(
	id                 int(10) unsigned not null auto_increment,
	uid                bigint(20) unsigned not null,
	day                varchar(12) not null,
	single_uid         bigint(20) not null,
	sex                tinyint(2) not null,
	nick               varchar(30) not null,
	birthday           int(10) not null,
	live_location      int(10) unsigned not null,
	live_sublocation   int(10) unsigned not null,
	love               tinyint(2) not null,
	ctime              int(10) unsigned not null,
	primary key (id),
	unique key (uid, day, single_uid)
);

use user_8;
create table user_8.user_single_8(
	id                 int(10) unsigned not null auto_increment,
	uid                bigint(20) unsigned not null,
	day                varchar(12) not null,
	single_uid         bigint(20) not null,
	sex                tinyint(2) not null,
	nick               varchar(30) not null,
	birthday           int(10) not null,
	live_location      int(10) unsigned not null,
	live_sublocation   int(10) unsigned not null,
	love               tinyint(2) not null,
	ctime              int(10) unsigned not null,
	primary key (id),
	unique key (uid, day, single_uid)
);

use user_9;
create table user_9.user_single_9(
	id                 int(10) unsigned not null auto_increment,
	uid                bigint(20) unsigned not null,
	day                varchar(12) not null,
	single_uid         bigint(20) not null,
	sex                tinyint(2) not null,
	nick               varchar(30) not null,
	birthday           int(10) not null,
	live_location      int(10) unsigned not null,
	live_sublocation   int(10) unsigned not null,
	love               tinyint(2) not null,
	ctime              int(10) unsigned not null,
	primary key (id),
	unique key (uid, day, single_uid)
);

