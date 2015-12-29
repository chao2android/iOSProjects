//
//  PhotoCell.h
//  TestRedCollar
//
//  Created by miracle on 14-7-29.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchPhotoView.h"

@protocol PhotoCellDelegate <NSObject>
- (void)photoCellSelect:(NSString *)selectID;
@end

@interface PhotoCell : UITableViewCell
{
    TouchPhotoView *myLeftView;
    TouchPhotoView *myRightView;
}

@property (nonatomic, assign) id <PhotoCellDelegate> delegate;
@property (nonatomic, strong) NSString *myLeftName;
@property (nonatomic, strong) NSString *myRightName;
@property (nonatomic, strong) NSString *myLeftID;
@property (nonatomic, strong) NSString *myRightID;

- (void)photoCellLeftName:(NSString *)leftName RightName:(NSString *)rightName;
- (void)photoCellLeftID:(NSString *)lefeID RightID:(NSString *)rightID;

@end
