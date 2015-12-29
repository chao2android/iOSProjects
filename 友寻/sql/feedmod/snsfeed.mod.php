<?php
/**
 * 动态消息功能模块
 * @author ZhuShunqing
 */
class cmi_snsfeed extends cmi_module{

	/*
	 * 发布动态
	 * @param float $uid 发起关注者
	 * @param int $type 动态消息类型
	 * @param array $data 消息内容
	 * @param int $time 指定消息时间（不分发给关注者）
	 * @return float feedid
	 */
	function &push($uid, $type, $data = array(), $time = null){ return $this->_callImplements(); }

	/**
	 * 获取动态消息
	 * @param float uid 
	 * @param int $page 页数
	 * @param int $size 条数 
	 * @param array $types 消息类型 
	 * @return array
	 */
	function &gets($uid, $page = 1, $size = 10, $types = array()){ return $this->_callImplements(); }

	/**
	 * 获取app动态消息列表
	 * @param float uid 
	 * @param int $page 页数
	 * @param int $size 条数 
	 * @param bool $copy 防止刷新重复记录
	 * @return array
	 */
	function &gets_app($uid, $page = 1, $size = 10, $copy= false){ return $this->_callImplements(); }
	
	/**
	 * 删除动态消息
	 * @param float uid
	 * @param float feedid
	 * @return bool
	 */
	function &delete($uid, $feedid){ return $this->_callImplements(); }

	/**
	 * 删除指定关注用户动态消息
	 * @param float uid
	 * @param float feedid
	 * @return int 清理个数
	 */
	function &delete_by_oid($uid, $oid){ return $this->_callImplements(); }

	/**
	 * 更新动态内容
	 * @param int feedid 
	 * @param array data 
	 * @return bool
	 */
	function &update($feedid, $data){ return $this->_callImplements(); }

	/**
	 * 从最新动态数据库里实时查询重新生成feed
	 * @param float uid
	 * @return bool
	 */
	function &rebuild_feeds($uid){ return $this->_callImplements(); }
	
	/**
	 * feed列表
	 * @param float uid
	 * @return bool
	 */
	function &app_rebuild_feeds($uid){ return $this->_callImplements(); }
	
	/**
	 * 获取动态内容
	 * @param int uid 
	 * @return array
	 */
	function &get_feed($feedid){ return $this->_callImplements(); }

	/**
	 * 获取动态列表数目
	 * @param float $uid
	 * @param array $types 消息类型 
	 * @return int
	 */
	function &count($uid, $types = array()){ return $this->_callImplements(); }

	/**
	 * 获取某用户产生的全部动态消息数目
	 * @param float $uid 
	 * @return int
	 */
	function &count_by_uid($uid, $type = array()){ return $this->_callImplements(); }

	/**
	 * 获取某用户产生的消息列表
	 * @param float $uid 
	 * @param int $page 页码
	 * @param int $size 条数
	 * @param array $type 类型
	 * @param bool $isdel 包含已删除
	 * @return array
	 */
	function gets_by_uid($uid, $page = 1, $size = 10, $type = false, $isdel = false){ return $this->_callImplements(); }

	/**
	* 我like了谁总数
	* @param float $uid 
	* @return int
	*/
	function &ilikecount($uid){ return $this->_callImplements(); }


	/**
	* 谁like了我总数
	* @param float $uid 
	* @return int
	*/
	function &wholikecount($uid){ return $this->_callImplements(); }

	
	/**
	* 我like了谁
	* @param float $uid 
	* @param int $page 页数
	* @param num $size 条数 
	* @return array
	*/
	function &ilikes($uid, $page = 1, $size = 10){ return $this->_callImplements(); }

	/**
	* 谁like了我
	* @param float $uid 
	* @param int $page 页数
	* @param num $size 条数 
	* @return array
	*/
	function &wholikes($uid, $page = 1, $size = 10){ return $this->_callImplements(); }

