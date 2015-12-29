//
//  GrassWantGoTableViewCell.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "GrassWantGoTableViewCell.h"
#import "UIImageView+WebCache.h"


@implementation GrassWantGoTableViewCell
{
    UIButton *btn;
    UIButton *_addHaveBtn;
    UIButton *_deleteBtn;
}

@synthesize  delegate,OnDelete, OnAddHave;

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
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KscreenWidth-48, Bg.bounds.size.height - 45, 35, 35);
        [btn setBackgroundImage:[UIImage imageNamed:@"想去清单-删除"] forState:UIControlStateNormal];
        [btn addTarget: self action:@selector(DeleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        _addHaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addHaveBtn.frame = CGRectMake(KscreenWidth - 90, Bg.bounds.size.height - 45, 35, 35);
        [_addHaveBtn setBackgroundImage:[UIImage imageNamed:@"删除-放到去过"] forState:UIControlStateNormal];
        [_addHaveBtn addTarget:self action:@selector(OnAddHaveClick) forControlEvents:UIControlEventTouchUpInside];
        _addHaveBtn.hidden = YES;
        [self.contentView addSubview:_addHaveBtn];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = btn.frame;
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(OnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
        
    }
    return self;
}
- (void)loadView:(VideoListModel *)model{
    btn.hidden = NO;
    _deleteBtn.hidden = YES;
    _addHaveBtn.hidden = YES;
    [_picView setImageWithURL:[NSURL URLWithString:model.image]];
    _nameLabel.text = model.title;
    _addressLabel.text = model.xy_name;
}

- (void)OnDeleteClick{
    if (delegate && OnDelete) {
        SafePerformSelector([delegate performSelector:OnDelete withObject:[NSNumber numberWithInt:(int)self.tag]]);
    }
}

- (void)OnAddHaveClick{
    if (delegate && OnAddHave) {
        SafePerformSelector([delegate performSelector:OnAddHave withObject:[NSNumber numberWithInt:(int)self.tag]]);
    }
}

- (void)DeleteClick:(UIButton *)sender
{
//    if (sender.selected) {
//        if (delegate && OnDelete) {
//            [delegate performSelector:OnDelete withObject:[NSNumber numberWithInt:self.tag]];
//        }
//    }
//    else{
//        sender.selected = YES;
//    }
    sender.hidden = YES;
    _deleteBtn.hidden = NO;
    _addHaveBtn.hidden = NO;
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
