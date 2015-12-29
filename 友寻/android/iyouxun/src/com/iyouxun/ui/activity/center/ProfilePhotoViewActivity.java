package com.iyouxun.ui.activity.center;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONObject;

import uk.co.senab.photoview.PhotoView;
import uk.co.senab.photoview.PhotoViewAttacher.OnPhotoTapListener;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.sina.weibo.SinaWeibo;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.beans.users.BaseUser;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.ImageLoadListener;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.DeleteAvatarRequest;
import com.iyouxun.net.request.DeletePhotoRequest;
import com.iyouxun.net.request.GetPhotoListRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.open.J_ShareParams;
import com.iyouxun.ui.activity.BaseActivity;
import com.iyouxun.ui.dialog.PhotoManageDialog;
import com.iyouxun.ui.dialog.ReportDialog;
import com.iyouxun.ui.dialog.SharePopDialog;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.OpenPlatformUtil;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 图片浏览
 * 
 * @author likai
 * @date 2015-2-28 下午2:24:46
 * 
 */
public class ProfilePhotoViewActivity extends BaseActivity {
	private RelativeLayout show_photo_titleBox;
	private LinearLayout show_photo_bottomBox;
	private Button show_photo_titleLeftButton;
	private ImageButton show_photo_titleRightButton;
	private TextView show_photo_titleCenter;
	private ImageButton show_photo_likebtn;
	private ViewPager viewPager;
	private PhotoPagerAdapter adapter;
	private LinearLayout show_photo_userbox;
	private TextView show_photo_likenum;
	private RelativeLayout show_photo_user_box;

	/** 传递来要访问浏览的图片信息 */
	private ArrayList<PhotoInfoBean> photoInfo = new ArrayList<PhotoInfoBean>();
	/** 开始的序列位置 */
	private int currentIndex = 0;
	/** 查看相册用户的uid(如果photoInfo为空，则使用该uid获取相册信息) */
	private long currentUid = 0;
	/** 查看图片类型1:加载图片data列表，2：相册图片|加载uid用户的图片列表（网络），需要附带uid，3：查看头像, **/
	private int viewType = 0;
	/** 每页加载图片数量 */
	private static int PAGE_NUM = 32;
	/** 用来分页的pid */
	private String PAGE_PID = "0";
	/** 是否最后一页了 */
	private boolean isLast = false;
	/** 是否正在加载中 */
	private boolean isLoading = false;
	/** 当前页面可显示图片的总数 */
	private int totalPhotos = 1;

	@SuppressWarnings("unchecked")
	@Override
	protected void onCreate(Bundle arg0) {
		super.onCreate(arg0);
		setContentView(R.layout.activity_profile_photo_view);

		// 参数获取---------
		currentIndex = getIntent().getIntExtra("index", 0);
		if (getIntent().hasExtra("photoInfo")) {
			photoInfo = (ArrayList<PhotoInfoBean>) getIntent().getSerializableExtra("photoInfo");
		}
		if (getIntent().hasExtra("viewType")) {
			viewType = getIntent().getIntExtra("viewType", 0);
		}
		currentUid = getIntent().getLongExtra("uid", 0);
		// 页面组建初始化-------------
		show_photo_titleBox = (RelativeLayout) findViewById(R.id.show_photo_titleBox);
		show_photo_bottomBox = (LinearLayout) findViewById(R.id.show_photo_bottomBox);
		show_photo_titleLeftButton = (Button) findViewById(R.id.show_photo_titleLeftButton);
		show_photo_titleRightButton = (ImageButton) findViewById(R.id.show_photo_titleRightButton);
		show_photo_titleCenter = (TextView) findViewById(R.id.show_photo_titleCenter);
		show_photo_likebtn = (ImageButton) findViewById(R.id.show_photo_likebtn);
		viewPager = (ViewPager) findViewById(R.id.show_photo_viewPager);
		show_photo_userbox = (LinearLayout) findViewById(R.id.show_photo_userbox);
		show_photo_likenum = (TextView) findViewById(R.id.show_photo_likenum);
		show_photo_user_box = (RelativeLayout) findViewById(R.id.show_photo_user_box);

		// 点击事件
		show_photo_titleLeftButton.setOnClickListener(listener);
		show_photo_titleRightButton.setOnClickListener(listener);
		show_photo_likebtn.setOnClickListener(listener);

		// 数据初始化------------
		// viewpager的adapter
		adapter = new PhotoPagerAdapter();
		adapter.setDatas(photoInfo);
		viewPager.setAdapter(adapter);
		// 设置pager变化监听方法
		viewPager.setOnPageChangeListener(new MyPagerChange());

		// 根据类型，做特殊处理------------
		if (currentUid > 0) {
			viewType = 2;
			if (currentUid == J_Cache.sLoginUser.uid) {
				// 登录用户的图片总数量
				totalPhotos = J_Cache.sLoginUser.photoCount;
			} else {
				// 其他普通用户的图片总数量
				totalPhotos = SharedPreUtil.getNormalUser(currentUid).photoCount;
			}

			if (photoInfo.size() > 0 && photoInfo.size() - currentIndex <= 2) {
				// 计算出最后一张图片，然后再向后获取
				PAGE_PID = photoInfo.get(photoInfo.size() - 1).pid;
			}
			// 当前焦点图片的位置
			viewPager.setCurrentItem(currentIndex, false);
			// 加载uid的网络图片
			getUserAlbumPhotoInfo();
		} else if (photoInfo.size() > 0) {
			// 加载data数据
			totalPhotos = photoInfo.size();
			// 当前焦点图片的位置
			viewPager.setCurrentItem(currentIndex, false);
		} else {
			ToastUtil.showToast(mContext, "图片加载异常...");
		}

		if (photoInfo.size() > 0) {
			getPhotoPraiseList();
		}
	}

