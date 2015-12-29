<?php
/**
 * SNS动态消息-focus子类
 * @author ZhuShunqing 
 *
 */
class snsfeed_focus extends cmi_implements{

	function _Init_(){
		$this->loadC('implements');
	}
	
	/**
	* 添加关注对象
	* @param int $uid
	* @param int $oid
	* @param string $queue 使用哪组队列
	* @param int $expire 过期时间（秒）0不过期
	*/
	function add_focus($uid, $oid, $queue = '', $expire = 0){
		//正向
		$redis = $this->implements->getRedisByUID($uid);
		$rdkey = 'feed_focus_' . $uid . '_' . $queue;
		$ret = $redis->sadd($rdkey, $oid);
		if($expire) $redis->expire($rdkey, $expire);
		//反向
		$redis = $this->implements->getRedisByUID($oid);
		$rdkey = 'feed_fans_' . $oid . '_' . $queue;
		$ret = $redis->sadd($rdkey, $uid);
		if($expire) $redis->expire($rdkey, $expire);
		return $ret;
	}

	/**
	* 删除关注对象
	* @param int $uid
	* @param int $oid
	* @param string $queue 使用哪组队列
	*/
	function del_focus($uid, $oid, $queue = ''){
		//正向
		$redis = $this->implements->getRedisByUID($uid);
		$rdkey = 'feed_focus_' . $uid . '_' . $queue;
		$ret = $redis->srem($rdkey, $oid);		
		//反向
		$redis = $this->implements->getRedisByUID($oid);
		$rdkey = 'feed_fans_' . $oid . '_' . $queue;
		$ret = $redis->srem($rdkey, $uid);
		return $ret;
	}

	/**
	* 返回关注对象
	* @param int $uid
	* @param string $queue 使用哪组队列
	*/
	function gets_focus($uid, $queue = ''){
		$redis = $this->implements->getRedisByUID($uid);
		$rdkey = 'feed_focus_' . $uid . '_' . $queue;
		$ret = $redis->smembers($rdkey);
		return $ret;
	}

	/**
	* 添加谁关注了我
	* @param int $uid
	* @param string $queue 使用哪组队列
	*/
	function gets_fans($uid, $queue = ''){
		$redis = $this->implements->getRedisByUID($uid);
		$rdkey = 'feed_fans_' . $uid . '_' . $queue;
		$ret = $redis->smembers($rdkey);
		return $ret;
	}

}
?>