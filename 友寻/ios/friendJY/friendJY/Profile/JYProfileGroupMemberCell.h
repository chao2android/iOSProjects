//
//  JYProfileGroupMemberCell.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYGroupMemberModel;
@interface JYProfileGroupMemberCell : UICollectionViewCell
{
    //头像
    UIImageView *_avatarView;
    //单身
    UIImageView *_singleView;
    //昵称
    UILabel *_nickLab;
    //群主
    UIImageView *_ownerView;
    //性别
//    UIImageView *_sexView;

}
- (void)relayoutSubViewDataWithMember:(JYGroupMemberModel*)member;

@end
