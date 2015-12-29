//
//  JYShareData.h
//  friendJY
//
//  Created by 高斌 on 15/3/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JYProfileModel;
@interface JYShareData : NSObject
{
    NSString *_filePath;
}

@property (nonatomic, strong) NSDictionary *profile_dict; //个人资料里常用的选择，比较省份，城市等
@property (nonatomic, strong) NSDictionary *myself_profile_dict; //我自已的个人资料的详细信息
@property (nonatomic, strong) JYProfileModel *myself_profile_model;
@property (nonatomic, strong) NSArray *contactsList;
//@property (nonatomic, strong) NSMutableArray *contactsList; //通讯录
@property (nonatomic, strong) NSMutableArray *feedList; //所有动态的列表
@property (nonatomic, strong) NSMutableArray *myFeedList; //我的动态的列表
@property (nonatomic, strong) NSDictionary *province_code_dict; 
@property (nonatomic, strong) NSDictionary *city_code_dict;
@property (nonatomic, strong) NSArray *province_array;
@property (nonatomic, strong) NSArray *city_array;
@property (nonatomic, strong) NSArray *emoji_array;
@property (nonatomic, assign) BOOL networkStates;//网络状态
@property (nonatomic, strong) NSMutableArray *messageUserList;//消息用户列表
@property (nonatomic, strong) NSMutableArray *currentChatLog;//当前用户聊天记录
@property (nonatomic, assign) BOOL showOrHiddenKeyboard; //存当前键盘是收起还是弹起
@property (nonatomic, strong) NSString * groupChatIsShowNick;//群组聊天时是否显示昵称，0-显示，1-不显示
@property (nonatomic, strong) NSString * voiceSpeakerOrHeadphone;//语音聊天时是听筒模式还是扬声器
@property (nonatomic, strong) NSString * lastVoiceMsgTime;//最后一条语音消息的时间
/**
 *  本地图片信息 url
 */
@property (nonatomic, strong) NSMutableArray *localImageArr;
/**
 *  男的推荐标签
 */
@property (nonatomic, strong) NSMutableArray *maleRecommendTagArr;
/**
 *  女的推荐标签
 */
@property (nonatomic, strong) NSMutableArray *feMaleRecommendTagArr;

+ (JYShareData *)sharedInstance;

//上传通讯录
- (void)upListAndShowProgress:(BOOL)isShow;
/**
 *  获取本地图片信息，当前启动只需获取一次就行，图片信息保存在localImageArr里面
 *
 *  @return 图片信息数组 url
 */
- (void)getLocalImageInfoWithFinishBlcok:(void (^)())finishBlock;
/**
 *  获取推荐标签
 *
 *  @param isMale       是否为男
 *  @param successBlock 成功回调，不带参数，可以直接通过JYProfileData取到。
 */
- (void)loadRecommendTagsWithMaleOrNot:(BOOL)isMale successBlock:(void (^)())successBlock;

@end
