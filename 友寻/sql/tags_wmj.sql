/** 标签明细 **/
use user;
create table tag_info(
	tid bigint(20) not null,
	title varchar(30) not null,
	ctime int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

/** 个人备选标签 **/
use user;
create table alternative_tag_info(
	`tid` bigint(20) unsigned not null,
	`title` varchar(30) not null,
	`ctime` int(10),
        `sex` tinyint(2) unsigned not null,
        `status` tinyint(2) unsigned not null default 1,
	primary key (`tid`),
	unique key (`title`,`sex`),
        key `list` (`ctime`,`status`)
) comment '备选标签';

/** 用户与标签的绑定关系 **/
use user_0;
create table user_tag_0(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`form_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`title`    varchar(30) not null,
	`bind`     int(10) unsigned not null default 0,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_0(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_1;
create table user_tag_1(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`form_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`title`    varchar(30) not null,
	`bind`     int(10) unsigned not null default 0,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_1(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_2;
create table user_tag_2(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`form_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`title`    varchar(30) not null,
	`bind`     int(10) unsigned not null default 0,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_2(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_3;
create table user_tag_3(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`form_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`title`    varchar(30) not null,
	`bind`     int(10) unsigned not null default 0,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_3(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_4;
create table user_tag_4(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`form_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`title`    varchar(30) not null,
	`bind`     int(10) unsigned not null default 0,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_4(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_5;
create table user_tag_5(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`form_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`title`    varchar(30) not null,
	`bind`     int(10) unsigned not null default 0,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_5(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_6;
create table user_tag_6(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`form_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`title`    varchar(30) not null,
	`bind`     int(10) unsigned not null default 0,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_6(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_7;
create table user_tag_7(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`form_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`title`    varchar(30) not null,
	`bind`     int(10) unsigned not null default 0,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_7(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_8;
create table user_tag_8(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`form_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`title`    varchar(30) not null,
	`bind`     int(10) unsigned not null default 0,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_8(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';

use user_9;
create table user_tag_9(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`form_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`title`    varchar(30) not null,
	`bind`     int(10) unsigned not null default 0,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid)
) comment '用户标签明细';

create table user_tag_bind_9(
	`id`       int(10) unsigned not null auto_increment,
	`uid`      bigint(20) unsigned not null,
	`from_uid` bigint(20) unsigned not null,
	`tid`      bigint(20) unsigned not null,
	`status`   tinyint(2) unsigned not null default 1,
	`ctime`    int(10),
	primary key (id),
	key (uid),
	key (uid,from_uid,tid)
) comment '用户标签绑定明细';




/** 标签与用户的绑定关系 **/
create database tags_0;

create database tags_1;

create database tags_2;

create database tags_3;

create database tags_4;

create database tags_5;

create database tags_6;

create database tags_7;

create database tags_8;

create database tags_9;



use tags_0;
create table tag_info_0(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_user_0(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) unsigned not null default 1,
	`ctime`  int(10),
	primary key (id),
	key(tid),
	unique key (tid, uid)
)comment '标签与用户的绑定[一对多]';

use tags_1;
create table tag_info_1(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_user_1(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) unsigned not null default 1,
	`ctime`  int(10),
	primary key (id),
	key(tid),
	unique key (tid, uid)
)comment '标签与用户的绑定[一对多]';

use tags_2;
create table tag_info_2(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_user_2(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) unsigned not null default 1,
	`ctime`  int(10),
	primary key (id),
	key(tid),
	unique key (tid, uid)
)comment '标签与用户的绑定[一对多]';

use tags_3;
create table tag_info_3(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_user_3(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) unsigned not null default 1,
	`ctime`  int(10),
	primary key (id),
	key(tid),
	unique key (tid, uid)
)comment '标签与用户的绑定[一对多]';

use tags_4;
create table tag_info_4(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_user_4(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) unsigned not null default 1,
	`ctime`  int(10),
	primary key (id),
	key(tid),
	unique key (tid, uid)
)comment '标签与用户的绑定[一对多]';

use tags_5;
create table tag_info_5(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_user_5(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) unsigned not null default 1,
	`ctime`  int(10),
	primary key (id),
	key(tid),
	unique key (tid, uid)
)comment '标签与用户的绑定[一对多]';

use tags_6;
create table tag_info_6(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_user_6(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) unsigned not null default 1,
	`ctime`  int(10),
	primary key (id),
	key(tid),
	unique key (tid, uid)
)comment '标签与用户的绑定[一对多]';

use tags_7;
create table tag_info_7(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_user_7(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) unsigned not null default 1,
	`ctime`  int(10),
	primary key (id),
	key(tid),
	unique key (tid, uid)
)comment '标签与用户的绑定[一对多]';

use tags_8;
create table tag_info_8(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_user_8(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) unsigned not null default 1,
	`ctime`  int(10),
	primary key (id),
	key(tid),
	unique key (tid, uid)
)comment '标签与用户的绑定[一对多]';

use tags_9;
create table tag_info_9(
	`tid`   bigint(20) not null,
	`title` varchar(30) not null,
	`ctime` int(10),
	primary key (tid),
	unique key (title)
) comment '标签明细';

create table tag_user_9(
	`id`     int(10) not null auto_increment,
	`tid`    bigint(20) not null,
	`uid`    bigint(20) not null,
	`title`  varchar(30) not null,
	`status` tinyint(2) unsigned not null default 1,
	`ctime`  int(10),
	primary key (id),
	key(tid),
	unique key (tid, uid)
)comment '标签与用户的绑定[一对多]';

