//
//  GrassHaveGoTableViewCell.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "GrassHaveGoTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation GrassHaveGoTableViewCell
{
    UIButton *_goodBtn;
    UIButton *_badBtn;
}
@synthesize delegete,OnDelete;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        UIImageView *Bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenWidth*114/320)];
        Bg.image = [UIImage imageNamed:@"w_Bg"];
        [self.contentView addSubview:Bg];
        
        _picView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, KscreenWidth*134/320, KscreenWidth*103/320)];
        [self.contentView addSubview:_picView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth*292/640, 5, KscreenWidth - 150, 40)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:18];
        [Bg addSubview:_nameLabel];
        
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth*292/640, 40, KscreenWidth - 150, 20)];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.textColor = [UIColor grayColor];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.font = [UIFont systemFontOfSize:14];
        [Bg addSubview:_addressLabel];
        
        _goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goodBtn.frame = CGRectMake(KscreenWidth-54, Bg.bounds.size.height - 47, 35, 35);
        [_goodBtn setBackgroundImage:[UIImage imageNamed:@"LIKE"] forState:UIControlStateNormal];
        [_goodBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_goodBtn setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateSelected];
        _goodBtn.hidden = YES;
        [self.contentView addSubview:_goodBtn];
        
        _badBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _badBtn.frame = CGRectMake(KscreenWidth-54, Bg.bounds.size.height - 47, 35, 35);
        [_badBtn setBackgroundImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        [_badBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_badBtn setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateSelected];
        _badBtn.hidden = YES;
        [self.contentView addSubview:_badBtn];
    }
    return self;
}
- (void)loadView:(VideoListModel *)model
{
    _goodBtn.selected = NO;
    _badBtn.selected = NO;
    if ([model.flag intValue] == 2) {
        _goodBtn.hidden = NO;
        _badBtn.hidden = YES;
    }
    else if([model.flag intValue] == 1){
        _goodBtn.hidden = YES;
        _badBtn.hidden = NO;
    }
    [_picView setImageWithURL:[NSURL URLWithString:model.image]];
    _nameLabel.text = model.title;
    _addressLabel.text = model.xy_name;
}
- (void)BtnClick:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
    }
    else{
        if (delegete && OnDelete) {
            [delegete performSelector:OnDelete withObject:[NSNumber numberWithInt:self.tag]];
        }
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
