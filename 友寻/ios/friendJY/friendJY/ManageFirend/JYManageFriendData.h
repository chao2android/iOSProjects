//
//  JYManageFriendData.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/21.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYCreatGroupFriendModel;
@class JYFriendGroupModel;

@interface JYManageFriendData : NSObject
//一度好友
@property (nonatomic, strong) NSMutableArray *friendList;
//二度好友
@property (nonatomic, strong) NSMutableArray *secondFriendList;
//好友分组
@property (nonatomic, strong) NSMutableArray *groupListArr;
/*一度好友数量*/
@property (nonatomic, assign) NSInteger friendNums;
/*二度好友数量*/
@property (nonatomic, assign) NSInteger fsFriendNums;
/*未加入app的一度手机好友*/
@property (nonatomic, strong) NSMutableArray *mobileFriendList;

//@property (nonatomic, strong) NSMutableArray *mutualFriendArr;


/*------------------------------*/
//单例方法
+ (instancetype)sharedInstance;
//退出登录清楚数据
- (void)cleanData;

//通过用户UID获取 friendModel
- (JYCreatGroupFriendModel*)aFriendWithFriendID:(NSString*)frdID;
//通过组的id编号找到该组
- (JYFriendGroupModel*)aGroupArrWithGroupID:(NSString*)groupID;
//插入一个组
- (void)addAGroupIntoGroupList:(JYFriendGroupModel*)groupModel;
//删除一个组
- (void)removeAGroupWithGroupID:(NSString*)group_id;
- (void)removeAGroupInSever:(NSString*)group_id;
//修改组名
- (void)modifyGroupNameWithGroupID:(NSString*)group_id andGroupName:(NSString*)groupName;
//减少组成员
- (void)deleteMemberInGroupWithGroupID:(NSString*)group_id;
//增加组员
- (void)addMemberInGroupWithGroupID:(NSString*)group_id withMemberCount:(NSInteger)nums;
/**
 *  获取一度好友数据
 *
 *  @param nums         数量
 *  @param successBlcok 成功回调
 *  @param failureBlock 失败回调
 */
- (void)loadMyFriendsAllWithNums:(NSInteger)nums SuccessBlock:(void (^)(NSArray*))successBlcok failureBlock:(void (^)(NSError*))failureBlock;
/**
 *  获取二度好友数据
 *
 *  @param nums         数量
 *  @param statusDic    过滤属性
 *  @param successBlcok 成功回调
 *  @param failureBlock 失败回调
 */
- (void)loadSecondFriendsWithNums:(NSInteger)nums statusDic:(NSDictionary*)statusDic SuccessBlock:(void (^)(NSMutableArray*))successBlcok failureBlock:(void (^)(NSError*))failureBlock;

@end



