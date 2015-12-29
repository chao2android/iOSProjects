package com.iyouxun.ui.dialog;

import java.util.HashMap;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;

import com.iyouxun.R;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.ReportPicRequest;
import com.iyouxun.net.request.ReportProfileRequest;
import com.iyouxun.ui.adapter.ReportListAdapter;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 举报弹层
 * 
 * @ClassName: ReportDialog
 * @author likai
 * @date 2015-3-10 下午4:15:09
 * 
 */
public class ReportDialog extends Dialog {
	private final Context mContext;
	// 回调方法
	private DialogUtils.OnSelectCallBack callBack;
	/** 类型：1:图片，2：个人资料 */
	private int reportType = 1;

	// 举报信息
	private String reportUid;// 用户uid
	private String reportPid;// 图片pid

	private ListView dialogReportLv;
	private Button dialogReportCancel;

	public ReportDialog(Context context, int theme) {
		super(context, theme);
		mContext = context;
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
	public ReportDialog setCallBack(DialogUtils.OnSelectCallBack callBack) {
		this.callBack = callBack;
		return this;
	}

	/**
	 * type 举报类型：1:图片，2：个人资料
	 * 
	 */
	public ReportDialog setReportType(int type) {
		this.reportType = type;
		return this;
	}

	public ReportDialog setReportUid(String reportUid) {
		this.reportUid = reportUid;
		return this;
	}

	public ReportDialog setReportPid(String reportPid) {
		this.reportPid = reportPid;
		return this;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dialog_report_layout);

		// 设置显示位置
		Window window = getWindow();
		WindowManager.LayoutParams windowParams = window.getAttributes();
		windowParams.width = Util.getScreenWidth(mContext);
		windowParams.height = WindowManager.LayoutParams.WRAP_CONTENT;
		window.setAttributes(windowParams);
		window.setGravity(Gravity.BOTTOM);
		window.setWindowAnimations(R.style.AnimBottom); // 设置窗口弹出动画

		// 点击外部区域不能关闭
		// setCanceledOnTouchOutside(false);

		dialogReportLv = (ListView) findViewById(R.id.dialogReportLv);
		dialogReportCancel = (Button) findViewById(R.id.dialogReportCancel);

		// 列表数据
		String[] reportData = mContext.getResources().getStringArray(R.array.report_pic);
		if (reportType == 2) {
			reportData = mContext.getResources().getStringArray(R.array.report_profile);
		}

		ReportListAdapter adapter = new ReportListAdapter(mContext);
		adapter.setData(reportData);
		dialogReportLv.setAdapter(adapter);
		dialogReportLv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				doReport(position);
			}
		});

		// 取消按钮的监听
		dialogReportCancel.setOnClickListener(listener);
	}

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.dialogReportCancel:
				// 取消
				dismiss();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 执行举报请求操作
	 * 
	 * @Title: doReport
	 * @return void 返回类型
	 * @param @param position 参数类型
	 * @author likai
	 * @throws
	 */
	private void doReport(int position) {
		if (reportType == 1) {
			// 举报图片
			new ReportPicRequest(new OnDataBack() {
				@Override
				public void onResponse(Object result) {
					J_Response response = (J_Response) result;
					if (response.retcode == 1) {
						// 举报成功
						ToastUtil.showToast(mContext, "提交成功，感谢您的反馈");
					} else {
						// 举报失败
						ToastUtil.showToast(mContext, "举报失败");
					}
					dismiss();
				}

				@Override
				public void onError(HashMap<String, Object> errMap) {
					// 举报失败
					ToastUtil.showToast(mContext, "举报失败");
				}
			}).execute(reportUid, reportPid, position);
		} else if (reportType == 2) {
			// 举报用户
			new ReportProfileRequest(new OnDataBack() {

				@Override
				public void onResponse(Object result) {
					J_Response response = (J_Response) result;
					if (response.retcode == 1) {
						// 举报成功
						ToastUtil.showToast(mContext, "提交成功，感谢您的反馈。");
					} else {
						// 举报失败
						ToastUtil.showToast(mContext, "举报失败");
					}
					dismiss();
				}

				@Override
				public void onError(HashMap<String, Object> errMap) {
					int Error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
					// 举报失败
					ToastUtil.showToast(mContext, "举报失败");
				}
			}).execute(reportUid, position);
		} else {
			dismiss();
		}
	}
}
