//
//  JYSaveGroupController.h
//  friendJY
//
//  Created by 高斌 on 15/3/12.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYManageFirendController.h"
@class JYFriendGroupModel;
typedef NS_ENUM(NSInteger, JYFriendGroupEditType){
    JYFriendGroupEditTypeEdit,//编辑分组
    JYFriendGroupEditTypeCreate//创建分组
};

@interface JYSaveGroupController : JYBaseController<UICollectionViewDelegate, UICollectionViewDataSource, JYSelectFriendDelegate>
{
    JYBaseTextField *_groupNameTF;
    UICollectionView *_collectionView;
}

@property (nonatomic, strong) JYFriendGroupModel *groupInfo;
@property (nonatomic, strong) NSMutableArray *membersList;
//@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, assign) JYFriendGroupEditType groupEditType;

@end
