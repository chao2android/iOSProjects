//
//  PhotoCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-29.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        myLeftView = [[TouchPhotoView alloc] initWithFrame:CGRectMake(5, 5, 152, 195)];
        myLeftView.delegate = self;
        myLeftView.OnViewClick = @selector(OnLeftClick);
        myLeftView.mImageType = TImageType_CutFill;
        myLeftView.hidden = YES;
        [self.contentView addSubview:myLeftView];
        
        myRightView = [[TouchPhotoView alloc] initWithFrame:CGRectMake(162, 5, 152, 195)];
        myRightView.delegate = self;
        myRightView.OnViewClick = @selector(OnRightClick);
        myRightView.mImageType = TImageType_CutFill;
        myRightView.hidden = YES;
        [self.contentView addSubview:myRightView];
        
    }
    return self;
}

- (void)OnLeftClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(photoCellSelect:)])
    {
        [_delegate photoCellSelect:self.myLeftID];
    }
}

- (void)OnRightClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(photoCellSelect:)])
    {
        [_delegate photoCellSelect:self.myRightID];
    }
}

- (void)photoCellLeftName:(NSString *)leftName RightName:(NSString *)rightName
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

- (void)photoCellLeftID:(NSString *)lefeID RightID:(NSString *)rightID
{
    self.myLeftID = lefeID;
    self.myRightID = rightID;
}

- (void)dealloc
{
    self.myLeftName = nil;
    self.myRightName = nil;
    self.delegate = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
