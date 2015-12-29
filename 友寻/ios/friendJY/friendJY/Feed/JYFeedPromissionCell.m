//
//  JYFeedPromissionCell.m
//  friendJY
//
//  Created by ouyang on 4/23/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedPromissionCell.h"
#import "JYFriendGroupModel.h"

@implementation JYFeedPromissionCell{
    UILabel *mContent;
    UIImageView *selectImg;
    UILabel *nameLab;
    UILabel *numLab;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self _initFeedSubviews];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - init method
- (void)_initFeedSubviews
{
    
    nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [nameLab setTextColor:kTextColorBlack];
    [nameLab setLineBreakMode:NSLineBreakByTruncatingTail];
    [nameLab setTag:111];
    [self addSubview:nameLab];
    
    numLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [numLab setFont:[UIFont systemFontOfSize:14]];
    [numLab setTextColor:kTextColorBlack];
    [numLab setLineBreakMode:NSLineBreakByTruncatingTail];
    [numLab setTag:222];
    [self addSubview:numLab];
        

    mContent = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth - 85 , 20)];
    mContent.textAlignment = NSTextAlignmentLeft;
    mContent.backgroundColor = [UIColor clearColor];
    mContent.font = [UIFont systemFontOfSize:14];
    [self addSubview:mContent];
    
    
    selectImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 25, 10, 17, 14)];
    selectImg.clipsToBounds = YES;
    selectImg.image = [UIImage imageNamed:@"feedSelectImg"];
    [self addSubview:selectImg];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
   
    if (self.cRow == 1) {
        mContent.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        selectImg.frame = CGRectMake(kScreenWidth - 50, 18, 13, 8);
        if (self.isExpand) {
            selectImg.image = [UIImage imageNamed:@"feedClose"];
        }else{
            selectImg.image = [UIImage imageNamed:@"feedOpen"];
        }
    }else{
        if (_mydata.selected) {
            selectImg.frame = CGRectMake(kScreenWidth - 25, 10, 17, 14);
            selectImg.image = [UIImage imageNamed:@"feedSelectImg"];
        }else{
            selectImg.frame = CGRectZero;
        }
        mContent.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    }
    if (self.cRow >1) {
//        JYFriendGroupModel *groupModel = _groupList[indexPath.row];
        NSString *nameStr = ToString(self.mydata.group_name);
        NSString *numStr = [NSString stringWithFormat:@"(%@)",self.mydata.member_nums];
        CGFloat nameWidth = [JYHelpers getTextWidthAndHeight:nameStr fontSize:14].width;
        CGFloat numWidth = [JYHelpers getTextWidthAndHeight:numStr fontSize:14].width;
        
        if (numWidth+nameWidth+50 > kScreenWidth) {
            [numLab setFrame:CGRectMake(kScreenWidth - 40 - numWidth, 0, numWidth, self.height)];
            [nameLab setFrame:CGRectMake(15, 0, numLab.left - 15, self.height)];
        }else{
            [nameLab setFrame:CGRectMake(15, 0, nameWidth, self.height)];
            [numLab setFrame:CGRectMake(nameLab.right, 0, numWidth, nameLab.height)];
        }
        [nameLab setText:nameStr];
        [numLab setText:numStr];
    }else{
        mContent.text = self.mydata.group_name;
        mContent.frame =  CGRectMake(15, 10, kScreenWidth - 85 , 20);
    }
    
}
@end
