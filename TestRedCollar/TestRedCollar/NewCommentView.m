//
//  NewCommentView.m
//  TestRedCollar
//
//  Created by dreamRen on 14-7-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "NewCommentView.h"
#import "NetImageView.h"
@implementation NewCommentView
@synthesize delegate,didSelected;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI:frame];
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}
- (void)btnClick
{
    if (delegate && didSelected) {
        SafePerformSelector(
                            [delegate performSelector:didSelected withObject:self.mModel];
        );
    }
}
- (void)createUI:(CGRect)frame
{
    
    
     _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headButton.frame = CGRectMake(0, 5, 40, 40);
    [_headButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_headButton];
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 40, 40)];
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = 20;
    [self addSubview:_imgView];
    
    //    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(55, 5, 320-60, 50)];
    //    _backImageView.image = [UIImage imageNamed:@"1.png"];
    //    [self addSubview:_backImageView];
    
    _commentView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 5, frame.size.width-48, frame.size.height)];
    _commentView.image = [UIImage imageNamed:@"comment.png"];
    _commentView.userInteractionEnabled = YES;
    [self addSubview:_commentView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    //_nameLabel.backgroundColor = [UIColor redColor];
    _nameLabel.textAlignment = 0;
    _nameLabel.textColor = [UIColor colorWithRed:0.7 green:0.1 blue:0.2 alpha:1];
    [_commentView addSubview:_nameLabel];
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 4, 75, 15)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    //_dateLabel.backgroundColor = [UIColor redColor];
    _dateLabel.font = [UIFont systemFontOfSize:12];
    _dateLabel.textColor = [UIColor colorWithRed:0.7 green:0.1 blue:0.2 alpha:1];
    [_commentView addSubview:_dateLabel];
    
    _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, 190, frame.size.height-15)];
    _commentLabel.backgroundColor = [UIColor clearColor];
    [_commentView addSubview:_commentLabel];
    _commentLabel.textColor = [UIColor darkGrayColor];
    _commentLabel.font = [UIFont systemFontOfSize:14];
    
}
- (void)loadCoolCommentContent:(CoolCommentModel *)model
{
    self.mModel = model;
    NetImageView *netImg = [[NetImageView alloc] initWithFrame:self.imgView.bounds];
    netImg.mDefaultImage = [UIImage imageNamed:@"default_avatar.png"];
    netImg.mImageType = TImageType_CutFill;
    [self.imgView addSubview:netImg];
    [netImg GetImageByStr:model.avatar];
    
    [_headButton setBackgroundImage:self.imgView.image forState:UIControlStateNormal];
    
    NSString *username = [UserInfoManager GetSecretName:model.nickname username:model.user_name];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 说:",username];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[model.add_time doubleValue]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    self.dateLabel.text = dateStr;
    if ([model.content isEqualToString:@""]) {
        return;
    }
    self.commentLabel.text = model.content;
}

- (void)dealloc {
    self.mModel = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
