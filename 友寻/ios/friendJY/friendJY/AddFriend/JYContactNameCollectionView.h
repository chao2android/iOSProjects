//
//  JYContactNameCollectionView.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/28.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYContactNameCollectionView : UIScrollView
{
    UILabel *_nameLabel;
}
//@property (nonatomic, strong) NSArray *selectListArr;

- (void)relayoutLabelWithStr:(NSString*)str;

@end
