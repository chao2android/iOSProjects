package com.iyouxun.db;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * 消息数据库
 * 
 * @author likai
 * @date 2014年10月11日 下午7:12:47
 */
public class MsgDbHelper extends SQLiteOpenHelper implements IMsgTablColumns {
	private static final String CREATTABLE = "CREATE TABLE " + TABLE_NAME + " (" + _ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
			+ UID + " VARCHAR(15)," + AVATAR + " VARCHAR(200)," + NICKNAME + " VARCHAR(50)," + TYPE + " INTEGER," + SENDTIME
			+ " LONG," + CONTENT + " TEXT," + STATUS + " INTEGER," + EXPIRETIME + " LONG," + ISEXPIRE + " INTEGER" + "," + QID
			+ " INTEGER," + GOLD + " INTEGER," + MSG_TYPE + " INTEGER)";

	public MsgDbHelper(Context context, String name) {
		super(context, name, null, DATABASE_VERSION);
	}

	@Override
	public void onCreate(SQLiteDatabase db) {
		db.execSQL(CREATTABLE);
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		int version = oldVersion;
		if (version != DATABASE_VERSION) {
			db.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME);
			onCreate(db);
		}
	}

}
