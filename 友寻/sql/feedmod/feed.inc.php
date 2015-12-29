<?php
/**
 * SNS动态消息-feed子类
 * @author ZhuShunqing 
 *
 */
class snsfeed_feed extends cmi_implements{

	function _Init_(){
		$this->loadC('implements');
	}
	
	/*
	 * 发布动态
	 * @param int $uid 发起关注者
	 * @param int $type 动态消息类型
	 * @param array $data 消息内容
	 * @param int $time 指定消息时间（不分发给关注者）
	 * @return float feedid
	 */
	function push($uid, $type, $data = array(), $time = null){
		$uid = floatval($uid);
		$type = intval($type);
		if(!$time){
			$time = time();
			$push = true;
		}else{
			//指定时间的消息不分发给关注者
			$push = false;
		}
		if(!$uid || !$type)
			return $this->getconf('ERROR_DEFINE', 'param_err');

		//Step.1插入消息内容
		//-------------------------------------------------------------
		//生成全局feedid
		$feedid = $this->incr->get_zone_id('feed_content');
		if(!$feedid) return $this->getconf('ERROR_DEFINE', 'zone_feed_err');

		$feed_content = $this->dbr->loadDB('feed_content');
		$row = array(
				'feedid'	=> $feedid,
				'uid'		=> $uid,
				'type'		=> $type,
				'data'		=> json_encode($data),
				'time'		=> $time
			);
		$ret = $feed_content->insert('feed_content', $row);
		if(!$ret) return $this->getconf('ERROR_DEFINE', 'insert_content_err');
		unset($row['data']);

		//Step.2插入到个人索引(消息列表)
		//-------------------------------------------------------------
		$feed_index = $this->dbr->loadDB('feed_index');
		$ret = $feed_index->insert('feed_index', $row);
		if(!$ret) return $this->getconf('ERROR_DEFINE', 'insert_index_err');

		//Step.3插入到全局最新消息
		//-------------------------------------------------------------
		$this->mod('profile');
		$userinfo = $this->profile->get_user_info($uid, 'sex');
		$uprow = $row;
		$uprow['sex'] = $userinfo['sex'];
		if($data['tag']){
			$tags = implode('|', $data['tag']);
			$uprow['tag'] = '|' . $tags . '|';
		}

		$db = $this->dba->loadDB('mdb_sns_0');
		$db->selectdb('feed_update');
		$ret = $db->insert('feed_update', $uprow);
		if(!$ret) return $this->getconf('ERROR_DEFINE', 'insert_feed_err');

		//Step.4加入自己redis列表
		//-------------------------------------------------------------
		$redis = $this->implements->getRedisByUID($uid);
		$rds_web = 'feed_index_' . $uid;
		$rds_app = 'app_feed_index_' . $uid;
		if ($redis->exists($rds_web)) {
			$ret = $redis->lpush($rds_web, implode('|', $row));
		}
		if ($redis->exists($rds_app)) {
			$ret = $redis->lpush($rds_app, implode('|', $row));
		}
		if(!$ret) return $this->getconf('ERROR_DEFINE', 'insert_redis_err');

		//Step.5插入到redis推送队列
		//-------------------------------------------------------------
		if($push){
			$ret = $redis->lpush("feed_queue", implode('|', $row));
			//$redis->close();
			if(!$ret) return $this->getconf('ERROR_DEFINE', 'insert_redis_err');
		}
		
		//Step.6插入到广场redis队列
		//-------------------------------------------------------------
		$this->square_push_feeds($uid, $feedid, $type);
		
		//用户内容推进审核队列
		if($type == 100 || $type == 101){
			$this->mod('queue');
			$this->queue->addFeedQueue($uid, $feedid);
		}

		//更新列表cache
		$this->reCache('default');
		return $feedid;
	}

