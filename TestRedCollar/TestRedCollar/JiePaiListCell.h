//
//  JiePaiListCell.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiePaiListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *theLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *theRightButton;

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL onButtonClick;

- (IBAction)theItemClick:(id)sender;

@end
