//
//  CoolSubView.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolSubView.h"
#import "CoolListModel.h"
@implementation CoolSubView

@synthesize OnHeadViewClick,MyClick;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // self.userInteractionEnabled = YES;
        mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 36, frame.size.width-2, frame.size.height-86)];
        mImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        mImageView.userInteractionEnabled = YES;
        [self addSubview:mImageView];
        
        //        mImageViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        mImageViewButton.frame = mImageView.bounds;
        //        [mImageView addSubview:mImageViewButton];
        //        mImageViewButton.tag = 2;
        //        [mImageViewButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //收藏But
        //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btn.frame = CGRectMake(frame.size.width-27, frame.size.height-65, 27, 27);
        //        btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        //        [btn setImage:[UIImage imageNamed:@"89.png"] forState:UIControlStateNormal];
        //        [self addSubview:btn];
        
        UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 43)];
        topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        topView.image = [UIImage imageNamed:@"87.png"];
        [self addSubview:topView];
        // topView.userInteractionEnabled = YES;
        
        mHeadView = [[NetImageView alloc] initWithFrame:CGRectMake(5, 5, 27, 27)];
        mHeadView.mDefaultImage = [UIImage imageNamed:@"default_avatar"];
        mHeadView.layer.masksToBounds = YES;
        mHeadView.layer.cornerRadius = 13.5;
        [topView addSubview:mHeadView];
        //        mHeadViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        mHeadViewButton.frame = mHeadView.bounds;
        //        [mHeadView addSubview:mHeadViewButton];
        //        mHeadViewButton.tag = 1;
        //        [mHeadViewButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        mlbName = [[UILabel alloc] initWithFrame:CGRectMake(37, 10, 115, 15)];
        mlbName.backgroundColor = [UIColor clearColor];
        mlbName.font = [UIFont systemFontOfSize:12];
        [topView addSubview:mlbName];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = topView.bounds;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(HeadViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        UIImageView *botView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-50, frame.size.width, 50)];
        botView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        botView.image = [UIImage imageNamed:@"90.png"];
        [self addSubview:botView];
        
        mlbDesc = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, botView.frame.size.width-10, 25)];
        mlbDesc.backgroundColor = [UIColor clearColor];
        mlbDesc.font = [UIFont systemFontOfSize:10];
        mlbDesc.textColor = [UIColor grayColor];
        mlbDesc.numberOfLines = 0;
        mlbDesc.text = @"暂无描述";
        [botView addSubview:mlbDesc];
        
        // botView.userInteractionEnabled = YES;
        
        commentBut = [CoolButton buttonWithType:UIButtonTypeCustom];
        [commentBut setFrame:CGRectMake(8, 25, 70, 22)];
        commentBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [commentBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [commentBut setImage:[UIImage imageNamed:@"s8_11.png"] forState:UIControlStateNormal];
        commentBut.tag = 3;
        [botView addSubview:commentBut];
        
        // [commentBut addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        favorBut = [CoolButton buttonWithType:UIButtonTypeCustom];
        [favorBut setFrame:CGRectMake(83, 25, 65, 22)];
        favorBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [favorBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [favorBut setImage:[UIImage imageNamed:@"s8_12.png"] forState:UIControlStateNormal];
        //  [favorBut addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        favorBut.tag = 4;
        [botView addSubview:favorBut];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, topView.bounds.size.height, self.bounds.size.width, self.bounds.size.height - topView.bounds.size.height);
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(BottomClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        //        mRHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 7, 22, 22)];
        //        [botView addSubview:mRHeadView];
        
        //        mlbRName = [[UILabel alloc] initWithFrame:CGRectMake(1, 20, 37, 17)];
        //        mlbRName.backgroundColor = [UIColor clearColor];
        //        mlbRName.font = [UIFont systemFontOfSize:10];
        //        mlbRName.textColor = [UIColor grayColor];
        //        mlbRName.textAlignment = UITextAlignmentCenter;
        //        [botView addSubview:mlbRName];
        //
        //        mlbRDesc = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 105, 37)];
        //        mlbRDesc.backgroundColor = [UIColor clearColor];
        //        mlbRDesc.font = [UIFont systemFontOfSize:11];
        //        mlbRDesc.numberOfLines = 0;
        //        [botView addSubview:mlbRDesc];
        
    }
    return self;
}
- (void)BottomClick:(UIButton *)sender{
    if (self.delegate && MyClick) {
        [self.delegate performSelector:MyClick withObject:self];
    }
}
- (void)HeadViewClick:(UIButton *)sender{
    if (self.delegate && OnHeadViewClick) {
        [self.delegate performSelector:OnHeadViewClick withObject:self];
    }
}

+ (NSDictionary *)HeightOfContent:(CoolListModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    int iHeight = 50;
    NSLog(@"url = %@",model.url);
    
    UIImage *image = nil;
    NSString *localpath = [NetImageView GetLocalPathOfUrl:model.url];
    if (localpath && localpath.length>0) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:localpath]) {
            NSData *data = [NSData dataWithContentsOfFile:localpath];
            image = [UIImage imageWithData:data];
        }
        else {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.url]];
            image = [UIImage imageWithData:data];
            [data writeToFile:localpath atomically:YES];
        }
    }
    if (image == nil) {
        [dict setObject:@"1" forKey:@"height"];
        return dict;
    }
    iHeight += (153*image.size.height/image.size.width+30);
    
    [dict setObject:[NSString stringWithFormat:@"%d", iHeight] forKey:@"height"];
    [dict setObject:image forKey:@"image"];
    return dict;
}

- (void)LoadContent:(CoolListModel *)model and:(UIImage *)image {
    mlbName.text = [UserInfoManager GetSecretName:model.nickname username:model.user_name];
    
    mlbDesc.text = model.des;
    
    [commentBut setTitle:model.comment_num forState:UIControlStateNormal];
    [favorBut setTitle:model.like_num forState:UIControlStateNormal];
    
    [mImageView setImage:image];
    
    [mHeadView GetImageByStr:model.avatar];
    
}

//- (void)buttonClick:(UIButton*)button {
//
//    NSLog(@"button.tag = %d",button.tag);
//    if (self.buttonClickBlock) {
//        self.buttonClickBlock(button.tag,self);
//    }
//}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
