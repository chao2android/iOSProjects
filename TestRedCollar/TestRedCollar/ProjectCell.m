//
//  ProjectCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ProjectCell.h"

@implementation ProjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        myLeftView = [[TouchPhotoView alloc] initWithFrame:CGRectMake(5, 5, 152, 220)];
        myLeftView.delegate = self;
        myLeftView.OnViewClick = @selector(OnLeftClick);
        myLeftView.hidden = YES;
        myLeftView.mImageType = TImageType_CutFill;
        [self.contentView addSubview:myLeftView];
        
        myRightView = [[TouchPhotoView alloc] initWithFrame:CGRectMake(162, 5, 152, 220)];
        myRightView.delegate = self;
        myRightView.OnViewClick = @selector(OnRightClick);
        myRightView.hidden = YES;
        myRightView.mImageType = TImageType_CutFill;
        [self.contentView addSubview:myRightView];
    }
    return self;
}

- (void)OnLeftClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(projectCellSelect:)]) {
        [_delegate projectCellSelect:self.myLeftID];
    }
}

- (void)OnRightClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(projectCellSelect:)]) {
        [_delegate projectCellSelect:self.myRightID];
    }
}

- (void)dealloc
{
    self.myLeftName = nil;
    self.myRightName = nil;
    self.delegate = nil;
}

- (void)projectCellLeftName:(NSString *)leftName RightName:(NSString *)rightName
{
    self.myLeftName = leftName;
    self.myRightName = rightName;
    myLeftView.hidden = YES;
    myRightView.hidden = YES;
    if (leftName && leftName.length>0)
    {
        myLeftView.hidden = NO;
        [myLeftView GetImageByStr:leftName];
    }
    if (rightName && rightName.length>0)
    {
        myRightView.hidden = NO;
        [myRightView GetImageByStr:rightName];
    }
}

- (void)projectCellLeftID:(NSString *)lefeID RightID:(NSString *)rightID
{
    self.myLeftID = lefeID;
    self.myRightID = rightID;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
