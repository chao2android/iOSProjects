//
//  MoneyRecordCell.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *theOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *theTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *theThreeLabel;

-(void)resetInfoDict:(NSDictionary*)aDict;

@end
