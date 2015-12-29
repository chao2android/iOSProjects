//
//  InstallTableViewCell.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/22.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstallTableViewCell : UITableViewCell
{
    
    UIImageView * imageView;//左边的图标
    UILabel * titleLabel;//左边的提示文字
    
}

@property (nonatomic,retain)UIImageView * jiantouImageView;//箭头  可以要隐藏的那种  有的没有
@property (nonatomic,retain)UIImageView * lineImageView;

- (void)creatImageViewAndLabelWithImageString:(NSString*)imageName Title:(NSString *)titleName;

@end