	/**
	 * 获取照片被赞人的列表
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getPhotoPraiseList() {
		if (!Util.isBlankString(photoInfo.get(viewPager.getCurrentItem()).pid)
				&& photoInfo.get(viewPager.getCurrentItem()).likeUsers.size() <= 0 && viewType == 2) {
			UtilRequest.getPhotoPraiseList(photoInfo.get(viewPager.getCurrentItem()).uid,
					photoInfo.get(viewPager.getCurrentItem()).pid, 0, 10, mContext, mHandler);
		} else if (!Util.isBlankString(photoInfo.get(viewPager.getCurrentItem()).pid) && viewType == 2) {
			show_photo_bottomBox.setVisibility(View.VISIBLE);
		}
	}

	@Override
	protected void onResume() {
		super.onResume();
		dismissLoading();
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_GET_PHOTO_PRAISE_LIST:
				// 获取赞用户列表
				J_Response response = (J_Response) msg.obj;
				if (response.retcode == 1) {
					// 获取成功
					try {
						JSONObject praiseObj = new JSONObject(response.data);
						String pid = praiseObj.optString("pid");
						int count = praiseObj.optInt("count");
						int is_praise = praiseObj.optInt("is_praise");// 是否赞过该图片
						String list = praiseObj.optString("list");
						ArrayList<BaseUser> likeUses = new ArrayList<BaseUser>();
						if (!Util.isBlankString(list) && !list.equals("[]")) {
							JSONObject userObj = praiseObj.optJSONObject("list");

							Iterator it = userObj.keys();
							while (it.hasNext()) {
								String uid = (String) it.next();
								JSONObject userinfoObj = userObj.optJSONObject(uid);
								JSONObject avatarObj = userinfoObj.optJSONObject("avatars");

								BaseUser pUser = new BaseUser();
								pUser.uid = Util.getLong(uid);
								pUser.avatarUrl = avatarObj.optString("100");
								likeUses.add(pUser);
							}
						}

						for (int i = 0; i < photoInfo.size(); i++) {
							PhotoInfoBean currBean = photoInfo.get(i);
							if (currBean.pid.equals(pid)) {
								currBean.likeNum = count;
								currBean.likeUsers = likeUses;
								currBean.isLike = is_praise;
								photoInfo.set(i, currBean);
								if (photoInfo.get(viewPager.getCurrentItem()).pid.equals(pid)) {
									photoInfo.get(viewPager.getCurrentItem()).likeNum = count;
									photoInfo.get(viewPager.getCurrentItem()).likeUsers = likeUses;
								}
							}
						}

						// 读取相册图片的时候，才可以赞
						show_photo_bottomBox.setVisibility(View.VISIBLE);

						setTitleInfo();
					} catch (Exception e) {
						e.printStackTrace();
					}

				}
				break;
			case 0x10001:
				String result = msg.obj.toString();
				ToastUtil.showToast(mContext, result);
				dismissLoading();
				break;
			case 0x404:
				// 没有sd卡
				ToastUtil.showToast(mContext, "保存失败：没有SD卡");
				break;
			case 0x405:
				// 存储空间不足
				ToastUtil.showToast(mContext, "保存失败：SD卡空间不足");
				break;
			case 0x102:
				// 保存成功
				ToastUtil.showCenterToast("保存成功", true);
				break;
			case 0x103:
				// 保存失败
				ToastUtil.showToast(mContext, "保存失败");
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 检查当前图片中的赞用户中是否存在该user用户
	 * 
	 * @return boolean 返回类型
	 * @param @param user
	 * @param @param index
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	private boolean isCurrentPhotoHaveUser(BaseUser user, int index) {
		boolean isHave = false;

		for (int i = 0; i < photoInfo.get(index).likeUsers.size(); i++) {
			if (photoInfo.get(index).likeUsers.get(i).uid == user.uid) {
				isHave = true;
			}
		}

		return isHave;
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.show_photo_likebtn:
				// 赞
				if (photoInfo.get(viewPager.getCurrentItem()).isLike == 0) {
					// 还未赞
					photoInfo.get(viewPager.getCurrentItem()).isLike = 1;
					// 设置图标
					show_photo_likebtn.setImageResource(R.drawable.icon_like_pressed);
					// 添加用户
					BaseUser user = new BaseUser();
					user.uid = J_Cache.sLoginUser.uid;
					user.nickName = J_Cache.sLoginUser.nickName;
					user.avatarUrl = J_Cache.sLoginUser.avatarUrl;
					if (!isCurrentPhotoHaveUser(user, viewPager.getCurrentItem())) {
						photoInfo.get(viewPager.getCurrentItem()).likeNum += 1;
						photoInfo.get(viewPager.getCurrentItem()).likeUsers.add(user);
					}
					// 发送请求-赞
					UtilRequest.praisePhoto(photoInfo.get(viewPager.getCurrentItem()).uid,
							photoInfo.get(viewPager.getCurrentItem()).pid, mContext, mHandler);
				} else {
					// 已赞
					photoInfo.get(viewPager.getCurrentItem()).isLike = 0;
					// 设置图标
					show_photo_likebtn.setImageResource(R.drawable.icon_like);
					// 移除
					for (int i = 0; i < photoInfo.get(viewPager.getCurrentItem()).likeUsers.size(); i++) {
						if (photoInfo.get(viewPager.getCurrentItem()).likeUsers.get(i).uid == J_Cache.sLoginUser.uid) {
							photoInfo.get(viewPager.getCurrentItem()).likeNum -= 1;
							photoInfo.get(viewPager.getCurrentItem()).likeUsers.remove(i);
						}
					}
					// 发送请求-取消赞
					UtilRequest.praisePhotoCancle(photoInfo.get(viewPager.getCurrentItem()).uid,
							photoInfo.get(viewPager.getCurrentItem()).pid, mContext, mHandler);
				}
				setTitleInfo();
				break;
			case R.id.show_photo_titleLeftButton:
				// 点击左侧按钮
				finish();
				break;
			case R.id.show_photo_titleRightButton:
				// 点击右侧菜单
				new PhotoManageDialog(mContext, R.style.dialog).setPhotoData(photoInfo.get(viewPager.getCurrentItem()))
						.setCallBack(new OnSelectCallBack() {
							@Override
							public void onCallBack(String value1, String value2, String value3) {
								if (value1.equals("1")) {
									// 分享
									J_ShareParams params = OpenPlatformUtil.getSharePhotoParams(photoInfo.get(viewPager
											.getCurrentItem()));
									new SharePopDialog(ProfilePhotoViewActivity.this, R.style.dialog)
											.setCallBack(new PlatformActionListener() {
												@Override
												public void onError(Platform arg0, int arg1, Throwable arg2) {
													mHandler.sendMessage(mHandler.obtainMessage(0x10001, "分享失败！"));
												}

												@Override
												public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
													if (!arg0.getName().equals(SinaWeibo.NAME)) {
														mHandler.sendMessage(mHandler.obtainMessage(0x10001, "分享成功！"));
													}
												}

												@Override
												public void onCancel(Platform arg0, int arg1) {
													mHandler.sendMessage(mHandler.obtainMessage(0x10001, "取消分享！"));
												}
											}).setParams(params).show();
								} else if (value1.equals("2")) {
									// 保存图片
									Util.saveImageToLocal(mContext, photoInfo.get(viewPager.getCurrentItem()), mHandler);
								} else if (value1.equals("3")) {
									// 举报图片
									new ReportDialog(mContext, R.style.dialog).setReportType(1)
											.setReportPid(photoInfo.get(viewPager.getCurrentItem()).pid)
											.setReportUid(photoInfo.get(viewPager.getCurrentItem()).uid + "").show();
								} else if (value1.equals("4")) {
									// 删除图片
									if (photoInfo.get(viewPager.getCurrentItem()).type == 2) {
										// 删除头像
										deleteAvatar(photoInfo.get(viewPager.getCurrentItem()));
									} else {
										// 删除照片
										deletePhoto(photoInfo.get(viewPager.getCurrentItem()));
									}
								}
							}
						}).show();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * TODO 刷新用户列表
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void refreshLikeUser() {
		if (photoInfo.get(viewPager.getCurrentItem()).likeUsers.size() > 0) {
			// 有赞的用户
			show_photo_user_box.setVisibility(View.VISIBLE);
			show_photo_likebtn.setBackgroundResource(R.drawable.bg_like_have);
			show_photo_userbox.removeAllViews();
			for (int i = 0; i < photoInfo.get(viewPager.getCurrentItem()).likeUsers.size(); i++) {
				final BaseUser bean = photoInfo.get(viewPager.getCurrentItem()).likeUsers.get(i);
				View userView = View.inflate(mContext, R.layout.item_photo_like_user, null);
				ImageView item_likeuser_avatar = (ImageView) userView.findViewById(R.id.item_likeuser_avatar);
				J_NetManager.getInstance().loadIMG(null, bean.avatarUrl, item_likeuser_avatar, R.drawable.icon_avatar,
						R.drawable.icon_avatar);
				show_photo_userbox.addView(userView);
				item_likeuser_avatar.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
						profileIntent.putExtra("uid", bean.uid);
						startActivity(profileIntent);
					}
				});
			}
		} else {
			// 没有赞的用户
			show_photo_user_box.setVisibility(View.GONE);
			show_photo_likebtn.setBackgroundResource(R.drawable.bg_like_no);
		}
		if (photoInfo.get(viewPager.getCurrentItem()).isLike == 0) {
			// 未赞过
			show_photo_likebtn.setImageResource(R.drawable.icon_like);
		} else {
			// 已赞过
			show_photo_likebtn.setImageResource(R.drawable.icon_like_pressed);
		}
	}

	/**
	 * 展示、隐藏操作菜单
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void toggleMenu() {
		if (show_photo_titleBox.getVisibility() == View.VISIBLE) {
			show_photo_titleBox.setVisibility(View.GONE);
			if (viewType == 2) {
				show_photo_bottomBox.setVisibility(View.GONE);
			}
		} else {
			show_photo_titleBox.setVisibility(View.VISIBLE);
			if (viewType == 2) {
				show_photo_bottomBox.setVisibility(View.VISIBLE);
			}
		}
	}

	/**
	 * 通过uid，获取该用户的相册列表
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getUserAlbumPhotoInfo() {
		if (isLast || isLoading) {// 已经到达最后一页，不能再加载了
			return;
		}

		isLoading = true;

		new GetPhotoListRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				isLoading = false;
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					// 加载成功
					try {
						JSONArray allPhotos = new JSONArray(response.data);
						if (allPhotos.length() > 0) {
							for (int i = 0; i < allPhotos.length(); i++) {
								JSONObject json = allPhotos.getJSONObject(i);
								PhotoInfoBean bean = new PhotoInfoBean();
								bean.pid = json.optString("pid");
								bean.url_small = json.optString("pic100");
								bean.url = json.optString("pic800");
								bean.uid = json.optLong("uid");
								bean.nick = json.optString("nick");
								if (!isPicHave(bean.pid)) {
									photoInfo.add(bean);
								}
							}
							if (photoInfo.size() > 0) {
								PAGE_PID = photoInfo.get(photoInfo.size() - 1).pid;
							}
							// 刷新页面
							adapter.setDatas(photoInfo);
							adapter.notifyDataSetChanged();
						} else {
							isLast = true;
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
			}
		}).execute(currentUid, PAGE_PID, PAGE_NUM);
	}

	/**
	 * 检查当前页面是否已经存在该图片
	 * 
	 * @Title: isPicHave
	 * @return boolean 返回类型
	 * @param @param pid
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	private boolean isPicHave(String pid) {
		boolean isHave = false;
		for (int i = 0; i < photoInfo.size(); i++) {
			PhotoInfoBean bean = photoInfo.get(i);
			if (!Util.isBlankString(pid) && bean.pid.equals(pid)) {
				isHave = true;
			}
		}
		return isHave;
	}

	/**
	 * TODO 加载图片信息
	 * 
	 * @return View 返回类型
	 * @param @param arg1
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public View handlerPhotos(int arg1) {
		View showImage = View.inflate(mContext, R.layout.show_photo_view, null);
		// 图片
		PhotoView imageView = (PhotoView) showImage.findViewById(R.id.show_photo_image);
		ProgressBar show_photo_loading = (ProgressBar) showImage.findViewById(R.id.show_photo_loading);
		// 图片点击
		imageView.setOnPhotoTapListener(new OnPhotoTapListener() {
			@Override
			public void onPhotoTap(View arg0, float arg1, float arg2) {
				toggleMenu();
			}
		});
		// 加载图片
		displayImage(arg1, imageView, show_photo_loading);
		return showImage;
	}

	/**
	 * @Title: displayImage
	 * @Description: 显示URL的图片
	 * @param @param index
	 * @return void
	 * @throws
	 * @date 2014-3-18
	 */
	private void displayImage(final int index, ImageView imageView, final ProgressBar loadingImg) {
		if (photoInfo != null && photoInfo.size() > index) {
			// 图片信息
			loadingImg.setVisibility(View.VISIBLE);
			final PhotoInfoBean bean = photoInfo.get(index);
			if (!Util.isBlankString(bean.url)) {
				// 网络加载图片
				J_NetManager.getInstance().loadIMG(null, bean.url, imageView, new ImageLoadListener() {
					@Override
					public void onLoadFinish() {
						loadingImg.setVisibility(View.GONE);
					}
				}, 0, R.drawable.pic_default_square);
			} else if (!Util.isBlankString(bean.picPath)) {
				// 加载本地图片
				Bitmap bm = BitmapFactory.decodeFile(bean.picPath);
				imageView.setImageBitmap(bm);
				loadingImg.setVisibility(View.GONE);
			} else {
				loadingImg.setVisibility(View.GONE);
				imageView.setImageResource(R.drawable.pic_default_square);
			}
		}
	}

