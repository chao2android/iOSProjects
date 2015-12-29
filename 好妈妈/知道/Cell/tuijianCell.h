//
//  tuijianCell.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-10.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageTextLabel.h"
#import "AsyncImageView.h"
#import "NetImageView.h"
@protocol tuijianCellDelegate <NSObject>

-(void)clickCellButton:(int)butTag;

@end

@interface tuijianCell : UITableViewCell

//@property (nonatomic ,retain)  UIImageView *bigImageView;
//@property (nonatomic ,retain)  UIImageView *listImageView1;
//@property (nonatomic ,retain)  UIImageView *listImageView2;
//@property (nonatomic ,retain)  UIImageView *listImageView3;
@property (nonatomic,retain) NetImageView *bigImageView;
@property (nonatomic,retain) NetImageView *listImageView1;
@property (nonatomic,retain) NetImageView *listImageView2;
@property (nonatomic,retain) NetImageView *listImageView3;

@property (nonatomic ,retain)  ImageTextLabel *bigLab;
@property (nonatomic ,retain)  ImageTextLabel *listLab1;
@property (nonatomic ,retain)  ImageTextLabel *listLab2;
@property (nonatomic ,retain)  ImageTextLabel *listLab3;

@property (nonatomic ,retain)  UIButton *bigBut;
@property (nonatomic ,retain)  UIButton *but1;
@property (nonatomic ,retain)  UIButton *but2;
@property (nonatomic ,retain)  UIButton *but3;

@property (nonatomic ,retain)  UILabel *timeLab;

@property (nonatomic,assign) id <tuijianCellDelegate>delegate;

-(void)remImageTextLab;
@end
