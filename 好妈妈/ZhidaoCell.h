//
//  ZhidaoCell.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKStreamView.h"
#import "AsyncImageView.h"

@interface ZhidaoCell : UIView<EKResusableCell>{

  NSString *reuseIdentifier;
}

@property (nonatomic ,retain,readonly) AsyncImageView *picView_;
//@property (nonatomic,retain,readonly) UIImageView *bgIV;
@property (nonatomic ,retain,readonly) UIButton *suoIV;

@property (nonatomic ,retain ,readonly) UILabel *timeLab;


@end
