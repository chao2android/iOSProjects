//
//  CommentView.m
//  TestRedCollar
//
//  Created by MC on 14-7-8.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CommentView.h"
#import "NetImageView.h"

@implementation CommentView

@synthesize delegate,didSelected;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI:frame];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)btnClick
{
    NSLog(@"okokokokok");
    if (delegate && didSelected) {
        [delegate performSelector:didSelected withObject:[NSNumber numberWithInt:self.tag] afterDelay:0];
    }
}
- (void)createUI:(CGRect)frame
{
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 40, 40)];
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = 20;
    _imgView.userInteractionEnabled = YES;
    [self addSubview:_imgView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, _imgView.bounds.size.width, _imgView.bounds.size.height);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [_imgView addSubview:btn];
    
//    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(55, 5, 320-60, 50)];
//    _backImageView.image = [UIImage imageNamed:@"1.png"];
//    [self addSubview:_backImageView];
    
    _commentView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 5, frame.size.width-48, frame.size.height)];
    _commentView.image = [UIImage imageNamed:@"comment.png"];
    [self addSubview:_commentView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    //_nameLabel.backgroundColor = [UIColor redColor];
    _nameLabel.textAlignment = 0;
    _nameLabel.textColor = [UIColor redColor];
    [_commentView addSubview:_nameLabel];
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 4, 75, 15)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    //_dateLabel.backgroundColor = [UIColor redColor];
    _dateLabel.font = [UIFont systemFontOfSize:12];
    _dateLabel.textColor = [UIColor redColor];
    [_commentView addSubview:_dateLabel];
    
    _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, 190, 25)];
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.font = [UIFont systemFontOfSize:14];
    _commentLabel.textColor = [UIColor darkGrayColor];
    [_commentView addSubview:_commentLabel];
}
- (void)loadContent:(CommentModel *)model
{
//    NetImageView *netImg = [[NetImageView alloc]initWithFrame:self.imgView.bounds];
//    netImg.mImageType = TImageType_CutFill;
//    [self.imgView addSubview:netImg];
//    [netImg GetImageByStr:model.avatar];
    
    NSString *username = [UserInfoManager GetSecretName:model.nickname username:model.user_name];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 说:",username];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[model.add_time doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    self.dateLabel.text = dateStr;
    self.commentLabel.text = model.content;
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
