//
//  contentCell.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-11.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "EmoTextLable.h"
#import "ImageTextLabel.h"

#import "AudioButton.h"
#import "Mp3PlayerButton.h"

@interface contentCell : UITableViewCell

@property(nonatomic,retain)  UIImageView *replyBgView;
@property(nonatomic,retain)  UIImageView *replyIconView;
@property(nonatomic,retain)  ImageTextLabel *replyContentLab;
@property(nonatomic,retain)  UILabel *replyTimeLab;
@property(nonatomic,retain)  UILabel *replyNameLab;
@property(nonatomic,retain)  UIImageView *repLineView;
@property(nonatomic,retain)  UIImageView *repBgNumView;
@property(nonatomic,retain)  UILabel *repNumLab;

@property (nonatomic,retain )  AsyncImageView  *contentImage;
@property (nonatomic,retain )  UIImageView *lineImage;
@property (nonatomic,retain )  UIImageView *lineImage2;
@property (nonatomic,retain )  UIImageView *contentBgView;



@property (nonatomic,retain )  ImageTextLabel *contentLab;
@property (nonatomic,retain )  UILabel *nameLab;
@property (nonatomic,retain )  UILabel *statusLab;
@property (nonatomic,retain )  UILabel *timeLab;
@property (nonatomic,retain )  UILabel *levelLab;


@property (nonatomic,retain )  UIImageView *iconImage;
@property (nonatomic,retain)   UILabel *numLab;
@property (nonatomic,retain)   UIImageView *numView;
@property (nonatomic ,retain)  UIButton *iconBut;

@property (nonatomic,strong)   UIButton *zanBut;
@property (nonatomic ,strong)  UIButton *plBut;
//@property (nonatomic ,assign)  UIButton *jubaoBut;

@property (strong, nonatomic)  Mp3PlayerButton *audioButton;


+ (int)HeightOfContent:(NSDictionary *)dic;
- (void)ShowContent:(NSDictionary *)dic;

@end
