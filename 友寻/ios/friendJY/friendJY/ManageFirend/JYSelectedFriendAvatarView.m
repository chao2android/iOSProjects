//
//  JYSelectedFriendAvatarView.m
//  friendJY
//
//  Created by 高斌 on 15/3/12.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYSelectedFriendAvatarView.h"
#import "JYCreatGroupFriendModel.h"
#import <UIImageView+WebCache.h>

@implementation JYSelectedFriendAvatarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUserInteractionEnabled:YES];
        [self layoutCollectionView];
        
    }
    
    return self;
}

- (void)layoutCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:5.0f];
    [layout setMinimumLineSpacing:5.0f];
    [layout setItemSize:CGSizeMake(30, 30)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
//    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    [_collectionView setContentInset:UIEdgeInsetsMake(7, 15, 7, 15)];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"selectedFriendCellID"];
}
- (void)reloadData{
    [_collectionView reloadData];
    if (_selectedFriendList.count > 1) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedFriendList.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}
#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_selectedFriendList count];
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"selectedFriendCellID";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UIView *view = [cell viewWithTag:1234];
    [view removeFromSuperview];
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:cell.bounds];
    JYCreatGroupFriendModel *friendModel = [_selectedFriendList objectAtIndex:indexPath.row];
    [avatar sd_setImageWithURL:[NSURL URLWithString:friendModel.avatar] placeholderImage:[UIImage imageNamed:@"pic_morentouxiang_man"]];
    [avatar.layer setCornerRadius:15];
    [avatar.layer setMasksToBounds:YES];
    [avatar setTag:1234];
    [cell addSubview:avatar];
    return cell;
}
#pragma mark -UICollectionViewDelegate


@end







