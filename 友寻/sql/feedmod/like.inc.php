<?php
/**
 * SNS动态消息-like子类
 * @author ZhuShunqing 
 *
 */
class snsfeed_like extends cmi_implements{

	/**
	* like列表
	* @param float $uid 
	* @param int $type 类型 0like我的 1我like的
	* @return int
	*/
	function likecount($uid, $type){
		$uid = floatval($uid);
		$type = intval($type);

		$feed_like = $this->dbr->loadDB('feed_like');
		$condition = array(
			'where' => array(
				'uid'	=> array('=', $uid),
				'and',
				'type'	=> array('=', $type),
				'and',
				'status'=> array('!=', -1)
			)
		);
		$count = $feed_like->query_count('feed_like', $condition);
		return $count;
	}

	/**
	* like列表
	* @param float $uid 
	* @param int $page 页数
	* @param int $size 条数 
	* @param int $type 类型 0like我的 1我like的
	* @return array
	*/
	function likelist($uid, $page, $size, $type){
		$uid = floatval($uid);
		$page = intval($page);
		$size = intval($size);
		$type = intval($type);
		$page = $page > 1 ? ($page - 1) * $size : 0;

		$feed_like = $this->dbr->loadDB('feed_like');
		$fields = array('feedid', 'uid', 'oid', 'type', 'time');
		$condition = array(
			'where' => array(
				'uid'	=> array('=', $uid),
				'and',
				'type'	=> array('=', $type),
				'and',
				'status'=> array('!=', -1)
			),
			'order' => array(
				'time' => 'desc'
			),
			'limit' => array($page, $size),
		);
		$list = $feed_like->query_all('feed_like', $fields, $condition);
		foreach($list as $i => &$v){
			$data = $this->parent->get_feed($v['feedid']); //用$this->parent->引用同类方法可以调用CMI缓存
			$v['data'] = $data['data'];
			$v['like'] = $data['like'];
			$v['status'] = $data['status'];
		}
		return $list;
	}	