	/**
	 * 获取动态消息
	 * @param int uid 
	 * @param int $page 页数
	 * @param int $size 条数 
	 * @param array $types 消息类型 
	 * @return array
	 */
	function gets($uid, $page = 1, $size = 10, $types = array()){
		$size = intval($size);
		if(!$size) $size = 10;
		$start = $page > 1 ? ($page - 1) * $size : 0;
		$end = $start + $size - 1;

		//清空新动态计数		
		$memc = $this->memcd->loadMemc('feeds');
		$ret = $memc->delete('feed_new_' . $uid);

		//取出消息队列
		$redis = $this->implements->getRedisByUID($uid);

		$rdkey = 'feed_index_' . $uid;

		//如果动态为空则从数据库实时查询重新生成feed
		if(!$redis->exists($rdkey))
			$this->implements->rebuild_feeds($uid);

		//筛选类型
		if(empty($types)){
			//全部feed
			$feeds = $redis->lrange($rdkey, $start, $end);
		}else{
			//按type值列表
			$feeds = $redis->lrange($rdkey, 0, 300);
			$tmpfeeds = array();
			foreach($feeds as $i => $v){
				list($feedid, $fuid, $type, $time) = explode('|', $v);
				if(in_array($type, $types))
					$tmpfeeds[] = $v;
			}
			$feeds = array_slice($tmpfeeds, $start, $size);
		}
		//$redis->close();

		$this->mod('profile');

		//取出内容数据及格式化
		$list = array();
		$reload = 0; 
		foreach($feeds as $i => $v){
			list($feedid, $fuid, $type, $time) = explode('|', $v);
			if(!$feedid || !$fuid || !$type || !$time) continue;

			//取出用户信息
			$userinfo = $this->profile->get_user_info($fuid, array('gid', 'status'));
			if(!$userinfo) $userinfo = array('gid' => 1, 'status' => 0);//防止取用户信息失败下面代码会清理全部feed
			//feed信息
			$data = $this->parent->get_feed($feedid); //用$this->parent->引用同类方法可以调用CMI缓存

			if(
				$data['status'] != -1 //未删除
			&&
				$this->profile->getConf('gid', $userinfo['gid'])//状态正常
			&&
				$userinfo['status'] == 0 //征友进行中
			){
				$list[] = array(
					'feedid'	=> $feedid,
					'uid'		=> $fuid,
					'type'		=> $type,
					'data'		=> $data['data'],
					'like'		=> $data['like'],
					//'status'	=> $data['status'],
					'time'		=> $time,
				);
			}else{
				//清理不想显示的feed
				$redis->lrem($rdkey, $v, 1);
				$reload = 1; //需要重新读取列表
			}
		}

		//因清理删除feed重新读取列表
		if($reload)
			$list = $this->gets($uid, $page, $size, $types);

		//动态合并处理
		$merage_index = array();
		$merage_list = array();
		$merage_conf = $this->getConf('FEED_MERAGE');
		foreach($merage_conf as $type => $conf){
			$merage_index[$conf['type']] = array();
			$merage_list[$conf['type']] = array();
			$numb = count($list);
			for($i = 0; $i < $numb; $i ++){
				if($list[$i]['type'] == $type){
					//按天合并类型
					if($conf['time'] == 'day'){
						$day = date('Y-m-d', $list[$i]['time']);
						if(!isset($merage_index[$conf['type']][$day]))
							$merage_index[$conf['type']][$day] = $i;
						$merage_list[$conf['type']][$day][] = $list[$i]['uid'];
						unset($list[$i]);
					}
				}
			} 
		}
		foreach($merage_list as $type => $group){
			foreach($group as $time => $data){
				$list[$merage_index[$type][$time]] = array(
					'feedid'	=> 0,
					'uid'		=> 0,
					'type'		=> $type,
					'data'		=> $data,
					'like'		=> 0,
					'time'		=> strtotime($time)
				);
			}
		}
		ksort($list);
		$list = array_values($list);
		return $list;
	}

