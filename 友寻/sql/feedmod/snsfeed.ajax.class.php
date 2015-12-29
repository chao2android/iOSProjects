<?php
/*
 * 动态列表 客户端
 * @author WangYinghao
 * @modify LiuYang
*/

class snsfeed_ajax extends cmi_snsfeed{

	function _Init_($args){ //处理接收到的参数
		$this->mod('feedformat');
		$this->mod('profile');
		$this->mod('permission');
		$this->mod('picture');
		$this->mod('relation');
		$this->mod('match');
		$this->mod('search');
		$this->mod('memcd');
		$this->mod('avatar');

		$this->form = json_decode($this->getParam('form'), true);
		$this->oid = $this->getParam('oid', 'floatval', 0); //对方uid
		$this->feedid = $this->getParam('feedid', 'floatval'); 
		$this->photoid = $this->getParam('photoid', 'floatval'); 
		$this->source = $this->getParam('source','string'); //app统计标识
		$this->uid = $args['cmiajax_uid'];
	}
	/**
	 * 获取动态内容
	 * @param int uid 
	 * @return array
	 */
	public function get_feed(){
		$uid = $this->oid ? $this->oid : $this->uid;
		$value = parent::get_feed($this->feedid);
		$data['feed'] = $this->feedformat->formatFeed($uid,$value);
		//$data['feed']['userinfo'] = $this->profile->get_user_info($value['uid']);
		//$avatar = $this->avatar->get_useravatar($value['uid']);
		//$data['feed']['userinfo']['avatar'] = $avatar[1];

		$data['userinfo'] = $this->profile->get_user_info($uid);
		$avatar = $this->avatar->get_useravatar($uid);
		$data['userinfo']['avatar'] = $avatar[1];

		// 返回正常请求状态和结果
		$rt = array (
				'retcode' => CMI_AJAX_RET_CODE_SUCC,
				'retmean' => 'CMI_AJAX_RET_CODE_SUCC',
				'data' => $data
			);
		return $rt;
	}

	public function get_feed_by_uid(){
		$form = $this->form;
		$uid = $this->uid;
		$oid = $this->oid;
		$type = $form['type'] ? $form['type'] : 0;
		$page = $form['page'];
		$pagesize = $form['pagesize'];
		
		$userinfo = $this->profile->get_user_info($uid, array('sex'));	
		$sex_num_dttab_ci  = $userinfo['sex'] ? 200453 : 200454;
		$this->log->checkpoint_code($sex_num_dttab_ci);
		
		

		$result = array('resultCount'=>0,
			'resultJson'=>array(),
			'page'=>$page,
			'pageSize'=>$pagesize
			);
		$ret = $arr = array();
		if($oid>0 && $uid != $oid) {
			$feeds=$this->feedformat->getOnceByUid($oid,$uid,$page,$pagesize);  //按分页获取动态 
			// 返回正常请求状态和结果
			$rt = array (
					'retcode' => CMI_AJAX_RET_CODE_SUCC,
					'retmean' => 'CMI_AJAX_RET_CODE_SUCC',
					'data' => $feeds
				);
			return $rt;
		} else {
				$ret = parent::gets_by_uid($uid,$page,$pagesize);
				$count = parent::count_by_uid($uid);
		}

		$userinfo=array();
		if(is_array($ret) && $count > 0 && !$ret['status']){ //接口返回容错
			foreach($ret as $value ){
				//我自己发的 不显示 生日提醒
				if($value['type'] == 111 || $value['type'] == 312  
					|| ($type==100 && $value['type']==400 )){
					$count--;
					continue;
				}
				if($value['type']==400){
					$count--;
					continue;
				}
				$id = $value['uid'];
				if(!empty($id)) {
					$user = $this->profile->getUserInfo($id);
				} elseif($value['type'] % 100 != 12) {
					$count--;
					continue;
				}
				$user['feed'] = $this->feedformat->formatFeed($uid,$value);
				$is_focus = $this->relation->check_focus($uid,$id);
				$user['is_focus'] = $is_focus ? 1 : 0;

				if(count($user['feed']['data']['pids'])<=0)
					$user['feed']['data']['pids']='';
				$userinfo[] = $user;

			}
		}
		$result = array(
			'resultJson'=>$userinfo,
			'page'=>$page,
			'pageSize'=>$pagesize,
		);
		// 返回正常请求状态和结果
		$rt = array (
				'retcode' => CMI_AJAX_RET_CODE_SUCC,
				'retmean' => 'CMI_AJAX_RET_CODE_SUCC',
				'data' => $result
			);
		return $rt;
	}

