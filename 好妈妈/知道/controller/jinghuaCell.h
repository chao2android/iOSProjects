//
//  jinghuaCell.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-24.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKStreamView.h"
#import "AsyncImageView.h"
#import "ImageTextLabel.h"

@interface jinghuaCell : UIView<EKResusableCell>
{
  NSString *reuseIdentifier;
}

@property (nonatomic ,retain,readonly) AsyncImageView *picView_;
@property (nonatomic ,retain,readonly) ImageTextLabel *tLab;
@property (nonatomic ,retain,readonly) UILabel * ipadLab;

@property (nonatomic,retain,readonly) UIButton *clickBut;

-(void)remImageTextLab:(NSString *)text;
@end
