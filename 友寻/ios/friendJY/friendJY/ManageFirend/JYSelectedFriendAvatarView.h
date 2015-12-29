//
//  JYSelectedFriendAvatarView.h
//  friendJY
//
//  Created by 高斌 on 15/3/12.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYSelectedFriendAvatarView : UIImageView<UICollectionViewDataSource, UICollectionViewDelegate>
{
    
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedFriendList;

//- (void)layoutCollectionView;
- (void)reloadData;
@end