	/**
	* 赞
	* @param float $uid 
	* @param float $oid 
	* @param float $feedid feedid为0表示该人的赞
	* @param $checkpoint=true表示进行统计，
	******   $checkpoint为false表示不进行统计
	* @return bool
	*/
	function &like($uid, $oid, $feedid, $checkpoint = true){ return $this->_callImplements(); }

	/**
	* 取消赞
	* @param float $uid 
	* @param float $oid 
	* @param float $feedid 
	* @return bool
	*/
	function &unlike($uid, $oid, $feedid){ return $this->_callImplements(); }

	/**
	* 我是否赞了
	* @param float $uid 
	* @param float $oid 
	* @param float $feedid 
	* @return bool
	*/
	function &isilike($uid, $oid, $feedid){ return $this->_callImplements(); }

	/**
	* 赞过此feed的人数
	* @param float $feedid 
	* @return int
	*/
	function &wholikefeedcount($feedid){ return $this->_callImplements(); }

	/**
	* 赞过此feed的人
	* @param float $feedid 
	* @return array
	*/
	function &wholikefeed($feedid){ return $this->_callImplements(); }

	/**
	* 检查新动态
	* @param float $uid
	* @param string $type 新'feed' or 新'like'
	* @return int
	*/
	function &check($uid, $type = 'feed'){ return $this->_callImplements(); }

	/**
	* 生成几条默认动态
	* @param float $uid
	* @param array $types 指定类型
	* @return array feeds
	*/
	function &push_first_feeds($uid, $types = array()){ return $this->_callImplements(); }

	/**
	* 添加关注对象
	* @param float $uid
	* @param float $oid
	* @param string $queue 使用哪组队列
	* @param int $expire 过期时间（秒）0不过期
	*/
	function &add_focus($uid, $oid, $queue = '', $expire = 0){ return $this->_callImplements(); }

	/**
	* 删除关注对象
	* @param float $uid
	* @param float $oid
	* @param string $queue 使用哪组队列
	*/
	function &del_focus($uid, $oid, $queue = ''){ return $this->_callImplements(); }

	/**
	* 添加关注对象
	* @param float $uid
	* @param string $queue 使用哪组队列
	*/
	function &gets_focus($uid, $queue = ''){ return $this->_callImplements(); }

	/**
	* 添加谁关注了我
	* @param float $uid
	* @param string $queue 使用哪组队列
	*/
	function &gets_fans($uid, $queue = ''){ return $this->_callImplements(); }

	/**
	* 根据uid返回redis实例（后台脚本用，前端调用无效）
	* @param float $uid
	* @return redis
	*/
	function &getRedisByUID($uid){ return $this->_callImplements(); }
	
	/**
	* 广场推最新feed
	* @param int $uid 
	* @param int $feedid 动态id
	* @param int $type feed类型
	* return Boolean
	*/
	function &square_push_feeds($uid, $feedid, $type){ return $this->_callImplements(); }
	
	/**
	* 取全站最新动态 mysql
	* @param int $uid
	* @param int $sex
	* @param int $page 分页用
	* @param int $num 每页显示数量
	* @param int $feed_id
	* return array
	*/
	function &getHotFeedList($sex= 0, $page= 1, $num= 10, $feed_id= 0){ return $this->_callImplements(); }
	
	/**
	* 取全站最新动态 redis
	* @param int $uid
	* @param int $sex
	* @param int $page 分页用
	* @param int $num 每页显示数量
	* @param int $feed_id
	* return array
	*/
	function &getHotFeedListNew($sex= 0, $page= 1, $num= 10, $feed_id= 0){ return $this->_callImplements(); }
	
	/**
	* 取全站最新动态 feedid
	* @param int $sex
	* return int
	*/
	function &getLatestFeedid($sex= 0){ return $this->_callImplements(); }
	
	/** 
	 * 清缓存 
	 * @param int $uid
	 * @return boolean
	 */
	function &clear_cache($uid){ return $this->_callImplements(); }
}