//
//  VideoListTableViewCell.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoListTableViewCell.h"

@implementation VideoListTableViewCell


@synthesize delegate,moreCLick,haveGoClick,xingClick,locationClick,videoClick,headClick, mVideoView;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int iLeft = 4;
        int iHeight = KscreenWidth;
        int iVideoHeight = iHeight*3/4;
        int iTop = (iHeight-iVideoHeight)*4/9;
        int iBottom = iHeight-iVideoHeight-iTop;
        float fScale = KscreenWidth/320;
        
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(iLeft, 5, KscreenWidth-iLeft*2, KscreenWidth)];
        backView.image = [UIImage imageNamed:@"p_listback"];
        backView.userInteractionEnabled = YES;
        [self.contentView addSubview:backView];
        
        mNameView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.frame.size.width-iLeft-80, (iTop-22)/2, 75, 24)];
        mNameView.image = [UIImage imageNamed:@"f_nameback"];
        [backView addSubview:mNameView];
        
        //144 36
        mlbName = [[UILabel alloc]initWithFrame:mNameView.bounds];
        mlbName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        mlbName.textColor = [UIColor whiteColor];
        mlbName.textAlignment = NSTextAlignmentCenter;
        mlbName.backgroundColor = [UIColor clearColor];
        mlbName.font = [UIFont systemFontOfSize:14];
        [mNameView addSubview:mlbName];
        
        NetImageView *videoView = [[NetImageView alloc] initWithFrame:CGRectMake(5, iTop, backView.frame.size.width-10, iVideoHeight)];
        videoView.userInteractionEnabled = YES;
        videoView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        videoView.mImageType = TImageType_CutFill;
        [backView addSubview:videoView];
        
        mVideoView = videoView;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = mVideoView.bounds;
        [btn addTarget:self action:@selector(VideoViewClick) forControlEvents:UIControlEventTouchUpInside];
        [mVideoView addSubview:btn];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((btn.frame.size.width-60)/2, (btn.frame.size.height-60)/2, 60, 60)];
        imageView.image = [UIImage imageNamed:@"playimage"];
        [btn addSubview:imageView];
        
        float fSubLeft = 7*fScale;
        
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(fSubLeft, fSubLeft*iTop/40, 46, 46)];
        headView.backgroundColor = [UIColor whiteColor];
        headView.layer.masksToBounds = YES;
        headView.layer.cornerRadius = headView.frame.size.width/2;
        headView.userInteractionEnabled =YES;
        [backView addSubview:headView];
        
        mHeadView = [[NetImageView alloc]initWithFrame:CGRectMake(3, 3, 40, 40)];
        mHeadView.layer.masksToBounds = YES;
        mHeadView.layer.cornerRadius = mHeadView.frame.size.width/2;
        mHeadView.userInteractionEnabled = YES;
        mHeadView.mImageType = TImageType_CutFill;
        mHeadView.mDefaultImage = [UIImage imageNamed:@"default_avatar"];
        [headView addSubview:mHeadView];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = mHeadView.bounds;
        [btn addTarget:self action:@selector(headViewClick) forControlEvents:UIControlEventTouchUpInside];
        [mHeadView addSubview:btn];
        
        fSubLeft += (headView.frame.size.width+5);
        
        UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(fSubLeft, iTop-fScale*20, 15, fScale*20)];
        mLabel.backgroundColor = [UIColor clearColor];
        mLabel.textAlignment = NSTextAlignmentCenter;
        mLabel.text = @"和";
        mLabel.textColor = [UIColor grayColor];
        mLabel.font = [UIFont boldSystemFontOfSize:13];
        [backView addSubview:mLabel];
        
        fSubLeft += mLabel.frame.size.width;
        
        mlbCount = [[UILabel alloc]initWithFrame:CGRectMake(fSubLeft, iTop-fScale*20-2, 36, fScale*20)];
        mlbCount.textColor = [UIColor blackColor];
        mlbCount.textAlignment = NSTextAlignmentCenter;
        mlbCount.backgroundColor = [UIColor clearColor];
        mlbCount.font = [UIFont boldSystemFontOfSize:19];
        [backView addSubview:mlbCount];
        
        fSubLeft += mlbCount.frame.size.width;
        
        mLabel = [[UILabel alloc]initWithFrame:CGRectMake(fSubLeft, iTop-fScale*20, 90, fScale*20)];
        mLabel.backgroundColor = [UIColor clearColor];
        mLabel.textAlignment = NSTextAlignmentLeft;
        mLabel.text = @"人觉得好好吃";
        mLabel.textColor = [UIColor grayColor];
        mLabel.font = [UIFont boldSystemFontOfSize:13];
        [backView addSubview:mLabel];
        
        float fOffset = backView.bounds.size.width/4;
        for (int i = 0; i<4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*fOffset, backView.bounds.size.height-iBottom, fOffset, iBottom);
            btn.tag = 100+i;
            
            if (i == 0) {
                [btn setImage:[UIImage imageNamed:@"video_gengduo"] forState:UIControlStateNormal];
            }
            else if(i==1){
                [btn setImage:[UIImage imageNamed:@"video_didian"] forState:UIControlStateNormal];
            }
            else if(i==2){
                [btn setImage:[UIImage imageNamed:@"video_xiangqu"] forState:UIControlStateNormal];
                mWantGoBtn = btn;
            }
            else if(i==3){
                [btn setImage:[UIImage imageNamed:@"video_quguo"] forState:UIControlStateNormal];
                mHaveGoBtn = btn;
            }
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];
            
            if (i > 0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*fOffset, backView.bounds.size.height-iBottom*3/4, 1, iBottom/2)];
                lineView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
                [backView addSubview:lineView];
            }
        }
    }
    return self;
}
- (void)loadView:(VideoListModel *)model{
    self.mVideoModel = model;
    [mHeadView GetImageByStr:model.avater];
    mlbCount.text = model.lnum;
    mlbName.text = model.title;
    [mVideoView GetImageByStr:model.image];
    
    int iType = [model.type intValue];
    if (iType == 1) {
        [mWantGoBtn setImage:[UIImage imageNamed:@"f_wantgo"] forState:UIControlStateNormal];
        [mHaveGoBtn setImage:[UIImage imageNamed:@"video_quguo"] forState:UIControlStateNormal];
    }
    else if (iType == 2) {
        [mWantGoBtn setImage:[UIImage imageNamed:@"video_xiangqu"] forState:UIControlStateNormal];
        [mHaveGoBtn setImage:[UIImage imageNamed:@"f_havego"] forState:UIControlStateNormal];
    }
    else {
        [mWantGoBtn setImage:[UIImage imageNamed:@"video_xiangqu"] forState:UIControlStateNormal];
        [mHaveGoBtn setImage:[UIImage imageNamed:@"video_quguo"] forState:UIControlStateNormal];
    }
    
    CGRect rect = mNameView.frame;

    NSDictionary *attribute = @{ NSFontAttributeName:mlbName.font };
    CGSize size = [mlbName.text boundingRectWithSize:CGSizeMake(180, 30) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    mNameView.frame = CGRectMake(rect.origin.x+rect.size.width-size.width-15, rect.origin.y, size.width+15, rect.size.height);
}

- (void)loadFView:(FriendVideoModel *)model{

}

- (void)dealloc {
    self.mVideoModel = nil;
}

- (void)VideoViewClick{
    if (delegate && videoClick) {
        SafePerformSelector([delegate performSelector:videoClick withObject:self]);
    }
}

- (void)headViewClick{
    if (delegate && headClick) {
        SafePerformSelector([delegate performSelector:headClick withObject:self]);
    }
}

- (void)btnClick:(UIButton *)sender{
    NSInteger index = sender.tag-100;
    if (index == 0) {
        if (delegate && moreCLick) {
            SafePerformSelector([delegate performSelector:moreCLick withObject:self]);
        }
    }
    else if (index == 1) {
        if (delegate && locationClick) {
            SafePerformSelector([delegate performSelector:locationClick withObject:self]);
        }
    }
    else if (index == 2) {
        if (delegate && xingClick) {
            SafePerformSelector([delegate performSelector:xingClick withObject:self]);
        }
    }
    else if (index == 3) {
        if (delegate && haveGoClick) {
            SafePerformSelector([delegate performSelector:haveGoClick withObject:self]);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
