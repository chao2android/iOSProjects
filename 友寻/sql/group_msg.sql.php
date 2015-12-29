<?PHP

//单次SQL
println("

");

//大循环x10库
for($i = 0; $i < 10; $i ++){

	//10库
	println("

		CREATE DATABASE group_msg_content_{$i};

		CREATE DATABASE group_msg_index_{$i};

		CREATE DATABASE group_info_{$i};

		CREATE DATABASE group_chat_friend_info_{$i};

		CREATE DATABASE user_group_chat_info_{$i};

	");

	//10库x10表
	for($j = 0; $j < 10; $j ++){
		
		println("

			-- create database group_msg_content_{$i};
			USE group_msg_content_{$i};
			--
			-- 站内信-收发信索引(按msgid分表)
			-- 消息内容表(按feed id分表) 建10库x10表，每个表最大存放1000万条，最大10亿条
			-- 分库规则 {feedid} % 10
			-- 分表规则 {feedid} % 10000000
			--
			DROP TABLE IF EXISTS `group_msg_content_{$i}_{$j}`;
			CREATE TABLE `group_msg_content_{$i}_{$j}` (
			  `mid` bigint(20) unsigned NOT NULL, -- 消息id
			  `content` text NOT NULL, -- 信体内容
			  `uid` bigint(20) unsigned NOT NULL, -- 发件人id
			  `from` varchar(50) NOT NULL default '', -- 来源
			  `sendtime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00', -- 发信时间
			  `status` tinyint(2) NOT NULL default '0', -- 0正常 -1已删除
			  `msgtype` int(10) unsigned NOT NULL DEFAULT '0', --子类型 0 普通聊天
              `ext` text NOT NULL,
			  PRIMARY KEY (`mid`)
			) ENGINE=MYISAM DEFAULT CHARSET=utf8;

            --
		-- 群信息表
		--
		-- create database group_info_{$i};
		USE group_info_{$i};
		DROP TABLE IF EXISTS `group_info_{$i}_{$j}`;
		CREATE TABLE `group_info_{$i}_{$j}` (
		  `groupid` bigint(20) unsigned NOT NULL, -- 群id
		  `uid` bigint(20) unsigned NOT NULL, -- 用户id
		  `title` varchar(100) NOT NULL default '', -- 群组名称
          `ctime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00', -- 创建时间
		  `power` tinyint(2) unsigned NOT NULL DEFAULT 0, -- 0可以直接加入 ;1需要申请加入；2允许1，2度好友直接加入;3允许12度好友;4禁止任何人加入
		  `total` int(10) unsigned NOT NULL DEFAULT 0, -- 成员总数
		  `public` tinyint(2) NOT NULL default '0', -- 0 不公开，1 公开（将推荐给好友）
		  `status` tinyint(2) NOT NULL default '0', -- 0 正常 -1 已删除
		  KEY `status` (`status`),
		  PRIMARY KEY (`groupid`)
		) ENGINE=MYISAM DEFAULT CHARSET=utf8;
			
		");

	}

	//10库x1000表
	for($j = 0; $j < 1000; $j ++){

		println("
			-- create database group_msg_index_{$i};
			USE group_msg_index_{$i};
			--
			-- 站内信-收发信索引表(按uid分表) 建10库x1000表，每个表最大存放1000个用户，最大用户数1000万
			-- 分库规则 {uid} % 10
			-- 分表规则 {uid} % 100000
			--
			DROP TABLE IF EXISTS `group_msg_index_{$i}_{$j}`;
			CREATE TABLE `group_msg_index_{$i}_{$j}` (
			  `iid` bigint(20) unsigned NOT NULL,
			  `groupid` bigint(20) unsigned NOT NULL, -- 群id
			  `uid` bigint(20) unsigned NOT NULL, -- 发送id
			  `mid` bigint(20) unsigned NOT NULL, -- 消息id
			  `sendtime` timestamp NOT NULL default '0000-00-00 00:00:00', -- 发送时间
			  `deletime` timestamp NOT NULL default '0000-00-00 00:00:00', -- 阅读时间
			  `status` tinyint(2) NOT NULL default '0', -- 0 正常 -1 删除
			  `from` varchar(50) NOT NULL default '', -- 来源
			  KEY `list` (`groupid`, `sendtime` , `status`),
			  KEY `mid` (`groupid`, `mid`),
			  PRIMARY KEY (`iid`)
			)
			ENGINE=INNODB DEFAULT CHARSET=utf8;

		");
	}

	//10库x100表
	for($j = 0; $j < 100; $j ++){

		println("	
			-- create database group_chat_friend_info_{$i};
			USE group_chat_friend_info_{$i};
			--
			-- 群id索引(按groupid分表)
			-- 群聊友信息表(按feed id分表) 建10库x10表，每个表最大存放1000万条，最大10亿条
			-- 分库规则 {feedid} % 10
			-- 分表规则 {feedid} % 10000000
			--
			DROP TABLE IF EXISTS `group_chat_friend_info_{$i}_{$j}`;
			CREATE TABLE `group_chat_friend_info_{$i}_{$j}` (
			  `groupid` bigint(20) unsigned NOT NULL, -- 群id
			  `uid` bigint(20) unsigned NOT NULL, -- 用户id
			  `nick` varchar(50) NOT NULL default '', -- 用户昵称
			  `jointime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00', -- 加入时间
              `quittime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00', -- 退出时间
			  `status` tinyint(2) NOT NULL default '0', -- 0正常 -1已删除
			  KEY `status` (`jointime`,`status`),
			  PRIMARY KEY (`groupid`,`uid`)
			) ENGINE=INNODB DEFAULT CHARSET=utf8;

			-- create database user_group_chat_info_{$i};
			USE user_group_chat_info_{$i};
			--
			-- 用户uid索引(按uid分表)
			-- 用户群信息表(按feed id分表) 建10库x10表，每个表最大存放1000万条，最大10亿条
			-- 分库规则 {feedid} % 10
			-- 分表规则 {feedid} % 10000000
			--
			DROP TABLE IF EXISTS `user_group_chat_info_{$i}_{$j}`;
			CREATE TABLE `user_group_chat_info_{$i}_{$j}` (
              `uid` bigint(20) unsigned NOT NULL, -- 用户id
			  `groupid` bigint(20) unsigned NOT NULL, -- 群id
			  `type` tinyint(2) NOT NULL default '0', -- 0 普通用户 1  管理员
              `hint` tinyint(2) NOT NULL default '0', -- 提醒 0 接受 1 不接受
			  `status` tinyint(2) NOT NULL default '0', -- 0 正常 -1 已删除
			  KEY `status` (`type`,`status`),
			  PRIMARY KEY (`uid`,`groupid`)
			) ENGINE=INNODB DEFAULT CHARSET=utf8;
		");
	}

}

function println($str){
	echo $str . "\n";
}

?>