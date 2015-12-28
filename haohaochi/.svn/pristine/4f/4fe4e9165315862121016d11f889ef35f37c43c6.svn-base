//
//  AttentionTableViewCell.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AttentionTableViewCell.h"
#import "UIImageView+WebCache.h"


@implementation AttentionTableViewCell
@synthesize delegate,headClick;

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(2, -3, KscreenWidth-4, 55)];
        bg.image = [UIImage imageNamed:@"f_sbg"];
        bg.userInteractionEnabled = YES;
        [self.contentView addSubview:bg];
        
        _headPic = [[UIImageView alloc]initWithFrame:CGRectMake(11, 7, 40, 40)];
        _headPic.layer.masksToBounds = YES;
        _headPic.layer.cornerRadius = 20;
        _headPic.userInteractionEnabled = YES;
        [bg addSubview:_headPic];
        
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame = _headPic.bounds;
        headBtn.backgroundColor = [UIColor clearColor];
        [headBtn addTarget:self action:@selector(HeadClick) forControlEvents:UIControlEventTouchUpInside];
        [_headPic addSubview:headBtn];
        
        _mLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 17, KscreenWidth-100, 20)];
        _mLabel.backgroundColor = [UIColor clearColor];
        _mLabel.textAlignment = NSTextAlignmentLeft;
        _mLabel.textColor = [UIColor blackColor];
        _mLabel.font = [UIFont systemFontOfSize:15];
        [bg addSubview:_mLabel];
        
        UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mBtn.backgroundColor = [UIColor clearColor];
        mBtn.frame = CGRectMake(KscreenWidth-40, 18, 20, 20);
        [mBtn setImage:[UIImage imageNamed:@"F_A.png"] forState:UIControlStateNormal];
        [bg addSubview:mBtn];
    }
    return self;
}
- (void)loadView:(FriendAttentionModel *)model{
    [_headPic setImageWithURL:[NSURL URLWithString:model.avater]];
    NSString *str = @"";
    if ([model.type intValue] == 1 ) {
        str = @"喜欢了你的视频";
    }
    else{
        str = @"关注了你";
    }
    _mLabel.text = [NSString stringWithFormat:@"%@%@",model.nickname,str];
}
- (void)HeadClick{
    NSLog(@"点击头像");
    if (delegate && headClick) {
        [delegate performSelector:headClick withObject:[NSNumber numberWithInt:self.tag]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
