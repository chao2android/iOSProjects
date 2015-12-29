//
//  ServiceTableCell.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceTableCell : UITableViewCell {
    UIImageView *mHeadView;
    UILabel *mlbName;
    UILabel *mlbAddress;
    UILabel *mlbDistance;
}

- (void)LoadContent:(NSDictionary *)dict;

@end
