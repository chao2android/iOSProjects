//
//  GuanZhuTableViewCell.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "GuanZhuTableViewCell.h"
#import "NetImageView.h"

@implementation GuanZhuTableViewCell{
    NetImageView *_headView;
    UILabel *_nameLabel;
    UILabel *_addressLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headView = [[NetImageView alloc]initWithFrame:CGRectMake(12, 9, 44, 44)];
        _headView.userInteractionEnabled = YES;
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = 22;
        _headView.mDefaultImage = [UIImage imageNamed:@"default_avatar"];
        [self.contentView addSubview:_headView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(73, 0, self.frame.size.width-120, 63)];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_nameLabel];
        
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 6, 80, 53)];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.textColor = [UIColor grayColor];
        _addressLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_addressLabel];
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"F_A.png"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(KscreenWidth-43, 21, 20, 20);
        [self.contentView addSubview:btn];
        
    }
    return self;
}
- (void)LoadView:(BeCareListModel *)model{
    _nameLabel.text = model.nickname;
    //_addressLabel.text = mDict[@"address"];
    [_headView GetImageByStr:model.avater];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
