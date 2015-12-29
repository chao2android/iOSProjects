//
//  QuanmeituCell.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKStreamView.h"
#import "AsyncImageView.h"

@interface QuanmeituCell : UIView<EKResusableCell>
{
  NSString *reuseIdentifier;
}

@property (nonatomic ,retain,readonly) AsyncImageView *picView_;


@end
