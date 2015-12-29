//
//  CoolSubView.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchView.h"
#import "CoolButton.h"
#import "NetImageView.h"
@class CoolListModel;
@interface CoolSubView : TouchView {
    UIImageView *mImageView;
    NetImageView *mHeadView;
    UILabel *mlbName;
    UILabel *mlbDesc;
    CoolButton *favorBut;
    CoolButton *commentBut;

}
@property (assign, nonatomic) SEL MyClick;
@property (assign, nonatomic) SEL OnHeadViewClick;
- (void)LoadContent:(CoolListModel *)model and:(UIImage*)image;
+ (NSDictionary *)HeightOfContent:(CoolListModel *)model;

@end
