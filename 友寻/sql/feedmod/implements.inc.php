<?php
/**
 * SNS动态消息接口
 * @author ZhuShunqing 
 *
 */
class snsfeed_implements extends cmi_implements{

	function _Init_(){
		$this->_db_trans = $this->getConf('DB_TRANSACTION');
		$this->_error_define = $this->getConf('ERROR_DEFINE');
		$this->redis = array();
	}

	/*
	 * 发布动态
	 * @param float $uid 发起关注者
	 * @param int $type 动态消息类型
	 * @param array $data 消息内容
	 * @param int $time 指定消息时间（不分发给关注者）
	 * @return float feedid
	 */
	function push($uid, $type, $data = array(), $time = null){
		$this->loadC('feed');
		$ret = $this->feed->push($uid, $type, $data, $time);
		return $ret;
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
		$this->loadC('feed');
		$ret = $this->feed->gets($uid, $page, $size, $types);
		return $ret;
	}

	/**
	 * 获取qpp动态消息列表
	 * @param int uid 
	 * @param int $page 页数
	 * @param int $size 条数 
	 * @return array
	 */
	function gets_app($uid, $page = 1, $size = 10, $copy= false){
		$this->loadC('feed');
		$ret = $this->feed->gets_app($uid, $page, $size, $copy);
		return $ret;
	}

	/**
	 * 删除动态消息
	 * @param float uid
	 * @param float feedid
	 * @return bool
	 */
	function delete($uid, $feedid){
		$this->loadC('feed');
		$ret = $this->feed->delete($uid, $feedid);
		return $ret;
	}


	/**
	 * 删除指定关注用户动态消息
	 * @param float uid
	 * @param float feedid
	 * @return int 清理个数
	 */
	function delete_by_oid($uid, $oid){
		$this->loadC('feed');
		$ret = $this->feed->delete_by_oid($uid, $oid);
		return $ret;
	}

	/**
	 * 更新动态内容
	 * @param int feedid 
	 * @param array data 
	 * @return bool
	 */
	function update($feedid, $data){
		$this->loadC('feed');
		$ret = $this->feed->update($feedid, $data);
		return $ret;
	}

	/**
	 * 获取动态内容数据
	 * @param float $feedid
	 */
	function get_feed($feedid){
		$this->loadC('feed');
		$ret = $this->feed->get_feed($feedid);
		return $ret;
	}

	/**
	 * 获取动态列表数目
	 * @param float $uid
	 * @param array $types 消息类型 
	 * @return int
	 */
	function count($uid, $types = array()){
		$this->loadC('feed');
		$ret = $this->feed->count($uid, $types);
		return $ret;
	}

	/**
	 * 获取某用户产生的个人动态消息数目
	 * @param float $uid 
	 * @param array $types 消息类型 
	 * @return int
	 */
	function count_by_uid($uid, $types = array()){
		$this->loadC('feed');
		$ret = $this->feed->count_by_uid($uid, $types);
		return $ret;
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
		$this->loadC('feed');
		$ret = $this->feed->gets_by_uid($uid, $page, $size, $type, $isdel);
		return $ret;
	}

	/**
	* 检查新动态
	* @param float $uid
	* @param string $type 新'feed' or 新'like'
	* @return int
	*/
	function check($uid, $type = 'feed'){
		$this->loadC('feed');
		$ret = $this->feed->check($uid, $type);
		return $ret;
	}


	/**
	* 我like了谁总数
	* @param float $uid 
	* @return int
	*/
	function ilikecount($uid){
		$this->loadC('like');
		$ret = $this->like->likecount($uid, 1);
		return $ret;
	}

	/**
	* 谁like了我总数
	* @param float $uid 
	* @return int
	*/
	function wholikecount($uid){
		$this->loadC('like');
		$ret = $this->like->likecount($uid, 0);
		return $ret;
	}

	/**
	* 我like了谁
	* @param float $uid 
	* @param int $page 页数
	* @param num $size 条数 
	* @return array
	*/
	function ilikes($uid, $page = 1, $size = 10){
		$this->loadC('like');
		$ret = $this->like->likelist($uid, $page, $size, 1);
		return $ret;
	}

	/**
	* 谁like了我
	* @param float $uid 
	* @param int $page 页数
	* @param num $size 条数 
	* @return array
	*/
	function wholikes($uid, $page = 1, $size = 10){
		//清空新like计数		
		$memc = $this->memcd->loadMemc('feeds');
		$ret = $memc->delete('like_new_' . $uid);
		//like子类方法
		$this->loadC('like');
		$ret = $this->like->likelist($uid, $page, $size, 0);
		return $ret;
	}

	/**
	* 赞
	* @param float $uid 
	* @param float $oid 
	* @param float $feedid 
	* @return bool
	* @param $checkpoint=true表示进行统计，
	******   $checkpoint为false表示不进行统计
	*/
	function like($uid, $oid, $feedid, $checkpoint = true){
		$this->loadC('like');
		$ret = $this->like->like($uid, $oid, $feedid, $checkpoint);
		//统计
		$this->mod('profile');
		$user = $this->profile->get_user_info($uid, array('sex'));
		$sex = $user['sex'] ? '男' : '女';
		if($ret && $checkpoint) {
			$this->log->checkpoint('互动指数', '赞-'.$sex, $uid);
			$this->log->checkpoint('互动指数', '每日互动人数-'.$sex, $uid);
		}
		return $ret;
	}

