//
//  CustomListCell.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CustomListCell.h"

@implementation CustomListCell

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        mLeftView = [[TouchView alloc] initWithFrame:CGRectMake(5, 5, 152, 220)];
        mLeftView.delegate = self;
        mLeftView.OnViewClick = @selector(OnLeftClick);
        mLeftView.hidden = YES;
        [self.contentView addSubview:mLeftView];
        
        mRightView = [[TouchView alloc] initWithFrame:CGRectMake(162, 5, 152, 220)];
        mRightView.delegate = self;
        mRightView.OnViewClick = @selector(OnRightClick);
        mRightView.hidden = YES;
        [self.contentView addSubview:mRightView];
    }
    return self;
}

- (void)OnLeftClick
{
    if (delegate && [delegate respondsToSelector:@selector(OnCustomListSelect:)]) {
        [delegate OnCustomListSelect:self.mLeftName];
    }
}

- (void)OnRightClick
{
    if (delegate && [delegate respondsToSelector:@selector(OnCustomListSelect:)]) {
        [delegate OnCustomListSelect:self.mRightName];
    }
}

- (void)dealloc {
    NSLog(@"CustomListCell dealloc");
    self.mLeftName = nil;
    self.mRightName = nil;
    self.delegate = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)LoadContent:(NSString *)leftname :(NSString *)rightname {
    self.mLeftName = leftname;
    self.mRightName = rightname;
    mLeftView.hidden = YES;
    mRightView.hidden = YES;
    if (leftname && leftname.length>0) {
        mLeftView.hidden = NO;
        mLeftView.image = [UIImage imageNamed:leftname];
    }
    if (rightname && rightname.length>0) {
        mRightView.hidden = NO;
        mRightView.image = [UIImage imageNamed:rightname];
    }
}

@end
