<?php
/**
 * snsfeed 模块配置信息
 */
return array(

	//远程调用接口
	'HTTP_CONFIG' => array(

		//默认接口
		'default' => array(
			'host'  => '10.30.40.1',
			'name'	=> 'cmi.izhenxin.com',
			'port'  => 80,
			'uri'   => '/cmi_http_proxy.php',
			'timeout'	=> 1000,  //超时毫秒设置
			'use'	=> 0, //全部接口走远程调用
		),
		
		//返回redis实例
		'getRedisByUID' => array('use' => 0),

		//重建feed 3秒超时
		'rebuild_feeds' => array('timeout' => 6000),
		
		'app_rebuild_feeds' => array('timeout' => 10000),
		
		'getHotFeedList' => array('timeout' => 3000)
	),

	//方法调用缓存设置
	'CACHE_CONFIG' => array(

		'default' => array(
			//cache开启
			'enalble' => 1,
			//更新标识key
			'rekey' => array(0),
			//cache组
			'cache' => 'callfuncache',
			//cache时间（单位秒）
			'timer' => 60 * 10,
			//延迟recache时间
			//'delay'	=> 10,
		),

		//feed内容数据缓存1天
		'get_feed' => array(
			//cache时间（单位秒）
			'timer' => 60 * 60 * 24,
		),

		//获取某用户产生的消息列表
		'count_by_uid'	=> 1,
		'gets_by_uid'	=> 1,

		//我like了谁
		'ilikecount'	=> 1,
		'ilikes'		=> 1,

		//谁like了我
		'wholikecount'	=> 1,
		'wholikes'		=> 1,
		
		//赞过此feed的人
		'wholikefeed'   => 1,
		
		//获取全站最新动态
		//'getHotFeedList' => 1,

	),

	//redis配置
	'REDIS_SERVERS'	=> array(

			array('host' => '10.30.10.37', 'port' => 6381),
			array('host' => '10.30.10.37', 'port' => 6382),
			array('host' => '10.30.10.37', 'port' => 6383),
			array('host' => '10.30.10.37', 'port' => 6384),
			array('host' => '10.30.10.37', 'port' => 6385),

			array('host' => '10.30.10.43', 'port' => 6381),
			array('host' => '10.30.10.43', 'port' => 6382),
			array('host' => '10.30.10.43', 'port' => 6383),
			array('host' => '10.30.10.43', 'port' => 6384),
			array('host' => '10.30.10.43', 'port' => 6385),
			
	),

	//错误返回定义
	'ERROR_DEFINE' => array(
		'param_err'		=> -1000,
		'zone_feedid_err'		=> -1001,
		'insert_content_err'	=> -1002,
		'insert_feed_err'		=> -1003,
		'insert_index_err'		=> -1004,
		'insert_redis_err'		=> -1005,
		'insert_like_err'		=> -1006,
		'is_liked'				=> -1007,
		'like_incr_err'			=> -1008,
		'delete_like_err'		=> -1009,
		'is_deleted'			=> -1010,
		'like_decr_err'			=> -1011,
		'delete_index_err'		=> -1012,
		'delete_content_err'	=> -1013,
		'delete_update_err'		=> -1014,
		'update_content_err'	=> -1015,
	),

	'FEED_TYPE'	=> array(

		//自己的
		'100'	=> '发布内容',
		'101'	=> '内容含图片',
		'110'	=> '会员生日',
		'111'	=> '生日提醒',
		'120'	=> '更新资料',
		'121'	=> '修改个人标签',
		'130'	=> '上传头像',
		'140'	=> '上传生活照',
		'150'	=> '评论和话题',

		//主动关注
		'200'	=> '发布内容',
		'210'	=> '会员生日',
		'211'	=> '生日提醒',
		'212'	=> '生日提醒合并',
		'220'	=> '更新资料',
		'230'	=> '上传头像',
		'240'	=> '上传生活照',

		//推荐用户
		'300'	=> '发布内容',
		'310'	=> '会员生日',
		'320'	=> '更新资料',
		'330'	=> '上传头像',
		'340'	=> '上传生活照',

		//广播动态
		'400'	=> '广播动态',

	),

	//动态合并
	'FEED_MERAGE' => array(

		//生日提醒
		'211' => array(
			//按天合并
			'time' => 'day',
			//类型值合并后转成212
			'type' => '212'
		),

		//生日提醒
		'311' => array(
			//按天合并
			'time' => 'day',
			//类型值合并后转成312
			'type' => '312'
		),

	),
	
);
?>