	/**
	 * 获取app动态消息列表
	 * @param int uid 
	 * @param int $page 页数
	 * @param int $size 条数 
	 * @param array $types 消息类型 
	 * @return array
	 */
	function gets_app($uid, $page = 1, $size = 10, $copy= false){
		$size = intval($size);
		if(!$size) $size = 10;
		$start = $page > 1 ? ($page - 1) * $size : 0;
		$end = $start + $size - 1;

		//清空新动态计数		
		$memc = $this->memcd->loadMemc('feeds');
		$ret = $memc->delete('android_new_' . $uid);

		//取出消息队列
		$redis = $this->implements->getRedisByUID($uid);

		$rdkey = 'app_feed_index_' . $uid;

		//如果动态为空则从数据库实时查询重新生成feed
		if (!$redis->exists($rdkey))
			$this->implements->app_rebuild_feeds($uid);
		
		//防止下拉导致当前页和上一页有重复记录问题
		$rdkey_copy = 'app_feed_index_copy_'.$uid;
		if ($copy && $redis->exists($rdkey_copy)) {
			$rdkey = $rdkey_copy;
		} else {
			$redis->del($rdkey_copy);
			$llen = $redis->llen($rdkey);
			$feeds_copy = $redis->lrange($rdkey, 0, $llen);
			array_unshift($feeds_copy, $rdkey_copy);
			call_user_func_array(array($redis, 'rPush'), $feeds_copy);
			$redis->expire($rdkey_copy, 7200);	
		}

		$feeds = $redis->lrange($rdkey, $start, $end);
		
		$this->mod('profile');

		//取出内容数据及格式化
		$list = array();
		$reload = 0; 
		$this->mod('relation');
		foreach($feeds as $i => $v){
			list($feedid, $fuid, $type, $time) = explode('|', $v);
			if(!$feedid || !$fuid || !$type || !$time) continue;

			//取出用户信息
			$userinfo = $this->profile->get_user_info($fuid, array('gid', 'status'));
			if(!$userinfo) $userinfo = array('gid' => 1, 'status' => 0);//防止取用户信息失败下面代码会清理全部feed
			//feed信息
			$data = $this->parent->get_feed($feedid); //用$this->parent->引用同类方法可以调用CMI缓存
			
			if(
				$data['status'] != -1 //未删除
			&&
				$this->profile->getConf('gid', $userinfo['gid'])//状态正常
			&&
				$userinfo['status'] == 0 //征友进行中
			&& 
				( $uid == $fuid || ( !$this->relation->check_black($uid, $fuid)
			&& 
				  !$this->relation->check_dislike($uid, $fuid) )
				)
			){
				$list[$time] = array(
					'feedid'	=> $feedid,
					'uid'		=> $fuid,
					'type'		=> $type,
					'data'		=> $data['data'],
					'like'		=> $data['like'],
					//'status'	=> $data['status'],
					'time'		=> $time,
				);
			}else{
				//清理不想显示的feed
				$redis->lrem($rdkey, $v, 1);
				$reload = 1; //需要重新读取列表
			}
		}

		//因清理删除feed重新读取列表
		if($reload)
			$list = $this->gets_app($uid, $page, $size);
		krsort($list);
		return $list;
	}

	/**
	 * 删除动态消息
	 * @param float uid
	 * @param float feedid
	 * @return bool
	 */
	function delete($uid, $feedid){
		$uid = floatval($uid);
		$feedid = floatval($feedid);

		if(!$uid || !$feedid)
			return $this->getconf('ERROR_DEFINE', 'param_err');

		//feed_index个人索引置删除
		$feed_index = $this->dbr->loadDB('feed_index');
		$row = array('status' => -1);
		$condition = array(
			'where' => array(
				'uid'	=> array('=', $uid),
				'and',
				'feedid' => array('=', $feedid),
			),
		);
		$ret = $feed_index->update('feed_index', $row, $condition);
		if(!$ret) return $this->getconf('ERROR_DEFINE', 'delete_index_err');

		//feed_content数据表置删除
		$feed_content = $this->dbr->loadDB('feed_content');
		$row = array('status' => -1);
		$condition = array(
			'where' => array(
				'feedid'	=> array('=', $feedid)
			),
		);
		$ret = $feed_content->update('feed_content', $row, $condition);
		if(!$ret) return $this->getconf('ERROR_DEFINE', 'delete_content_err');

		//feed_update表数据置删除
		$feed_update = $this->dba->loadDB('mdb_sns_0');
		$feed_update->selectdb('feed_update');
		$row = array('status' => -1);
		$condition = array(
			'where' => array(
				'feedid'	=> array('=', $feedid)
			),
		);
		$ret = $feed_update->update('feed_update', $row, $condition);
		if(!$ret) return $this->getconf('ERROR_DEFINE', 'delete_update_err');

		//删除包含照片
		$feed = $this->parent->get_feed($feedid);
		if(!empty($feed['data']['pids'])){
			$this->mod('picture');
			$this->picture->delete_user_picture($uid, $feed['data']['pids']);
		}

		//清除content cache
		$this->delCache('get_feed', array($feedid));
		//更新列表cache
		$this->reCache('default');
		return $ret;
	}


