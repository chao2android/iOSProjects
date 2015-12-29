//
//  JYGroupMembersCollectionView.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYGroupMembersCollectionView.h"
#import "JYProfileGroupMemberCell.h"

#define ProfileGroupMemberCellID @"JYProfileGroupMemberCellID"
@implementation JYGroupMembersCollectionView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setDataSource:self];
        [self setDelegate:self];
        [self setScrollEnabled:NO];
        [self setShowsVerticalScrollIndicator:NO];
        _memberList = [NSMutableArray array];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self registerClass:[JYProfileGroupMemberCell class] forCellWithReuseIdentifier:ProfileGroupMemberCellID];
    }
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _memberList.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JYProfileGroupMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProfileGroupMemberCellID forIndexPath:indexPath];
    [cell relayoutSubViewDataWithMember:[_memberList objectAtIndex:indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.memberDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.memberDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
