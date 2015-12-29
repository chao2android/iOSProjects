//
//  JYGroupMembersCollectionView.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYMemberCollectionViewDelegate <NSObject>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface JYGroupMembersCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *memberList;

@property (nonatomic, assign) id<JYMemberCollectionViewDelegate>memberDelegate;

@end
