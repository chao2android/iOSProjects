package com.iyouxun.ui.dialog;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.ToastUtil;

public class UploadContactsDialog extends Dialog {
	private final Context mContext;
	private DialogUtils.OnSelectCallBack callBack;
	private Button dialogFindContactsButton;
	private TextView dialogFindContactsTitle;
	private TextView dialogFindContactsDescription;
	private boolean auto = true;// 直接上传 false是callback处理上传

	public UploadContactsDialog(Context context, int theme) {
		super(context, theme);
		this.mContext = context;
	}

	/**
	 * 设置回调方法
	 * 
	 * @Title: setCallBack
	 * @return PhotoSelectDialog 返回类型
	 * @param @param callBack
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public UploadContactsDialog setCallBack(DialogUtils.OnSelectCallBack callBack) {
		this.callBack = callBack;
		return this;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dialog_upload_contacts);
		auto = true;
		dialogFindContactsButton = (Button) findViewById(R.id.dialogFindContactsButton);
		dialogFindContactsTitle = (TextView) findViewById(R.id.dialogFindContactsTitle);
		dialogFindContactsDescription = (TextView) findViewById(R.id.dialogFindContactsDescription);

		dialogFindContactsButton.setOnClickListener(listener);

		// 页面关闭
		setOnCancelListener(new OnCancelListener() {
			@Override
			public void onCancel(DialogInterface arg0) {
				callBack.onCallBack("2", null, null);
			}
		});
	}

	/**
	 * @Title: setTitle
	 * @Description: 设置标题内容
	 * @return void 返回类型
	 * @param @param title 显示内容
	 * @author donglizhi
	 * @throws
	 */
	public void setTitle(String title) {
		dialogFindContactsTitle.setText(title);
	}

	/**
	 * @Title: setDesc
	 * @Description: 设置描述内容
	 * @return void 返回类型
	 * @param @param desc 显示内容
	 * @author donglizhi
	 * @throws
	 */
	public void setDesc(String desc) {
		dialogFindContactsDescription.setText(desc);
	}

	/**
	 * @Title: setTitleVisiblity
	 * @Description: 设置标题的可见性
	 * @return void 返回类型
	 * @param @param visiblility 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public void setTitleVisiblity(int visiblility) {
		dialogFindContactsTitle.setVisibility(visiblility);
	}

	/**
	 * @Title: setBtnText
	 * @Description: 设置按钮的显示内容
	 * @return void 返回类型
	 * @param @param text 显示内容
	 * @author donglizhi
	 * @throws
	 */
	public void setBtnText(String text) {
		dialogFindContactsButton.setText(text);
	}

	public void setAutoUpload(boolean auto) {
		this.auto = auto;
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_UPLOAD_USER_CONTACTS:
				// 上传联系人
				DialogUtils.dismissDialog();
				ToastUtil.showToast(mContext, "导入成功");
				// 回调
				callBack.onCallBack("0", null, null);
				dismiss();
				break;
			case 0x404:
				// 没有联系人
				dismiss();
				break;

			default:
				break;
			}
		}
	};

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.dialogFindContactsButton:
				// 导入按钮
				if (auto) {
					DialogUtils.showProgressDialog(mContext, "导入中...");
					UtilRequest.uploadUserContacts(mContext, mHandler);
				} else {
					callBack.onCallBack("1", null, null);
				}
				break;
			default:
				break;
			}
		}
	};
}
