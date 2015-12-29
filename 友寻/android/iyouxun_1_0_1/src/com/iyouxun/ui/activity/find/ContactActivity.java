package com.iyouxun.ui.activity.find;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.comparator.FriendsPinyinComparator;
import com.iyouxun.data.beans.ManageFriendsBean;
import com.iyouxun.data.parser.CharacterParser;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.SortAdapter;
import com.iyouxun.ui.views.ClearEditText;
import com.iyouxun.ui.views.SideBar;
import com.iyouxun.ui.views.SideBar.OnTouchingLetterChangedListener;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: ContactActivity
 * @Description: 手机联系人页面
 * @author donglizhi
 * @date 2015年3月9日 下午5:49:52
 * 
 */
public class ContactActivity extends CommTitleActivity {
	private ListView sortListView;
	private SideBar sideBar;// 右边索引
	private SortAdapter adapter;
	private ClearEditText mClearEditText;// 带删除按钮的edittext
	private final List<ManageFriendsBean> sourceDateList = new ArrayList<ManageFriendsBean>();// 用户联系人数据
	private final List<ManageFriendsBean> selectedList = new ArrayList<ManageFriendsBean>();// 用户联系人数据
	/** 汉字转换成拼音的类 */
	private CharacterParser characterParser;
	private FriendsPinyinComparator pinyinComparator;// 排序
	private Button btnInvite;// 邀请按钮
	private TextView selectedName;// 选中的人
	private TextView btnSelectAll;// 全选按钮
	private boolean allSelectedStatus;// 全选状态
	private TextView btnCancel;// 取消按钮
	private RelativeLayout titleBox;// 标题栏

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.str_contact);
		titleLeftButton.setText(R.string.str_add_friends);
		titleRightButton.setText(R.string.str_add_friends);
		titleLeftButton.setOnClickListener(listener);
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_contact, null);
	}

	@Override
	protected void initViews() {
		mContext = ContactActivity.this;
		// 实例化汉字转拼音类
		characterParser = CharacterParser.getInstance();
		pinyinComparator = new FriendsPinyinComparator();
		sideBar = (SideBar) findViewById(R.id.contact_sidrbar);
		btnInvite = (Button) findViewById(R.id.contact_btn_invite);
		selectedName = (TextView) findViewById(R.id.contact_item_text);
		sortListView = (ListView) findViewById(R.id.contact_contacts);
		mClearEditText = (ClearEditText) findViewById(R.id.contact_filter_edit);
		btnSelectAll = (TextView) findViewById(R.id.contact_btn_select_all);
		btnCancel = (TextView) findViewById(R.id.contact_btn_cancel);
		titleBox = (RelativeLayout) findViewById(R.id.titleBox);
		allSelectedStatus = false;
		btnCancel.setOnClickListener(listener);
		btnInvite.setOnClickListener(listener);
		btnSelectAll.setOnClickListener(listener);
		adapter = new SortAdapter(mContext, sourceDateList);
		sortListView.setAdapter(adapter);
		String friendsData = getIntent().getStringExtra(JsonParser.RESPONSE_DATA);
		parserFriendsData(friendsData);
		sortListView.setOnItemClickListener(onItemClickListener);
		// 根据输入框输入值的改变来过滤搜索
		mClearEditText.addTextChangedListener(textWatcher);
		mClearEditText.setOnFocusChangeListener(new OnFocusChangeListener() {

			@Override
			public void onFocusChange(View v, boolean hasFocus) {
				if (hasFocus) {// 获得焦点显示取消按钮上滑，隐藏全选按钮
					btnCancel.setVisibility(View.VISIBLE);
					titleBox.setVisibility(View.GONE);
					btnSelectAll.setVisibility(View.GONE);
				} else {
					btnCancel.setVisibility(View.GONE);
					titleBox.setVisibility(View.VISIBLE);
					btnSelectAll.setVisibility(View.VISIBLE);
				}
			}
		});
		// 设置右侧触摸监听
		sideBar.setOnTouchingLetterChangedListener(new OnTouchingLetterChangedListener() {

			@Override
			public void onTouchingLetterChanged(String s) {
				// 该字母首次出现的位置
				int position = adapter.getPositionForSection(s.charAt(0));
				if (position != -1) {
					sortListView.setSelection(position);
				}

			}
		});
	}

	private final TextWatcher textWatcher = new TextWatcher() {

		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
			// 当输入框里面的值为空，更新为原来的列表，否则为过滤数据列表
			filterData(s.toString());
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}

		@Override
		public void afterTextChanged(Editable s) {
		}
	};

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			ManageFriendsBean bean = (ManageFriendsBean) adapter.getItem(position);
			int selectPostion = -1;
			for (int i = 0; i < sourceDateList.size(); i++) {
				if (bean.getMobile().equals(sourceDateList.get(i).getMobile())) {
					selectPostion = i;
					if (sourceDateList.get(i).isChecked()) {
						sourceDateList.get(i).setChecked(false);
					} else {
						sourceDateList.get(i).setChecked(true);
					}
					break;
				}
			}
			if (selectPostion < 0) {
				return;
			}
			boolean has = false;// 是否选中了
			for (int i = 0; i < selectedList.size(); i++) {
				if (selectedList.get(i).getMobile().equals(sourceDateList.get(selectPostion).getMobile())) {
					has = true;
					if (!sourceDateList.get(selectPostion).isChecked()) {// 移除未选中的
						selectedList.remove(i);
					}
					break;
				}
			}
			if (!has) {
				selectedList.add(sourceDateList.get(selectPostion));
			}
			StringBuilder sb = new StringBuilder();
			int selectCount = 0;
			for (int i = 0; i < selectedList.size(); i++) {// 拼串显示选中的人名
				if (selectedList.get(i).isChecked()) {
					sb.append(selectedList.get(i).getName());
					sb.append("、");
					selectCount++;
				}
			}
			if (selectCount > 0) {
				selectedName.setText(sb.substring(0, sb.length() - 1));
				btnInvite.setText("邀请 （" + selectCount + "）");
			} else {
				selectedName.setText("");
				btnInvite.setText("邀请");
			}
			if (selectCount == sourceDateList.size()) {
				allSelectedStatus = true;
				btnSelectAll.setText("取消全选");
			} else {
				allSelectedStatus = false;
				btnSelectAll.setText("全选");
			}
			adapter.notifyDataSetChanged();
		}
	};

	/**
	 * 根据输入框中的值来过滤数据并更新ListView
	 * 
	 * @param filterStr
	 */
	private void filterData(String filterStr) {
		List<ManageFriendsBean> filterDateList = new ArrayList<ManageFriendsBean>();

		if (TextUtils.isEmpty(filterStr)) {
			filterDateList = sourceDateList;
		} else {
			filterDateList.clear();
			for (ManageFriendsBean contact : sourceDateList) {
				String name = contact.getName();
				String key = contact.getSortLetter();
				if (name.indexOf(filterStr.toString()) != -1 || key.startsWith(filterStr.toString())
						|| key.toLowerCase().startsWith(filterStr.toString())) {
					filterDateList.add(contact);
				} else if (contact.getMobile().indexOf(filterStr) != -1) {
					filterDateList.add(contact);
				}
			}
		}
		// 根据a-z进行排序
		Collections.sort(filterDateList, pinyinComparator);
		adapter.updateListView(filterDateList);
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.contact_btn_cancel:// 取消按钮
				clearEditTextClearFocus();
				break;
			case R.id.contact_btn_select_all:// 全选按钮
				if (allSelectedStatus) {
					allSelectedStatus = false;
					btnSelectAll.setText("全选");
					selectedList.clear();
				} else {
					btnSelectAll.setText("取消全选");
					allSelectedStatus = true;
					selectedList.clear();
					selectedList.addAll(sourceDateList);
				}
				StringBuilder sb = new StringBuilder();

				for (int i = 0; i < sourceDateList.size(); i++) {
					sourceDateList.get(i).setChecked(allSelectedStatus);
					if (sourceDateList.get(i).isChecked()) {
						sb.append(sourceDateList.get(i).getName());
						sb.append("、");
					}
				}
				if (sb.length() > 0) {
					selectedName.setText(sb.substring(0, sb.length() - 1));
					btnInvite.setText("邀请 （" + sourceDateList.size() + "）");
				} else {
					btnInvite.setText("邀请");
					selectedName.setText("");
				}
				adapter.updateListView(sourceDateList);
				break;
			case R.id.titleLeftButton:// 头部左侧按钮
				finish();
				break;
			case R.id.contact_btn_invite:// 邀请按钮
				String toNumbers = "";
				for (ManageFriendsBean contact : sourceDateList) {
					if (contact.isChecked()) {
						toNumbers = toNumbers + contact.getMobile() + ";";
					}
				}
				if (toNumbers.length() <= 0) {
					ToastUtil.showToast(mContext, getString(R.string.you_must_select_one_friend));
				} else {
					toNumbers = toNumbers.substring(0, toNumbers.length() - 1);
					Util.sendSMS(toNumbers, mContext);
				}
				break;
			default:
				break;
			}
		}
	};

	private void parserFriendsData(String friendsData) {
		try {
			JSONArray dataArray = new JSONArray(friendsData);
			for (int i = 0; i < dataArray.length(); i++) {
				JSONObject valueObject = dataArray.getJSONObject(i);
				ManageFriendsBean bean = new ManageFriendsBean();
				String mobile = JsonUtil.getJsonString(valueObject, UtilRequest.FORM_MOBILE);
				String nick = JsonUtil.getJsonString(valueObject, UtilRequest.FORM_TRUENAME);
				bean.setMobile(mobile);
				bean.setName(nick);
				bean.setChecked(false);
				if (Util.isBlankString(nick)) {
					bean.setSortLetter("#");
				} else {
					String pinyin = characterParser.getSelling(nick);
					String sortString = pinyin.substring(0, 1).toUpperCase();

					// 正则表达式，判断首字母是否是英文字母
					if (sortString.matches("[A-Z]")) {
						bean.setSortLetter(sortString.toUpperCase());
					} else {
						bean.setSortLetter("#");
					}
				}
				sourceDateList.add(bean);
			}
			// 根据a-z进行排序源数据
			Collections.sort(sourceDateList, pinyinComparator);
			adapter.updateListView(sourceDateList);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK && titleBox.getVisibility() == View.GONE) {
			clearEditTextClearFocus();
			return true;
		} else {
			return super.onKeyDown(keyCode, event);
		}
	}

	/**
	 * @Title: clearEditTextClearFocus
	 * @Description: 清楚输入框的焦点
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void clearEditTextClearFocus() {
		Util.hideKeyboard(mContext, mClearEditText);
		mClearEditText.setText("");
		mClearEditText.clearFocus();
	}
}