	/**
	* 赞
	*
	* @param float $uid 
	* @param float $oid 
	* @param float $feedid
	* @param $checkpoint=true表示进行统计，
	******   $checkpoint为false表示不进行统计
	* @return bool
	*/
	function like($uid, $oid, $feedid, $checkpoint = true){
		$uid = floatval($uid);
		$oid = floatval($oid);
		$feedid = floatval($feedid);
		if(!$uid || !$oid || !$feedid)
			return $this->getConf('ERROR_DEFINE', 'param_err');

		$feed_like = $this->dbr->loadDB('feed_like');
		$feed_wholike = $this->dbr->loadDB('feed_wholike');
		$feed_update = $this->dba->loadDB('mdb_sns_0');

		$duprow = array('status' => 0);
		//插入我like过的
		$row = array(
			'uid'	=> $uid,
			'oid'	=> $oid,
			'feedid'=> $feedid,
			'type'	=> 1,
			'time'	=> time(),
		);
		$ret = $feed_like->insert('feed_like', $row, $duprow);
		if(!$ret) return $this->getConf('ERROR_DEFINE', 'insert_like_error');

		//已经like过了
		$affected = $feed_like->query_affected_rows($uid);
		if(!$affected) return $this->getConf('ERROR_DEFINE', 'is_liked');

		//插入like我的
		$row = array(
			'uid'	=> $oid,
			'oid'	=> $uid,
			'feedid'=> $feedid,
			'type'	=> 0,
			'time'	=> time(),
		);
		$ret = $feed_like->insert('feed_like', $row, $duprow);
		if(!$ret) return $this->getConf('ERROR_DEFINE', 'insert_like_err');

		//已经like过了
		$affected = $feed_like->query_affected_rows($oid);
		if(!$affected) return $this->getConf('ERROR_DEFINE', 'is_liked');

		//插入按feed索引被哪些人like
		$row = array(
			'feedid'=> $feedid,
			'uid'	=> $uid,
			'time'	=> time(),
		);
		$ret = $feed_wholike->insert('feed_wholike', $row, $duprow);
		if(!$ret) return $this->getConf('ERROR_DEFINE', 'insert_like_err');

		//已经like过了
		$affected = $feed_wholike->query_affected_rows($feedid);
		if(!$affected) return $this->getConf('ERROR_DEFINE', 'is_liked');

		//更新like计数
		$feed_content = $this->dbr->loadDB('feed_content');
/*
		$row = array(
			'like' => '(`like`+1)'
		);
		$condition = array(
			'where'	=> array(
				'feedid' => array('=', $feedid)
			)
		);
		$ret = $feed_content->update('feed_content', $row, $condition);
*/

		//改用insert on duplicate key update方式使虚拟feedid不存在时自动插入
		$row = array(
			'feedid' => $feedid,
			'like' => 1
		);
		$duprow = array(
			'like' => '(`like`+1)'
		);
		$ret = $feed_content->insert('feed_content', $row, $duprow);

		if(!$ret) return $this->getConf('ERROR_DEFINE', 'like_incr_err');

		//更新update里的计数
		$feed_update->selectdb('feed_update');
		$row = array(
			'like' => '(`like`+1)'
		);
		$condition = array(
			'where'	=> array(
				'feedid' => array('=', $feedid)
			)
		);
		//$row, $conditio 接上段
		$ret = $feed_update->update('feed_update', $row, $condition);
		if(!$ret) return $this->getConf('ERROR_DEFINE', 'like_incr_err');

		//对方新like计数		
		$memc = $this->memcd->loadMemc('feeds');
		$ret = $memc->increment('like_new_' . $oid, 1, 3600 * 24 * 7);
		
		//更新广场照片墙赞排行
		$this->square_like_rank($oid, $feedid);
		
		//清除content cache
		$this->delCache('get_feed', array($feedid));
		//推送提醒消息
		$this->mod('notice');
		$this->notice->push($oid, 104);
		//更新列表cache
		$this->reCache('default');
		//更新对方列表cache
		$this->reCache('default', array($oid));
		//赞 计数器
		$this->mod('permission');
		$this->permission->jycount_like($uid, $oid);
		
		//更新 接收互动表
		$this->mod('relation');
		$this->relation->add_interactive($oid);
		
		//赞推送消息
		$push = $this->mod('push');
		$pushid = $push->getPushId($oid);
		if ($pushid) {
			$profile = $this->mod('profile');
			$userinfo = $profile->get_user_info($uid, array('nick'));
			extract($userinfo);
			$message = array(
				'cmd'	=> 124,
				'nick'	=> $nick,
				'from'	=> $uid,
				'timer' => time(),
				'feedid' => $feedid
			);
			$ret = $push->pushMessage($oid, $message);
			$ret = json_decode(json_encode($ret), true);
			//trace log 
			if (isset($ret[3])) {
				$tracelog = $this->mod('tracelog');
				$tracelog->insertTraceLog(array('uid'=> $uid, 'act_type'=> 149, 'content'=> $oid));
			}
		}
		//
		
		//所有赞的统计
		if($checkpoint){
			$this->mod('profile');
			$userinfo = $this->profile->get_user_info($uid, 'sex');
			$sex = $userinfo['sex'] ? '男会员' : '女会员';
			$otherSex = $userinfo['sex'] ? '女会员' : '男会员';
			$this->log->checkpoint('赞汇总', $sex.'发赞人数', $uid);
			$this->log->checkpoint('赞汇总', $sex.'发赞条数');
			$this->log->checkpoint('赞汇总', $otherSex.'收赞人数', $oid);

			$sex = $userinfo['sex'] ? '男' : '女';
			$this->log->checkpoint('互动人数', 'all-'.$sex, $uid);
		}
			
		return $ret;
	}
	
	/**
	* 广场照片墙赞排名
	* @param float $uid 
	* @param float $feedid 
	* @return bool
	*/
	function square_like_rank($uid, $feedid) {
		$profile = $this->mod('profile');
		$login = $this->mod('login');
		$userinfo = $profile->get_user_info($uid, 'sex');
		$sex = $userinfo['sex'];
		$gender = $sex ? 'm' : 'f';
		$sub = $sex ? 1000 : 500;
		$redis = $this->parent->getRedisByUID($sub);
		$newPhotoListKey = 'new_photo_list_key_'.$gender;
		$member = $feedid."|".$uid;
		$score = $redis->zScore($newPhotoListKey, $member);
		$user_login = $login->get_userlogin($uid);
		$register_time = $user_login['register_time'];
		$last_login = $user_login['last_login'];
		$reg_month = date('Y-m', $register_time);
		$now_month = date('Y-m');
		$last_login_month = date('Y-m', $last_login);
		if ($reg_month != $now_month && $last_login_month == $now_month && $score >= 10) {
			$redis->zRem($newPhotoListKey, $member);
			return false;
		}
		if (false !== $score) {
			$redis->zIncrBy($newPhotoListKey, 1, $member);
		}
		return true;
	}
	