	/**
	 * 删除指定关注用户动态消息
	 * @param float uid
	 * @param float feedid
	 * @return int 清理个数
	 */
	function delete_by_oid($uid, $oid){
		$uid = floatval($uid);
		$oid = floatval($oid);
		//取出消息队列
		$redis = $this->implements->getRedisByUID($uid);
		$rdkey = 'feed_index_' . $uid;
		$feeds = $redis->lrange($rdkey, 0, 300);
		$count = 0;
		foreach($feeds as $i => $v){
			list($feedid, $fuid, $type, $time) = explode('|', $v);
			if($oid == $fuid){
				$redis->lrem($rdkey, $v, 1);
				$count ++;
			}
		}
		return $count;
	}

	/**
	 * 更新动态内容
	 * @param int feedid 
	 * @param array data 
	 * @return bool
	 */
	function update($feedid, $data){
		$feedid = floatval($feedid);
		if(!$feedid)
			return $this->getconf('ERROR_DEFINE', 'param_err');

		$feed_content = $this->dbr->loadDB('feed_content');
		$row = array(
			'data' => json_encode($data)
		);
		$condition = array(
			'where' => array(
				'feedid'	=> array('=', $feedid)
			),
		);
		$ret = $feed_content->update('feed_content', $row, $condition);
		if(!$ret) return $this->getconf('ERROR_DEFINE', 'update_content_err');

		//清除content cache
		$this->delCache('get_feed', array($feedid));
		return $ret;
	}

	/**
	 * 获取动态内容数据
	 * @param float $feedid
	 */
	function get_feed($feedid){
		$feedid = floatval($feedid);
		$feed_content = $this->dbr->loadDB('feed_content');
		$fields = array('uid', 'type', 'data', 'like', 'time', 'status');
		$condition = array(
			'where' => array(
				'feedid'	=> array('=', $feedid)
			),
		);
		$content = $feed_content->query_one('feed_content', $fields, $condition);
		$content['data'] = json_decode($content['data'], 1);
		return $content;
	}

	/**
	 * 获取动态列表数目
	 * @param float $uid
	 * @param array $types 消息类型 
	 * @return int
	 */
	function count($uid, $types = array()){
		$uid = floatval($uid);
		$redis = $this->implements->getRedisByUID($uid);
		$count = 0;
		if(empty($types)){
			//全部feed
			$count = $redis->llen('feed_index_' . $uid);
		}else{
			//按type值列表
			$feeds = $redis->lrange('feed_index_' . $uid, 0, 300);
			foreach($feeds as $i => $v){
				list($feedid, $fuid, $type, $time) = explode('|', $v);
				if(in_array($type, $types))
					$count ++;
			}
		}
		//$redis->close();
		return $count;
	}

	/**
	 * 获取某用户产生的个人动态消息数目
	 * @param float $uid 
	 * @param array $types 消息类型 
	 * @return int
	 */
	function count_by_uid($uid, $types = array()){
		$uid = floatval($uid);
		$feed_index = $this->dbr->loadDB('feed_index');
		$condition = array(
			'where' => array(
				'uid'	=> array('=', $uid),
				'and',
				'status'=> array('!=', -1)
			),
		);
		if($types){
			$condition['where'][] = 'and';
			$condition['where']['type'] = array('in', $types);
		}
		$count = $feed_index->query_count('feed_index', $condition);
		//如果消息为空则生成默认动态
		// if($count == 0){
		// 	$feeds = $this->push_first_feeds($uid);
		// 	$count = count($feeds);
		// }
		return $count;
	}

