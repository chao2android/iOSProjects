//
//  JiePaiAndSheJiListCell.h
//  TestRedCollar
//
//  Created by dreamRen on 14-7-27.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoolListModel.h"
#import "JiePaiAndSheJiView.h"
@interface JiePaiAndSheJiListCell : UITableViewCell{
    UIButton *_leftButton;
    UIButton *_rightButton;
    JiePaiAndSheJiView *_leftView;
    JiePaiAndSheJiView *_rightView;
    
}
@property(nonatomic,copy)void(^blockButtonClick)(JiePaiAndSheJiView*);
- (void)createUI;
- (void)configCell:(CoolListModel *)leftModel And:(CoolListModel *)rightModel;
@end