	/**
	* 获取动态列表
	* @param $type 动态类型
	* @param $page 实际分页
	*/
	public function get_feed_list() {
		$form = $this->form;
		$uid  = $this->uid;
		$page = $form['page'];
		$pagesize = $form['pagesize'];
		$copy = $form['copy'];
		
		$userinfo = $this->profile->get_user_info($uid, array('sex'));	
		$sex_num_dtlist_ren  = $userinfo['sex'] ? 200449 : 200450;
		$this->log->checkpoint_code($sex_num_dtlist_ren, $uid);//APP-进入动态列表
		
		
		$feeds = parent::gets_app($uid, $page, $pagesize, $copy);
		$ret = array();
		foreach ($feeds as $time => $feed) {
			$oid = $feed['uid'];
			$user = $this->profile->getUserInfo($oid);
			$user['feed'] = $this->feedformat->formatFeed($uid, $feed);
			$is_focus = $this->relation->check_focus($uid, $oid);
			$user['is_focus'] = $is_focus > 0 ? 1 : 0;
			$ret[] = $user;			
		}
	
		// 返回正常请求状态和结果
		$result = array (
				'retcode' => CMI_AJAX_RET_CODE_SUCC,
				'retmean' => 'CMI_AJAX_RET_CODE_SUCC',
				'data' => $ret
			);
		return $result;
	}

	/**
	*获取最新动态条数
	*
	*/
	function new_feed()
	{
		$newfeed = parent::check($this->uid,'android');
		// 返回正常请求状态和结果
		$rt = array (
				'retcode' => CMI_AJAX_RET_CODE_SUCC,
				'retmean' => 'CMI_AJAX_RET_CODE_SUCC',
				'data' => $newfeed
			);
		return $rt;
	}

	
	/**
	* 发布动态消息
	*/
	function publish_dyn() {
		$uid = $this->uid;

		$pid  = $this->getParam('pid', 'string');
		$tvalue = $this->getParam('tvalue', 'string');

		$userinfo = $this->profile->get_user_info($uid, array('sex'));
		$sex = $userinfo['sex'] ? '男' : '女';
		
		$sex_num_dongtai_ren  = $userinfo['sex'] ? 200443 : 200444;
		$this->log->checkpoint_code($sex_num_dongtai_ren, $uid);//发动态人数
		$sex_num_dongtai_tiao  = $userinfo['sex'] ? 200445 : 200446;
		$this->log->checkpoint_code($sex_num_dongtai_tiao);//发动态条数
		$sex_num_dongtai_tiao_pic  = $userinfo['sex'] ? 200447 : 200448;
		
		//picture
		$picture_list = $arrPid = array();
		$feed_type = 100;
		if(!empty($pid)) {
			//$pid = trim($pid, ';');
			$this->log->checkpoint_code($sex_num_dongtai_tiao_pic);//发动态条数含图片
			$arrPid = json_decode($pid, true);
			$feed_type = 101;
		}
		//exp replace
		$tvalue_exp = "";
		$tvalue = str_replace('<br />', '', $tvalue);
		if(!empty($tvalue)) {
			$exp = $this->utility->loadC('exp');
			$tvalue_exp = $exp->expText2Url($tvalue);
		}
		$data = array('pids' => $arrPid, 'desc' => $tvalue);
		$result = parent::push($uid, $feed_type, $data);
		if($result) {
			$feed_id = $result;
			if(!empty($arrPid)) {
				$tracelog = $this->mod('tracelog');
				foreach($arrPid as $pic_id) {
					$arrPicture = array('status'=> 1, 'feed_id' => $feed_id);
					$this->picture->update_user_picture($uid, $pic_id, $arrPicture);
					//trace log upload dyn picture
					$content = array('feed_id'=> $feed_id,"pid"=> $pic_id);
					$tracelog->insertTraceLog(array('uid'=> $uid,'act_type'=> 103,'content'=> json_encode($content)));
				}
				$pub_picture = $this->picture->get_user_picture($uid, $arrPid);
				foreach($pub_picture as $key => $picture) {
					$picture_list[$key][130] = $picture[130];
					$picture_list[$key][580] = $picture[580];
				}
			}
			if(empty($tvalue_exp) && !empty($picture_list)) {
				$tvalue_exp = "分享图片";
				
			}

			$json = array('pids'=> $picture_list, 'desc'=> $tvalue_exp,'feedid'=> $feed_id,'time'=> time());

			$ret = array (
				'retcode' => CMI_AJAX_RET_CODE_SUCC,
				'retmean' => 'CMI_AJAX_RET_CODE_SUCC',
				'data' => $json
			);
		} else {$ret = array (
				'retcode' => -1,
				'retmean' => '发布失败',
			);
		}
		return $ret;
	}

