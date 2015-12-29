//
//  JYManageFirendController.h
//  friendJY
//
//  Created by 高斌 on 15/3/11.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
/*管理朋友还是分组成员添加*/
typedef NS_ENUM(NSInteger, JYFriendManageType){
    JYFriendManageTypeManage,
    JYFriendManageTypeSelect
};
//将已选择好友的数据模型返回
@protocol JYSelectFriendDelegate <NSObject>

- (void)confirmBtnActionWithFriendList:(NSMutableArray *)friendList;

@end



@interface JYManageFirendController : JYBaseController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_table;
    UIImageView *_filterBg;
    
//    NSMutableArray *_friendList;
//    NSMutableArray *indexArr;
    UILabel *_selectedNameLab;
    UIButton *_inviteBtn;
    NSMutableArray *_selectedListArr;
//    NSMutableArray *_nameList;
}
@property (nonatomic, strong) NSMutableArray *selectMembers;

@property (nonatomic, strong) NSMutableArray *nameList;

@property (nonatomic, strong) NSMutableArray *indexArr;

@property (nonatomic, strong) NSMutableArray *friendList;

@property (nonatomic, assign) id<JYSelectFriendDelegate>delegate;

@property (nonatomic, assign) JYFriendManageType type;

@end