	/**
	 * 删除图片
	 * 
	 * @Title: deletePhoto
	 * @return void 返回类型
	 * @param @param pid 参数类型
	 * @author likai
	 * @throws
	 */
	private void deletePhoto(final PhotoInfoBean bean) {
		new DeletePhotoRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					ToastUtil.showToast(mContext, "删除成功");

					// 刷新相册列表页的列表
					if (J_Cache.pageListener.size() > 0 && J_Cache.pageListener.containsKey("profile_album_activity")) {
						ProfileAlbumActivity activity = (ProfileAlbumActivity) J_Cache.pageListener.get("profile_album_activity");
						activity.delForRefreshList(bean.pid);
					}

					// 删除图片
					for (int i = 0; i < photoInfo.size(); i++) {
						PhotoInfoBean pBean = photoInfo.get(i);
						if (pBean.pid.equals(bean.pid)) {
							// 从列表数组中删除该图片
							photoInfo.remove(i);
							// 图片总数-1
							if (totalPhotos > 0) {
								totalPhotos -= 1;
							}
							if (J_Cache.sLoginUser.photoCount > 0) {
								J_Cache.sLoginUser.photoCount -= 1;
							}
							// 刷新标题信息
							setTitleInfo();
						}
					}
					adapter.setDatas(photoInfo);
					adapter.notifyDataSetChanged();
					if (photoInfo.size() <= 0) {
						finish();
					}
				} else {
					ToastUtil.showToast(mContext, "删除失败");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
			}
		}).execute(bean.pid);
	}

	/**
	 * 删除头像
	 * 
	 * @Title: deleteAvatar
	 * @return void 返回类型
	 * @param @param bean 参数类型
	 * @author likai
	 * @throws
	 */
	private void deleteAvatar(final PhotoInfoBean bean) {
		if (!Util.isBlankString(bean.pid)) {
			new DeleteAvatarRequest(new OnDataBack() {
				@Override
				public void onResponse(Object result) {
					J_Response response = (J_Response) result;
					if (response.retcode == 1) {
						ToastUtil.showToast(mContext, "头像删除成功");
						finish();
					}
				}

				@Override
				public void onError(HashMap<String, Object> errMap) {
				}
			}).execute(bean.pid);
		}
	}

	/**
	 * @ClassName: PhotoPagerAdapter
	 * @Description: photoPager adapter
	 * @author donglizhi
	 * @date 2014-1-24
	 */
	private class PhotoPagerAdapter extends PagerAdapter {
		private ArrayList<PhotoInfoBean> datas = new ArrayList<PhotoInfoBean>();

		public void setDatas(ArrayList<PhotoInfoBean> datas) {
			this.datas = datas;
		}

		// 显示数目
		@Override
		public int getCount() {
			return datas.size();
		}

		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			return arg0 == arg1;
		}

		@Override
		public int getItemPosition(Object object) {
			return POSITION_NONE;
		}

		@Override
		public void destroyItem(View arg0, int arg1, Object arg2) {
			View view = (View) arg2;
			((ViewPager) arg0).removeView(view);
			view = null;
		}

		/***
		 * 获取每一个item类于listview中的getview
		 */
		@Override
		public Object instantiateItem(View arg0, int arg1) {
			// 创建view，并加载
			View view = handlerPhotos(arg1);
			((ViewPager) arg0).addView(view);
			return view;
		}
	}

	private class MyPagerChange implements OnPageChangeListener {
		private int currentArrayIndex = 0;

		@Override
		public void onPageScrollStateChanged(int arg0) {
			// 此方法是在状态改变的时候调用，其中arg0这个参数有三种状态（0，1，2）。
			// arg0 ==1的时辰默示正在滑动，arg0==2的时辰默示滑动完毕了，arg0==0的时辰默示什么都没做
			if (arg0 == 2) {
				// 滑动完成后调用
				if (photoInfo.size() > 0) {
					// 设置当前停留的index
					currentIndex = currentArrayIndex;
					// 在小于3项的时候加载下一页
					if (viewType == 2 && photoInfo.size() - currentArrayIndex <= 2) {
						getUserAlbumPhotoInfo();
					}

					// 获取赞列表人
					show_photo_bottomBox.setVisibility(View.GONE);
					getPhotoPraiseList();
				}
			}
		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {
			// arg0 :当前页面，及你点击滑动的页面
			// arg1:当前页面偏移的百分比
			// arg2:当前页面偏移的像素位置
			// 当前数组中显示的图片的序列
			currentArrayIndex = arg0;
			// 刷新标题
			setTitleInfo();
		}

		@Override
		public void onPageSelected(int arg0) {
			// arg0,代表哪个页面被选中
			// 刷新标题
			setTitleInfo();
		}
	}

	/**
	 * 刷新标题内容
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setTitleInfo() {
		// 显示标题数字
		int showIndex = viewPager.getCurrentItem() + 1;
		showIndex = showIndex > totalPhotos ? totalPhotos : showIndex;
		String str = photoInfo.size() > 1 ? showIndex + " / " + totalPhotos : "1/1";
		show_photo_titleCenter.setText(str);

		// 设置当前图片赞的数量
		show_photo_likenum.setText(photoInfo.get(viewPager.getCurrentItem()).likeNum + "人已赞");

		// 刷新图片信息
		refreshLikeUser();
	}
}