	/**
	*删除动态
	*
	*/
	function delete_feed()
	{
		$feedid = $this->feedid;
		if(parent::delete($this->uid,$feedid)) {
			$ret = array (
				'retcode' => CMI_AJAX_RET_CODE_SUCC,
				'retmean' => 'CMI_AJAX_RET_CODE_SUCC',
			);
		} else{
			$ret = array (
				'retcode' => -1,
				'retmean' => '删除失败',
			);
		}
		return $ret;
	}



	/**
	 * 赞 动态
	 * 自己不能赞自己，同性不能赞
	 */
	function like()
	{
		$oid = $this->oid;
		$feedid = $this->feedid;		
		$source = $this->source;	
		
		$recode = $this->permission->is_like($this->uid, $oid);
		if($recode['code']!=1) {
			$ret = array (
				'retcode' => $recode['code'],
				'retmean' => $recode['msg']
			);
			return $ret;
		}

		if(parent::isilike($this->uid,$oid,$feedid)){
			$ret = array (
				'retcode' => 2,
				'retmean' => '您已经赞过了'
			);
			return $ret; 
		}

		$recode = parent::like($this->uid, $oid, $feedid);

		if($recode) {
			
			$this->mod('profile');
			$uid_userinfo = $this->profile->get_user_info($this->uid);
			$sex_num_r_ci  = $uid_userinfo['sex'] ? 200401 : 200402;
			$this->log->checkpoint_code($sex_num_r_ci); //发赞人次
			$sex_num_r_ren  = $uid_userinfo['sex'] ? 200399 : 200400;
			$this->log->checkpoint_code($sex_num_r_ren, $this->uid); //发赞人数
			
			
			$sex_num_rec_ren  = $uid_userinfo['sex'] ? 200403 : 200404;
			$this->log->checkpoint_code($sex_num_rec_ren, $oid); //收赞人数
			
			$sex_num_hudong  = $uid_userinfo['sex'] ? 200441 : 200442;
			$this->log->checkpoint_code($sex_num_hudong, $this->uid);//互动
			
			if($source == 'app'){	
				$sex_num_r_ci  = $uid_userinfo['sex'] ? 200463 : 200464;
				$this->log->checkpoint_code($sex_num_r_ci); //发赞人次
				$sex_num_r_ren  = $uid_userinfo['sex'] ? 200461 : 200462;
				$this->log->checkpoint_code($sex_num_r_ren, $this->uid); //发赞人数
			}
			//trace log 赞统计
			$tracelog = $this->mod('tracelog');
			$tracelog->insertTraceLog(array('uid'=> $this->uid, 'act_type'=> 135, 'content'=> $oid));
			
			$ret = array (
				'retcode' => CMI_AJAX_RET_CODE_SUCC,
				'retmean' => 'CMI_AJAX_RET_CODE_SUCC',
			);
		} else{
			$ret = array (
				'retcode' => 0,
				'retmean' => '赞失败'
			);
		}
		return $ret;
	}

