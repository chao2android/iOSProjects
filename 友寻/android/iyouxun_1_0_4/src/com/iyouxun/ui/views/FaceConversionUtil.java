package com.iyouxun.ui.views;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextUtils;
import android.text.style.ImageSpan;

import com.iyouxun.utils.Util;

/**
 * 
 ****************************************** 
 * @文件名称 : FaceConversionUtil.java
 * @文件描述 : 表情轉換工具
 ****************************************** 
 * 
 */
public class FaceConversionUtil {
	/** 每一页表情的个数 */
	protected int pageSize = 24;
	private static FaceConversionUtil mFaceConversionUtil;
	/** 保存于内存中的表情HashMap */
	protected HashMap<String, String> emojiMap = new HashMap<String, String>();
	/** 保存于内存中的表情集合 */
	protected List<ChatEmoji> emojis = new ArrayList<ChatEmoji>();
	/** 表情分页的结果集合 */
	protected List<List<ChatEmoji>> emojiLists = new ArrayList<List<ChatEmoji>>();
	/** 存储所有的保存于内存中的表情HashMap */
	protected HashMap<String, String> emojiMapAll = new HashMap<String, String>();
	/** 存储所有的保存于内存中的表情集合 */
	protected HashMap<String, ChatEmoji> emojisAll = new HashMap<String, ChatEmoji>();
	/** 存储所有的动态表情的thread控制类 */
	protected HashMap<String, GifTextDrawable> cartoonFaceCtrl = new HashMap<String, GifTextDrawable>();

	private FaceConversionUtil() {
	}

	public static FaceConversionUtil getInstace() {
		if (mFaceConversionUtil == null) {
			mFaceConversionUtil = new FaceConversionUtil();
		}
		return mFaceConversionUtil;
	}

	/**
	 * 得到一个SpanableString对象，通过传入的字符串,并进行正则判断
	 * 
	 * @param context
	 * @param str
	 * @return
	 */
	public synchronized SpannableString getExpressionString(Context context, String str, int width, int height) {
		SpannableString spannableString = new SpannableString(str);
		// 正则表达式比配字符串里是否含有表情，如： 我好[开心]啊
		String zhengze = "\\[[^\\]]+\\]";
		// 通过传入的正则表达式来生成一个pattern
		Pattern sinaPatten = Pattern.compile(zhengze, Pattern.CASE_INSENSITIVE);
		try {
			dealExpression(context, spannableString, sinaPatten, 0, width, height);
		} catch (Exception e) {
		}
		return spannableString;
	}

	/**
	 * 得到一个SpanableString对象，通过传入的字符串,并进行正则判断
	 * 
	 * @param context
	 * @param str 要显示的文字内容
	 * @param tv 在动画表情中需要使用到该参数，显示该内容的textview
	 * @param textId 消息的id，只有在动画表情中使用
	 * @return SpannableString
	 */
	public synchronized SpannableString getExpressionStringAll(Context context, String str) {
		if (str == null || Util.isBlankString(str)) {
			str = "";
		}
		SpannableString spannableString = new SpannableString(str);
		// 正则表达式比配字符串里是否含有表情，如： 我好[开心]啊
		String zhengze = "\\[[^\\]]+\\]";
		// 通过传入的正则表达式来生成一个pattern
		Pattern sinaPatten = Pattern.compile(zhengze, Pattern.CASE_INSENSITIVE);
		try {
			getFileTextAll(context);

			dealExpressionAll(context, spannableString, sinaPatten, 0);
		} catch (Exception e) {
		}
		return spannableString;
	}

