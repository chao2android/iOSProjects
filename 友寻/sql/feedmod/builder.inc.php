<?php
/**
 * SNS动态消息-like子类
 * @author ZhuShunqing 
 * WILL
 *
 */
class snsfeed_builder extends cmi_implements{

	function _Init_(){
		$this->loadC('implements');
	}

	/**
	 * 从最新动态数据库里实时查询重新生成feed
	 * @param float uid
	 * @return bool
	 */
	function rebuild_feeds($uid){
		$uid = floatval($uid);

		$feed_update = $this->dba->loadDB('sdb_sns_0');

		//如果本人feed为空则生成初始动态
		$feed_count = $this->implements->count_by_uid($uid);
		if($feed_count == 0)
			$this->push_first_feeds($uid);

		//取出我关注的人列表
		$focus_my = $this->get_all_focus($uid);
		//取出每日推荐的临时关注列表
		$focus_today = $this->implements->gets_focus($uid, 'today');
		//包含自己的
		$focus = array_merge($focus_my, $focus_today);
		//转换为数值型
		foreach($focus as $i => &$v)
			$v = floatval($v);
		$focus[] = $uid;

		$feed_update->selectdb('feed_update'); //查询前重新选择db以免mysql复用效应
		$fields = array('feedid', 'uid', 'type', 'time');
		$condition = array(
			'where' => array(
				'uid'	=> array('in', $focus),
				'and',
				'status'=> array('!=', -1)
			),
			'order' => array(
				'time' => 'desc'
			),
			'limit' => array(300),
		);
		$feeds = $feed_update->query_all('feed_update', $fields, $condition);
		foreach($feeds as $i => &$v){
			if($v['uid'] != $uid){
				//小于200用户主动产生动态才显示
				if($v['type'] < 200){
					if(in_array($v['uid'], $focus_my))
						$v['type'] += 100; //2xx
					else
						$v['type'] += 200; //3xx

				//不显示其它动态
				}else{
					unset($feeds[$i]);
				}
			}
			if($v)
				$v = implode($v, '|');
		}
		$feeds = array_values($feeds);

		//写入消息队列
		$redis = $this->implements->getRedisByUID($uid);
		$rdkey = 'feed_index_' . $uid;
		$redis->del($rdkey);
		for($i = count($feeds); $i >= 0; $i --) //故意的多推一个$i[count($feeds)]空值保证key存在
			$redis->lpush($rdkey, $feeds[$i]);

		return $feeds;
	}
	
	/**
	 * 生成app feed列表
	 * @param float uid
	 * @return bool
	 */
	function app_rebuild_feeds($uid){
		$uid = floatval($uid);

		$feed_update = $this->dba->loadDB('sdb_sns_0');
		$this->mod('relation');
		
		//如果本人feed为空则生成初始动态
		$feed_count = $this->implements->count_by_uid($uid);
		if($feed_count == 0)
			$this->push_first_feeds($uid);

		//取出关注我的人列表
		$focus_my = $this->get_my_fans($uid, 0, 400);
		if (count($focus_my) < 400) {
			//取出每日推荐的临时关注列表
			$focus_android = $this->implements->gets_focus($uid, 'android');
			$focus = array_merge($focus_my, $focus_android);
		} else {
			$focus = $focus_my;
		}
		$focus = array_slice($focus, 0, 400);
		//转换为数值型
		foreach($focus as $i => &$v)
			$v = floatval($v);
		$focus[] = $uid;

		$types = array_keys($this->implements->getConf('FEED_TYPE'));
		foreach ($types as $key => $value) {
			if ($value >= 200)
				unset($types[$key]);
		}
		$ret = array();
		foreach ($focus as $key => $oid) {
			$feeds = $this->parent->gets_by_uid($oid, 1, 3, $types);
			if (is_array($feeds) && count($feeds) > 0) {
				$feed = array();
				foreach ($feeds as $key => $value) {
					if (in_array($value['type'], array(111, 400, 312)))
						continue;
					if ($this->relation->check_sender($uid, $oid))
						continue;
					$feed = $value;
					if (empty($value['uid']))
						$feed['uid'] = $oid;
					break;
				}
				if ($feed) {
					unset($feed['data'],$feed['like'],$feed['status']);
					$strFeed = implode($feed, '|');
					$ret[$feed['time']] = $strFeed;
				}
			}
		}
		ksort($ret);
		//写入消息队列
		$redis = $this->implements->getRedisByUID($uid);
		$rdkey = 'app_feed_index_' . $uid;
		$redis->del($rdkey);
		foreach ($ret as $key => $val) {
			$redis->lpush($rdkey, $val);
		}
		return $ret;
	}