	/**
	 * 打招呼 会员（区别于赞动态,feedid以99结尾）
	 * @param oid 被查看会员uid
	 * @param from 用于区分来源 0 代表个人中心，1 代表夫妻相专题
	 * @return bool
	 */
	function like_user(){
		$oid = $this->oid;

		$recode = $this->permission->is_like($this->uid, $oid);
		if($recode['code']!=1) {
			$ret = array (
				'retcode' => $recode['code'],
				'retmean' => $recode['msg']
			);
			return $ret;
		}
		//为会员的个人主页生成一个feedid
		$feedid=intval($oid / 100)*100 + 99;

		if(parent::isilike($this->uid,$oid,$feedid)){
			$ret = array (
				'retcode' => 2,
				'retmean' => '您已经打过招呼了'
			);
			return $ret; 
		}
		
		$recode=parent::like($this->uid,$oid,$feedid);

		if($recode > 0 ) {
			
			$this->mod('profile');
			$uid_userinfo = $this->profile->get_user_info($this->uid);
			$sex_num_r_ci  = $uid_userinfo['sex'] ? 200401 : 200402;
			$this->log->checkpoint_code($sex_num_r_ci); //发赞人次
			$sex_num_r_ren  = $uid_userinfo['sex'] ? 200399 : 200400;
			$this->log->checkpoint_code($sex_num_r_ren, $this->uid); //发赞人数
			
			
			$sex_num_rec_ren  = $uid_userinfo['sex'] ? 200403 : 200404;
			$this->log->checkpoint_code($sex_num_rec_ren, $oid); //收赞人数
			
			$sex_num_hudong  = $uid_userinfo['sex'] ? 200441 : 200442;
			$this->log->checkpoint_code($sex_num_hudong, $this->uid);//互动
			
			//trace log 赞统计
			$tracelog = $this->mod('tracelog');
			$tracelog->insertTraceLog(array('uid'=> $this->uid, 'act_type'=> 135, 'content'=> $oid));
			
			$ret = array (
				'retcode' => CMI_AJAX_RET_CODE_SUCC,
				'retmean' => 'CMI_AJAX_RET_CODE_SUCC',
			);
		} else{
			$ret = array (
				'retcode' => 0,
				'retmean' => '打过招呼失败'
			);
		}
		return $ret;
	}

	/**
	 * 赞生活照 会员（区别于赞动态,feedid以94结尾）
	 * @param oid 被查看会员uid
	 * @param photoid 照片ID
	 * @return bool
	 */
	function like_user_photo(){
		$oid = $this->oid;

		$recode = $this->permission->is_like($this->uid, $oid);
		if($recode['code']!=1) {
			$ret = array (
				'retcode' => $recode['code'],
				'retmean' => $recode['msg']
			);
			return $ret;
		}
		//为生活照 生成一个feedid
		$feedid = intval($this->photoid / 100)*100 + 94;

		if(parent::isilike($this->uid,$oid,$feedid)){
			$ret = array (
				'retcode' => 2,
				'retmean' => '您已经过了'
			);
			return $ret; 
		}
		
		
		$recode=parent::like($this->uid,$oid,$feedid);

		if($recode > 0 ) {
			
			$this->mod('profile');
			$uid_userinfo = $this->profile->get_user_info($this->uid);
			$sex_num_r_ci  = $uid_userinfo['sex'] ? 200401 : 200402;
			$this->log->checkpoint_code($sex_num_r_ci); //发赞人次
			$sex_num_r_ren  = $uid_userinfo['sex'] ? 200399 : 200400;
			$this->log->checkpoint_code($sex_num_r_ren, $this->uid); //发赞人数
			
			
			$sex_num_rec_ren  = $uid_userinfo['sex'] ? 200403 : 200404;
			$this->log->checkpoint_code($sex_num_rec_ren, $oid); //收赞人数
			
			//trace log 赞统计
			$tracelog = $this->mod('tracelog');
			$tracelog->insertTraceLog(array('uid'=> $this->uid, 'act_type'=> 135, 'content'=> $oid));
			
			$ret = array (
				'retcode' => CMI_AJAX_RET_CODE_SUCC,
				'retmean' => 'CMI_AJAX_RET_CODE_SUCC',
			);
		} else{
			$ret = array (
				'retcode' => 0,
				'retmean' => '赞失败'
			);
		}
		return $ret;
	}


}