	/**
	 * 添加表情--输入框中的表情
	 * 
	 * @param context
	 * @param imgId
	 * @param spannableString
	 * @return
	 */
	public synchronized SpannableString addFace(Context context, int imgId, String spannableString, int type) {
		if (TextUtils.isEmpty(spannableString)) {
			return null;
		}
		Bitmap bitmap = BitmapFactory.decodeResource(context.getResources(), imgId);
		int sizetest = Util.px2dip(context, Util.getFaceSize(context, type));
		bitmap = Bitmap.createScaledBitmap(bitmap, sizetest, sizetest, true);
		ImageSpan imageSpan = new ImageSpan(context, bitmap);
		SpannableString spannable = new SpannableString(spannableString);
		spannable.setSpan(imageSpan, 0, spannableString.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
		return spannable;
	}

	/**
	 * 对spanableString进行正则判断，如果符合要求，则以表情图片代替
	 * 
	 * @param context
	 * @param spannableString
	 * @param patten
	 * @param start
	 * @throws Exception
	 */
	private synchronized void dealExpression(Context context, SpannableString spannableString, Pattern patten, int start,
			int width, int height) throws Exception {
		Matcher matcher = patten.matcher(spannableString);
		while (matcher.find()) {
			String key = matcher.group();
			// 返回第一个字符的索引的文本匹配整个正则表达式,ture 则继续递归
			if (matcher.start() < start) {
				continue;
			}
			String value = emojiMap.get(key);
			if (TextUtils.isEmpty(value)) {
				continue;
			}
			int resId = context.getResources().getIdentifier(value, "drawable", context.getPackageName());
			// 通过上面匹配得到的字符串来生成图片资源id
			// Field field=R.drawable.class.getDeclaredField(value);
			// int resId=Integer.parseInt(field.get(null).toString());
			if (resId != 0) {
				Bitmap bitmap = BitmapFactory.decodeResource(context.getResources(), resId);
				bitmap = Bitmap.createScaledBitmap(bitmap, width > 0 ? width : bitmap.getWidth(),
						height > 0 ? height : bitmap.getHeight(), true);
				// 通过图片资源id来得到bitmap，用一个ImageSpan来包装
				ImageSpan imageSpan = new ImageSpan(bitmap);

				// 计算该图片名字的长度，也就是要替换的字符串的长度
				int end = matcher.start() + key.length();
				// 将该图片替换字符串中规定的位置中
				spannableString.setSpan(imageSpan, matcher.start(), end, Spannable.SPAN_INCLUSIVE_EXCLUSIVE);
				if (end < spannableString.length()) {
					// 如果整个字符串还未验证完，则继续。。
					dealExpression(context, spannableString, patten, end, width, height);
				}
				break;
			}
		}
	}

	/** 存储已经添加到界面的动画表情 */
	private static List<GifObj> gifList = new ArrayList<GifObj>();

	/**
	 * 对spanableString进行正则判断，如果符合要求，则以表情图片代替
	 * 
	 * @param context
	 * @param spannableString
	 * @param patten
	 * @param start
	 * @throws Exception
	 */
	private synchronized void dealExpressionAll(Context context, SpannableString spannableString, Pattern patten, int start)
			throws Exception {
		Matcher matcher = patten.matcher(spannableString);
		while (matcher.find()) {
			String key = matcher.group();
			// 返回第一个字符的索引的文本匹配整个正则表达式,ture 则继续递归
			if (matcher.start() < start) {
				continue;
			}
			ChatEmoji faceValue = emojisAll.get(key);
			String value = faceValue.getFaceName();
			if (TextUtils.isEmpty(value)) {
				continue;
			}
			int resId = context.getResources().getIdentifier(value, "drawable", context.getPackageName());
			if (resId != 0) {
				VerticalImageSpan imageSpan;
				int end;
				if (faceValue.getFaceType() == 3) {// 该匹配的表情为动画表情
				} else {
					Bitmap bitmap = BitmapFactory.decodeResource(context.getResources(), resId);
					int showWidth = Util.getShowFaceSize(context, faceValue.getFaceType());
					bitmap = Bitmap.createScaledBitmap(bitmap, showWidth, showWidth, true);
					// 通过图片资源id来得到bitmap，用一个ImageSpan来包装
					imageSpan = new VerticalImageSpan(bitmap);
					// 计算该图片名字的长度，也就是要替换的字符串的长度
					end = matcher.start() + key.length();
					// 将该图片替换字符串中规定的位置中
					spannableString.setSpan(imageSpan, matcher.start(), end, Spannable.SPAN_INCLUSIVE_EXCLUSIVE);
					if (end < spannableString.length()) {
						// 如果整个字符串还未验证完，则继续。。
						dealExpressionAll(context, spannableString, patten, end);
					}
				}
				break;
			}
		}
	}

	/**
	 * 获取表情文件内容
	 * 
	 * @param context
	 * @param type
	 */
	public synchronized void getFileText(Context context, int type) {
		emojiLists.clear();// 初始化
		emojis.clear();// 初始化
		emojiMap.clear();// 初始化
		List<String> tempFaceList_default = Util.getEmojiFile(context, 1);
		List<String> tempFaceList_emoji = Util.getEmojiFile(context, 2);
		List<String> tempFaceList_cartoon = Util.getEmojiFile(context, 3);
		List<String> tempFaceList = new ArrayList<String>();
		switch (type) {
		case 1:
			pageSize = 18;
			tempFaceList = tempFaceList_default;
			break;
		case 2:
			pageSize = 21;
			tempFaceList = tempFaceList_emoji;
			break;
		case 3:
			pageSize = 8;
			tempFaceList = tempFaceList_cartoon;
			break;
		default:
			break;
		}

		// 读取单独的一个表情文件
		if (tempFaceList.size() > 0) {
			ParseData(tempFaceList, context);
		}

		if (emojisAll.size() <= 0) {
			List<String> tempFaceListAll = new ArrayList<String>();
			// 读取所有的表情文件
			tempFaceListAll.addAll(tempFaceList_default);
			tempFaceListAll.addAll(tempFaceList_emoji);
			tempFaceListAll.addAll(tempFaceList_cartoon);
			ParseDataAll(tempFaceListAll, context);
		}
	}

	/**
	 * 获取表情文件内容
	 * 
	 * @param context
	 * @param type
	 */
	public synchronized void getFileTextAll(Context context) {
		if (emojisAll.size() <= 0) {
			List<String> tempFaceList_default = Util.getEmojiFile(context, 1);
			List<String> tempFaceList_emoji = Util.getEmojiFile(context, 2);
			List<String> tempFaceList_cartoon = Util.getEmojiFile(context, 3);
			List<String> tempFaceListAll = new ArrayList<String>();

			// 读取所有的表情文件
			tempFaceListAll.addAll(tempFaceList_default);
			tempFaceListAll.addAll(tempFaceList_emoji);
			tempFaceListAll.addAll(tempFaceList_cartoon);
			ParseDataAll(tempFaceListAll, context);
		}
	}

	/**
	 * 解析字符
	 * 
	 * @param data
	 */
	private synchronized void ParseData(List<String> data, Context context) {
		if (data == null || emojis.size() > 0) {
			return;
		}
		ChatEmoji emojEentry;
		try {
			for (String str : data) {
				String[] text = str.split(",");
				String fileName = text[0].substring(0, text[0].lastIndexOf("."));
				emojiMap.put(text[1], fileName);// 解析出[对应的名字，文件名(不带后缀)]
				int resID = context.getResources().getIdentifier(fileName, "drawable", context.getPackageName());
				if (resID != 0) {
					emojEentry = new ChatEmoji();
					emojEentry.setId(resID);
					emojEentry.setCharacter(text[1]);
					emojEentry.setFaceName(fileName);
					emojEentry.setFaceType(Util.getInteger(text[2]));
					emojis.add(emojEentry);
				}
			}
			// 计算需要的翻页页数18/21/8
			float realNum = (float) emojis.size() / (float) pageSize;
			int pageCount = (int) Math.ceil(realNum);
			for (int i = 0; i < pageCount; i++) {
				emojiLists.add(getData(i));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 解析所有表情字符
	 * 
	 * @param data
	 */
	private synchronized void ParseDataAll(List<String> data, Context context) {
		if (data == null || emojisAll.size() > 0) {
			return;
		}
		ChatEmoji emojEentry;
		try {
			for (String str : data) {
				String[] text = str.split(",");
				String fileName = text[0].substring(0, text[0].lastIndexOf("."));
				emojiMapAll.put(text[1], fileName);
				int resID = context.getResources().getIdentifier(fileName, "drawable", context.getPackageName());
				if (resID != 0) {
					emojEentry = new ChatEmoji();
					emojEentry.setId(resID);
					emojEentry.setCharacter(text[1]);
					emojEentry.setFaceName(fileName);
					emojEentry.setFaceType(Util.getInteger(text[2]));
					emojisAll.put(text[1], emojEentry);
				}
			}
		} catch (Exception e) {
		}
	}

	/**
	 * 获取分页数据
	 * 
	 * @param page
	 * @return
	 */
	private synchronized List<ChatEmoji> getData(int page) {
		int startIndex = page * pageSize;
		int endIndex = startIndex + pageSize;

		if (endIndex > emojis.size()) {
			endIndex = emojis.size();
		}
		// 不这么写，会在viewpager加载中报集合操作异常，我也不知道为什么
		List<ChatEmoji> list = new ArrayList<ChatEmoji>();
		list.addAll(emojis.subList(startIndex, endIndex));
		if (list.size() < pageSize) {
			for (int i = list.size(); i < pageSize; i++) {
				ChatEmoji object = new ChatEmoji();
				list.add(object);
			}
		}
		return list;
	}

	/**
	 * 获取表情类型
	 * 
	 * */
	public ChatEmoji getChatEmoji(String content) {
		ChatEmoji ce = null;
		SpannableString spannableString = new SpannableString(content);
		// 正则表达式比配字符串里是否含有表情，如： 我好[开心]啊
		String zhengze = "\\[[^\\]]+\\]";
		// 通过传入的正则表达式来生成一个pattern
		Pattern sinaPatten = Pattern.compile(zhengze, Pattern.CASE_INSENSITIVE);
		try {
			Matcher matcher = sinaPatten.matcher(spannableString);
			while (matcher.find()) {
				String key = matcher.group();
				// 返回第一个字符的索引的文本匹配整个正则表达式,ture 则继续递归
				if (matcher.start() < 0) {
					continue;
				}
				ce = emojisAll.get(key);
				break;
			}
		} catch (Exception e) {
		}
		return ce;
	}

	/**
	 * 关闭所有动态表情的动画
	 * */
	public void closeCartoonFace() {
		Iterator iter = cartoonFaceCtrl.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();
			Object key = entry.getKey();
			cartoonFaceCtrl.get(key.toString()).stop();
		}
	}

	/**
	 * 检查该字符串内容中，有多少表情字符
	 * 
	 * */
	public int getFaceNumFromContent(Context context, String content) {
		int totalNum = 0;

		if (content == null || Util.isBlankString(content)) {
			return totalNum;
		}

		SpannableString spannableString = new SpannableString(content);
		// 正则表达式比配字符串里是否含有表情，如： 我好[开心]啊
		String zhengze = "\\[[^\\]]+\\]";
		// 通过传入的正则表达式来生成一个pattern
		Pattern sinaPatten = Pattern.compile(zhengze, Pattern.CASE_INSENSITIVE);
		Matcher matcher = sinaPatten.matcher(spannableString);
		while (matcher.find()) {
			String key = matcher.group();
			// 返回第一个字符的索引的文本匹配整个正则表达式,ture 则继续递归
			if (matcher.start() < 0) {
				continue;
			}
			ChatEmoji faceValue = emojisAll.get(key);

			if (faceValue == null) {
				continue;
			}

			String value = faceValue.getFaceName();
			if (TextUtils.isEmpty(value)) {
				continue;
			}
			int resId = context.getResources().getIdentifier(value, "drawable", context.getPackageName());
			if (resId != 0) {
				totalNum++;
			}
		}
		return totalNum;
	}

	/**
	 * 清除表情缓存
	 * 
	 * */
	public void clearAll() {
		if (emojiMap != null) {
			emojiMap.clear();
			emojiMap = null;
		}
		if (emojis != null) {
			emojis.clear();
			emojis = null;
		}
		if (emojiLists != null) {
			emojiLists.clear();
			emojiLists = null;
		}
		if (emojiMapAll != null) {
			emojiMapAll.clear();
			emojiMapAll = null;
		}
		if (emojisAll != null) {
			emojisAll.clear();
			emojisAll = null;
		}
		if (cartoonFaceCtrl != null) {
			cartoonFaceCtrl.clear();
			cartoonFaceCtrl = null;
		}
		if (mFaceConversionUtil != null) {
			mFaceConversionUtil = null;
		}
	}
}