	/**
	* 生成几条默认动态
	* @param int $uid
	* @param array $types 指定类型
	* @return array feeds
	*/
	function push_first_feeds($uid, $types = array()){
		$uid = floatval($uid);
		$feeds = array();

		$this->mod('profile');
		$userinfo = $this->profile->get_user_login($uid);
		$regtime = $userinfo['register_time'];

		$userinfo = $this->profile->get_user_info($uid, array('birthday', 'gid'));
		$birthtimer = strtotime($userinfo['birthday']);
		$gid = $userinfo['gid'];

		//无效用户
		if(!$regtime) return 'invalid uid';

		//生成生日feed
		$type = 110;
		if(in_array($type, $types)){
			$check = $this->implements->gets_by_uid($uid, 1, 1, array($type), true);
			if(!$check && $birthtimer > strtotime('-100 years')){
				$feed = array(
					'uid'  => $uid,
					'type' => $type,
					'data' => array('time'	=> $birthtimer),
					'like' => 0,
					'time' => $regtime,
					'status' => 0,
				);
				$feed['feedid'] = $this->implements->push($uid, $feed['type'], $feed['data'], $regtime);
				$feeds[] = $feed;
			}
		}

		//生成独白feed
		$type = 120;
		if(in_array($type, $types)){
			$check = $this->implements->gets_by_uid($uid, 1, 1, array($type), true);
			if(!$check && $gid == 1){
				$userinfo = $this->profile->get_user_moreinfo($uid, array('intro'));
				$uploadtime = $regtime + 1;
				$feed = array(
					'uid'  => $uid,
					'type' => $type,
					'data' => array(
						'field' => '内心独白',
						'desc'	=> strip_tags($userinfo['intro']),
						'time'	=> $uploadtime
					),
					'like' => 0,
					'time' => $uploadtime,
					'status' => 0,
				);
				$feed['feedid'] = $this->implements->push($uid, $feed['type'], $feed['data'], $uploadtime);
				$feeds[] = $feed;
			}
		}

		//生成照片feed
		$type = 140;
		if(in_array($type, $types)){
			$check = $this->implements->gets_by_uid($uid, 1, 1, array($type), true);
			if(!$check){
				$this->mod('photo');
				$photos = $this->photo->getPhotoTime($uid);
				if(!empty($photos)){
					$pids = array();
					for($i = 0; $i < count($photos) && $i < 4; $i ++){
						$pids[] = $photos[$i]['pid'];
						$uploadtime = $photos[$i]['upload_time'];
					}
					$feed = array(
						'uid'  => $uid,
						'type' => $type,
						'data' => array(
							'pids'	=> $pids,
							'time'	=> $uploadtime
						),
						'like' => 0,
						'time' => $uploadtime,
						'status' => 0,
					);
					$feed['feedid'] = $this->implements->push($uid, $feed['type'], $feed['data'], $uploadtime);
					$feeds[] = $feed;
				}
			}
		}

		//生成头像feed
		$type = 130;
		if(in_array($type, $types)){
			$check = $this->implements->gets_by_uid($uid, 1, 1, array($type), true);
			if(!$check){
				$this->mod('avatar');
				$avatar = $this->avatar->getAvatarTime($uid);
				if(!empty($avatar)){
					$uploadtime = $avatar['upload_time'];
					$feed = array(
						'uid'  => $uid,
						'type' => $type,
						'data' => array(
							'pids'	=> array($avatar['pid']),
							'time'	=> $uploadtime
						),
						'like' => 0,
						'time' => $uploadtime,
						'status' => 0,
					);
					$feed['feedid'] = $this->implements->push($uid, $feed['type'], $feed['data'], $uploadtime);
					$feeds[] = $feed;
				}
			}
		}

		//反转顺序
		$feeds = array_reverse($feeds);
		return $feeds;
	}

	/**
	* 获取我关注的全部人
	*/
	function get_all_focus($uid){
		$this->mod('relation');
		//翻页取出所有关注，共用翻页cache
		$focus = array();
		$page = 1;
		for($p = 1; $p <= $page; $p ++){
			$fansary = $this->relation->get_focus($uid, $p);
			$fanscount = $fansary['count'];
			$page = ceil($fanscount / 10);
			foreach($fansary['uids'] as $f => $fuid)
				$focus[] = $fuid['fuid'];
		}
		return $focus;
	}
	
	/**
	* 获取关注我的人
	*/
	function get_my_fans($uid, $page= 0, $size= 10){
		$this->mod('relation');
		$fans = array();	
		$fansary = $this->relation->get_fans($uid, $page, $size);
		if (count($fansary['count']) > 0) {
			foreach($fansary['uids'] as $f => $fuid)
				$fans[] = $fuid['fuid'];
		}
		return $fans;
	}

}
?>
