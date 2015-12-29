//
//  PopView.h
//  TestRedCollar
//
//  Created by MC on 14-7-25.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopView : UIView

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnPopSelect;

- (void)loadContent:(NSArray *)dataArray withFrame:(CGRect)frame;
@end