	/**
	* 赞
	* @param float $uid 
	* @param float $oid 
	* @param float $feedid 
	* @return bool
	*/
	function unlike($uid, $oid, $feedid){
		$uid = floatval($uid);
		$oid = floatval($oid);
		$feedid = floatval($feedid);
		if(!$uid || !$oid || !$feedid)
			return $this->getConf('ERROR_DEFINE', 'param_err');

		$feed_like = $this->dbr->loadDB('feed_like');
		$feed_wholike = $this->dbr->loadDB('feed_wholike');
		$feed_update = $this->dba->loadDB('mdb_sns_0');

		//删除状态
		$row = array('status' => -1);

		//删除我like过的
		$condition = array(
			'where' => array(
				'uid'	=> array('=', $uid),
				'and',
				'oid'	=> array('=', $oid),
				'and',
				'feedid'=> array('=', $feedid)
			),
		);
		$ret = $feed_like->update('feed_like', $row, $condition);
		if(!$ret) return $this->getConf('ERROR_DEFINE', 'delete_like_err');

		//已经删除过了
		$affected = $feed_like->query_affected_rows($uid);
		if(!$affected) return $this->getConf('ERROR_DEFINE', 'is_deleted');

		//删除被like的
		$condition = array(
			'where' => array(
					'uid'	=> array('=', $oid),
					'and',
					'oid'	=> array('=', $uid),
					'and',
					'feedid'=> array('=', $feedid)
				),
		);
		$ret = $feed_like->update('feed_like', $row, $condition);
		if(!$ret) return $this->getConf('ERROR_DEFINE', 'delete_like_err');

		//已经删除过了
		$affected = $feed_like->query_affected_rows($oid);
		if(!$affected) return $this->getConf('ERROR_DEFINE', 'is_deleted');

		//删除按feed索引被哪些人like
		$condition = array(
			'where' => array(
					'feedid'=> array('=', $feedid),
					'and',
					'uid'	=> array('=', $uid)
				),
		);
		$ret = $feed_wholike->update('feed_wholike', $row, $condition);
		if(!$ret) return $this->getConf('ERROR_DEFINE', 'delete_like_err');

		//已经删除过了
		$affected = $feed_wholike->query_affected_rows($feedid);
		if(!$affected) return $this->getConf('ERROR_DEFINE', 'is_deleted');

		//更新like计数
		$feed_content = $this->dbr->loadDB('feed_content');
		$row = array(
			'like' => '(`like`-1)'
		);
		$condition = array(
			'where'	=> array(
				'feedid' => array('=', $feedid)
			)
		);
		$ret = $feed_content->update('feed_content', $row, $condition);
		if(!$ret) return $this->getConf('ERROR_DEFINE', 'like_decr_err');

		//更新update里的计数
		$feed_update->selectdb('feed_update');
		//$row, $conditio 接上段
		$ret = $feed_update->update('feed_update', $row, $condition);
		if(!$ret) return $this->getConf('ERROR_DEFINE', 'like_decr_err');
		
		//清除content cache
		$this->delCache('get_feed', array($feedid));
		//更新列表cache
		$this->reCache('default');

		return $ret;
	}

	/**
	* 我是否赞了
	* @param float $uid 
	* @param float $oid 
	* @param float $feedid 
	* @return bool
	*/
	function isilike($uid, $oid, $feedid){
		if (empty($uid) || empty($oid) || empty($feedid)) {
			return false;
		}
		$uid = floatval($uid);
		$oid = floatval($oid);
		$feedid = floatval($feedid);

		$feed_like = $this->dbr->loadDB('feed_like');
		$condition = array(
			'where' => array(
				'uid'	=> array('=', $uid),
				'and',
				'oid'	=> array('=', $oid),
				'and',
				'feedid'=> array('=', $feedid),
				'and',
				'status'=> array('!=', -1)
			),
		);
		$ret = $feed_like->query_count('feed_like', $condition);
		return $ret;
	}

	/**
	* 赞过此feed的人数
	* @param float $feedid 
	* @return int
	*/
	function wholikefeedcount($feedid){
		$feed = $this->parent->get_feed($feedid);
		if($feed){
			return intval($feed['like']);
		}else{
			return false;
		}
	}

	/**
	* 赞过此feed的人
	* @param float $feedid 
	* @return array
	*/
	function wholikefeed($feedid, $page = 1, $size = 12){
		$feedid = floatval($feedid);
		$page = intval($page);
		$size = intval($size);
		$page = $page > 1 ? ($page - 1) * $size : 0;

		$feed_wholike = $this->dbr->loadDB('feed_wholike');

		$fields = array('uid', 'time');
		$condition = array(
			'where' => array(
				'feedid'	=> array('=', $feedid),
				'and',
				'status'=> array('!=', -1)
			),
			'order' => array(
				'time' => 'desc'
			),
			'limit' => array($page, $size),
		);
		$list = $feed_wholike->query_all('feed_wholike', $fields, $condition);
		return $list;
	}
}
?>