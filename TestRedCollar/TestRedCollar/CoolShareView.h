//
//  CoolShareView.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoolShareView : UIView
@property(nonatomic,copy)void(^shareBlock)(int tag);
@end
