<?php
	$uid = floatval($args['uid']);
	$oid = floatval($args['oid']);
	$feedid = floatval($args['feedid']);
	$page = intval($args['page'])?intval($args['page']):1;
	$size = intval($args['size'])?intval($args['size']):10;
	$type = $args['type'];

	switch($args['func']){
		case 'push':
			$type = 100;
			$data = array(
				'pids' => array(27128010, 2811810),
				'desc' => '发几张美图给大家看看',
				'tag' => array(10,18,28),
			);
			$rs['推入动态'] = $this->push($uid, $type, $data);
		break;

		//生成测试推送消息
		case 'pushtest':

			$feed_memc = $this->memcd->loadMemc('feeds');
			$redis = $this->getRedisByUID($uid);
/*
			//模拟我关注的人和系统推荐feed
			$feedtest = array(

				//关注用户的动态
				//发布内容
				'200'	=> array(
					'pids' => array(27128010, 2811810),
					'desc' => '发几张美图给大家看看',
					'tag' => array(10,18,28),
				),

				//会员生日
				'210'	=> array(
					'time'	=> strtotime('1988-08-08 00:00:00'),
				),

				//更新资料
				'220'	=> array(
					'field' => '内心独白',
					'desc'	=> '曾经我以为：邂逅本就是这世间最平凡的际遇 我们无法控制下一秒会遇见谁 不经意的遇见谁 又会带来怎样不平凡的悸动 没有人能够预见 然而经过这无数的离别 我们都学会了隐藏内心澎湃的风起云涌',
					'time'	=> strtotime('2013-03-26 17:00:00'),
				),

				//上传头像
				'230'	=> array(
					'pids' => array(50973810),
					//上传时间
					'time'	=> strtotime('2013-03-26 17:00:00'),
				),

				//上传生活照
				'240'	=> array(
					'pids' => array(20327710, 27249110),
					//上传时间
					'time'	=> strtotime('2013-03-26 17:00:00'),
				),

				//推荐用户的动态
				//发布内容
				'300'	=> array(
					'pids' => array(27128010, 2811810),
					'desc' => '发几张美图给大家看看',
					'tag' => array(10,18,28),
				),

				//会员生日
				'310'	=> array(
					'time'	=> strtotime('1988-08-08 00:00:00'),
				),

				//更新资料
				'320'	=> array(
					'field' => '内心独白',
					'desc'	=> '曾经我以为：邂逅本就是这世间最平凡的际遇 我们无法控制下一秒会遇见谁 不经意的遇见谁 又会带来怎样不平凡的悸动 没有人能够预见 然而经过这无数的离别 我们都学会了隐藏内心澎湃的风起云涌',
					'time'	=> strtotime('2013-03-26 17:00:00'),
				),

				//上传头像
				'330'	=> array(
					'pids' => array(50973810),
					//上传时间
					'time'	=> strtotime('2013-03-26 17:00:00'),
				),

				//上传生活照
				'340'	=> array(
					'pids' => array(20327710, 27249110),
					//上传时间
					'time'	=> strtotime('2013-03-26 17:00:00'),
				),

			);

			for($i = 0; $i < 10; $i ++){
				$uid_rand = rand(185100, 203660) * 100;

				$type = array_rand($feedtest);
				$data = $feedtest[$type];

				$time = time();
				$feedid = $this->push($uid_rand, $type, $data);
				$feed = "{$feedid}|{$uid_rand}|{$type}|{$time}";
				$redis->lpush('feed_index_' . $uid, $feed);

				$feed_memc->increment('feed_new_' . $uid, 3600 * 3);
				$rs['pushtest'][] = $feed . ' => ' . $uid;
			}
*/
///////////////////////////////////////////////////////////////////////////////////////////

			//模拟自己的feed
			$feedtest = array(

				//自己发布的
				//发布内容
				'100'	=> array(
					'pids' => array(50973810, 16032510, 20327710, 27249110),
					'desc' => '发几张美图给大家看看',
					'tag' => array(10,18,28),
				),

				//会员生日
				'110'	=> array(
					'time'	=> strtotime('1988-08-08 00:00:00'),
				),

				//更新资料
				'120'	=> array(
					'field' => '内心独白',
					'desc'	=> '曾经我以为：邂逅本就是这世间最平凡的际遇 我们无法控制下一秒会遇见谁 不经意的遇见谁 又会带来怎样不平凡的悸动 没有人能够预见 然而经过这无数的离别 我们都学会了隐藏内心澎湃的风起云涌',
					'time'	=> strtotime('2013-03-26 17:00:00'),
				),

				//上传头像
				'130'	=> array(
					'pids' => array(50973810),
					//上传时间
					'time'	=> strtotime('2013-03-26 17:00:00'),
				),

				//上传生活照
				'140'	=> array(
					'pids' => array(50973810),
					//上传时间
					'time'	=> strtotime('2013-03-26 17:00:00'),
				),
			);
			$type = array_rand($feedtest);
			$data = $feedtest[$type];
			$feedid = $this->push($uid, $type, $data);
			$feed = "{$uid}|{$uid_rand}|{$type}|{$time}";
			$rs['pushtest'][] = $feed . ' => ' . $uid;

			$redis->ltrim('feed_index_' . $uid, 0, 300);

		break;

		case 'count':
			if($type) $types = explode(',', $type);
			$rs['动态数'] = $this->count($uid, $types);
		break;

		case 'count_by_uid':
			$rs['个人动态数'] = $this->count_by_uid($uid);
		break;

		case 'gets':
			if($type) $types = explode(',', $type);
			$rs['动态列表'] = $this->gets($uid, $page, $size, $types);
		break;

		case 'gets_by_uid':
			$rs['个人动态列表'] = $this->gets_by_uid($uid, $page, $size);
		break;

		case 'check':
			$rs['检查新动态'] = $this->check($uid);
		break;

		case 'like':
			$rs['like'] = $this->like($uid, $oid, $feedid);
		break;

		case 'unlike':
			$rs['unlike'] = $this->unlike($uid, $oid, $feedid);
		break;

		case 'ilikes':
			$rs['ilike count'] = $this->ilikecount($uid);
			$rs['ilikes'] = $this->ilikes($uid);
		break;

		case 'wholikes':
			$rs['wholikecount'] = $this->wholikecount($uid);
			$rs['wholikes'] = $this->wholikes($uid);
		break;

		case 'isilike':
			$rs['isilike'] = $this->isilike($uid, $oid, $feedid);
		break;

		case 'wholikefeedcount':
			$rs['wholikefeedcount'] = $this->wholikefeedcount($feedid);
		break;

		case 'wholikefeed':
			$rs['wholikefeed'] = $this->wholikefeed($feedid);
		break;

		case 'rebuild_feeds':
			$rs['rebuild_feeds'] = $this->rebuild_feeds($uid, $feedid);
		break;

		case 'get_feed':
			$rs['get_feed'] = $this->get_feed($feedid);
		break;

		case 'delete_by_oid':
			$rs['delete_by_oid'] = $this->delete_by_oid($uid, $oid);
		break;

		case 'push_first_feeds':
			$type = explode(',', $type);
			$rs['push_first_feeds'] = $this->push_first_feeds($uid, $type);
		break;

		case 'push_first_feeds_all':

			$this->mod('profile');

			for($uid = 25000010; $uid < 26000010; $uid += 100){
				$feeds = $this->push_first_feeds($uid, array(110, 120, 130, 140));
				print $uid . ' add ' . count($feeds) . "\n";

				$userinfo = $this->profile->get_user_info($uid, array('birthday'));
				$birthtimer = strtotime($userinfo['birthday']);
				$rs['userinfo'] = $userinfo;
				$rs['birthtimer'] = $birthtimer;
				$rs['feed'] = $feed = $this->gets_by_uid($uid, 1, 1, array(110));
				$diff = ($birthtimer == $feed[0]['data']['time']);
				$rs['diff'] = var_export($diff, 1);
				if(!$diff){
					$data = array('time' => $birthtimer);
					$ret = $this->update($feed[0]['feedid'], $data);
					$rs['fix'] = var_export($ret, 1);
					$this->reCache('default', array($uid));
					print $uid . " update_feed_110\n";
				}

			}
		break;

		case 'focuslist':
			//读取列表
			//$rs['add_foucs'] = $this->add_focus(1000300, 20194600, 'today', CMI_TODAY_TIMER);
			$rs['gets_focus'] = $this->gets_focus($uid, 'today');
			$rs['gets_fans'] = $this->gets_fans($uid, 'today');
			if(!$rs['gets_focus']){
				//添加today关注
				for($oid = 100000; $oid <= 900000; $oid += 100000)
					$this->add_focus($uid, $oid, 'today', CMI_TODAY_TIMER);
				//删除指定
				for($oid = 100000; $oid <= 900000; $oid += 200000)
					$this->del_focus($uid, $oid, 'today');
			}

		break;

		//修复初始生日动态里的time值
		case 'update_feed_110':
			$this->mod('profile');
			$userinfo = $this->profile->get_user_info($uid, array('birthday'));
			$birthtimer = strtotime($userinfo['birthday']);
			$rs['userinfo'] = $userinfo;
			$rs['birthtimer'] = $birthtimer;
			$rs['feed'] = $feed = $this->gets_by_uid($uid, 1, 1, array(110));
			$diff = ($birthtimer == $feed[0]['data']['time']);
			$rs['diff'] = var_export($diff, 1);
			if(!$diff){
				$data = array('time' => $birthtimer);
				$ret = $this->update($feed[0]['feedid'], $data);
				$rs['fix'] = var_export($ret, 1);
				$this->reCache('default', array($uid));
			}
			break;
		case 'delete_feed':
			$rs['delete_feed'] = $this->delete($uid, $feedid);
			break;
		case 'push_birth':
			$feed_type = 111;
			$rs['push_birth'] = $this->push($uid,$feed_type);
			break;
		case 'getHotFeedList':
			$rs['hotfeedlist'] = $this->getHotFeedList(1);
			break;
		case 'getLatestFeedCount':
			$rs['getLatestFeedCount'] = $this->getLatestFeedCount('1000100');
			break;
		case 'clear_cache':
			$rs['clear_cache'] = $this->clear_cache($uid);;
	}
	print_r($rs);
?>