	/**
	 * 获取某用户产生的消息列表
	 * @param float $uid 
	 * @param int $page 页码
	 * @param int $size 条数
	 * @param array $type 类型
	 * @param bool $isdel 包含已删除
	 * @return array
	 */
	function gets_by_uid($uid, $page = 1, $size = 10, $type = false, $isdel = false){
		$uid = floatval($uid);
		$page = intval($page);
		$size = intval($size);

		$page = $page > 1 ? ($page - 1) * $size : 0;

		$feed_index = $this->dbr->loadDB('feed_index');
		$fields = array('feedid', 'uid', 'type', 'time', 'status');
		$condition = array(
			'where' => array(
				'uid'	=> array('=', $uid)
			),
			'order' => array(
				'time' => 'desc'
			),
			'limit' => array($page, $size),
		);
		//指定feed type
		if($type){
			$condition['where'][] = 'and';
			$condition['where']['type'] = array('in', $type);
		}
		//不含已删除
		if(!$isdel){
			$condition['where'][] = 'and';
			$condition['where']['status'] = array('!=', -1);
		}
		$list = $feed_index->query_all('feed_index', $fields, $condition);
		foreach($list as $i => &$v){
			$data = $this->parent->get_feed($v['feedid']); //用$this->parent->引用同类方法可以调用CMI缓存
			$v['data'] = $data['data'];
			$v['like'] = $data['like'];
			$v['status'] = $data['status'];
		}

		//如果消息为空则生成默认动态
		// if($page == 0 && $size == 10 && empty($list))
		// 	$list = $this->implements->push_first_feeds($uid);

		return $list;
	}

	/**
	* 检查新动态
	* @param float $uid
	* @param string $type 新'feed' or 新'like'
	* @return int
	*/
	function check($uid, $type = 'feed'){
		$uid = floatval($uid);
		$memc = $this->memcd->loadMemc('feeds');
		$key = $type . '_new_' . $uid;
		$ret = intval($memc->get($key));
		return $ret;
	}
	
	/**
	* 取全站最新动态 mysql
	* @param int $uid session uid
	* @param int $sex
	* @param int $page 分页用
	* @param int $num 每页显示数量
	* return array
	*/
	function getHotFeedList($sex= 0, $page= 1, $num= 10, $feed_id= 0) {
		$start = $page > 1 ? ($page - 1) * $num : 0;
		$profile = $this->mod('profile');
		$feed_update = $this->dba->loadDB('sdb_sns_0');
		$feed_update->selectdb('feed_update');
		$field = array('uid', 'max(feedid)'=> 'fid');
		$condition = array(
			'where' => array(
				'sex'	=> array('=', $sex),
				'and',
				'status'=> array('!=' , -1),
				'and',
				'type'  => array('in', array(100,101,140)),
				'and',
				'feedid' => array('>', $feed_id)
			),
			'group' => array(
				'uid'
			),
			'order' => array(
				'fid' => 'desc'
			),
			'limit' => array($start, $num),
		);
		$feeds = $feed_update->query_all('feed_update', $field, $condition);
		$feedlist = array();
		if (!empty($feeds)) {
			foreach ($feeds as $key => $feed) {
				$uid = $feed['uid'];
				$feedid = $feed['fid'];
				$user_info = $profile->get_user_info($uid, array('gid','status'));
				$gid = $user_info['gid'];
				$status = $user_info['status'];
				if (($gid != 1 && $gid != 4) || $status != 0) {
					continue;
				}
				
				$feedinfo = $this->parent->get_feed($feedid);
				$feedinfo['feedid'] = $feedid;
				$feedlist[] = $feedinfo;
			}
		}
		return $feedlist;
	}
	
