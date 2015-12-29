//
//  OrderListCell.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *theButton;

@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)SEL onButtonClick;

- (IBAction)theButtonClick:(id)sender;

@end