	/**
	* 赞
	* @param float $uid 
	* @param float $oid 
	* @param float $feedid 
	* @return bool
	*/
	function unlike($uid, $oid, $feedid){		
		$this->loadC('like');
		$ret = $this->like->unlike($uid, $oid, $feedid);
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
		$this->loadC('like');
		$ret = $this->like->isilike($uid, $oid, $feedid);
		return $ret;
	}

	/**
	* 赞过此feed的人数
	* @param float $feedid 
	* @return int
	*/
	function wholikefeedcount($feedid){
		$this->loadC('like');
		$ret = $this->like->wholikefeedcount($feedid);
		return $ret;
	}

	/**
	* 赞过此feed的人
	* @param float $feedid 
	* @return array
	*/
	function wholikefeed($feedid, $page = 1, $size = 12){
		$this->loadC('like');
		$ret = $this->like->wholikefeed($feedid, $page, $size);
		return $ret;
	}

	/**
	 * 从最新动态数据库里实时查询重新生成feed
	 * @param float uid
	 * @return bool
	 */
	function rebuild_feeds($uid){
		$this->loadC('builder');
		$ret = $this->builder->rebuild_feeds($uid);
		return $ret;
	}
	
	/**
	 * 生成app feed列表
	 * @param float uid
	 * @return bool
	 */
	function app_rebuild_feeds($uid){
		$this->loadC('builder');
		$ret = $this->builder->app_rebuild_feeds($uid);
		return $ret;
	}
	
	/**
	* 生成几条默认动态
	* @param float $uid
	* @param array $types 指定类型
	* @return array feeds
	*/
	function push_first_feeds($uid, $types = array()){
		$this->loadC('builder');
		$ret = $this->builder->push_first_feeds($uid, $types);
		return $ret;
	}

	/**
	* 添加关注对象
	* @param float $uid
	* @param float $oid
	* @param string $queue 使用哪组队列
	* @param int $expire 过期时间（秒）0不过期
	*/
	function add_focus($uid, $oid, $queue = '', $expire = 0){
		$this->loadC('focus');
		return $this->focus->add_focus($uid, $oid, $queue, $expire);
	}

	/**
	* 删除关注对象
	* @param float $uid
	* @param float $oid
	* @param string $queue 使用哪组队列
	*/
	function del_focus($uid, $oid, $queue = ''){
		$this->loadC('focus');
		return $this->focus->del_focus($uid, $oid, $queue);
	}

	/**
	* 返回关注对象
	* @param float $uid
	* @param string $queue 使用哪组队列
	*/
	function gets_focus($uid, $queue = ''){
		$this->loadC('focus');
		return $this->focus->gets_focus($uid, $queue);
	}

	/**
	* 添加谁关注了我
	* @param float $uid
	* @param string $queue 使用哪组队列
	*/
	function gets_fans($uid, $queue = ''){
		$this->loadC('focus');
		return $this->focus->gets_fans($uid, $queue);
	}

	//根据uid分配redis
	function getRedisByUID($uid){
		$i = $uid / 100 % 10;
		$conf = $this->getConf('REDIS_SERVERS', $i);
		if(!isset($this->redis[$i])){
			$this->redis[$i] = new Redis();
			$this->redis[$i]->connect($conf['host'], $conf['port']);
		}
		return $this->redis[$i];
	}
	
	/**
	* 广场推最新feed
	* @param int $uid 
	* @param int $feedid 动态id
	* @param int $type feed类型
	* return Boolean
	*/
	function square_push_feeds($uid, $feedid, $type) {
		$this->loadC('feed');
		return $this->feed->square_push_feeds($uid, $feedid, $type);
	}
	
	/**
	* 取全站最新动态 mysql
	* @param int $sex
	* @param int $page 分页用
	* @param int $num 每页显示数量
	* @param int $feed_id 最新feedid
	* return array
	*/
	function getHotFeedList($sex= 0, $page= 1, $num= 10, $feed_id= 0) {
		$this->loadC('feed');
		return $this->feed->getHotFeedList($sex, $page, $num, $feed_id);
	}
	
	/**
	* 取全站最新动态 redis
	* @param int $sex
	* @param int $page 分页用
	* @param int $num 每页显示数量
	* @param int $feed_id 最新feedid
	* return array
	*/
	function getHotFeedListNew($sex= 0, $page= 1, $num= 10, $feed_id= 0) {
		$this->loadC('feed');
		return $this->feed->getHotFeedListNew($sex, $page, $num, $feed_id);
	}
	
	/**
	* 取全站最新动态 feedid
	* @param int $sex
	* return int
	*/
	function getLatestFeedid ($sex= 0) {
		$this->loadC('feed');
		return $this->feed->getLatestFeedid($sex);
	}
		
	/** 
	 * 清缓存 
	 * @param int $uid
	 * @return boolean
	 */
	function clear_cache($uid) {
		$this->reCache('default');
		return true;
	}
}

?>