	/**
	* 取全站最新动态 redis
	* @param int $uid session uid
	* @param int $sex
	* @param int $page 分页用
	* @param int $num 每页显示数量
	* @param int $feed_id 最新feedid
	* return array
	*/
	function getHotFeedListNew($sex= 0, $page= 1, $num= 10, $feed_id= 0) {
		$start = $page > 1 ? ($page - 1) * $num : 0;
		$gender = $sex ? 'm' : 'f';
		$sub = $sex ? 1000 : 500;
		$profile = $this->mod('profile');
		$feed_id = $feed_id ? $feed_id : '+inf';
		$redis = $this->implements->getRedisByUID($sub);
		$redisKey = 'new_feed_list_key_'.$gender;
		$feed_list = $redis->zRevRangeByScore($redisKey,$feed_id,'-inf',array('withscores'=> true,'limit'=> array($start,$num)));
		$feedlist = array();
		if ($feed_list) {
			foreach ($feed_list as $key => $value) {
				$uid = $key;
				$fid = $value;
				$user_info = $profile->get_user_info($uid, array('gid','status'));
				$gid = $user_info['gid'];
				$status = $user_info['status'];
				if (($gid != 1 && $gid != 4) || $status != 0) {
					continue;
				}
				
				$feedinfo = $this->parent->get_feed($fid);
				if ($feedinfo['status'] == -1) 
					continue;
				$feedinfo['feedid'] = $fid;
				$feedlist[] = $feedinfo;
			}
		}
		return $feedlist;
	}
	
	/**
	* 广场推最新feed
	* @param int $uid 
	* @param int $feedid 动态id
	* @param int $type feed类型
	* return Boolean
	*/
	function square_push_feeds($uid, $feedid, $type) {
		$profile = $this->mod('profile');
		$login = $this->mod('login');
		$userinfo = $profile->get_user_info($uid, 'sex');
		$sex = $userinfo['sex'];
		$gender = $sex ? 'm' : 'f';
		$sub = $sex ? 1000 : 500;
		$redis = $this->implements->getRedisByUID($sub);
		//feed
		$newFeedListKey = 'new_feed_list_key_'.$gender;
		$newFeedIdKey   = 'new_feed_id_key_'.$gender;
		if (in_array($type, array(100, 101, 140))) {
			$redis->zadd($newFeedListKey, $feedid, $uid);
			$redis->set($newFeedIdKey, $feedid);
			$zset_count = $redis->zcard($newFeedListKey);
			if ($zset_count > 300) {
				$redis->zremrangebyrank($newFeedListKey, 0, $zset_count - 301);
			}
		}
		//photo
		$newPhotoListKey = 'new_photo_list_key_'.$gender;
		if (in_array($type, array(101, 140))) {
			$user_login = $login->get_userlogin($uid);
			$register_time = $user_login['register_time'];
			$last_login = $user_login['last_login'];
			$reg_month = date('Y-m', $register_time);
			$now_month = date('Y-m');
			$last_login_day = date('Y-m-d', $last_login);
			$reg_day = date('Y-m-d', $register_time);
			if ($reg_month == $now_month && $reg_day != $last_login_day) {
				return false;
			}
			$member = $feedid."|".$uid;
			$redis->zadd($newPhotoListKey, 0, $member);
			$zset_count = $redis->zcard($newPhotoListKey);
			if ($zset_count > 450) {
				$redis->zremrangebyrank($newPhotoListKey, 0, $zset_count - 451);
			}
		}
		return true;
	}
	
	/**
	* 取全站最新动态 feedid
	* @param int $sex
	* return array
	*/
	function getLatestFeedid ($sex= 0) {
		$gender = $sex ? 'm' : 'f';
		$sub = $sex ? 1000 : 500;
		$redis = $this->implements->getRedisByUID($sub);
		$redisKey = 'new_feed_list_key_'.$gender;
		$feedidKey = 'new_feed_id_key_'.$gender;
		$feedid = $redis->get($feedidKey);
		if ($feedid) {
			return $feedid;
		}
		$feedinfo = $redis->zRevRange($redisKey, 0, 0, true);
		$feed = array_values($feedinfo);
		list($feedid) = $feed;
		return $feedid;
	}
	
}
?>