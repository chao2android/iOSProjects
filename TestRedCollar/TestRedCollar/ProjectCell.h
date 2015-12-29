//
//  ProjectCell.h
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchPhotoView.h"

@protocol ProjectCellDelegate <NSObject>
- (void)projectCellSelect:(NSString *)selectID;
@end

@interface ProjectCell : UITableViewCell
{
    TouchPhotoView *myLeftView;
    TouchPhotoView *myRightView;
}

@property (nonatomic, assign) id <ProjectCellDelegate> delegate;
@property (nonatomic, strong) NSString *myLeftName;
@property (nonatomic, strong) NSString *myRightName;
@property (nonatomic, strong) NSString *myLeftID;
@property (nonatomic, strong) NSString *myRightID;

- (void)projectCellLeftName:(NSString *)leftName RightName:(NSString *)rightName;
- (void)projectCellLeftID:(NSString *)lefeID RightID:(NSString *)rightID;
@end
