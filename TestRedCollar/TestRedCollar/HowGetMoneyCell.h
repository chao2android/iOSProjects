//
//  HowGetMoneyCell.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowGetMoneyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *theLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *theRightLabel;

-(void)resetInfoDict:(NSDictionary*)aDict;

@end
