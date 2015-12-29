//
//  CustomTableCell.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTableCell;

@protocol CustomTableCellDelegate <NSObject>

- (void)OnCustomImageSelect:(CustomTableCell *)sender :(int)index;
- (void)OnCustomListSelect:(CustomTableCell *)sender;

@end

@interface CustomTableCell : UITableViewCell {
    UILabel *mlbTitle;
    UIImageView *backView;
}

@property (nonatomic, assign) id<CustomTableCellDelegate> delegate;

- (void)LoadContent:(NSDictionary *)dict;

@end
